module Firebase.Functions exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode



{--
Usage:
- Call the function via port
- Create a decoder for the expected Result 
- Decode the result with decodeResult and pass the created result decoder
--}


type Result a
    = NoRequest
    | Loading
    | Error String
    | Found a


type alias Payload =
    { functionName : String
    , data : Maybe Encode.Value
    , portIn : String
    }


call : Payload -> Encode.Value
call options =
    Encode.object <|
        [ ( "functionName", Encode.string <| options.functionName )
        , ( "data", justValue options.data )
        , ( "portIn", Encode.string <| options.portIn )
        ]


justValue : Maybe Encode.Value -> Encode.Value
justValue value =
    case value of
        Just value_ ->
            value_

        Nothing ->
            Encode.null


decodeResult : Decode.Decoder a -> Decode.Decoder (Result a)
decodeResult dataDecoder =
    Decode.oneOf [ decodeError, decodeData dataDecoder ]


decodeError : Decode.Decoder (Result a)
decodeError =
    Decode.map Error (Decode.field "message" Decode.string)


decodeData : Decode.Decoder a -> Decode.Decoder (Result a)
decodeData dataDecoder =
    Decode.map Found dataDecoder
