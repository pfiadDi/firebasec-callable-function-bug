//import "babel-polyfill";
import { firebaseConfig } from "../firebaseConfig";
import { initApp } from "../submodules/elm-firebase-new/ts/init/init";

import { getFunctions } from 'firebase/functions';
const fbApp = initApp(firebaseConfig(window.location.host));

const functions = getFunctions(fbApp,"europe-west3")

const importCsv = httpsCallable(functions, "importCsv");
importCsv({
        csv: portData.payload.file,
        importName: portData.payload.importName,
      })
        .then((result) => {
          const data = result.data;
          console.log(data);
        })
        .catch((error) => {
          // Getting the Error details.
          const code = error.code;
          const message = error.message;
          const details = error.details;
          // ...
          console.log(error);
        });