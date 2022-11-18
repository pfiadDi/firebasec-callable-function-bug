import { } from 'mocha'
import * as chai from 'chai'    
import chaiAsPromised = require('chai-as-promised');
chai.use(chaiAsPromised)
const expect = chai.expect
import {createStatus, language, promptText, persistence } from "./auth"
import { browserLocalPersistence,browserSessionPersistence,inMemoryPersistence} from "firebase/auth"

describe("Request persitence types",()=> {
    it("local returns browserLocalPersistence", ()=>{
        expect(persistence('local')).to.be.eql(browserLocalPersistence)
    })
    it("session returns browserSessionPersistence", ()=>{
        expect(persistence('session')).to.be.eql(browserSessionPersistence)
    })
    it("none returns inMemoryPersistence", ()=>{
        expect(persistence('none')).to.be.eql(inMemoryPersistence)
    })
})

describe('Browser language to Language', () => {
    it('de-At returns de', () => {
        expect(language("de-At")).to.be.equal("de")
    })
    it('De-de returns de', () => {
        expect(language("De-de")).to.be.equal("de")
    })
    it('en returns en', () => {
        expect(language("en")).to.be.equal("en")
    })
    it('fr-fr returns en', () => {
        expect(language("en")).to.be.equal("en")
    })
})

describe("auth prompt text", () => {
    it('en - Please provide your email for confirmation', ()=>{
        expect(promptText('en')).to.be.equal("Please provide your email for confirmation")
    })

    it('de - Bitte geben Sie zur Bestätigung Ihre E-Mail Adresse erneut ein', ()=>{
        expect(promptText('de')).to.be.equal("Bitte geben Sie zur Bestätigung Ihre E-Mail Adresse erneut ein")
    })
})

describe("Status",()=>{
    it('success returns success with the passed content',()=>{
        expect(createStatus("success","my msg")).eql({
            "status" : "SUCCESS",
            "content" : "my msg"
        })
    })
    it('error returns error with the passed content',()=>{
        expect(createStatus("error","my err msg")).eql({
            "status" : "ERROR",
            "content" : "my err msg"
        })
    })
})