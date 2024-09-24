const { uniqueIdentifier } = require("../packages/uuid");
const { generateNonce } = require("../nonce.source");
const request = require('request')
const express = require('express')
const fetch = (...args) => import('node-fetch').then(({
    default: fetch
}) => fetch(...args));
const { getWallet, getUserProfile } = require("./store");
const { sendEmailNotifications, sendPushNotifications, sendSuccessfulPaymentEmailNotifications, sendSuccessfulRefundEmailNotifications } = require("./notifications");
const logger = require("../packages/logger");
const { createItem } = require("./db_operations");
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
 * 
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
 * Generate a transaction history description
 * @param {number} amount 
 * @returns {string}
 */
const _transactionDescription = (amount) => {
    const CENTS = 100;
    try {
        const statements = [
            "Account credited with #AMOUNT on #DATE, for your next adventure with us.",
            "Your balance was successfully topped up by #AMOUNT on #DATE. for your next adventure with us",
            "Congratulations! You've added #AMOUNT to your account on #DATE. Ready for more fun?",
            "You've successfully recharged your account with #AMOUNT on #DATE. More power to your purchases!",
            "A successful top-up! Your account now has an extra #AMOUNT as of #DATE. Shine on!",
            "Your wallet just got heavier! Added #AMOUNT to your balance on #DATE. Spend wisely, or don't!",
            "You're all set with an additional #AMOUNT added on #DATE. What's the next move?",
            "Your account was topped up with #AMOUNT on #DATE. Enjoy more of our services!",
            "Your account was boosted with #AMOUNT worth of credits on #DATE. Enjoy the spree!",
            "#DATE: Account topped-up by #AMOUNT. The world of entertainment awaits!",
            "Your purchase of #AMOUNT in credits on #DATE, was successful. Dive into more experiences!",
            "Added #AMOUNT to your balance on #DATE. Keep enjoying our services!",
            "Your account was topped up with #AMOUNT on #DATE. Sparkle more!",
            "Boosted your balance by #AMOUNT on #DATE. More adventures await!",
            "You've successfully recharged #AMOUNT on #DATE. The excitement never stops!",
            "On #DATE, your account gained an extra #AMOUNT. Enjoy more of our features!",
            "#DATE: Account recharged with #AMOUNT. Your journey, your rules!",
            //"Welcome boost! #AMOUNT added to your account on #DATE. Dive back into action!",
            "Your wallet's happier with an extra #AMOUNT on #DATE. Enjoy more of our features!",
            "Recharged #AMOUNT on #DATE. Thanks for your support!",
        ];
        const rnd = Math.floor(Math.random() * statements.length);
        ///
        const date = (new Date()).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });
        ///
        const statement = statements[rnd];
        const amountStr = "ZAR" + " " + (amount / CENTS);
        const description = statement.replace("#AMOUNT", amountStr).replace("#DATE", date);
        return description;
    } catch (error) {
        const date = (new Date()).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });
        console.log(error);
        return date + ": A successful top-up! Sparkle more!";
    }
}

function generateNotification(event, amount) {
    const amountStr = "ZAR" + (amount / 100).toFixed(2);

    function createNotification(title, body) {
        return {
            title,
            body: body.replace("#AMOUNT", amountStr)
        };
    }

    switch (event) {
        case eventTypes["payment.succeeded"]:
            return createNotification("A successful top-up!", "We've received your payment of #AMOUNT. Thanks for choosing us!");

        case eventTypes["payment.failed"]:
            return createNotification("Oops! Payment Not Processed", "We encountered an issue with your payment. Assistance is on the way.");

        case eventTypes["payment.refunded"]:
            return createNotification("Refund Processed", "A refund of #AMOUNT has been credited to your account.");

        case eventTypes["payment.cancelled"]:
            return createNotification("Payment Cancelled", "Your payment of #AMOUNT has been cancelled.");

        case eventTypes["payment.disputed"]:
            return createNotification("Payment Disputed", "Your payment of #AMOUNT has been disputed.");

        case eventTypes["payment.charged_back"]:
            return createNotification("Payment Charged Back", "Your payment of #AMOUNT has been charged back.");

        case eventTypes["payment.updated"]:
            return createNotification("Payment Updated", "Your payment of #AMOUNT has been updated.");

        default:
            return createNotification("Unknown Payment Event 🫤", "Open your Verified app.");
    }
}

/**
 * handle yoco webhook
 * @param {express.Request} req
 * @param {express.Response} res
 */
