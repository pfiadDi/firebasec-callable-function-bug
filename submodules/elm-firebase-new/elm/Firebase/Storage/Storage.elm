module Firebase.Storage.Storage exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline as PipeDecode


type UploadStatus
    = Init
    | Uploading
    | Finished String
    | Error String


decodeUploadResult : Decode.Decoder UploadStatus
decodeUploadResult =
    Decode.field "status" Decode.string
        |> Decode.andThen
            (\r ->
                case r of
                    "SUCCESS" ->
                        Decode.succeed Finished
                            |> PipeDecode.required "path" Decode.string

                    _ ->
                        Decode.succeed Error
                            |> PipeDecode.required "error" Decode.string
            )
