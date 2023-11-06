# elm-pictogrammers

This package provides all the icons from [Pictogrammers](https://pictogrammers.com) in an Elm-friendly package, based on [elm-css](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/).

## Using the icons

Install the package with `elm install breadbutterapp/elm-pictogrammers`, and then import the icons in your project:

```elm
import Pictogrammers
import Svg.Styled exposing (Svg)

iconPath : Svg msg
iconPath =
  Pictogrammers.food_hot_dog
```

Please note that the icons just represent the Svg's `path`, so you will need to specify the size of the viewport, etc.

## Generating the icons

In order to generate the icons, you will need to :

1. Clone the repository, including the necessary git submodules; and
2. Run `npm install`; and
3. Run `npm run generate`.

You will then find the generated icons in the `./generated` folder.
