const { v4: uuidv4 } = require("uuid");
const { generateNonce } = require("../nonce.source");
const request = require('request')
const fetch = (...args) => import('node-fetch').then(({
    default: fetch
}) => fetch(...args));
const { getWallet } = require("./store");
const PAYMENTS_TOKEN =
    process.env.PAYMENTS_TOKEN || "sk_test_1d9ae04aBLnrM8nfaf14ba5ac783";
const HOST = process.env.HOST || "0.0.0.0";
const PORT = process.env.PORT || "5400";

/**
 * Represents a payment event object.
 * @typedef {Object} PaymentEvent
 * @property {string} id - The unique identifier of the event.
 * @property {string} type - The type of event, e.g., 'payment.succeeded'.
 * @property {string} createdDate - The creation date of the event in ISO format.
 * @property {Payload} payload - The payload containing detailed information about the payment.
 */

/**
 * Represents the detailed information about the payment.
 * @typedef {Object} Payload
 * @property {string} id - The unique identifier of the payment.
 * @property {string} type - The type of the object, e.g., 'payment'.
 * @property {string} createdDate - The creation date of the payment in ISO format.
 * @property {number} amount - The amount of the payment.
 * @property {string} currency - The three-letter ISO currency code representing the currency in which the payment was made.
 * @property {PaymentMethodDetails} paymentMethodDetails - The details about the payment method used.
 * @property {string} status - The status of the payment, e.g., 'succeeded'.
 * @property {string} mode - The mode of the payment, e.g., 'live'.
 * @property {Metadata} metadata - Additional information or data associated with the payment.
 */

/**
 * Represents the details about the payment method used for the payment.
 * @typedef {Object} PaymentMethodDetails
 * @property {string} type - The type of the payment method, e.g., 'card'.
 * @property {Card} card - The details of the card used for the payment.
 */

/**
 * Represents the card details.
 * @typedef {Object} Card
 * @property {number} expiryMonth - The expiration month of the card.
 * @property {number} expiryYear - The expiration year of the card.
 * @property {string} maskedCard - The masked card number, only showing the last four digits.
 * @property {string} scheme - The card scheme, e.g., 'visa'.
 */

/**
 * Represents additional information or data associated with the payment.
 * @typedef {Object} Metadata
 * @property {string} checkoutId - The unique identifier of the checkout process related to the payment.
 * @property {string} payerId - The unique identifier of the payer
 * @property {string} walletId - The unique identifier of the payer's Wallet
 */

/**
 * Represents a refund event object.
 * @typedef {Object} RefundEvent
 * @property {string} id - The unique identifier of the event.
 * @property {string} type - The type of event, can be 'refund.succeeded' or 'refund.failed'.
 * @property {string} createdDate - The creation date of the event in ISO format.
 * @property {RefundPayload} payload - The payload containing detailed information about the refund.
 */

/**
 * Represents the detailed information about the refund.
 * @typedef {Object} RefundPayload
 * @property {string} id - The unique identifier of the refund.
 * @property {string} type - The type of the object, always 'refund'.
 * @property {string} createdDate - The creation date of the refund in ISO format.
 * @property {number} amount - The amount of the refund.
 * @property {string} currency - The three-letter ISO currency code representing the currency in which the refund was made.
 * @property {string} paymentId - The unique identifier of the payment from which the refund was made.
 * @property {string} status - The status of the refund, can be 'succeeded' or 'failed'.
 * @property {string} mode - The mode of the refund, e.g., 'live'.
 * @property {Metadata} metadata - Additional information or data associated with the refund.
 */

/**
 * payment provider webhook events
 */
const eventTypes = {
    "payment.succeeded": "payment.succeeded",
    "refund.succeeded": "refund.succeeded",
    "refund.failed": "refund.failed",
};

/**
 *
 * @param {Request} req
 * @param {Response} res
 */
