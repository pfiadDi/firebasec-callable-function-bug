module Firebase.Firestore.Document exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline as PipeDecode
import Json.Encode as Encode


type Document docData
    = Init
    | Creating docData
    | Operating DocumentID docData
    | Offline DocumentID docData
    | Online DocumentID docData
    | Error String (Maybe DocumentID) docData


type alias DocumentID =
    String


result : Document docData -> Encode.Value -> Result Decode.Error (Document docData)
result document json =
    case extract document of
        ( _, Just docData ) ->
            Decode.decodeValue (decoderOperation docData) json

        ( _, Nothing ) ->
            Decode.decodeValue (Decode.fail "No document data in status") Encode.null


decoderOperation : docData -> Decode.Decoder (Document docData)
decoderOperation data =
    Decode.field "status" Decode.string
        |> Decode.andThen
            (\r ->
                case r of
                    "SUCCESS-ONLINE" ->
                        Decode.succeed Online
                            |> PipeDecode.required "docId" Decode.string
                            |> PipeDecode.hardcoded data

                    "SUCCESS-OFFLINE" ->
                        Decode.succeed Offline
                            |> PipeDecode.required "docId" Decode.string
                            |> PipeDecode.hardcoded data

                    _ ->
                        Decode.succeed Error
                            |> PipeDecode.required "error" Decode.string
                            |> PipeDecode.optional "docId"
                                (Decode.string
                                    |> Decode.andThen
                                        (\res ->
                                            Decode.succeed (Just res)
                                        )
                                )
                                Nothing
                            |> PipeDecode.hardcoded data
            )


type alias Payload =
    { collectionName : String
    , docId : Maybe String
    , data : Maybe Encode.Value
    , portIn : String
    , merge : Bool
    }


operation : Payload -> Encode.Value
operation options =
    Encode.object <|
        [ ( "collectionName", Encode.string <| options.collectionName )
        , ( "docId", justString options.docId )
        , ( "data", justValue options.data )
        , ( "portIn", Encode.string <| options.portIn )
        , ( "merge", Encode.bool <| options.merge )
        ]


justString : Maybe String -> Encode.Value
justString value =
    case value of
        Just str ->
            Encode.string str

        Nothing ->
            Encode.null


justValue : Maybe Encode.Value -> Encode.Value
justValue value =
    case value of
        Just value_ ->
            value_

        Nothing ->
            Encode.null


updateData : Document a -> a -> Document a
updateData document nV =
    case document of
        Init ->
            Init

        Creating _ ->
            Creating nV

        Operating docId _ ->
            Operating docId nV

        Offline docId _ ->
            Offline docId nV

        Online docId _ ->
            Online docId nV

        Error err docId _ ->
            Error err docId nV


extract : Document a -> ( Maybe DocumentID, Maybe a )
extract document =
    case document of
        Init ->
            ( Nothing, Nothing )

        Creating data ->
            ( Nothing, Just data )

        Operating docId data ->
            ( Just docId, Just data )

        Offline docId data ->
            ( Just docId, Just data )

        Online docId data ->
            ( Just docId, Just data )

        Error _ docId data ->
            case docId of
                Just docId_ ->
                    ( Just docId_, Just data )

                Nothing ->
                    ( Nothing, Just data )


setDocumentStatus : Document a -> { record | documentStatus : Document a } -> { record | documentStatus : Document a }
setDocumentStatus nV record =
    { record | documentStatus = nV }
