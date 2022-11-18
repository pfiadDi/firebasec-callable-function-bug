module Firebase.Firebase exposing (..)


type Language
    = De
    | En


langToString : Language -> String
langToString lang =
    case lang of
        De ->
            "de"

        En ->
            "en"
