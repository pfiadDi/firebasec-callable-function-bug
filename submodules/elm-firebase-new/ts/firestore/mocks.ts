export const payload = {
    collectionName:"test",
    limit:10,
    startAfter:null,
    orderBy:"items",
    direction:"asc",
    searchArray: [
        {
            field:"name",
            operator:"==",
            value:"user1"
        }
    ],
    listen:false
} 
export const payloadEmpty = {
    collectionName:"test",
    limit:10,
    startAfter:null,
    orderBy:"items",
    direction:"asc",
    searchArray: [
        {
            field:"notExistingField",
            operator:"==",
            value:"user1"
        }
    ],
    listen:false
} 
export const payloadFailing = {
    collectionName:"",
    limit:10,
    startAfter:null,
    orderBy:"items",
    direction:"asc",
    searchArray: [
        {
            field:"notExistingField",
            operator:"==",
            value:"user1"
        }
    ],
    listen:false
} 

export const payloadWrong = {
    collectionName:"test",
    limit:10,
    orderBy:"fieldname",
    direction:"asc",
    searchArray: [
        {
            field:"name",
            operator:"==",
            value:"testName"
        }
    ]
} 