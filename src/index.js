//import "babel-polyfill";

import { initializeApp } from 'https://www.gstatic.com/firebasejs/9.14.0/firebase-app.js'

import { getFunctions } from 'https://www.gstatic.com/firebasejs/9.14.0/firebase-functions.js'


const firebaseConfig = {}

// Initialize Firebase
const app = initializeApp(firebaseConfig);

const functions = getFunctions(app,"europe-west3")

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