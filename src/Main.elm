module Main exposing (..)

import Html exposing (Html)
import Http


-- Local

import Types exposing (Model, Package, PackageRow, Msg(..))
import Model
import View


---- API ----
{-
   fetchPackages : Http.Request (List Package)
   fetchPackages =
       Http.get ("https://cors-anywhere.herokuapp.com/" ++ "http://package.elm-lang.org/all-packages") packagesDecoder
-}
---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchPackages ->
            let
                m =
                    Debug.log "msg" msg
            in
                ( model, Cmd.none )

        LoadPackages response ->
            let
                m =
                    Debug.log "msg" (String.left 20 (toString msg))
            in
                ( { model
                    | loadingPackages = False
                    , packages = resultToList response
                  }
                , Cmd.none
                )

        SetTableState newState ->
            ( { model | tableState = newState }
            , Cmd.none
            )


resultToList : Result Http.Error (List Package) -> List Package
resultToList result =
    case result of
        Err msg ->
            []

        Ok packages ->
            packages



---- VIEW ----
---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = View.view
        , init = Model.init
        , update = update
        , subscriptions = always Sub.none
        }
