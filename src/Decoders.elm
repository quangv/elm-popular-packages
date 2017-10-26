module Decoders exposing (..)

import Json.Decode as Decode exposing (decodeString, list, field, string)
import Types exposing (Package)


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
