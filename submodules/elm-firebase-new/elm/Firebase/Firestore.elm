module Firebase.Firestore exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline as PipeDecode
import Json.Encode as Encode
import Firebase.Firebase exposing (Language(..))




type Status
    = NoOfflineCapabilities
    | MultipleTabsOpen
    | Other
    | NoError





statusToString : Language -> Status -> String
statusToString lang status =
    case lang of
        De ->
            statusToGerman status

        En ->
            statusToEnglish status


statusToGerman : Status -> String
statusToGerman status =
    case status of
        NoOfflineCapabilities ->
            "Leider verfügt Ihr Browser nicht über die notwendigen Offline-Fähigkeiten. Bitte verwenden Sie einen anderen Browser."

        MultipleTabsOpen ->
            "Es scheint als wäre diese Web-App auch in einem anderen Tab gleichzeitig geöffnet. Bitte schließen Sie eine und laden Sie die Web-App neu."

        Other ->
            "Unbekannter Fehler"

        NoError ->
            "Kein Fehler"


statusToEnglish : Status -> String
statusToEnglish status =
    case status of
        NoOfflineCapabilities ->
            "Unfortunately, your browser does not have the necessary offline capabilities. Please use a different browser."

        MultipleTabsOpen ->
            "It seems that this web app is also open in another tab at the same time. Please close one and reload the web app."

        Other ->
            "Unknown error"

        NoError ->
            "No error"





statusErrorDecoder : Decode.Decoder Status
statusErrorDecoder =
    Decode.field "code" Decode.string
        |> Decode.andThen
            (\result ->
                case result of
                    "failed-precondition" ->
                        Decode.succeed MultipleTabsOpen

                    "unimplemented" ->
                        Decode.succeed NoOfflineCapabilities

                    _ ->
                        Decode.succeed Other
            )






