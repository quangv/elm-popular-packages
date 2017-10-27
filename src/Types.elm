module Types exposing (..)

import Table
import Http


type alias Model =
    { --loadingPackages : Bool
      packages : List Package
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


type Msg
    = --FetchPackages
      --| LoadPackages (Result Http.Error (List Package))
      SetTableState Table.State
