import { FirebaseApp } from "firebase/app";
import {  Firestore, startAfter, orderBy, query, QueryConstraint, limit, collection, doc, onSnapshot, getDoc} from "firebase/firestore"
import {Decoder,object, decodeValue,str, num, DecodeError, oneOf,format, nil, array, bool, union} from "ts-json-decode"
import { payload } from "./mocks";


type Payload = {
    collectionName:string;
    docId:string|null;
    data:object|null;
    portIn:string;
    merge:boolean;
}

const decodeData: Decoder<any> = value => {
    if(typeof value === "object") return value;
    throw new DecodeError("Expected an object","got anything else")
}

const decodePayload : Decoder<Payload> = object({
    collectionName:str,
    docId:oneOf(str,nil),
    data:oneOf(nil,decodeData),
    portIn:str,
    merge:bool
})


export const checkPayload = (payload : unknown) : Payload => {
    try {
        return decodeValue(decodePayload,payload)
    } catch (error) {
        throw error
    }
}

export const resultOnline = (docId:string) : Result => {
    return {
        status:"SUCCESS-ONLINE"
        ,docId:docId
        ,error:undefined
    }
}
export const resultOffline = (docId:string) : Result => {
    return {
        status:"SUCCESS-OFFLINE"
        ,docId:docId
        ,error:undefined
    }
}

export const resultError = (error : string, docId : string|null|undefined) : Result => {
    return {
        status:"ERROR"
        ,docId:docId
        ,error:error
    }
}

export const resultPayload = (payload:Result, portIn:string ) : ResultPayload=> {
    return {
        name:portIn
        ,payload:payload
    }
}

type Result = {
    status:"ERROR"|"SUCCESS-ONLINE"|"SUCCESS-OFFLINE"
    docId:string|null|undefined
    error:string|undefined
}

type ResultPayload = {
    name:string;
    payload:Result
}
