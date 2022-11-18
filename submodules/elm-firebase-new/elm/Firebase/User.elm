port module Firebase.User exposing (..)

import Firebase.Firebase
import Html exposing (..)
import Html.Attributes
import Html.Events
import Json.Decode as Decode
import Json.Decode.Pipeline as PipeDecode
import Json.Encode as Encode


type alias UserMasterData =
    { displayName : String
    , email : String
    , photoURL : String
    , uid : String
    , type_ : UserType
    , emailVerified : Bool
    }


type UserType
    = None
    | Auth
    | Anonymous


loginPayload : Firebase.Firebase.Language -> String -> Encode.Value
loginPayload lang redirectUrl =
    Encode.object
        [ ( "lang", Encode.string <| Firebase.Firebase.langToString lang )
        , ( "redirectUrl", Encode.string <| redirectUrl )
        ]


emptyUser : UserMasterData
emptyUser =
    { displayName = ""
    , email = ""
    , photoURL = ""
    , uid = ""
    , type_ = None
    , emailVerified = False
    }


userDecoder : Decode.Decoder UserMasterData
userDecoder =
    Decode.succeed UserMasterData
        |> PipeDecode.optional "displayName" Decode.string "NO DISPLAYNAME"
        |> PipeDecode.optional "email" Decode.string ""
        |> PipeDecode.optional "photoURL" Decode.string "/avatar.png"
        |> PipeDecode.required "uid" Decode.string
        |> PipeDecode.required "isAnonymous" decodeUserType
        |> PipeDecode.required "emailVerified" Decode.bool


decodeUserType : Decode.Decoder UserType
decodeUserType =
    Decode.bool
        |> Decode.andThen
            (\isAnonymous ->
                if isAnonymous then
                    Decode.succeed Anonymous

                else
                    Decode.succeed Auth
            )


port userPort : (Decode.Value -> msg) -> Sub msg


port startLogin : Encode.Value -> Cmd msg


port startLogout : Encode.Value -> Cmd msg


port loginUIShown : (Encode.Value -> msg) -> Sub msg


port resendVerification : Encode.Value -> Cmd msg


port verificationSent : (Encode.Value -> msg) -> Sub msg


type Msg
    = StartLogin
    | StartLogout
    | UserObject Decode.Value
    | LoginUIShown Decode.Value
    | ReloadAfterVerify
    | ResendVerification
    | VerificationSent Decode.Value


uiContainer : Html msg
uiContainer =
    div [ Html.Attributes.id "firebaseLoginContainer" ] []


dummyLoginContainer : UserMasterData -> Html Msg
dummyLoginContainer user =
    if user.type_ == Auth then
        div [ Html.Events.onClick StartLogout ]
            [ h1 [] [ text "Click here to logout" ]
            , uiContainer
            ]

    else
        div [ Html.Events.onClick StartLogin ]
            [ h1 [] [ text "Click here to login" ]
            , uiContainer
            ]
