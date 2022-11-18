import * as functions from "firebase-functions";

export const importCsv = functions
  .region("europe-west3")
  .https.onCall(async (data, context) => {
    try {
      console.log("importCSV started");
      if (!context.auth) throw new Error("Missing auth:");

      return {
        parsedRows: 2,
      };
    } catch (e) {
      const error = e as Error;
      const errorReason = error.message.split(":");
      switch (errorReason[0]) {
        case "Missing auth":
          throw new functions.https.HttpsError(
            "failed-precondition",
            "The function must be called while authenticated."
          );
        case "Csv argument missing":
          throw new functions.https.HttpsError(
            "invalid-argument",
            "CSV missing"
          );
        case "Import name missing":
          throw new functions.https.HttpsError(
            "invalid-argument",
            "Import name missing"
          );

        case "Csv parsing error":
          throw new functions.https.HttpsError(
            "invalid-argument",
            `${error.message}`
          );
        default:
          throw new functions.https.HttpsError(
            "internal",
            "Something else happend"
          );
      }
    }
  });
