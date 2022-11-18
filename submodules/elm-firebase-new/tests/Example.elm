module Example exposing (..)

import Expect exposing (Expectation)
import Firebase.User
import Json.Decode
import Test exposing (..)
import Firebase.Firestore



        
decodeUser : Test
decodeUser =
    describe "Testing decoding of the user object"
        [ test "correct user" <|
            \_ -> Ok userMasterData |> Expect.equal (Json.Decode.decodeString Firebase.User.userDecoder userObject)
        , test "correct anonymous user" <|
            \_ -> Ok anonUserMasterData |> Expect.equal (Json.Decode.decodeString Firebase.User.userDecoder anonUserObject)
        , test "correct verified user" <|
            \_ -> Ok verifiedUserMasterData |> Expect.equal (Json.Decode.decodeString Firebase.User.userDecoder veriefiedUserObject)
        ]


userMasterData : Firebase.User.UserMasterData
userMasterData =
    { displayName = "John Doe"
    , email = "urban.th@gmail.com"
    , photoURL = "/avatar.png"
    , uid = "Okcp27jsZceXlsgTlSMfS8BoPC12"
    , type_ = Firebase.User.Auth
    , emailVerified = False
    }


verifiedUserMasterData : Firebase.User.UserMasterData
verifiedUserMasterData =
    { displayName = "John Doe"
    , email = "urban.th@gmail.com"
    , photoURL = "/avatar.png"
    , uid = "Okcp27jsZceXlsgTlSMfS8BoPC12"
    , type_ = Firebase.User.Auth
    , emailVerified = True
    }


anonUserMasterData : Firebase.User.UserMasterData
anonUserMasterData =
    { displayName = "NO DISPLAYNAME"
    , email = ""
    , photoURL = "/avatar.png"
    , uid = "w1luTssWt7OiGaT3ODwVXOQWvSz1"
    , type_ = Firebase.User.Anonymous
    , emailVerified = False
    }


userObject : String
userObject =
    """
 {
    "uid": "Okcp27jsZceXlsgTlSMfS8BoPC12",
    "displayName": "John Doe",
    "photoURL": null,
    "email": "urban.th@gmail.com",
    "emailVerified": false,
    "phoneNumber": null,
    "isAnonymous": false,
    "tenantId": null,
    "providerData": [
        {
            "uid": "urban.th@gmail.com",
            "displayName": "urban.th@gmail.com",
            "photoURL": null,
            "email": "urban.th@gmail.com",
            "phoneNumber": null,
            "providerId": "password"
        }
    ],
    "apiKey": "AIzaSyCklS7mMyB3_ILbyDXm0UU1KDhh_9Ph-Ms",
    "appName": "[DEFAULT]",
    "authDomain": "h-i-p-hub.firebaseapp.com",
    "stsTokenManager": {
        "apiKey": "AIzaSyCklS7mMyB3_ILbyDXm0UU1KDhh_9Ph-Ms",
        "refreshToken": "AOvuKvSPjwZHx7DVhDfXFvZ-xbklMYCypVrSjCq-MeHA79F6ABwJBvOn1bfFH_rDVgI7s34ZTplvXhRZ-lFbGRa8h8CMPSX9RsukvMqa3knkCiV4BRBIJ8gNJRh4I2flN75Pe9v8UgyNDA2TAkXBjY5YEiZUn7F2AVzK-PK4TQLhGqa8NVb0M6OtYUoUOPgwB8xhRrfpleT_",
        "accessToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImEyYjkxODJiMWI0NmNiN2ZjN2MzMTFlZTgwMjFhZDY1MmVlMjc2MjIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vaC1pLXAtaHViIiwiYXVkIjoiaC1pLXAtaHViIiwiYXV0aF90aW1lIjoxNjExMjY5OTY4LCJ1c2VyX2lkIjoiT2tjcDI3anNaY2VYbHNnVGxTTWZTOEJvUEMxMiIsInN1YiI6Ik9rY3AyN2pzWmNlWGxzZ1RsU01mUzhCb1BDMTIiLCJpYXQiOjE2MTEyNjk5NjgsImV4cCI6MTYxMTI3MzU2OCwiZW1haWwiOiJ1cmJhbi50aEBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsidXJiYW4udGhAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.bdhiD574BLs5ed9BL0bbcfhRt-8KGqR36Em7GhEUcocQAvFImoBDY5qK2ZWO3zXH9v-FQULu_mSkT7_9X3by0HIaUYJrSVd7dldt2Yr_SACW3jOTPZ8IwQdNZjSvvcHVRmq2ahPeVpXJX6-J5hmwQ1-l_X6F_VuvyS2rcAvANdkQ-EiQH6qsiOkNv-lOMKTuaTUxcyLcN_AD3ZHwr6zX3KebCqXPD91sLCVb7HxSK1ty5K40k4AS_gIswoGyf6DpXC-V2IAaL67hw8mWVVPFlaq2RCqunxqubkSAhtPBFca_qcWimMRT-jQb1Eh5ZsDTIRBoC601V-NVAn5sDOgPlA",
        "expirationTime": 1611273568960
    },
    "redirectEventId": null,
    "lastLoginAt": "1611269968690",
    "createdAt": "1611269968690",
    "multiFactor": {
        "enrolledFactors": []
    }
}
 """


