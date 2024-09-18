const { uniqueIdentifier } = require("../packages/uuid");
const { generateNonce } = require("../nonce.source");
const { getUserProfile, getWallet, cache3rdPartResponse } = require("./store");
const { sendHelpEmailNotifications } = require("./notifications");
const { getAll, updateItem } = require("./db_operations");
const jsonServer = require("json-server");
const path = require('node:path');
const logger = require("../packages/logger");
const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));
const VERIFYID_3RD_PARTY_TOKEN =
  process.env.VERIFYID_3RD_PARTY_TOKEN || "3rd_party_token";
const HOST = process.env.HOST || "0.0.0.0";
const PORT = process.env.PORT || "5400";
const ADMIN_EMAIL = process.env.VERIFIED_ADMIN_EMAIL || 'admin@byteestudio.com'
const CDN = process.env.CDN_BASE_URL || 'http://192.168.0.132:4334/static/';
const { getImageAsBase64 } = require('.././utils/image')

const fakeContactResData = {
  status: "Success",
  contactEnquiry: {
    results: [
      {
        idnumber: "09877087090987",
        forename1: "JUST",
        forename2: "METHOD",
        surname: "GOOFY",
      },
      {
        idnumber: "7865765786576",
        forename1: "SAKIO",
        forename2: "NIXON",
        surname: "MALATJI",
      },
      {
        idnumber: "74567456745645",
        forename1: "JUST",
        forename2: "FRED",
        surname: "LONGONE",
      },
      {
        idnumber: "345234523452345",
        forename1: "GUMMY",
        forename2: "",
        surname: "BEAR",
      },
    ],
  },
};

const fakeSaidResData = {
  status: "ID Number Valid",
  verification: {
    firstnames: "JUST",
    lastname: "GOOFY",
    dob: "1979-05-01",
    age: 39,
    idNumber: "IDNUMBER_09123123",
    gender: "Male",
    citizenship: "South African",
    dateIssued: "1997-07-25T00:00:00+02:00",
  },
};

const fakeCreditResData = { Status: "Success", Result: { sadl_credits: 0 } };
/**
 * Generate a transaction history description
 * @param {number} amount
 * @returns {string}
 */
const _transactionDescription = (query) => {
  try {
    const statements = [
      "Charge: Deduction for searching '#QUERY' at #DATE.",
      "Charge: Amount deducted for searching '#QUERY' at #DATE.",
      "Charge: Deduction for querying '#QUERY' at #DATE.",
      "Transaction: Debited funds for conducting a search on '#QUERY' at #DATE.",
      "Charge: Charged amount for performing search on '#QUERY' at #DATE.",
      "Charge: Deduction for performing a search on '#QUERY' at #DATE.",
      "Charge: Amount deducted for searching '#QUERY' in-app at #DATE.",
      "Charge: Deduction for conducting a search for '#QUERY' at #DATE.",
      "Charge: Payment deducted for searching '#QUERY' at #DATE.",
      "Charge: Deduction for utilizing search feature for '#QUERY' at #DATE.",
      "Charge: Deduction for searching '#QUERY' made at #DATE.",
      "Charge: Amount charged for searching '#QUERY' at #DATE.",
    ];

    const rnd = Math.floor(Math.random() * statements.length);
    ///
    const date = new Date().toLocaleDateString("en-US", {
      year: "numeric",
      month: "long",
      day: "numeric",
    });
    ///
    const statement = statements[rnd];
    const description = statement
      .replace("#QUERY", query)
      .replace("#DATE", date);
    return description;
  } catch (error) {
    const date = new Date().toLocaleDateString("en-US", {
      year: "numeric",
      month: "long",
      day: "numeric",
    });
    console.log(error);
    return "Charge: Deducted credits for performing a search on '#QUERY' at #DATE."
      .replace("#QUERY", query)
      .replace("#DATE", date);
  }
};
/**
 * Represents a transaction object when someone uses their credits.
 * @typedef {Object} Transaction
 * @property {string} profileId - The profile ID of the payer.
 * @property {number} amount - The amount of the transaction.
 * @property {string} isoCurrencyCode - The ISO currency code of the transaction.
 * @property {string} categoryId - The category ID of the transaction.
 * @property {number} timestamp - The timestamp of the transaction in Unix time (seconds).
 * @property {Object|null} details - Additional details of the transaction.
 * @property {string} details.id - The ID of the details.
 * @property {string} details.query - The query of the details.
 * @property {string} description - The description of the transaction.
 * @property {string} subtype - The subtype of the transaction.
 * @property {string} type - The type of the transaction.
 * @property {string} transactionReferenceNumber - The reference number of the transaction.
 * @property {string} transactionId - The ID of the transaction.
 */

