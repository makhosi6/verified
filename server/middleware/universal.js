const { v4: uuidv4 } = require("uuid");
const { generateNonce } = require("../nonce.source");
const request = require("request");
const { archiveRecord } = require("../usecases/store");
const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));

const PORT = process.env.PORT || process.env.PORT || 5400;
const HOST = process.env.HOST || "0.0.0.0";

const analytics = (req, res, next) => {
  const IP = "";
  const time = Math.floor(Date.now() / 1000);
  const sessionId = "";
  const headers = {};

  next();
};

const security = (req, res, next) => {
  next();
};
const authenticate = (req, res, next) => {
  next();
};

const authorization = (req, res, next) => {
  try {

    let isAuthorized =
      `${req.headers?.authorization}`.includes("TOKEN") ||
      `${req.headers?.authorization}`.includes("TOKEN_1") ||
      `${req.query?.key}` == "KEY";

    if (isAuthorized) {
      next();
    } else {
      res.sendStatus(401);
    }
  } catch (error) {
    console.table({
      error: error.message,
    });
    res.sendStatus(500);
  }
};
/**
 * Processes user's wallet information.
 *
 * @param {Object} wallet - The user's account information.
 * @param {string} wallet.id - Primary unique identifier
 * @param {string} wallet.profileId - Unique identifier for the user profile.
 * @param {number} wallet.balance - Current balance in the account.
 * @param {string} wallet.isoCurrencyCode - ISO code for the currency of the balance.
 * @param {string} wallet.accountHolderName - Name of the account holder.
 * @param {string} wallet.accountName - Masked account name, showing only the last 4 digits.
 * @param {string} wallet.expDate - Expiration date of the account, in MM/YY format.
 * @param {number} wallet.lastDepositAt - Timestamp of the last deposit.
 * @param {string} wallet.historyId - Unique identifier for the account history.
 * @param {Array.<string>} wallet.promotions - List of promotion codes applied to the account.
 *
 */
function addWallet(wallet) {
  let headers = new Headers();
  headers.append("x-nonce", generateNonce());
  headers.append("Content-Type", "application/json");
  headers.append("Authorization", "Bearer TOKEN");

  const body = JSON.stringify(wallet);

  const host =
    (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) +
    ":5400";
  fetch(`http://${host}/api/v1/wallet/resource`, {
    method: "POST",
    headers,
    body,
  })
    .then((response) => response.text())
    .then((result) =>
      console.log(JSON.stringify({ ADDED_WALLET: result }, null, 2))
    )
    .catch((error) => console.log("error", error));
}
/**
 * Operation not allowed
 * @param {*} req
 * @param {*} res
 * @param {Function} next
 */
function noDeleteOperation(req, res, next) {
  const METHOD = req.method.toUpperCase();
  if (METHOD == "DELETE") {
    res.status(405).send({
      code: 405,
      message: "Not Allowed",
    });
  } else {
    next();
  }
}

async function archiveOnDelete(req, res, next) {
  try {
    const METHOD = req.method.toUpperCase();
    if (METHOD == "DELETE") {
      const headers = {
        /// add a nonce and TOKEN for security/auth
        "x-nonce": generateNonce(),
        Authorization: "Bearer TOKEN",
        "Content-Type": "application/json",
      };

      // make a url
      const host =
        (process.env.NODE_ENV === "production"
          ? `store_service`
          : `${process.env.HOST}`) + `:${process.env.PORT}`;
      const url = (
        req.originalUrl ||
        req.pathname ||
        req.url ||
        req.href
      ).replace("?role=system", "");

      // fetch request to get existing data from the database
      const response = await fetch(`http://${host}${url}?role=system`, {
        method: "GET",
        headers,
      });

      const data = await response.json();

      const urlArr = url.split("/");
      const type = urlArr[urlArr.length - 2];

      await archiveRecord({
        id: uuidv4(),
        type,
        record: data,
      });
    }

    next();
  } catch (error) {
    console.log(error);
    next();
  }
}

module.exports = {
  archiveOnDelete,
  noDeleteOperation,
  addWallet,
  analytics,
  security,
  authenticate,
  authorization,
};
