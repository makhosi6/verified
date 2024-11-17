const { uniqueIdentifier } = require("../packages/uuid");
const { generateNonce } = require("../nonce.source");
const { addWallet } = require("./universal");
const request = require("request");
const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));
const { Request, Response, NextFunction } = require("express");
const { getUserProfile } = require("../usecases/store");
const { sendWelcomeEmailNotifications, sadToSeeYouGoEmailOnAccountDeletion } = require("../usecases/notifications");
const { getOne } = require("../usecases/db_operations");
const HOST = process.env.HOST || "0.0.0.0";
const PORT = process.env.PORT || "5400";

/**
 *
 * @param {Request} req
 * @param {Response} res
 * @param {NextFunction} next
 */
const addTimestamps = (req, res, next) => {
  const METHOD = req.method.toUpperCase();

  if (METHOD === "POST") {
    if (req.url.includes("profile/resource")) {
      req.body["account_created_at"] = Math.floor(Date.now() / 1000);
      req.body["accountCreatedAt"] = Math.floor(Date.now() / 1000);
    }
    req.body["updatedAt"] = Math.floor(Date.now() / 1000);
    req.body["createdAt"] = Math.floor(Date.now() / 1000);
  }

  if (METHOD == "PUT") {
    req.body["updatedAt"] = Math.floor(Date.now() / 1000);
  }


  if (METHOD == "DELETE") {
    req.body["deletedAt"] = Math.floor(Date.now() / 1000)
  }
  next();
};

/**
 *  A middleware to add unique identifier to a POST requests
 * @param {Request} req
 * @param {Response} res
 * @param {NextFunction} next
 */
const addIdentifiers = (req, res, next) => {
  const METHOD = req.method.toUpperCase();
  // Check if the request is a POST request is not profile or wallet, then add a primary unique identifier
  if (
    METHOD === "POST" &&
    !req.url.includes("cache/resource") &&
    !req.url.includes("profile/resource") &&
    !req.url.includes("jobs/resource") &&
    !req.url.includes("comprehensive_verification") &&
    !req.url.includes("wallet/resource") &&
    !req.url.includes("devices/resource")
  ) {
    req.body.id = uniqueIdentifier();
  } else {
    console.log("addIdentifiers skip!!!");
  }
  next();
};

/**
 *
 * @param {Request} req
 * @param {Response} res
 * @param {NextFunction} next
 */
const lastLoginHook = (req, res, next) => {
  const id = req.url.split("/").pop().replace("?role=system", "");
  const method = req.method.toUpperCase();
  if (id && method == "GET" && !req.url.includes("?role=system")) {
    if (id != "resource") global.queue.push(() => updateLastSeen(id));
    else console.log("No ID found", { id });
  }

  next();
};

/**
 * create a wallet and send a welcome email
 * @param {Request} req
 * @param {Response} res
 * @param {NextFunction} next
 */
const otherAccountWorkFlows = async (req, res, next) => {
  ///
  if (req.url.includes("profile/resource")) {

    if (req.method === "DELETE") {
      const id = req.path.split('/').pop()
      const user = getOne('profile', id);
      sadToSeeYouGoEmailOnAccountDeletion(user);
    }

  }
  next();
}
/**
 * create a wallet and send a welcome email
 * @param {Request} req
 * @param {Response} res
 * @param {NextFunction} next
 */
