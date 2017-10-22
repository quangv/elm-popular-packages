module Main exposing (..)

import Array
import Html exposing (Html, text, div, h1, button)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (decodeString, field, string, list)
import Table
import SamplePackages


---- MODEL ----


type alias Model =
    { loadingPackages : Bool
    , packages : List Package
    , tableState : Table.State
    }


type alias Package =
    { name : String
    , summary : String
    , versions : List String
    }


type alias PackageRow =
    { name : String
    , summary : String
    , username : String
    , repoName : String
    }


init : ( Model, Cmd Msg )
init =
    ( { loadingPackages = False
      , packages = decodePackages SamplePackages.json
      , tableState = Table.initialSort "Name"
      }
      --, Http.send LoadPackages fetchPackages
    , Cmd.none
    )



---- API ----
{-
   fetchPackages : Http.Request (List Package)
   fetchPackages =
       Http.get ("https://cors-anywhere.herokuapp.com/" ++ "http://package.elm-lang.org/all-packages") packagesDecoder
-}


decodePackages : String -> List Package
decodePackages json =
    case decodeString packagesDecoder json of
        Ok list ->
            list

        Err error ->
            let
                _ =
                    Debug.log "err" error
            in
                []


packagesDecoder : Decode.Decoder (List Package)
packagesDecoder =
    list packageDecoder


packageDecoder : Decode.Decoder Package
packageDecoder =
    Decode.map3 Package
        (field "name" string)
        (field "summary" string)
        (field "versions" (list string))



---- UPDATE ----


type Msg
    = FetchPackages
    | LoadPackages (Result Http.Error (List Package))
    | SetTableState Table.State


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
        , Table.view config model.tableState (List.map mapPackages <| Debug.log "Result" model.packages)

        --, div [] (List.map viewPackage model.packages)
        ]


viewPackage : Package -> Html Msg
viewPackage package =
    div []
        [ text package.name
        ]


mapPackages : Package -> PackageRow
mapPackages pkg =
    let
        name =
            Array.fromList (String.split "/" pkg.name)
    in
        PackageRow pkg.name pkg.summary (Maybe.withDefault "" (Array.get 0 name)) (Maybe.withDefault "" (Array.get 1 name))



---- TABLE CONFIGURATION ----


config : Table.Config { a | repoName : String, username : String, name : String } Msg
config =
    Table.config
        { toId = .name
        , toMsg = SetTableState
        , columns =
            [ Table.stringColumn "Name" .name
            , Table.stringColumn "Username" .username
            , Table.stringColumn "Repo Name" .repoName
            ]
        }



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
