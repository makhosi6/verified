const { v4: uuidv4 } = require('uuid');
const { generateNonce } = require('../nonce.source');
const request = require('request')
const fetch = (...args) => import('node-fetch').then(({
    default: fetch
}) => fetch(...args));

const PORT = process.env.PORT || process.env.PORT  || 5400;
const HOST = process.env.HOST || "0.0.0.0";

const analytics = (req, res, next) => {
    console.log("analytics hook");
    const IP = "";
    const time = Math.floor(Date.now() / 1000)
    const sessionId = ""
    const headers = {};

    next();
}

const security = (req, res, next) => {
    console.log("Security hook");
    next()
}
const authenticate = (req, res, next) => {
    console.log("authenticate hook");
    next()
}

const authorization = (req, res, next) => {
    try {
        console.log("authorization hook");
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
            error: error.message
        });
        res.sendStatus(500);
    }
}
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

    const host = (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) + ':5400'
    fetch(`http://${host}/api/v1/wallet/resource`, {
        method: 'POST',
        headers,
        body
    })
        .then(response => response.text())
        .then(result => console.log(JSON.stringify({ADDED_WALLET: result}, null, 2)))
        .catch(error => console.log('error', error));
}

module.exports = {
    addWallet,
    analytics,
    security,
    authenticate,
    authorization
}

