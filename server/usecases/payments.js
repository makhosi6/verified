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
    'payment.succeeded': 'payment.succeeded',
    'refund.succeeded': 'refund.succeeded',
    'refund.failed': 'refund.failed'
};

/**
 * 
 * @param {Request} req 
 * @param {Response} res 
 */
function handlePaymentEvents(req, res) {
    console.log("Received a Payment Event: ", body?.type);
    const body = req?.body || req?.rawBody;

    switch (body?.type) {
        case eventTypes['payment.succeeded']: {

            /**
             * @type {PaymentEvent}
             */
            let paymentInformation = body;

            /// update wallet (add the payment amount)
            _addToWallet(paymentInformation.payload)

            /// then finally send a FB notification
            _sendFirebaseNotification(paymentInformation.metadata.payerId, eventTypes['payment.succeeded']);

            break;
        }
        case eventTypes['refund.failed']: {
            /**
             * @type {RefundEvent}
             */
            let paymentInformation = body;
            /// then finally send a FB notification
            _sendFirebaseNotification(paymentInformation.metadata.payerId, eventTypes['refund.failed'])
            break;
        }
        case eventTypes['refund.succeeded']: {

            /**
            * @type {RefundEvent}
            */
            let paymentInformation = body;

            /// update wallet (subtract the refund amount)
            _subtractFromWallet(paymentInformation.metadata.payerId, paymentInformation.payload.amount)

            /// then finally send a FB notification
            _sendFirebaseNotification(paymentInformation.metadata.payerId, eventTypes['refund.succeeded'])
            break;
        }
        default: {
            console.log("Unknown payment event...");
            break;
        }
    }

    /// record the transaction
    _createTransactionRecord(paymentInformation?.payload);

    res.send({ status: "Success" })
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
    console.log("Hit the store API and save the transaction...");
}
/**
 * 
 * @param {Payload} payload 
 */
function _addToWallet(payload) {
    console.log("Adding to wallet", payerRefId, amount);
    let options = {
        'method': 'PUT',
        'url': `http://${HOST}:${PORT}/api/v1/wallet/resource/${payload?.metadata?.walletId ?? ''}`,
        'headers': {
            'x-nonce': 'MjAyM184XzI1XzFfMTc1MTMyYjJmOTkwMDE1NmVkOTIzNmU0YTc3M2Y2ZGNhOGUxNzUxMzJiMmY5MWY3MjM2',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer TOKEN'
        },
        body: JSON.stringify({
            "profileId": payload.metadata.payerId,
            "balance": payload?.amount,
            "isoCurrencyCode": "ZAR",
            "accountName": payload?.paymentMethodDetails?.card?.maskedCard,
            "expDate": payload?.paymentMethodDetails?.card?.expiryMonth + "/" + payload?.paymentMethodDetails?.card?.expiryYear,
            "cardProvider": payload?.paymentMethodDetails?.card?.scheme,
            "lastDepositAt": Math.floor(Date.now() / 1000)
        })

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
        const body = req?.body || req?.rawBody;

        const headers = new Headers();
        headers.append("Content-Type", "application/json");
        headers.append("Idempotency-Key", uuidv4());
        headers.append("Authorization", `Bearer ${PAYMENTS_TOKEN}`);

        ///
        const response = await fetch("https://payments.yoco.com/api/checkouts", {
            method: 'POST',
            headers: headers,
            body: JSON.stringify(body),
        })

        const result = await response.json();

        res.send(result)


    } catch (error) {
        console.log(error);
        res.send({ code: 500, message: "Internal Error Occurred" })

    };


}

async function handleYocoRefund(req, res) {
    try {
        // incoming request body
        const body = req?.body || req?.rawBody;
        const checkoutId = req.params?.checkoutId;

        const headers = new Headers();
        headers.append("Content-Type", "application/json");
        headers.append("Idempotency-Key", uuidv4());
        headers.append("Authorization", `Bearer ${PAYMENTS_TOKEN}`);

        ///
        const response = await fetch(`https://payments.yoco.com/api/checkouts/${checkoutId}/refund`, {
            method: 'POST',
            headers: headers,
            body: JSON.stringify(body),
        })

        const result = await response.json();

        res.send(result)


    } catch (error) {
        console.log(error);
        res.send({ code: 500, message: "Internal Error Occurred" })

    };


}


module.exports = {
    handleYocoPayment,
    handleYocoRefund,
    handlePaymentEvents
}