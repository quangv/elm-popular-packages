module Main exposing (..)

import Html exposing (Html, text, div, h1, button)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (at, string, list)


---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Http.send LoadPackages fetchPackages )



---- COMMANDS ----


fetchPackages : Http.Request Package
fetchPackages =
    Http.get "http://package.elm-lang.org/all-packages" decodePackages


type alias Package =
    { name : String
    , summary : String
    , versions : List String
    }


decodePackages : Decode.Decoder Package
decodePackages =
    Decode.map3 Package
        (at [ "name" ] string)
        (at [ "summary" ] string)
        (at [ "versions" ] (list string))



---- UPDATE ----


type Msg
    = FetchPackages
    | LoadPackages (Result Http.Error Package)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchPackages ->
            let
                m =
                    Debug.log "msg" msg
            in
                ( model, Cmd.none )

        LoadPackages a ->
            let
                m =
                    Debug.log "msg" ( msg, a )
            in
                ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm Popular Packages" ]
        , button [ onClick FetchPackages ] [ text "Fetch" ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
