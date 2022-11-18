module Firebase.Firestore.Query exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline as PipeDecode
import Json.Encode as Encode


type Query a
    = Init
    | Fetching
    | NoDocument
    | Error String
    | Found a


get : GetPayload -> Encode.Value
get options =
    Encode.object <|
        [ ( "collectionName", Encode.string <| options.collectionName )
        , ( "docId", Encode.string <| options.docId )
        , ( "listen", Encode.bool <| options.listen )
        , ( "portIn", Encode.string <| options.portIn )
        ]


search : SearchPayload -> Encode.Value
search payload =
    Encode.object
        [ ( "collectionName", Encode.string payload.collectionName )
        , ( "limit", Encode.int payload.limit )
        , ( "startAfter", Maybe.withDefault Encode.null <| payload.startAfter )
        , ( "orderBy", Encode.string payload.orderBy )
        , ( "direction", Encode.string <| directionToString payload.direction )
        , ( "searchArray", encodeSearchList payload.searchArray )
        , ( "listen", Encode.bool payload.listen )
        , ( "portIn", Encode.string payload.portIn )
        ]


type alias GetPayload =
    { collectionName : String
    , docId : String
    , listen : Bool
    , portIn : String
    }


type alias SearchPayload =
    { collectionName : String
    , limit : Int
    , startAfter : Maybe Encode.Value
    , orderBy : String
    , direction : Direction
    , searchArray : List Search
    , listen : Bool
    , portIn : String
    }


type alias Search =
    { field : String
    , operator : Operator
    , value : Value
    }


result : Decode.Decoder a -> Encode.Value -> Result Decode.Error (Query a)
result decoder json =
    Decode.decodeValue (decodeResult decoder) json


decodeResult : Decode.Decoder a -> Decode.Decoder (Query a)
decodeResult dataDecoder =
    Decode.oneOf [ decodeEmptyResultOrError, decodeFound dataDecoder ]


decodeEmptyResultOrError : Decode.Decoder (Query a)
decodeEmptyResultOrError =
    Decode.field "status" Decode.string
        |> Decode.andThen
            (\r ->
                case r of
                    "NO-DOCUMENTS" ->
                        Decode.succeed NoDocument

                    _ ->
                        Decode.succeed Error
                            |> PipeDecode.required "error" Decode.string
            )


decodeFound : Decode.Decoder a -> Decode.Decoder (Query a)
decodeFound dataDecoder =
    Decode.field "data" <|
        Decode.map Found <|
            dataDecoder


decodeLastElement : Decode.Decoder Decode.Value
decodeLastElement =
    Decode.field "lastElement" Decode.value


type Operator
    = Less
    | LessEql
    | Eql
    | GreaterEql
    | Greater
    | NotEql
    | ArrayContains


opToString : Operator -> String
opToString op =
    case op of
        Less ->
            "<"

        LessEql ->
            "<="

        Eql ->
            "=="

        GreaterEql ->
            ">="

        Greater ->
            ">"

        NotEql ->
            "!="
        
        ArrayContains ->
            "array-contains"


type Value
    = String String
    | Bool Bool
    | Int Int


encodeSearch : Search -> Encode.Value
encodeSearch search_ =
    Encode.object
        [ ( "field", Encode.string <| search_.field )
        , ( "operator", encodeOp search_.operator )
        , ( "value", encodeValue search_.value )
        ]


encodeSearchList : List Search -> Encode.Value
encodeSearchList searches =
    Encode.list encodeSearch searches


encodeValue : Value -> Encode.Value
encodeValue value =
    case value of
        String value_ ->
            Encode.string value_

        Int value_ ->
            Encode.int value_

        Bool value_ ->
            Encode.bool value_


encodeOp : Operator -> Encode.Value
encodeOp op =
    Encode.string <| opToString op


type Direction
    = Asc
    | Desc


directionToString : Direction -> String
directionToString dir =
    case dir of
        Asc ->
            "asc"

        Desc ->
            "desc"
