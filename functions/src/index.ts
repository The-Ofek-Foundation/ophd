/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// eslint-disable-next-line @typescript-eslint/no-explicit-any
import * as dataFetcherFunctions from "./data_fetcher";

export const fetchAllResearchers = dataFetcherFunctions.fetchAllResearchers;
export const fetchAllPublications = dataFetcherFunctions.fetchAllPublications;
export const updateDatabase = dataFetcherFunctions.updateDatabase;

export const updatePublicationsForResearcher = dataFetcherFunctions.updatePublicationsForResearcher;
