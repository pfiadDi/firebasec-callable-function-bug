import { FirebaseApp } from "firebase/app";
import { enableIndexedDbPersistence, Firestore, getFirestore, connectFirestoreEmulator } from "firebase/firestore"; 
import { ElmPort } from "../auth/auth";
import { query_, getOne_ } from "./query"
import { setDoc_ } from "./document"

export const enableOffline = async (db : Firestore, port : ElmPort) => {
    try {
        await enableIndexedDbPersistence(db);
        return;
    }catch(e) {
        let e_ = e as Error
        port.send({
            name:"FirestoreStatusError_",
            payload:e_.message
        })
    }
}

export const query = (payload : unknown, db : Firestore, port : ElmPort) => {
    query_(payload,db,port)
}
export const getOne = (payload : unknown, db : Firestore, port : ElmPort) => {
    getOne_(payload,db,port)
}
export const setDoc = (payload : unknown, db : Firestore, port : ElmPort) => {
    setDoc_(payload,db,port)
}

export const initFS = (app : FirebaseApp) : Firestore => {
    return getFirestore(app);
}


export const useFSEmulator = (db : Firestore, hostname:string, port : number|null) => {
  port = (port === null || port === undefined) ? 8080 : port;
  if(hostname === "localhost") { 
      console.log("Firestore Emulator used")
    return connectFirestoreEmulator(db, hostname, port);
  }
}