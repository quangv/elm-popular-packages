module View exposing (..)

import Array
import Html exposing (Html, text, div, h1, button)
import Html.Events exposing (onClick)
import Types exposing (Model, Package, PackageRow, Msg(..))
import Table


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
        , Table.view config model.tableState (List.map mapPackages model.packages)

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
