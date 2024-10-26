const { uniqueIdentifier } = require("../packages/uuid");
const { generateNonce } = require("../nonce.source");
const jsonServer = require("json-server");
const os = require("node:os");
const request = require("request");
const path = require("node:path");
const { archiveRecord } = require("../usecases/store");
const logger = require("../packages/logger");
const Queue = require('../packages/queue');
const { delay } = require("../utils/delay");
const { getOne, createItem } = require("../usecases/db_operations");
const { handleKycVerification } = require("../usecases/verifyid");
const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));

const PORT = process.env.PORT || process.env.PORT || 5400;
const HOST = process.env.HOST || "0.0.0.0";

const analytics = (req, res, next) => {
  const { headers, params, query, connection } = req;
  const timestamp = Math.floor(Date.now() / 1000);
  const time = new Date(timestamp * 1000).toISOString();
  const sessionId = headers['x-session-id'] || 'unknown';
  const caller = headers["x-caller"] || 'unknown';

  const data = {
    ip: req.ip || headers['x-forwarded-for'] || connection.remoteAddress,
    userAgent: req.headers['user-agent'],
    language: req.headers['accept-language'] || ['en-GB', 'en-US', 'en', 'zh-TW'],
    referrer: req.headers['referer'] || req.headers['referrer'] || 'none',
    proxyIp : req.headers['x-forwarded-for'],
    cookies:  req.cookies,
    connection: {
      protocol: req.protocol,
      secure: req.secure,
      httpVersion: req.httpVersion,
      method: req.method,
      host: req.host,
      url: req.originalUrl || req.url,
      route: req.method + ' ' + req.originalUrl || req.url,
    },
    caller,
    sessionId,
    timestamp,
    time,
    headers,
    query,
    params,
    hostname: os.hostname(),
    platform: os.platform(),
    uptime: os.uptime(),
    loadAverage: os.loadavg(),
    totalMemory: os.totalmem(),
    freeMemory: os.freemem(),
    memoryUsage: process.memoryUsage(),
    cpuUsage: process.cpuUsage(),
    networkInterfaces: os.networkInterfaces(),
  };

  logger.warn(`${time}`, JSON.stringify(data, null, 2));
  next();
};


const security = (req, res, next) => {

  /// check if headers are defined
  /// and check if they are no the block list
  next();
};
const beforePostOperation = (req, res, next) => {
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
  const data = createItem('wallet', wallet)
  console.log(JSON.stringify({ data }, null, 2),)

  return data;
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

async function postOperationOnly(req, res, next) {
  if (req.method == 'POST') {
    next();
    return;
  }
  else {
    res.status(405).json({
      status: 'error',
      message: 'Method Not Allowed',
      data: null
    });
  }

}


/**
 * 
 * @param {Queue} queue 
 * @returns {import("express").RequestParamHandler}
 */
function triggerVerificationAsyncTasks(queue) {
  return function (req, res, next) {
    const instanceId = req?.body.candidateRequest?.jobUuid || req?.body.candidateRequest?.jobUuid;
    ///create a task queue
    queue.push(() => delay(10000, async function () {

      // send push to user
      const job = getOne('jobs', instanceId)

      await handleKycVerification(job)
      // send email to client

      console.log('Will process the ', instanceId, ' job')

    }));
    next();
  }
}
async function archiveOnDelete(req, res, next) {
  try {
    const METHOD = req.method.toUpperCase();
    const { client: clientId } = req.query;
    const clientEnv = req?.headers["x-client-env"];
    if (METHOD == "DELETE") {
      const headers = {
        /// add a nonce and TOKEN for security/auth
        "x-nonce": generateNonce(),
        'x-caller': "archiveOnDelete",
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
      const type = urlArr[urlArr.length - 3];

      await archiveRecord({
        id: uniqueIdentifier(),
        url,
        originalUrl: req.originalUrl,
        clientId,
        clientEnv,
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
  postOperationOnly,
  addWallet,
  analytics,
  security,
  authenticate,
  authorization,
  beforePostOperation,
  triggerVerificationAsyncTasks
};
