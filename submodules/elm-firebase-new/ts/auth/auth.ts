import { getAuth, Auth, isSignInWithEmailLink, onAuthStateChanged, signInWithEmailLink, User, signInAnonymously,sendSignInLinkToEmail, signOut, connectAuthEmulator,setPersistence, browserLocalPersistence, browserSessionPersistence,inMemoryPersistence, Persistence } from "firebase/auth";
import { FirebaseApp } from "firebase/app";



export interface ElmPort {
    send:(a : any) => void
}

export function startSignInWithLinkToEmail(payload : any, auth : Auth) {
    let email = window.prompt(promptText(language(payload.lang)))
    if(email === null) return;
    signInWithLinkToEmail(auth,email,payload.redirectUrl)
}

export function startSignInWithLinkToEmail_(payload : any, auth : Auth) {
    if(payload.email === null) return;
    signInWithLinkToEmail(auth,payload.email,payload.redirectUrl)
}



export const watchAuthState = (auth : Auth, port : ElmPort) => {
    onAuthStateChanged(auth, (user) => {
        port.send({
            name:"AuthStateChanged_",
            payload:user
        })
    })
}


export const init = (app : FirebaseApp) => {
    return getAuth(app);
}  

export const useEmulator = (auth : Auth,hostname:string,emuUrl : string|null) => {
  emuUrl = (emuUrl === null || emuUrl === undefined) ? "http://localhost:9099" : emuUrl;
  if(hostname === "localhost") { 
    return connectAuthEmulator(auth, emuUrl);
  }
}

export const logout = (auth:Auth) => {
  signOut(auth);
}

export const getUserEmailLink = (auth : Auth, emailLink : string , email : string, languageRaw : string) : Promise<User|null> => {
    return new Promise(async (resolve, reject) => {
        if (emailLink && isSignInWithEmailLink(auth, emailLink)) {
            await completeEmailSignIn(auth,email, emailLink,language(languageRaw));
        } 
        const unsubscribe = onAuthStateChanged(auth,(user) => {
                unsubscribe();
                resolve(user);
         }, reject);
    });
}
export const getUser = (auth : Auth, createAnon : boolean) : Promise<User|null> => {
    return new Promise(async (resolve, reject) => {
        const unsubscribe = onAuthStateChanged(auth,(user) => {
                unsubscribe();
                resolve(user);
         }, reject);
    });
}

export const getUserAnon = async (auth : Auth) : Promise<User> => {
  try {
    return (await signInAnonymously(auth)).user;
  }catch(e) {
    throw e
  }
}

export const signInWithLinkToEmail = async (auth : Auth, email : string, url : string) : Promise<Status> => {
  try {
    await sendSignInLinkToEmail(auth,email, {
      url:url, 
      handleCodeInApp : true
    });
    window.localStorage.setItem('emailForSignIn', email);
    return createStatus("success","E-Mail sent");
  } catch (error) {
    return createStatus("error",error)
  }

}



const completeEmailSignIn = async (auth : Auth, email : string|null, emailLink:string, lang : Language) => {
  try {
    if (email === null) {
      // User opened the link on a different device. To prevent session fixation
      // attacks, ask the user to provide the associated email again. For example:
      email = window.prompt(promptText(lang));
    } 
    if(email === null) throw new Error('No email found');
    window.localStorage.removeItem('emailForSignIn');
    console.log("should be deleted")
    return await signInWithEmailLink(auth, email, emailLink);
    //return authResult.user;
  }catch(e) {
    let e_ = e as Error;
    console.log(e_.message)
    return null;
  }
}

type Language = 
  "de" | "en"

export const language = (lang : string) : Language => {
  switch (lang.toLowerCase().slice(0,2)) {
    case "de":
      return "de"
    case "en":
      return "en";
    default:
      return "en"
  }
}

export const promptText = (lang : Language) : string => {
  switch (lang) {
    case "en":
      return "Please provide your email for confirmation"
    case "de":
      return "Bitte geben Sie zur Bestätigung Ihre E-Mail Adresse erneut ein"
    default:
      return "Please provide your email for confirmation"
  }
}

type StatusType = "success" | "error"

type Status = {
  "status":"SUCCESS"|"ERROR"|"UNKNOWN";
  "content":any;
}

export const createStatus = (statusType : StatusType,msg : any) : Status => {
  switch (statusType) {
    case "success":
      return {
        "status" : "SUCCESS",
        "content" : msg
      }
    case "error":
      return {
        "status" : "ERROR",
        "content" : msg
      }
    default:
      return {
        "status" : "UNKNOWN",
        "content" : "A unknown status was requested"
      };
  }
}

type PersistenceTypes = "local"|"session"|"none"

export const persistence = (type : PersistenceTypes) : Persistence => {
  switch (type) {
    case "local":
      return browserLocalPersistence
    case "session":
      return browserSessionPersistence
    case "none":
      return inMemoryPersistence
    default:
      return browserSessionPersistence
  }
}

export const setAuthPersistence = async (auth:Auth, type : PersistenceTypes) => {
  try {
    await setPersistence(auth,persistence(type))
    return createStatus("success",`Auth persistence set to ${type}`)
  } catch(e) {
    return createStatus("error",e)
  }

}