const onCreateAccountOrLoginHook = async (req, res, next) => {
  const walletId = uniqueIdentifier();
  const method = req.method.toUpperCase();

  /// also create a wallet on account creation
  if (method == "POST" && req.url.includes("profile/resource")) {
    /**@type {} */
    const storedUser = await getUserProfile(req?.body?.id || req?.body?.profileId);
    if (!(storedUser?.id)) {
      const { email, actualName, displayName, name, phone } = storedUser || req?.body;
      // send a welcome email
      sendWelcomeEmailNotifications({ name: (name || displayName || actualName || email), email, phone });
    }

    console.log({ method, walletId, storedUser });
    /// add wallet to profile
    req.body["walletId"] = storedUser?.walletId || walletId;

    console.log(JSON.stringify({ PROFILE: req.body }, null, 2));


    if (!(storedUser?.walletId)) global.queue.push(() =>
      addWallet({
        id: walletId,
        profileId: req.body.id,
        balance: 0,
        createdAt: Math.floor(Date.now() / 1000),
        updatedAt: Math.floor(Date.now() / 1000),
        deletedAt: null,
        isoCurrencyCode: "ZAR",

        /// add new account promotions
        promotions: [],
        accountHolderName: req.body.name,
        accountName: "----0000",
        expDate: "00/00",
      })
    );
  }
  next();
};
/**
 *
 * @param {Request} req
 * @param {Response} res
 * @param {NextFunction} next
 */
async function updateLastSeen(id) {
  try {
    const headers = {
      "x-nonce": generateNonce(),
      Authorization: "Bearer TOKEN",
      'x-caller': "updateLastSeen",
      "Content-Type": "application/json",
    };
    const host =
      (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) +
      `:${PORT}`;
    console.log({ host });
    const response = await fetch(
      `http://${host}/api/v1/profile/resource/${id}?role=system`,
      {
        method: "GET",
        headers,
      }
    );
    const data = await response.json();

    fetch(`http://${host}/api/v1/profile/resource/${id}?role=system`, {
      method: "PUT",
      headers,
      body: JSON.stringify({
        ...data,
        last_login_at: Math.floor(Date.now() / 1000),
      }),
    })
      .then((response) => response.text())
      .then((result) => console.log("Successful Last seen update!!"))
      .catch((error) => console.log("error", error));
  } catch (error) {
    console.log({
      error,
    });
  }
}
/**
 * Middleware to augment PUT requests with additional data
 * @param {Request} req
 * @param {Response} res
 * @param {NextFunction} next
 */
async function updateOrPutHook(req, res, next) {
  const METHOD = req.method.toUpperCase();
  const isSystemCall = (
    req.originalUrl ||
    req.pathname ||
    req.url ||
    req.href
  ).includes("?role=system")
  // if it's a PUT request
  if (METHOD == "PUT" && !isSystemCall) {
    const headers = {
      /// add a nonce and TOKEN for security/auth
      "x-nonce": generateNonce(),
      Authorization: "Bearer TOKEN",
      'x-caller': "updateOrPutHook",
      "Content-Type": "application/json",
    };

    // make a url
    const host =
      (process.env.NODE_ENV === "production"
        ? `store_service`
        : `${HOST}`) + `:${PORT}`;
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

    console.log({ data, url, isSystemCall, METHOD });
    // Merge the fetched data with the original request body
    // This allows the PUT request to include additional data from the service
    req.body = {
      ...data,
      ...req.body,
    };
  }

  // ..then
  next();
}

/** */
async function updateWalletLastTopUp({ id, amount }) {
  try {
    const headers = {
      "x-nonce": generateNonce(),
      Authorization: "Bearer TOKEN",
      'x-caller': "updateWalletLastTopUp",
      "Content-Type": "application/json",
    };
    const host =
      (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) +
      `:${PORT}`;
    console.log({ host });
    const response = await fetch(
      `http://${host}/api/v1/wallet/resource/${id}?role=system`,
      {
        method: "GET",
        headers,
      }
    );
    const data = await response.json();

    fetch(`http://${host}/api/v1/wallet/resource/${id}?role=system`, {
      method: "PUT",
      headers,
      body: JSON.stringify({
        ...data,
        balance: (data?.balance || 0) + amount,
        lastDepositAt: Math.floor(Date.now() / 1000),
      }),
    })
      .then((response) => response.json())
      .then((result) => console.log("Successful Last seen update!!", result?.id,),)
      .catch((error) => console.log("error", error));
  } catch (error) {
    console.log({
      error,
    });
  }
}



// export all functions
module.exports = {
  addTimestamps,
  addIdentifiers,
  lastLoginHook,
  updateLastSeen,
  onCreateAccountOrLoginHook,
  updateOrPutHook,
  otherAccountWorkFlows
};