/**
 *
 * @param {Transaction} transaction
 */
async function recordBurnCreditsTransaction(transaction) {
  try {
    console.log("Hit the store API and save the burn credits... ", transaction);
    const headers = new Headers();
    headers.append("x-nonce", generateNonce());
    headers.append("Content-Type", "application/json");
    headers.append("Authorization", `Bearer TOKEN`);

    const options = {
      method: "POST",
      headers: headers,
      body: JSON.stringify(transaction),
    };
    const host =
      (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) +
      ":5400";
    fetch(`http://${host}/api/v1/history/resource/`, options)
      .then((response) => response.json())
      .then((result) =>
        console.log("Logged burn transaction successfully", result)
      )
      .catch((error) => console.error(error));
  } catch (error) {
    console.log("Error @ record payment/burn transaction", error);
  }
}

async function handleContactEnquiry(req, res) {
  try {
    const { contact_number, reason } = req?.body;
    console.table(req?.body);
    const { client: clientId } = req.query;
    /** prod | test */
    const clientEnv = req?.headers["x-client-env"];
    let verificationResponse;

    /// hit 3rd party API
    if (clientEnv !== "test") {
      const headers = new Headers();
      headers.append("Content-Type", "multipart/form-data");
      headers.append("Accept", "application/json");

      const formdata = new FormData();
      formdata.append("api_key", VERIFYID_3RD_PARTY_TOKEN);
      formdata.append("contact_number", contact_number);

      const options = {
        method: "POST",
        headers: headers,
        body: formdata,
      };

      const response = await fetch(
        "https://www.verifyid.co.za/webservice/contact_enquiry",
        options
      );
      verificationResponse = await response.json();
    }
    /// if it successful, deduct credit form client wallet

    if (clientEnv === "test" || verificationResponse) {
      global.queue.push(() =>
        deductCreditsAfterTransaction(contact_number, clientId)
      );
    }
    //
    if (verificationResponse) {
      global.queue.push(() =>
        cache3rdPartResponse({ id: contact_number, data: verificationResponse })
      );
    }

    res.status(200).send(verificationResponse || fakeContactResData);
  } catch (error) {
    console.log(error);
    res.status(500).send({ error: error.toString() });
  }
}

async function handleSaidVerification(req, res) {
  try {
    const { id_number, reason } = req?.body;
    const { client: clientId } = req.query;
    console.table(req?.body);
    /** prod | test */
    const clientEnv = req?.headers["x-client-env"];
    let verificationResponse;

    /// hit 3rd party API
    if (clientEnv !== "test") {
      const headers = new Headers();
      headers.append("Content-Type", "multipart/form-data");
      headers.append("Accept", "application/json");

      const formdata = new FormData();
      formdata.append("api_key", VERIFYID_3RD_PARTY_TOKEN);
      formdata.append("id_number", id_number);

      const options = {
        method: "POST",
        headers,
        body: formdata,
      };

      const response = await fetch(
        "https://www.verifyid.co.za/webservice/said_verification",
        options
      );

      verificationResponse = await response.json();
    }
    /// if it successful, deduct credit form client wallet

    if (clientEnv === "test" || verificationResponse) {
      global.queue.push(() =>
        deductCreditsAfterTransaction(id_number, clientId)
      );
    }

    if (verificationResponse) {
      global.queue.push(() =>
        cache3rdPartResponse({ id: id_number, data: verificationResponse })
      );
    }

    res.status(200).send(verificationResponse || fakeSaidResData);
  } catch (error) {
    console.log(error);
    res.status(500).send({ error: error.toString() });
  }
}

