module Model exposing (..)

import Table


-- Local

import Decoders exposing (decodePackages)
import SamplePackages
import Types exposing (Model, Msg)


init : ( Model, Cmd Msg )
init =
    ( { --loadingPackages = False
        packages = decodePackages SamplePackages.json
      , tableState = Table.initialSort "Name"
      }
      --, Http.send LoadPackages fetchPackages
    , Cmd.none
    )
