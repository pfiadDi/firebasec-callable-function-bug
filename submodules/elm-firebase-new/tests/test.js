const expect = require('chai').expect;

const returnStatus = ({status, docId, content}) => {
    switch (status) {
        case "empty":
            return { "status": "NO-DOCUMENTS" };
            break;

        case "online":
            return { "status": "SUCCESS-ONLINE", "docId": docId };
            break;

        case "offline":
            return { "status": "SUCCESS-OFFLINE", "docId": docId };
            break;

        case "error":
            let res = { "status": "ERROR", "error": JSON.stringify(content) };
            if (docId !== undefined) res["docId"] = docId;
            return res;
            break;

        default:
            return;
    }
}


const empty = {
    status : "NO-DOCUMENTS"
}
const online = {
    status : "SUCCESS-ONLINE",
    docId : "testDoc"
}

const offline = {
    status : "SUCCESS-OFFLINE",
    docId : "testDoc"
}

const error = {
    status : "ERROR",
    docId : "testDoc",
    error: "\"der fehler\""
}
const errorNoId = {
    status : "ERROR",
    error: "\"der fehler\""
}

describe('When we request a status, it returns', () => {
        it('no document when passed empty', () => {
            expect(returnStatus({status:"empty"})).to.eql(empty);
        })
        it('online with docid', () => {
            expect(returnStatus({status:"online",docId:"testDoc"})).to.eql(online);
        })
        it('offline with docid', () => {
            expect(returnStatus({status:"offline",docId:"testDoc"})).to.eql(offline);
        })
        it('error with docId when passed a docid', () => {
            expect(returnStatus({status:"error",docId:"testDoc",content:"der fehler"})).to.eql(error);
        })
        it('error with no docId when no docid is passed', () => {
            expect(returnStatus({status:"error",content:"der fehler"})).to.eql(errorNoId);
        })
    

});

