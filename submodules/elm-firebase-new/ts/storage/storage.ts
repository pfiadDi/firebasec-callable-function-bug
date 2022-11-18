import { FirebaseApp } from "firebase/app";
import { getStorage, FirebaseStorage, connectStorageEmulator } from "firebase/storage";


export const init = (app : FirebaseApp) => {
    return getStorage(app)
}  

export const useEmulator = (storage : FirebaseStorage,hostname:string,emuUrl : string|null, emuPort : number|null) => {
  emuUrl = (emuUrl === null || emuUrl === undefined) ? "localhost" : emuUrl;
  emuPort = (emuPort === null || emuPort === undefined) ? 9199 : emuPort;
  if(hostname === "localhost") {
      console.log("Conncted to storage emulator")
    return connectStorageEmulator(storage, emuUrl, emuPort,{mockUserToken:{
        user_id: "string"
    }}); 
  }
}

