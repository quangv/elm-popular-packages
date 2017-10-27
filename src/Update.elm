module Update exposing (..)

import Http
import Types exposing (Model, Package, Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        {-
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
        -}
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
