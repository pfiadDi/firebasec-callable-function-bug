import { } from 'mocha'
import * as chai from 'chai'    
import chaiAsPromised = require('chai-as-promised');
chai.use(chaiAsPromised)
const expect = chai.expect

import { checkQueryPayload, decoderOrderByDirection, decoderWhere } from "./query.internal"
import { decodeString } from 'ts-json-decode';
import { execute } from './query';

import {payload, payloadWrong } from "./mocks"




describe('checks the query payload',()=>{
    it('Returns the same object, when all parameters are correct',()=> {
        expect(checkQueryPayload(payload)).to.be.eql(payload)
    })
    it('throws when something is missing',()=> {
        return expect(checkQueryPayload.bind(checkQueryPayload,payloadWrong)).to.throw("Expected a DocumentSnapshot")
    })
});

describe('checks and decode OrderByDirection',()=>{
    it('asc is successfull',()=> {
        expect(decodeString(decoderOrderByDirection,'"asc"')).to.equal("asc")
    })
    it('desc is successfull',()=> {
        expect(decodeString(decoderOrderByDirection,'"desc"')).to.equal("desc")
    })
    it('everything else fails',()=> {
        return expect(decodeString.bind(decodeString,decoderOrderByDirection,'""')).to.throw('Expected one of "asc" or "desc" but')
    })

});

describe('checks where op str',()=>{
    it('< is successfull',()=> {
        expect(decodeString(decoderWhere,'"<"')).to.equal("<")
    })
    it('<= is successfull',()=> {
        expect(decodeString(decoderWhere,'"<="')).to.equal("<=")
    })
    it('== is successfull',()=> {
        expect(decodeString(decoderWhere,'"=="')).to.equal("==")
    })
    it('!= is successfull',()=> {
        expect(decodeString(decoderWhere,'"!="')).to.equal("!=")
    })
    it('>= is successfull',()=> {
        expect(decodeString(decoderWhere,'">="')).to.equal(">=")
    })
    it('array-contains is successfull',()=> {
        expect(decodeString(decoderWhere,'"array-contains"')).to.equal("array-contains")
    })
    it('in is successfull',()=> {
        expect(decodeString(decoderWhere,'"in"')).to.equal("in")
    })
    it('array-contains-any is successfull',()=> {
        expect(decodeString(decoderWhere,'"array-contains-any"')).to.equal("array-contains-any")
    })
    it('not-in is successfull',()=> {
        expect(decodeString(decoderWhere,'"not-in"')).to.equal("not-in")
    })

    it('everything else fails',()=> {
        return expect(decodeString.bind(decodeString,decoderWhere,'""')).to.throw("Expected string matching /<|<=")
    })
    
});
