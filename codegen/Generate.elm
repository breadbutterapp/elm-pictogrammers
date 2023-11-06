module Generate exposing (main)

{-| -}

import Elm
import Gen.CodeGen.Generate as Generate
import Gen.Svg.Styled as StyledSvg
import Gen.Svg.Styled.Attributes as StyledSvgAttrs
import Json.Decode


main : Program Json.Decode.Value () ()
main =
    Generate.fromJson
        (Json.Decode.list decodeFile)
        generate


type alias File =
    { path : String
    , contents : String
    }


decodeFile : Json.Decode.Decoder File
decodeFile =
    Json.Decode.map2 File
        (Json.Decode.field "path" Json.Decode.string)
        (Json.Decode.field "contents" Json.Decode.string)


generate : List File -> List Elm.File
generate files =
    [ Elm.file [ "Pictogrammers" ]
        (List.sortBy .path files
            |> List.filterMap fileToDeclaration
        )
    ]


fileToDeclaration : File -> Maybe Elm.Declaration
fileToDeclaration file =
    extractPath file
        |> Maybe.map
            (\path ->
                Elm.declaration (getFileSimpleName file.path) (StyledSvg.path [ StyledSvgAttrs.d path ] [])
                    |> Elm.withDocumentation ("Return a styled Svg path for an " ++ getFileSimpleName file.path ++ " icon, in a 24x24 viewbox.")
            )


extractPath : File -> Maybe String
extractPath file =
    case String.split " d=\"" file.contents of
        [ _, rest ] ->
            case String.split "\"" rest of
                path :: _ ->
                    Just path

                _ ->
                    Nothing

        _ ->
            Nothing


{-|

> Result.toMaybe

        |> Maybe.andThen
            (\node ->
                case node of
                    [ Html.Parser.Element x _ _ ] ->
                        Just x

                    _ ->
                        Just "invalid svg"
            )

-}



{- Some string formatting -}


getFileSimpleName : String -> String
getFileSimpleName path =
    String.split "/" path
        |> List.reverse
        |> List.head
        |> Maybe.withDefault path
        |> String.replace ".svg" ""
        |> String.replace "-" "_"
        |> String.toLower
