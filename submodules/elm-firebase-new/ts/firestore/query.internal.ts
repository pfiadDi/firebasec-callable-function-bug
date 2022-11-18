import { FirebaseApp } from "firebase/app";
import {where,DocumentSnapshot, OrderByDirection, WhereFilterOp,DocumentData, QuerySnapshot, Query, QueryDocumentSnapshot, onSnapshot,getDocs} from "firebase/firestore"
import {Decoder,object, decodeValue,str, num, DecodeError, oneOf,format, nil, array, bool, union} from "ts-json-decode"
import { ElmPort } from "../auth/auth";


type GetPayload = {
    collectionName:string;
    docId:string;
    listen:boolean;
    portIn:string
}

const decoderGetPayload : Decoder<GetPayload> = object({
    collectionName:str,
    docId:str,
    listen:bool,
    portIn:str,
})

type Search =  {
  field:string;
  operator:WhereFilterOp;
  value:number|string|boolean
}


export type QueryPayload = {
  collectionName:string;
  limit:number;
  startAfter:DocumentSnapshot|null;
  orderBy:string;
  direction:OrderByDirection;
  searchArray:Array<Search>;
  listen:boolean;
  portIn:string;
}

export const decoderOrderByDirection : Decoder<OrderByDirection> = union(
    str,"asc","desc"
) as Decoder<OrderByDirection>

export const decoderWhere : Decoder<WhereFilterOp> = format(
    /<|<=|==|!=|>=|>|array-contains|in|array-contains-any|not-in/
) as Decoder<WhereFilterOp>

const docSnap: Decoder<any> = value => {
    if(value instanceof DocumentSnapshot) return value;
    throw new DecodeError("Expected a DocumentSnapshot", "got anything else")
};

const decoderSearch : Decoder<Search> = object({
    field:str,
    operator:decoderWhere,
    value:oneOf(str,bool,num)
})

const decoderQueryPayload : Decoder<QueryPayload> = object({
    collectionName:str,
    limit:num,
    startAfter:oneOf(nil,docSnap),
    orderBy:str,
    direction:decoderOrderByDirection,
    searchArray:array<Search>(decoderSearch),
    listen:bool,
    portIn:str,
})

export const checkQueryPayload = (payload : unknown) : QueryPayload => {
    try {
        return decodeValue(decoderQueryPayload,payload)
    } catch (error) {
        throw error
    }
}
export const checkGetPayload = (payload : unknown) : GetPayload => {
    try {
        return decodeValue(decoderGetPayload,payload)
    } catch (error) {
        throw error
    }
}


export const where_ = (searchArray : Array<Search>) => {
  return searchArray.map(search => {
    return where(search.field,search.operator,search.value)
  }) 
}

type DocResult = {
  id:string;
  path:string;
  data:object|undefined
}

type LastElement = QueryDocumentSnapshot<DocumentData>

type QuerySuccess = {
        data: Array<DocResult>,
        lastElement: LastElement
}

type GetSuccess = {
    data:DocResult
}

type QueryResult = {
    name:string,
    payload: QuerySuccess|GetSuccess|NoDocs|QError
}



export const docResult = (docSnap : DocumentSnapshot) : GetSuccess => {
    return {data : {
            id:docSnap.id,
            path:docSnap.ref.path,
            data:docSnap.data()
        }}
}

export const docArray = (querySnap : QuerySnapshot,portInName : string) : QueryResult => {
    const res : Array<DocResult>= []
    querySnap.forEach(doc => {
        res.push({
            id : doc.id,
            path : doc.ref.path,
            data : doc.data()
        });
    })
    return createQueryResult({
            data:res, 
            lastElement: querySnap.docs[querySnap.docs.length - 1]
            },
            portInName)
}

const createQueryResult = (payload : QuerySuccess|GetSuccess|NoDocs|QError, portInName : string) : QueryResult => {
    return {
        name:portInName,
        payload:payload
    }
}


export const parseGetResults = (doc : DocumentSnapshot, port : ElmPort, portInName : string) => {
    if(doc.exists()) {
        return port.send(
            createQueryResult(
                docResult(doc),
                portInName
            )
        )
    } else {
        return port.send(noDocs(portInName))
    }
}

export const parseQueryResults = (queryRes : QuerySnapshot, port : ElmPort, portInName : string) => {
    if(queryRes.docs.length === 0) return port.send(noDocs(portInName));
    return port.send(docArray(queryRes,portInName))
}

export const execute = (q : Query<DocumentData>,listen : boolean, port : ElmPort,portInName : string) => {
    try {
        if(listen) {
            onSnapshot(q,snap => {
                parseQueryResults(snap,port,portInName) 
            },error =>{
                return parseError(error,port,portInName)
            })
        } else {
            getDocs(q).then(qRes => {
                parseQueryResults(qRes,port,portInName)
            }).catch(error =>{
                return parseError(error,port,portInName)
            });
    }
    } catch (error) {
        return parseError(error,port,portInName)
    }
}

export const parseError = (error :unknown,port : ElmPort,portInName:string)  => {
    let error_ = error as Error
    if(error_.message === "No documents found") {
        port.send(noDocs(portInName));
    } else {
        port.send(qError(error_,portInName))
    }
}

type NoDocs = {
    status:"NO-DOCUMENTS"
}

type QError = {
    status: "ERROR",
    error: string
}

const noDocs = (portInName : string) : QueryResult => {
    return createQueryResult({status:"NO-DOCUMENTS"},portInName)
}

const qError = (error : Error,portInName :string) : QueryResult => {
    return createQueryResult({
        status:"ERROR",
        error: error.message
    },portInName)
}