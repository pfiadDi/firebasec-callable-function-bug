module DocumentTest exposing (..)

import Expect exposing (..)
import Firebase.Firestore.Document as Document
import Json.Decode as Decode
import Json.Encode as Encode
import Test exposing (..)


operation : Test
operation =
    describe "Encodes the payload for the operation"
        [ test "Uses all values when present" <|
            \_ ->
                Ok
                    { collectionName = colId
                    , docId = docId
                    , data = testData
                    , portIn = portInName
                    , merge = False
                    }
                    |> Expect.equal
                        (Decode.decodeValue
                            decoderOp
                            (Document.operation
                                { collectionName = colId
                                , docId = Just docId
                                , data = Just testDataEncoded
                                , portIn = portInName
                                , merge = False
                                }
                            )
                        )
        , test "Uses encodes to null" <|
            \_ ->
                Ok
                    { collectionName = colId
                    , docId = Nothing
                    , data = Nothing
                    , portIn = portInName
                    , merge = True
                    }
                    |> Expect.equal
                        (Decode.decodeValue
                            decoderOpNulls
                            (Document.operation
                                { collectionName = colId
                                , docId = Nothing
                                , data = Nothing
                                , portIn = portInName
                                , merge = True
                                }
                            )
                        )
        ]


type alias PayloadEncodedNulls =
    { collectionName : String
    , docId : Maybe String
    , data : Maybe Data
    , portIn : String
    , merge : Bool
    }


decoderOpNulls : Decode.Decoder PayloadEncodedNulls
decoderOpNulls =
    Decode.map5 PayloadEncodedNulls
        (Decode.field "collectionName" Decode.string)
        (Decode.field "docId" (Decode.maybe Decode.string))
        (Decode.field "data" (Decode.maybe decodeData))
        (Decode.field "portIn" Decode.string)
        (Decode.field "merge" Decode.bool)


type alias PayloadEncoded =
    { collectionName : String
    , docId : String
    , data : Data
    , portIn : String
    , merge : Bool
    }


decoderOp : Decode.Decoder PayloadEncoded
decoderOp =
    Decode.map5 PayloadEncoded
        (Decode.field "collectionName" Decode.string)
        (Decode.field "docId" Decode.string)
        (Decode.field "data" decodeData)
        (Decode.field "portIn" Decode.string)
        (Decode.field "merge" Decode.bool)


decodeData : Decode.Decoder Data
decodeData =
    Decode.map Data (Decode.field "uid" Decode.string)


portInName : String
portInName =
    "portInName"


decoderOperation : Test
decoderOperation =
    describe "Decodes a document operation"
        [ test "Online returns Online" <|
            \_ ->
                Ok (Document.Online docId testData)
                    |> Expect.equal
                        (Decode.decodeValue
                            (Document.decoderOperation testData)
                            onlineResult
                        )
        , test "Offline returns Offline" <|
            \_ ->
                Ok (Document.Offline docId testData)
                    |> Expect.equal
                        (Decode.decodeValue
                            (Document.decoderOperation testData)
                            offlineResult
                        )
        , test "Error returns Error without docId when docId is undefinded" <|
            \_ ->
                Ok (Document.Error errorMsg Nothing testData)
                    |> Expect.equal
                        (Decode.decodeValue
                            (Document.decoderOperation testData)
                            errorResult
                        )
        , test "Error returns Error with docId when docId is definded" <|
            \_ ->
                Ok (Document.Error errorMsg (Just docId) testData)
                    |> Expect.equal
                        (Decode.decodeValue
                            (Document.decoderOperation testData)
                            errorResultWithDocId
                        )
        ]


errorMsg : String
errorMsg =
    "Something failed"


colId : String
colId =
    "testCollection"


docId : String
docId =
    "testDocId"


onlineResult : Encode.Value
onlineResult =
    Encode.object
        [ ( "status", Encode.string "SUCCESS-ONLINE" )
        , ( "docId", Encode.string docId )
        ]


errorResult : Encode.Value
errorResult =
    Encode.object
        errorParts


errorParts : List ( String, Encode.Value )
errorParts =
    [ ( "status", Encode.string "ERROR" )
    , ( "error", Encode.string errorMsg )
    ]


errorResultWithDocId : Encode.Value
errorResultWithDocId =
    Encode.object
        (errorParts ++ [ ( "docId", Encode.string docId ) ])


offlineResult : Encode.Value
offlineResult =
    Encode.object
        [ ( "status", Encode.string "SUCCESS-OFFLINE" )
        , ( "docId", Encode.string docId )
        ]


type alias Data =
    { testField : String
    }


testData : Data
testData =
    { testField = "testData" }


testDataEncoded : Encode.Value
testDataEncoded =
    Encode.object
        [ ( "uid", Encode.string "testData" )
        ]
