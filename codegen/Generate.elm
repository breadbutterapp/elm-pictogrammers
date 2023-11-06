module Generate exposing (main)

{-| -}

import Elm
import Gen.CodeGen.Generate as Generate
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
    [ Elm.file [ "Assets" ]
        (List.map fileToDeclaration files)
    ]


fileToDeclaration : File -> Elm.Declaration
fileToDeclaration file =
    Elm.declaration (getFileName file.path)
        (Elm.string file.path)



{- Some string formatting -}


getFileName : String -> String
getFileName path =
    let
        fileName =
            String.split "/" path
                |> List.reverse
                |> List.head
                |> Maybe.withDefault path
    in
    fileName
        |> String.replace "." ""
        |> String.replace "-" ""
        |> String.replace "_" ""
        |> String.replace " " ""
        |> String.replace "/" ""
        |> String.replace "’" ""
        |> String.replace "'" ""
        |> decapitalize


decapitalize : String -> String
decapitalize str =
    case String.uncons str of
        Nothing ->
            str

        Just ( first, tail ) ->
            String.fromChar (Char.toLower first) ++ tail