veriefiedUserObject : String
veriefiedUserObject =
    """
 {
    "uid": "Okcp27jsZceXlsgTlSMfS8BoPC12",
    "displayName": "John Doe",
    "photoURL": null,
    "email": "urban.th@gmail.com",
    "emailVerified": true,
    "phoneNumber": null,
    "isAnonymous": false,
    "tenantId": null,
    "providerData": [
        {
            "uid": "urban.th@gmail.com",
            "displayName": "urban.th@gmail.com",
            "photoURL": null,
            "email": "urban.th@gmail.com",
            "phoneNumber": null,
            "providerId": "password"
        }
    ],
    "apiKey": "AIzaSyCklS7mMyB3_ILbyDXm0UU1KDhh_9Ph-Ms",
    "appName": "[DEFAULT]",
    "authDomain": "h-i-p-hub.firebaseapp.com",
    "stsTokenManager": {
        "apiKey": "AIzaSyCklS7mMyB3_ILbyDXm0UU1KDhh_9Ph-Ms",
        "refreshToken": "AOvuKvSPjwZHx7DVhDfXFvZ-xbklMYCypVrSjCq-MeHA79F6ABwJBvOn1bfFH_rDVgI7s34ZTplvXhRZ-lFbGRa8h8CMPSX9RsukvMqa3knkCiV4BRBIJ8gNJRh4I2flN75Pe9v8UgyNDA2TAkXBjY5YEiZUn7F2AVzK-PK4TQLhGqa8NVb0M6OtYUoUOPgwB8xhRrfpleT_",
        "accessToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImEyYjkxODJiMWI0NmNiN2ZjN2MzMTFlZTgwMjFhZDY1MmVlMjc2MjIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vaC1pLXAtaHViIiwiYXVkIjoiaC1pLXAtaHViIiwiYXV0aF90aW1lIjoxNjExMjY5OTY4LCJ1c2VyX2lkIjoiT2tjcDI3anNaY2VYbHNnVGxTTWZTOEJvUEMxMiIsInN1YiI6Ik9rY3AyN2pzWmNlWGxzZ1RsU01mUzhCb1BDMTIiLCJpYXQiOjE2MTEyNjk5NjgsImV4cCI6MTYxMTI3MzU2OCwiZW1haWwiOiJ1cmJhbi50aEBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsidXJiYW4udGhAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.bdhiD574BLs5ed9BL0bbcfhRt-8KGqR36Em7GhEUcocQAvFImoBDY5qK2ZWO3zXH9v-FQULu_mSkT7_9X3by0HIaUYJrSVd7dldt2Yr_SACW3jOTPZ8IwQdNZjSvvcHVRmq2ahPeVpXJX6-J5hmwQ1-l_X6F_VuvyS2rcAvANdkQ-EiQH6qsiOkNv-lOMKTuaTUxcyLcN_AD3ZHwr6zX3KebCqXPD91sLCVb7HxSK1ty5K40k4AS_gIswoGyf6DpXC-V2IAaL67hw8mWVVPFlaq2RCqunxqubkSAhtPBFca_qcWimMRT-jQb1Eh5ZsDTIRBoC601V-NVAn5sDOgPlA",
        "expirationTime": 1611273568960
    },
    "redirectEventId": null,
    "lastLoginAt": "1611269968690",
    "createdAt": "1611269968690",
    "multiFactor": {
        "enrolledFactors": []
    }
}
 """