function handlePaymentEvents(req, res) {
    /**
     * @type {PaymentEvent} PaymentEvent
     */
    const paymentInformation = JSON.parse(req.rawBody || req.body);

    setTimeout(() => {
        console.log({ T3: (typeof paymentInformation), TYPE: paymentInformation.type, });
    }, 1000);
    const { type } = paymentInformation;

    console.log({ T2: type, TYPE: paymentInformation.type, paymentInformation });
    console.log("Received a Payment Event: ", paymentInformation.type); 

    console.log("REQUEST BODY", JSON.stringify(paymentInformation, null, 2));

    // Early exit if [paymentInformation] or [paymentInformation.type] is not defined
    if (!paymentInformation || !paymentInformation.type) {
        console.log("Invalid request body or type missing");
        res.status(400).send({ status: "Error", message: "Invalid request" });
        return;
    }

    console.log("Received a Payment Event: ", paymentInformation.type);

    // Handle different event types using if-else statements
    if (paymentInformation.type === eventTypes["payment.succeeded"]) {
        // Payment succeeded event
        _addToWallet(paymentInformation.payload);
        _sendFirebaseNotification(paymentInformation.payload.metadata.payerId, eventTypes["payment.succeeded"]);
    } else if (paymentInformation.type === eventTypes["refund.failed"]) {
        // Refund failed event
        _sendFirebaseNotification(paymentInformation.payload.metadata.payerId, eventTypes["refund.failed"]);
    } else if (paymentInformation.type === eventTypes["refund.succeeded"]) {
        // Refund succeeded event
        _subtractFromWallet(paymentInformation.payload.metadata.payerId, paymentInformation.payload.amount);
        _sendFirebaseNotification(paymentInformation.payload.metadata.payerId, eventTypes["refund.succeeded"]);
    } else {
        // Unknown payment event
        console.log("Unknown payment event: ", paymentInformation.type);
    }
    console.log({ PAYMENTS_EVENT: paymentInformation });
    // Record transaction and send response
    _createTransactionRecord(paymentInformation?.payload);
    res.send({ status: "Success" });
}

function _sendFirebaseNotification(payerRefId, notificationType) {
    console.log("Sending a FB notification", payerRefId, notificationType);
}

function _subtractFromWallet(payerRefId, amount) {
    console.log("Subtracting from wallet", payerRefId, amount);
}
/**
 *
 * @param {Payload} payload
 */
function _createTransactionRecord(payload) {
    console.log("Hit the store API and save the transaction... ", payload);
    // {
    //     lastDepositAt: Math.floor(Date.now() / 1000)
    // }
}
/**
 *
 * @param {Payload} payload
 */
async function _addToWallet(payload) {


    const savedWallet = await getWallet(payload?.metadata?.walletId);

    console.log("Adding to wallet", payload);
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
    console.log({ SAVED_WALLET: savedWallet });
    const wallet = {
        ...savedWallet,
        id: payload?.metadata?.walletId,
        profileId: payload.metadata.payerId,
        balance: payload?.amount,
        isoCurrencyCode: "ZAR",
        accountName: payload?.paymentMethodDetails?.card?.maskedCard,
        expDate:
            payload?.paymentMethodDetails?.card?.expiryMonth +
            "/" +
            payload?.paymentMethodDetails?.card?.expiryYear,
        cardProvider: payload?.paymentMethodDetails?.card?.scheme,
        lastDepositAt: Math.floor(Date.now() / 1000),

    };
    const host =
        (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) +
        ':5400';
    let options = {
        method: "PUT",
        url: `http://${host}/api/v1/wallet/resource/${payload?.metadata?.walletId ?? ""
            }`,
        headers: {
            "x-nonce": generateNonce(),
            "Content-Type": "application/json",
            Authorization: "Bearer TOKEN",
        },
        body: JSON.stringify(wallet),
    };
    request(options, function (error, response) {
        if (error) throw new Error(error);
    });
}

/**
 *
 * @param {Request} req
 * @param {Response} res
 */
async function handleYocoPayment(req, res) {
    try {
        // incoming request body
        const body = JSON.parse(req?.rawBody || req?.body);

        const headers = new Headers();
        headers.append("Content-Type", "application/json");
        headers.append("Idempotency-Key", uuidv4());
        headers.append("Authorization", `Bearer ${PAYMENTS_TOKEN}`);

        ///
        const response = await fetch("https://payments.yoco.com/api/checkouts", {
            method: "POST",
            headers: headers,
            body: JSON.stringify(body),
        });

        const result = await response.json();

        res.send(result);
    } catch (error) {
        console.log(error);
        res.send({ code: 500, message: "Internal Error Occurred" });
    }
}

async function handleYocoRefund(req, res) {
    try {
        // incoming request body
        const body = JSON.parse(req?.rawBody || req?.body);
        const checkoutId = req.params?.checkoutId;

        const headers = new Headers();
        headers.append("Content-Type", "application/json");
        headers.append("Idempotency-Key", `refund_${checkoutId}`);
        headers.append("Authorization", `Bearer ${PAYMENTS_TOKEN}`);

        ///
        const response = await fetch(
            `https://payments.yoco.com/api/checkouts/${checkoutId}/refund`,
            {
                method: "POST",
                headers: headers,
                body: JSON.stringify(body),
            }
        );

        const result = await response.json();

        res.send(result);
    } catch (error) {
        console.log(error);
        res.send({ code: 500, message: "Internal Error Occurred" });
    }
}

module.exports = {
    handleYocoPayment,
    handleYocoRefund,
    handlePaymentEvents,
};