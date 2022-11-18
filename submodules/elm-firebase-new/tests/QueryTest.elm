module QueryTest exposing (..)

import Expect exposing (..)
import Firebase.Firestore.Query as Query
import Json.Decode as Decode
import Json.Encode as Encode
import Test exposing (..)


get : Test
get =
    describe "Creates a payload to get one specific document"
        [ test "uses the parameters" <|
            \_ ->
                Ok
                    { collectionName = "test"
                    , docId = "testDocId"
                    , listen = True
                    , portIn = "portInName"
                    }
                    |> Expect.equal
                        (Decode.decodeValue decodeGetDocObject <|
                            Query.get { collectionName = "test"
                                , docId = "testDocId"
                                , listen = True 
                                , portIn = "portInName"}
                        )
        ]


decodeGetDocObject : Decode.Decoder Query.GetPayload
decodeGetDocObject =
    Decode.map4 Query.GetPayload
        (Decode.field "collectionName" Decode.string)
        (Decode.field "docId" Decode.string)
        (Decode.field "listen" Decode.bool)
        (Decode.field "portIn" Decode.string)


opToString : Test
opToString =
    describe "Returns the the operator string for a given Operator Tag"
        [ test "Less = <" <|
            \_ ->
                "<" |> Expect.equal (Query.opToString Query.Less)
        , test "LessEql = <=" <|
            \_ ->
                "<=" |> Expect.equal (Query.opToString Query.LessEql)
        , test "Eql = ==" <|
            \_ ->
                "==" |> Expect.equal (Query.opToString Query.Eql)
        , test "GreaterEql = >=" <|
            \_ ->
                ">=" |> Expect.equal (Query.opToString Query.GreaterEql)
        , test "Greater = >" <|
            \_ ->
                ">" |> Expect.equal (Query.opToString Query.Greater)
        , test "NotEql = !=" <|
            \_ ->
                "!=" |> Expect.equal (Query.opToString Query.NotEql)
        ]


search : Test
search =
    describe "Creates the search payload"
        [ test "uses the passed parameters" <|
            \_ ->
                Ok
                    { collectionName = "test"
                    , limit = 10
                    , startAfter = Nothing
                    , orderBy = "fieldName"
                    , direction = "desc"
                    , searchArray = [ searchDecoded1, searchDecoded2 ]
                    , listen = True
                    , portIn = "namePortIn"
                    }
                    |> Expect.equal
                        (Decode.decodeValue
                            decodeSearchPayload
                            (Query.search
                                { collectionName = "test"
                                , limit = 10
                                , startAfter = Nothing
                                , orderBy = "fieldName"
                                , direction = Query.Desc
                                , searchArray = [ search1, search2 ]
                                , listen = True
                                , portIn = "namePortIn"
                                }
                            )
                        )
        ]


directionToString : Test
directionToString =
    describe "returns the direction as string"
        [ test "asc" <|
            \_ ->
                "asc"
                    |> Expect.equal
                        (Query.directionToString Query.Asc)
        , test "desc" <|
            \_ ->
                "desc"
                    |> Expect.equal
                        (Query.directionToString Query.Desc)
        ]


type alias SearchPayloadObject =
    { collectionName : String
    , limit : Int
    , startAfter : Maybe Encode.Value
    , orderBy : String
    , direction : String
    , searchArray : List SearchDecoded
    , listen : Bool
    , portIn : String
    }


decodeSearchPayload : Decode.Decoder SearchPayloadObject
decodeSearchPayload =
    Decode.map8 SearchPayloadObject
        (Decode.field "collectionName" Decode.string)
        (Decode.field "limit" Decode.int)
        (Decode.field "startAfter" (Decode.nullable Decode.value))
        (Decode.field "orderBy" Decode.string)
        (Decode.field "direction" Decode.string)
        (Decode.field "searchArray" decodeSearchArray)
        (Decode.field "listen" Decode.bool)
        (Decode.field "portIn" Decode.string)


encodeSearchList : Test
encodeSearchList =
    describe "Encodes a list of Search to an JS Array"
        [ test "a correct array" <|
            \_ ->
                Ok
                    [ searchDecoded1, searchDecoded2 ]
                    |> Expect.equal
                        (Decode.decodeValue
                            decodeSearchArray
                            (Query.encodeSearchList searchList)
                        )
        ]


encodeSearch : Test
encodeSearch =
    describe "encodes Search to an object"
        [ test "a correct object" <|
            \_ ->
                Ok
                    searchDecoded1
                    |> Expect.equal
                        (Decode.decodeValue
                            decodeSearchObject
                            (Query.encodeSearch search1)
                        )
        ]


encodeValue : Test
encodeValue =
    describe "Encodes Query values"
        [ test "string to string" <|
            \_ ->
                Ok (Query.String "field")
                    |> Expect.equal
                        (Decode.decodeValue
                            decodeStringValue
                            (Query.encodeValue <| Query.String "field")
                        )
        , test "int to int" <|
            \_ ->
                Ok (Query.Int 10)
                    |> Expect.equal
                        (Decode.decodeValue
                            decodeIntValue
                            (Query.encodeValue <| Query.Int 10)
                        )
        , test "bool to bool" <|
            \_ ->
                Ok (Query.Bool True)
                    |> Expect.equal
                        (Decode.decodeValue
                            decodeBoolValue
                            (Query.encodeValue <| Query.Bool True)
                        )
        ]


encodeOperator : Test
encodeOperator =
    describe "Encodes a Operator to a string value"
        [ test "Less to <" <|
            \_ ->
                Ok "<"
                    |> Expect.equal
                        (Decode.decodeValue
                            Decode.string
                            (Query.encodeOp <| Query.Less)
                        )
        ]



-- helpers


decodeSearchArray : Decode.Decoder (List SearchDecoded)
decodeSearchArray =
    Decode.list decodeSearchObject


type alias SearchDecoded =
    { field : String
    , operator : String
    , value : Query.Value
    }


decodeSearchObject : Decode.Decoder SearchDecoded
decodeSearchObject =
    Decode.map3 SearchDecoded
        (Decode.field "field" Decode.string)
        (Decode.field "operator" Decode.string)
        (Decode.field "value" decodeStringValue)


decodeStringValue : Decode.Decoder Query.Value
decodeStringValue =
    Decode.map Query.String Decode.string


decodeIntValue : Decode.Decoder Query.Value
decodeIntValue =
    Decode.map Query.Int Decode.int


decodeBoolValue : Decode.Decoder Query.Value
decodeBoolValue =
    Decode.map Query.Bool Decode.bool


searchList : List Query.Search
searchList =
    [ search1
    , search2
    ]


search2 : Query.Search
search2 =
    { field = "field2"
    , operator = Query.Less
    , value = Query.String "otherValue"
    }


search1 : Query.Search
search1 =
    { field = "field1"
    , operator = Query.Eql
    , value = Query.String "comparing"
    }


searchDecoded1 : SearchDecoded
searchDecoded1 =
    { field = "field1"
    , operator = "=="
    , value = Query.String "comparing"
    }


searchDecoded2 : SearchDecoded
searchDecoded2 =
    { field = "field2"
    , operator = "<"
    , value = Query.String "otherValue"
    }
