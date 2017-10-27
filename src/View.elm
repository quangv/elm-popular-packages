module View exposing (..)

import Array
import Html exposing (Html, text, div, h1, button)
import Html.Events exposing (onClick)
import Types exposing (Model, Package, Msg(..))
import Table


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm Popular Packages" ]

        {- , div []
           [ if model.loadingPackages then
               text "Loading..."
             else
               text ""
           ]
           -
        -}
        --, button [ onClick FetchPackages ] [ text "Fetch" ]
        , Table.view config model.tableState <| Debug.log "mp" model.packages

        --, div [] (List.map viewPackage model.packages)
        ]


viewPackage : Package -> Html Msg
viewPackage package =
    div []
        [ text package.name
        ]



---- TABLE CONFIGURATION ----
--config : Table.Config { a | repoName : String, username : String, name : String } Msg


config =
    Table.config
        { toId = .name
        , toMsg = SetTableState
        , columns =
            [ Table.stringColumn "Name" .name
            , Table.stringColumn "Summary" .summary
            , Table.stringColumn "Username" .username
            , Table.stringColumn "Repo Name" .repoName
            ]
        }