function handlePaymentEvents(req, res) {
    /**
     * parse to JSON
     * @type {PaymentEvent} PaymentEvent
     */
    const paymentInformation = JSON.parse(req.rawBody || req.body);


    console.log({ paymentInformation });
    console.log("Received a Payment Event: ", paymentInformation?.type);

    // Early exit if [paymentInformation] or [paymentInformation.type] is not defined
    if (!paymentInformation || !paymentInformation.type) {
        console.log("Invalid request body or type missing");
        res.status(400).send({ status: "Error", message: "Invalid request" });
        return;
    }


    // Handle different event types 
    if (paymentInformation.type === eventTypes["payment.succeeded"]) {
        // Payment succeeded event
        _addToOrSubtractWallet(paymentInformation.payload, eventTypes["payment.succeeded"]);
        sendNotification(paymentInformation.payload, eventTypes["payment.succeeded"]);
    } else if (paymentInformation.type === eventTypes["refund.failed"]) {
        // Refund failed event
        sendNotification(paymentInformation.payload, eventTypes["refund.failed"]);
    } else if (paymentInformation.type === eventTypes["refund.succeeded"]) {
        // Refund succeeded event
        _addToOrSubtractWallet(paymentInformation.payload, eventTypes["refund.succeeded"]);
        sendNotification(paymentInformation.payload, eventTypes["refund.succeeded"]);
    } else {
        // Unknown payment event
        logger.error("Unknown payment event: " + paymentInformation?.type)
    }

    // Record transaction and send response
    createTransactionRecord(paymentInformation?.payload);
    res.send({ status: "Success" });
}
/**
 * 
 * @param {Payload} payload 
 * @param {string} notificationType 
 */
async function sendNotification(payload, notificationType) {
    try {
        console.log("Sending a FB notification", payload.metadata.payerId, notificationType);
        const notification = generateNotification(notificationType, payload.amount);

        let user = await getUserProfile(payload.metadata.payerId);
        console.log({ notification, notificationType, user });
        if (!user?.notificationToken) {
            console.log("USER NOTIFICATION TOKEN NOT FOUND => ", user.id)
            return;
        }
        ///
        sendPushNotifications({
            token: user?.notificationToken,
            ...notification
        })
        ///
        if (notificationType === "refund.succeeded") {
            sendSuccessfulRefundEmailNotifications(payload);
        } else if (notificationType === "payment.succeeded") {
            sendSuccessfulPaymentEmailNotifications(payload);
        }

    } catch (error) {
        console.log("NOTIFiCATION ERROR => ", error)
    }
}

/**
 * POST a new transaction history item
 * @param {Payload} payload
 */
function createTransactionRecord(payload) {
    try {
        console.log("Hit the store API and save the transaction... ", payload);
        const headers = new Headers();
        headers.append("x-nonce", generateNonce());
        headers.append("Content-Type", "application/json");
        headers.append("Authorization", `Bearer TOKEN`);

        const data = JSON.stringify({
            "profileId": payload.metadata.payerId,
            "amount": payload.amount,
            "isoCurrencyCode": payload.currency,
            "categoryId": "",
            "timestamp": Math.floor(Date.now() / 1000),
            "details": null,
            "description": _transactionDescription(payload.amount),
            "subtype": "topup",
            "type": "bank card",
            "transactionReferenceNumber": payload.id,
            "transactionId": payload.metadata.checkoutId,
        });

        const options = {
            method: "POST",
            headers: headers,
            body: data
        };
        const host =
            (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) +
            ':5400';
        fetch(`http://${host}/api/v1/history/resource/`, options)
            .then((response) => response.json())
            .then((result) => console.log("Logged transaction successfully", result))
            .catch((error) => console.error(error));

    } catch (error) {
        console.log("Error @ record payment transaction", error);
    }
}
/**
 * Update wallet after payment event
 * @param {Payload} payload
 */
async function _addToOrSubtractWallet(payload, eventType) {

    const savedWallet = await getWallet(payload?.metadata?.walletId);

    console.log("Adding/subtract to wallet", payload, eventType);
    console.log({ SAVED_WALLET: savedWallet });
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
    const wallet = {
        ...savedWallet,
        id: payload?.metadata?.walletId,
        profileId: payload.metadata.payerId,
        balance: ((eventType == eventTypes["payment.succeeded"]) ?
            (savedWallet.balance + payload?.amount) :
            ((eventType == eventTypes['refund.succeeded']) ?
                (savedWallet.balance - payload?.amount) :
                savedWallet.balance)),
        isoCurrencyCode: payload.currency,
        accountName: payload?.paymentMethodDetails?.card?.maskedCard,
        expDate:
            payload?.paymentMethodDetails?.card?.expiryMonth +
            "/" +
            payload?.paymentMethodDetails?.card?.expiryYear,
        cardProvider: payload?.paymentMethodDetails?.card?.scheme,
        lastDepositAt: (eventType == eventTypes["payment.succeeded"]) ? Math.floor(Date.now() / 1000) : savedWallet.lastDepositAt,

    };
    const _router = jsonServer.router(path.join( "apps" , "store/db/wallet.json"))
    const data = createItem(_router, wallet)
}

/**
 * Handle a incoming payment request
 * @param {express.Request} req
 * @param {express.Response} res
 */
async function handleYocoPayment(req, res) {
    try {
        // incoming request body
        const body = JSON.parse(req?.rawBody || req?.body);

        const headers = new Headers();
        headers.append("Content-Type", "application/json");
        headers.append("Idempotency-Key", uniqueIdentifier());
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

/**
 *  Handle an incoming refund request
 * @param {express.Request} req 
 * @param {express.Response} res 
 */
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


module.exports = { handlePaymentEvents, handleYocoRefund, handleYocoPayment };