async function handleGetCreditsReq(req, res) {
  try {
    /** prod | test */
    const clientEnv = req?.headers["x-client-env"];
    const randomNumber = Math.floor(Math.random() * 1000);

    //if it's a test env simulate an error or return test/fake data
    if (clientEnv === "test") {
      if (randomNumber > 100) res.status(500).send({ error: 'chaos monkey' });
      else res.send(fakeCreditResData);

      return;
    }

    /// hit 3rd party API
    const headers = new Headers();
    headers.append("Accept", "application/json");

    const requestOptions = {
      method: "GET",
      headers: headers,
    };

    const response = await fetch(
      `https://www.verifyid.co.za/webservice/my_credits?api_key=${VERIFYID_3RD_PARTY_TOKEN}`,
      requestOptions
    );

    const data = await response.json();

    res.send(data);
  } catch (error) {
    console.log(error);
    res.status(500).send({ error: error.toString() });
  }
}

/**
 *
 * @param {string} query user query string, i.e, id number | phone number
 * @param {string} clientId user uuid
 */
const deductCreditsAfterTransaction = async (query, clientId) => {
  try {
    const user = await getUserProfile(clientId);
    const wallet = await getWallet(user?.walletId || "");
    const CENTS = 100;

    // Update wallet
    const options = {
      method: "PUT",
      headers: {
        "x-nonce": generateNonce(),
        "Content-Type": "application/json",
        Authorization: "Bearer TOKEN",
      },
      body: JSON.stringify({
        balance: Math.max(0, Number(wallet.balance - (30 * CENTS))),
      }),
    };
    const host =
      (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) +
      ":5400";

    const response = await fetch(
      `http://${host}/api/v1/wallet/resource/${wallet?.id}`,
      options
    );

    const data = await response.json();
    console.log("Wallet Update.");
    console.table(data);

    await recordBurnCreditsTransaction({
      profileId: user?.id || user?.profileId || "",
      // 30 rands by 100 cents
      amount: 30 * CENTS,
      isoCurrencyCode: "ZAR",
      categoryId: null,
      timestamp: Math.floor(Date.now() / 1000),
      details: {
        id: uniqueIdentifier(),
        query,
      },
      description: _transactionDescription(query),
      subtype: "spend",
      type: null,
      transactionReferenceNumber: uniqueIdentifier(),
      transactionId: uniqueIdentifier(),
    });

    // log a transaction
  } catch (error) {
    console.error("deductCreditsAfterTransaction", error);
  }
};
/**
 * @typedef {Object} KycVerificationData
 * @property {string} name - The name of the individual.
 * @property {?string} idNumber - The ID number of the individual (can be null).
 * @property {string} phoneNumber - The phone number of the individual.
 * @property {?string} bankAccountNumber - The bank account number (can be null).
 * @property {string} email - The email of the individual.
 * @property {?string} description - A description (can be null).
 * @property {string[]} selectedServices - The services selected by the individual.
 * @property {string} instanceId - A unique instance ID.
 * @property {string} id - A unique ID.
 * @property {number} updatedAt - The timestamp when the object was last updated.
 * @property {number} createdAt - The timestamp when the object was created.
 * @property {Object} comms - Communication preferences.
 * @property {boolean} comms.email - Indicates if email communication is enabled.
 * @property {boolean} comms.sms - Indicates if SMS communication is enabled.
 * @property {Object} candidateRequest - Details related to the candidate request.
 * @property {string} candidateRequest.jobUuid - A unique job UUID.
 * @property {?string} candidateRequest.image - The image associated with the request (can be null).
 * @property {?string} candidateRequest.preferredName - The preferred name (can be null).
 * @property {string} candidateRequest.email - The email related to the candidate request.
 * @property {string} candidateRequest.phoneNumber - The phone number related to the candidate request.
 * @property {?string} candidateRequest.description - A description for the candidate request (can be null).
 * @property {?string} candidateRequest.idNumber - The ID number for the candidate request.
 * @property {?string} candidateRequest.nationality - The nationality for the candidate request.
 * @property {Object} capturedCandidateDetails - The captured details of the candidate.
 * @property {?string} capturedCandidateDetails.surname - The surname of the candidate.
 * @property {?string} capturedCandidateDetails.names - The names of the candidate.
 * @property {?string} capturedCandidateDetails.sex - The sex of the candidate.
 * @property {?string} capturedCandidateDetails.documentType - The document type of the candidate.
 * @property {?string} capturedCandidateDetails.nationality - The nationality of the candidate.
 * @property {?string} capturedCandidateDetails.identityNumber - The identity number of the candidate.
 * @property {?string} capturedCandidateDetails.identityNumber2 - A second identity number (if applicable).
 * @property {?string} capturedCandidateDetails.passportNumber - The passport number of the candidate.
 * @property {?string} capturedCandidateDetails.dayOfBirth - The day of birth of the candidate.
 * @property {?string} capturedCandidateDetails.countryOfBirth - The country of birth of the candidate.
 * @property {?string} capturedCandidateDetails.status - The status of the candidate's details.
 * @property {?string} capturedCandidateDetails.dateOfIssue - The date the document was issued.
 * @property {?string} capturedCandidateDetails.securityNumber - The security number of the document.
 * @property {?string} capturedCandidateDetails.cardNumber - The card number of the document.
 * @property {?string} capturedCandidateDetails.rawInput - Raw input related to the verifee details.
 * @property {string} capturedCandidateDetails.jobUuid - A unique job UUID for the captured verifee details.
 * @property {Object} capturedCandidateDetails.cameraState - The state of the camera during verification.
 * @property {string} capturedCandidateDetails.cameraState.cameraLightingLevel - The camera lighting level.
 * @property {?string} capturedCandidateDetails.cameraState.idCode39Text - The Code 39 ID text (if any).
 * @property {?string} capturedCandidateDetails.cameraState.idCode39Text2 - A second Code 39 ID text (if any).
 * @property {?string} capturedCandidateDetails.cameraState.idPdf417Text - The PDF417 text (if any).
 * @property {string} capturedCandidateDetails.cameraState.passportMRZtext - The passport MRZ text.
 * @property {Array} capturedCandidateDetails.cameraState.imageFiles - Captures image file.
 * @property {string} capturedCandidateDetails.cameraState.imageFiles.file
 * @property {string} capturedCandidateDetails.cameraState.imageFiles.side 
 * @property {?string} capturedCandidateDetails.spaceFiller - Additional filler data (if any).
 * @property {Object} uploadedSelfieImg - The uploaded selfie image.
 * @property {string} uploadedSelfieImg.message - A message regarding the uploaded selfie image.
 * @property {?Array} uploadedSelfieImg.files - The uploaded selfie file (if any).
 * @property {Object} frontUploadedDocFiles - The uploaded selfie image.
 * @property {string} frontUploadedDocFiles.message - A message regarding the uploaded selfie image.
 * @property {?Array} frontUploadedDocFiles.files - The uploaded selfie file (if any).
 * @property {Object} backUploadedDocFiles - The uploaded selfie image.
 * @property {string} backUploadedDocFiles.message - A message regarding the uploaded selfie image.
 * @property {?Array} backUploadedDocFiles.files - The uploaded selfie file (if any).
 * @property {Array} uploadedSelfieImg.files - A list of uploaded selfie files.
 */
