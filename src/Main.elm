module Main exposing (..)

import Html exposing (Html, text, div, h1, button)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (at, string, list)


---- MODEL ----


type alias Model =
    { loadingPackages : Bool
    , packages : List Package
    }


init : ( Model, Cmd Msg )
init =
    ( { loadingPackages = True
      , packages = []
      }
    , Http.send LoadPackages fetchPackages
    )



---- COMMANDS ----


fetchPackages : Http.Request (List Package)
fetchPackages =
    Http.get ("https://cors-anywhere.herokuapp.com/" ++ "http://package.elm-lang.org/all-packages") decodePackages


type alias Package =
    { name : String
    , summary : String
    , versions : List String
    }


decodePackages : Decode.Decoder (List Package)
decodePackages =
    list decodePackage


decodePackage : Decode.Decoder Package
decodePackage =
    Decode.map3 Package
        (at [ "name" ] string)
        (at [ "summary" ] string)
        (at [ "versions" ] (list string))



---- UPDATE ----


type Msg
    = FetchPackages
    | LoadPackages (Result Http.Error (List Package))


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


resultToList : Result Http.Error (List Package) -> List Package
resultToList result =
    case result of
        Err msg ->
            []

        Ok packages ->
            packages



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm Popular Packages" ]
        , div []
            [ if model.loadingPackages then
                text "Loading..."
              else
                text ""
            ]
        , button [ onClick FetchPackages ] [ text "Fetch" ]
        , div [] (List.map viewPackage model.packages)
        ]



{--
viewPackages : Maybe Result Http.Error (List Package) -> Html Msg
viewPackages packages =
    case packages of
        Nothing ->
            div [] []

        _ ->
            div [] [ text "Well" ]



        Err msg ->
            div [] [ text "Error fetching packages" ]

        Ok packages ->
            List.map viewPackage packages
--}


viewPackage : Package -> Html Msg
viewPackage package =
    div []
        [ text package.name
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
