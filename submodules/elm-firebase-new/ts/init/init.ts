import { FirebaseApp, FirebaseOptions, initializeApp } from "firebase/app";

export const initApp = (config : FirebaseOptions) : FirebaseApp => {
    return initializeApp(config);
}

