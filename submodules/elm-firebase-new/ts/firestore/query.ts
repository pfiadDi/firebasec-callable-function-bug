import {
  Firestore,
  startAfter,
  orderBy,
  query,
  QueryConstraint,
  limit,
  collection,
  doc,
  onSnapshot,
  getDoc,
} from "firebase/firestore";
import {
  checkQueryPayload,
  where_,
  parseError,
  execute,
  checkGetPayload,
  parseGetResults,
} from "./query.internal";
import { ElmPort } from "../auth/auth";

export const query_ = async (
  payload: unknown,
  db: Firestore,
  port: ElmPort
) => {
  try {
    const payload_ = checkQueryPayload(payload);
    const collRef = collection(db, payload_.collectionName);
    const qConstraints: Array<QueryConstraint> = where_(payload_.searchArray);
    qConstraints.push(limit(payload_.limit));
    if (payload_.startAfter !== null)
      qConstraints.push(startAfter(payload_.startAfter));
    qConstraints.push(orderBy(payload_.orderBy, payload_.direction));
    const q = query(collRef, ...qConstraints);
    return execute(q, payload_.listen, port, payload_.portIn);
  } catch (error) {
    //@ts-ignore
    return otherError(error, port, payload.portIn);
  }
};

export const getOne_ = (payload: unknown, db: Firestore, port: ElmPort) => {
  try {
    const payload_ = checkGetPayload(payload);
    const docRef = doc(db, payload_.collectionName, payload_.docId);
    if (payload_.listen) {
      onSnapshot(
        docRef,
        (doc) => {
          parseGetResults(doc, port, payload_.portIn);
        },
        (error) => {
          return parseError(error, port, payload_.portIn);
        }
      );
    } else {
      getDoc(docRef)
        .then((doc) => {
          parseGetResults(doc, port, payload_.portIn);
        })
        .catch((error) => {
          return parseError(error, port, payload_.portIn);
        });
    }
  } catch (error) {
    //@ts-ignore
    return otherError(error, port, payload.portIn);
  }
};

const otherError = (
  error: unknown,
  port: ElmPort,
  portIn: string | undefined | null
) => {
  let portInName: string;
  if (typeof portIn === "string") {
    portInName = portIn;
  } else {
    portInName = "unlikelyError";
  }
  return parseError(error, port, portInName);
};
