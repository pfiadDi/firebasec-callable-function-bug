import { FirebaseApp } from "firebase/app";
import { Firestore, collection, doc, setDoc } from "firebase/firestore";
import {
  checkPayload,
  resultOnline,
  resultOffline,
  resultPayload,
  resultError,
} from "./document.internal";
import { ElmPort } from "../auth/auth";

export const setDoc_ = (payload: unknown, db: Firestore, port: ElmPort) => {
  try {
    const payload_ = checkPayload(payload);
    const docRef =
      payload_.docId === null
        ? doc(collection(db, payload_.collectionName))
        : doc(db, `${payload_.collectionName}/${payload_.docId}`);
    const data = payload_.data === null ? {} : payload_.data;
    setDoc(docRef, data, { merge: payload_.merge })
      .then(() => {
        port.send(resultPayload(resultOnline(docRef.id), payload_.portIn));
      })
      .catch((error) => {
        port.send(
          resultPayload(resultError(error.message, docRef.id), payload_.portIn)
        );
      });
    port.send(resultPayload(resultOffline(docRef.id), payload_.portIn));
  } catch (error) {
    let error_ = error as Error;
    let portInName: string;
    //@ts-ignore
    if (typeof payload.portIn === "string") {
      //@ts-ignore
      portInName = payload.portIn;
    } else {
      portInName = "unlikelyError";
    }
    port.send(
      //@ts-ignore
      resultPayload(resultError(error_.message, payload.docId), portInName)
    );
  }
};