/**
 * 
 * @param {KycVerificationData} data 
 */
async function handleKycVerification(data) {
  try {
    if (data.id === null || data.id === '') {

    }
    if (data.uploadedSelfieImg.message.toLocaleLowerCase().includes('no file')) {

    }
    if (data.frontUploadedDocFiles === null && data.capturedCandidateDetails.cameraState.imageFiles.length > 0) {

    }

    if ((data.backUploadedDocFiles === null && data.capturedCandidateDetails.documentType === 'id_card') && data.imageFiles.length > 0) {

    }

    const id_card_front = data.capturedCandidateDetails.cameraState.imageFiles.find(img => img.side === 'front').file
    const id_card_back = data.capturedCandidateDetails.cameraState.imageFiles.find(img => img.side === 'back').file
    const passport = (data.capturedCandidateDetails.documentType === 'passport') ? getImageAsBase64(CDN + data.frontUploadedDocFiles.files.find(file => file.filename.includes('front_')).filename) : null
    console.log({ id_card_back, id_card_front, passport });

    const headers = new Headers();
    headers.append("Content-Type", "multipart/form-data");
    headers.append("Accept", "application/json");
    const formdata = new FormData();
    formdata.append("api_key", VERIFYID_3RD_PARTY_TOKEN);
    formdata.append("identity_document_type", data.capturedCandidateDetails.documentType);
    formdata.append("selfie_photo", getImageAsBase64(CDN + data.uploadedSelfieImg.files[0].filename));
    formdata.append("id_card_front", getImageAsBase64(CDN + data.frontUploadedDocFiles.files.find(file => file.filename.includes('front_')).filename) || id_card_front);
    formdata.append("id_card_back", getImageAsBase64(CDN + data.backUploadedDocFiles.files.find(file => file.filename.includes('back_')).filename) || id_card_back);
    formdata.append("driver_license_front", null);
    formdata.append("driver_license_back", null);
    formdata.append("passport", passport);

    console.log({ token: VERIFYID_3RD_PARTY_TOKEN, id_card_back, id_card_front, passport });


    const options = {
      method: "POST",
      headers: headers,
      body: formdata,
      redirect: "follow"
    };

    const response = await fetch(`https://www.verifyid.co.za/webservice/kyc-verification`, options)

    const output = await response.json()

    global.queue.push(() =>
      cache3rdPartResponse({ id: data.capturedCandidateDetails.identityNumber || data.capturedCandidateDetails.identityNumber2, data: output })
    );

    if (output.liveness || output.liveness === 'Invalid Request!') {
      /// update first transaction
      const transactionRouter = jsonServer.router(path.resolve("../apps/store/db/history.json"))
      const transaction1 = getAll(transactionRouter).find(item => item.transactionId === data.instanceId)

      if (transaction1) updateItem(transactionRouter, transaction1.id, { ...transaction1, "description": `Liveness test failed (${transaction1.details.query})`, "categoryId": "failed", })

      return;
    }
    console.log({ output, url: response.url });

    if (output) {
      /// and email admin
      const email = sendHelpEmailNotifications({
        name: `Query for ${data.capturedCandidateDetails.identityNumber || data.capturedCandidateDetails.identityNumber2} - (Verified)`,
        email: ADMIN_EMAIL,
        message: `Notification of New Transaction (${data.instanceId})`,
      });
      /// update first transaction
      const transactionRouter = jsonServer.router(path.resolve("../apps/store/db/history.json"))
      const transaction1 = getAll(transactionRouter).find(item => item.transactionId === data.instanceId)

      if (transaction1) updateItem(transactionRouter, transaction1.id, { ...transaction1, "description": `Verification process complete (${transaction1.details.query})`, "categoryId": "done", })
      /// create second transaction
      deductCreditsAfterTransaction(transaction1.details.query, transaction1.profileId)
      
    }

    return data;
  } catch (error) {
    ///
    logger.error(error.toString(), error);

    /// update first transaction
    const transactionRouter = jsonServer.router(path.resolve("../apps/store/db/history.json"))
    const transaction1 = getAll(transactionRouter).find(item => item.transactionId === data.instanceId)

    if (transaction1) updateItem(transactionRouter, transaction1.id, { ...transaction1, "description": `Verification process failed (${transaction1.details.query})`, "categoryId": "failed", })

  }
}

module.exports = {
  handleContactEnquiry,
  handleSaidVerification,
  handleGetCreditsReq,
  handleKycVerification
};
