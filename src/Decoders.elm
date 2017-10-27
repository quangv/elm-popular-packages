module Decoders exposing (..)

import Json.Decode as Decode exposing (decodeString, list, field, string)
import Types exposing (Package)


--decodePackages : String -> List Package


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



--packagesDecoder : Decode.Decoder (List Package)


packagesDecoder =
    list packageDecoder



--packageDecoder : Decode.Decoder Package


packageDecoder =
    {-
       let
           nameList =
               String.split "/" (field "name" string)
       in
           Decode.map4 Package
               (field "name" string)
               (field "summary" string)
               (Maybe.withDefault "" <| List.head nameList)
               (field "name" string)
    -}
    Decode.map2 mapToPackage
        (field "name" string)
        (field "summary" string)


mapToPackage : String -> String -> Package
mapToPackage name summary =
    let
        nameList =
            String.split "/" name
    in
        Package
            name
            summary
            (Maybe.withDefault "" <| List.head nameList)
            (Maybe.withDefault "" <| List.head <| List.drop 1 nameList)
