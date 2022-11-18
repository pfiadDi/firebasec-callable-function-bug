# elm-firestore
A collection of functions to use the Google Firestore JS SDK with elm 

# Firebase Authentication

## elm usage
import elm/User.elm 


### Model and Init

Add to to your model:

```
, user : Firebase.User.UserMasterData
, loginUiShown : Bool

```

Add this flag:

```
Firebase.User.UserMasterData
```

### Msg 
Add this msg
```
UserManagement Firebase.User.Msg
```



### Subscriptions
Add to your subscriptions 
```
Sub.map UserManagement <| Firebase.User.userPort Firebase.User.UserObject
, Firebase.Firestore.firestoreStatusError FirestoreStatusError
, Sub.map UserManagement <| Firebase.User.loginUIShown Firebase.User.LoginUIShown
```

### Update Examples
Handle the msgs like:

```
   Firebase.User.StartLogin ->
                    ( model, Firebase.User.startLogin (Encode.bool True) )

    Firebase.User.StartLogout ->
        ( { model | loginUiShown = False }, Firebase.User.startLogout (Encode.bool True) )

    Firebase.User.UserObject json ->
        let
            ( appState, user ) =
                Main.App.setState json
        in
        ( { model | appState = appState, user = user }, Cmd.none )

    Firebase.User.LoginUIShown json ->
        case Decode.decodeValue Decode.bool json of
            Ok status ->
                if status then
                    ( { model | loginUiShown = True }, Cmd.none )

                else
                    ( { model | loginUiShown = False }, Cmd.none )

            Err err ->
                ( { model | appState = Main.App.UnlikleyError <| "an unexpected error has occurred" }, Cmd.none )
``` 

### JS 
Inititialize your elm app within a anonymous async function and await the user 
```
const authFunctions = require('js/authentication');
(async () => {
    let user = await authFunctions.getCurrentUser(firebase.auth());
    //let user = await authFunctions.getOrCreateAnonymouseUser(firebase.auth());
    const app = Elm.Main.init({ flags: user });

    //... rest of your code 

})();
```