anonUserObject : String
anonUserObject =
    """
{
    "uid": "w1luTssWt7OiGaT3ODwVXOQWvSz1",
    "displayName": null,
    "photoURL": null,
    "email": null,
    "emailVerified": false,
    "phoneNumber": null,
    "isAnonymous": true,
    "tenantId": null,
    "providerData": [],
    "apiKey": "AIzaSyCklS7mMyB3_ILbyDXm0UU1KDhh_9Ph-Ms",
    "appName": "[DEFAULT]",
    "authDomain": "h-i-p-hub.firebaseapp.com",
    "stsTokenManager": {
        "apiKey": "AIzaSyCklS7mMyB3_ILbyDXm0UU1KDhh_9Ph-Ms",
        "refreshToken": "AOvuKvRDeHvk-epuiCEmrflTBF5OwNL8k3Uezc0qvNNhLoJ1I-IMv9EdJP241t9FJPYGZhtNKt-lP4I14xYeXpASHia-Lq_guAtaN7M95qxoV214DVux4wxVaxaX5uEsGX-6ofXzaH8Wp5WtCBuKmzzABzavq9-leFMN14tac-NRqs5MTcCpbtg",
        "accessToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImEyYjkxODJiMWI0NmNiN2ZjN2MzMTFlZTgwMjFhZDY1MmVlMjc2MjIiLCJ0eXAiOiJKV1QifQ.eyJwcm92aWRlcl9pZCI6ImFub255bW91cyIsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS9oLWktcC1odWIiLCJhdWQiOiJoLWktcC1odWIiLCJhdXRoX3RpbWUiOjE2MTEyNzAyOTQsInVzZXJfaWQiOiJ3MWx1VHNzV3Q3T2lHYVQzT0R3VlhPUVd2U3oxIiwic3ViIjoidzFsdVRzc1d0N09pR2FUM09Ed1ZYT1FXdlN6MSIsImlhdCI6MTYxMTI3MDI5NCwiZXhwIjoxNjExMjczODk0LCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7fSwic2lnbl9pbl9wcm92aWRlciI6ImFub255bW91cyJ9fQ.e0pteQubEiAq1uJoldoVkvH8IKsn5ZSO8yxsKckqJJ-3GjLI4sGWLzsJSVEtNegStdrsi10GOjePjOVBupabpjrNh_2_It4eXxu-5MpORTh7ns5mVDAv-FM5xtfC5LTF2cjGq32KFAHOU7Cjo7c9jkAbVRX8AeuLMq_kcMGEVR7qJnJdCtA88f9PbxLyExZH3xhMXlYr3Vs5koNbFPUSRxX_K33N73cp_SVCYOXb_JaCwITFstuXmVidvi3IGVQe9irO4mp-QtfVAYRp3KAZzzX7kt1nzRja-JohuBZxRAXTVjyZkPGaOFWDE7FZoiKBDb5X6IMbp-Fg1ptQWSXTCQ",
        "expirationTime": 1611273894617
    },
    "redirectEventId": null,
    "lastLoginAt": "1611270294536",
    "createdAt": "1611270294536",
    "multiFactor": {
        "enrolledFactors": []
    }
}
"""
