const { uniqueIdentifier } = require("../packages/uuid");
const { generateNonce } = require("../nonce.source");
const { getUserProfile, getWallet, cache3rdPartResponse } = require("./store");
const { sendHelpEmailNotifications } = require("./notifications");
const { getAll, updateItem } = require("./db_operations");
const jsonServer = require("json-server");
const path = require('node:path');
const fs = require('node:fs');
const logger = require("../packages/logger");
const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));
const VERIFYID_3RD_PARTY_TOKEN =
  process.env.VERIFYID_3RD_PARTY_TOKEN || "3rd_party_token";
const HOST = process.env.HOST || "0.0.0.0";
const PORT = process.env.PORT || "5400";
const ADMIN_EMAIL = process.env.VERIFIED_ADMIN_EMAIL || 'admin@byteestudio.com'
const CDN = process.env.CDN_BASE_URL || 'http://192.168.0.173:4334/static/';
const { getImageAsBase64 } = require('.././utils/image');
const { ResponseCode } = require("../utils/models");


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
 * 
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

    const options = {
      method: "GET",
      headers: headers,
    };

    const response = await fetch(
      `https://www.verifyid.co.za/webservice/my_credits?api_key=${VERIFYID_3RD_PARTY_TOKEN}`,
      options
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
        balance: Math.max(0, Number((wallet?.balance || 0) - (30 * CENTS))),
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
    console.log("Wallet Update...");
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
 * @typedef {Object} ThirdPartyVerificationResponseData
 * @property {ResponseCode} code
 * @property {string} message
 * @property {Object} data
 */

/**
 * @typedef {Object} CandidateRequest
 * @property {string} jobUuid - Unique identifier for the job.
 * @property {?string} image - Base64 encoded image or null if no image.
 * @property {string} preferredName - Preferred name of the candidate.
 * @property {string} email - Candidate's email address.
 * @property {string} phoneNumber - Candidate's phone number.
 * @property {string} description - Additional description or 'n/a'.
 * @property {string} idNumber - Candidate's identification number.
 * @property {?string} nationality - Candidate's nationality or null.
 * @property {?string} dayOfBirth - Candidate's date of birth or null.
 */

/**
 * @typedef {Object} CapturedCandidateDetails
 * @property {?string} surname - Surname of the candidate.
 * @property {?string} names - Candidate's full names.
 * @property {?string} sex - Candidate's gender or sex.
 * @property {?string} documentType - Type of identification document.
 * @property {?string} nationality - Candidate's nationality.
 * @property {?string} identityNumber - Candidate's ID number.
 * @property {?string} identityNumber2 - Secondary ID number, if available.
 * @property {?string} passportNumber - Candidate's passport number.
 * @property {?string} dayOfBirth - Date of birth.
 * @property {?string} countryOfBirth - Country of birth.
 * @property {?string} status - Status of the candidate's details.
 * @property {?string} dateOfIssue - Issue date of the document.
 * @property {?string} securityNumber - Security number associated with the candidate.
 * @property {?string} cardNumber - Card number if available.
 * @property {?string} rawInput - Raw input data.
 * @property {string} jobUuid - Unique job identifier.
 * @property {CameraState} cameraState - State of the camera capture.
 * @property {?string} spaceFiller - Placeholder property.
 */

/**
 * @typedef {Object} CameraState
 * @property {string} cameraLightingLevel - Camera lighting level value.
 * @property {string} idCode39Text - ID Code39 text.
 * @property {string} idCode39Text2 - Secondary ID Code39 text.
 * @property {string} idPdf417Text - PDF417 barcode text.
 * @property {string} passportMRZtext - Machine readable zone text for passport.
 * @property {Array<ImageFile>} imageFiles - Array of image files captured by camera.
 */

/**
 * @typedef {Object} ImageFile
 * @property {string} file - Base64 encoded image file.
 * @property {string} side - Side of the document (e.g., "front").
 */

/**
 * @typedef {Object} UploadedFiles
 * @property {string} message - Upload status message.
 * @property {?string} file - Single file data or null.
 * @property {Array<FileDetails>} files - List of uploaded files.
 */

/**
 * @typedef {Object} FileDetails
 * @property {string} filename - Name of the file.
 * @property {number} size - Size of the file in bytes.
 * @property {string} mimetype - MIME type of the file.
 */

/**
 * @typedef {Object} PermitUploadData
 * @property {string} jobUuid - Unique job identifier.
 * @property {string} permitType - Type of permit.
 * @property {string} permitNumber - Number of the permit.
 * @property {string} date - Date associated with the permit.
 * @property {string} signature - Base64 encoded signature image.
 * @property {Array<UploadedFiles>} relatedDocuments - Related documents for the permit.
 * @property {string} additionalInformation - Additional information for the permit.
 */
/**
 * @typedef {Object} KycVerificationData
 * @property {CandidateRequest} candidateRequest - Candidate request data.
 * @property {CapturedCandidateDetails} capturedCandidateDetails - Captured details about the candidate.
 * @property {UploadedFiles} backUploadedDocFiles - Uploaded document files for the back of the ID.
 * @property {UploadedFiles} frontUploadedDocFiles - Uploaded document files for the front of the ID.
 * @property {UploadedFiles} uploadedSelfieImg - Uploaded selfie image data.
 * @property {PermitUploadData} permitUploadData - Permit-related upload data.
 */
/**
 * 
 * @param {KycVerificationData} data 
 * @returns {ThirdPartyVerificationResponseData}
 * 
 */
async function handleKycVerification(data) {
  try {
    console.log({ data });
    const jobUuid = data?.capturedCandidateDetails?.jobUuid || data?.candidateRequest?.jobUuid || data?.permitUploadData?.jobUuid
    if (jobUuid === null || jobUuid === '') {

    }
    if (data.uploadedSelfieImg?.message.toLocaleLowerCase().includes('no file')) {

    }
    if (data?.frontUploadedDocFiles === null && data.capturedCandidateDetails.cameraState.imageFiles.length > 0) {

    }

    if ((data?.backUploadedDocFiles === null && data.capturedCandidateDetails.documentType === 'id_card') && data.capturedCandidateDetails.cameraState.imageFiles.length > 0) {

    }

    const id_card_front = data.capturedCandidateDetails.cameraState.imageFiles.find(img => img.side === 'front')?.file
    const id_card_back = data.capturedCandidateDetails.cameraState.imageFiles.find(img => img.side === 'back')?.file
    const passport = (data.capturedCandidateDetails.documentType === 'passport') ? await getImageAsBase64(CDN + data.frontUploadedDocFiles.files[0]?.filename || CDN + data.backUploadedDocFiles.files[0]?.filename) : null;
    console.log({ id_card_back, id_card_front, passport });

    const headers = new Headers();
    headers.append("Content-Type", "multipart/form-data");
    headers.append("Accept", "application/json");
    const formdata = new FormData();
    formdata.append("api_key", VERIFYID_3RD_PARTY_TOKEN);
    formdata.append("identity_document_type", data.capturedCandidateDetails.documentType);
    formdata.append("selfie_photo", (await getImageAsBase64(CDN + data.uploadedSelfieImg.files[0]?.filename)));
    formdata.append("id_card_front", (await getImageAsBase64(CDN + data.frontUploadedDocFiles.files.find(file => file.filename.includes('front_'))?.filename)) || id_card_front);
    formdata.append("id_card_back", (await getImageAsBase64(CDN + data.backUploadedDocFiles.files.find(file => file.filename.includes('back_'))?.filename) || id_card_back));
    formdata.append("driver_license_front", null);
    formdata.append("driver_license_back", null);
    formdata.append("passport", passport);

    console.log({ token: VERIFYID_3RD_PARTY_TOKEN, id_card_back, id_card_front, passport });

    console.log({ formdata });

    const options = {
      method: "POST",
      headers: headers,
      body: formdata,
      redirect: "follow"
    };

    // Convert FormData to JSON-compatible object
    async function formDataToJSON(formData) {
      const formObject = {};
      for (let [key, value] of formData.entries()) {
        formObject[key] = value;
      }
      return JSON.stringify(formObject, null, 2); // Pretty print with 2-space indent
    }

    // Write JSON to file
    formDataToJSON(formdata)
      .then(jsonData => {
        fs.writeFile('formdata.json', jsonData, (err) => {
          if (err) throw err;
          console.log('FormData saved to formdata.json');
        });
      })
      .catch(error => console.error('Error:', error));

    // if (data) throw new Error('KILL TASK/JOB.')

    const response = await fetch(`https://www.verifyid.co.za/webservice/kyc-verification`, options)

    const output = await response.json()

    global.queue.push(() =>
      cache3rdPartResponse({ id: data.capturedCandidateDetails.identityNumber || data.capturedCandidateDetails.identityNumber2, data: output })
    );

    if (output.liveness || output.liveness === 'Invalid Request!') {
      /// update first transaction
      const transactionRouter = jsonServer.router(path.join("apps", "store/db/history.json"))
      const transaction1 = getAll(transactionRouter).find(item => item?.transactionId === data?.instanceId)

      if (transaction1) updateItem(transactionRouter, transaction1?.id, { ...transaction1, "description": `Liveness test failed (${transaction1.details.query})`, "categoryId": "failed", })

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
      const transactionRouter = jsonServer.router(path.join("apps", "store/db/history.json"))
      const transaction1 = getAll(transactionRouter).find(item => item?.transactionId === data?.instanceId)

      if (transaction1) updateItem(transactionRouter, transaction1?.id, { ...transaction1, "description": `Verification process complete (${transaction1.details.query})`, "categoryId": "done", })
      /// create second transaction
      deductCreditsAfterTransaction(transaction1.details.query, transaction1.profileId)

    }

    return output;
  } catch (error) {
    ///
    logger.error(error.toString(), error);

    /// update first transaction
    const transactionRouter = jsonServer.router(path.join("apps", "store/db/history.json"))
    const transaction1 = getAll(transactionRouter).find(item => item?.transactionId === data?.instanceId)

    if (transaction1) updateItem(transactionRouter, transaction1?.id, { ...transaction1, "description": `Verification process failed (${transaction1.details.query})`, "categoryId": "failed", })

  }
}

/**
 * 
 * @param {KycVerificationData} data 
 * @returns {ThirdPartyVerificationResponseData}
 * 
 */
async function handleKycVerification2(data) {

}


module.exports = {
  handleContactEnquiry,
  handleSaidVerification,
  handleGetCreditsReq,
  handleKycVerification,
  handleKycVerification2
};
