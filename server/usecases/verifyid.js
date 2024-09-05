const { uniqueIdentifier } = require("../packages/uuid");
const { generateNonce } = require("../nonce.source");
const { getUserProfile, getWallet, cache3rdPartResponse } = require("./store");
const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));
const VERIFYID_3RD_PARTY_TOKEN =
  process.env.VERIFYID_3RD_PARTY_TOKEN || "VERIFYID_3RD_PARTY_TOKEN";
const HOST = process.env.HOST || "0.0.0.0";
const PORT = process.env.PORT || "5400";

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

module.exports = {
  handleContactEnquiry,
  handleSaidVerification,
  handleGetCreditsReq,
};
