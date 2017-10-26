module Main exposing (..)

import Html exposing (Html)


-- Local

import Types exposing (Model, Msg)
import Model
import Update
import View


---- API ----
{-
   fetchPackages : Http.Request (List Package)
   fetchPackages =
       Http.get ("https://cors-anywhere.herokuapp.com/" ++ "http://package.elm-lang.org/all-packages") packagesDecoder
-}
---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { init = Model.init
        , update = Update.update
        , view = View.view
        , subscriptions = always Sub.none
        }
