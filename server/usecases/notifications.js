const request = require("request");
const FCM = require("fcm-node");
const logger = require("../packages/logger");
const serverKey = process.env.FB_SERVER_TOKEN || "FB_SERVER_TOKEN";
const fcm = new FCM(serverKey);
const HOST = process.env.HOST || "0.0.0.0";
const PORT = process.env.PORT || "9092";
const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));

/**
 * Represents a service complaint.
 *
 * @typedef {Object} ServiceComplaint
 * @property {string} id - The unique identifier of the service complaint.
 * @property {string} profileId - The profile ID associated with the complaint.
 * @property {number} timestamp - The timestamp when the complaint was made.
 * @property {boolean} isResolved - Indicates whether the complaint is resolved or not.
 * @property {string} type - The type of the complaint.
 * @property {Array<Object>} uploads - Array containing upload information related to the complaint.
 * @property {string} uploads.filename - The filename of the uploaded file.
 * @property {number} uploads.size - The size of the uploaded file.
 * @property {string} uploads.mimetype - The mimetype of the uploaded file.
 * @property {Object} comment - The comment associated with the complaint.
 * @property {string} comment.title - The title of the comment.
 * @property {string} comment.body - The body of the comment.
 * @property {Object|null} comment.upload - Information about an optional upload associated with the comment.
 * @property {string} preferredCommunicationChannel - The preferred communication channel for the complaint.
 * @property {Array<Object>} responses - Array containing responses to the complaint.
 * @property {number} updatedAt - The timestamp when the complaint was last updated.
 * @property {number} createdAt - The timestamp when the complaint was created.
 */
/**
 *
 * @param {ServiceComplaint} data
 */

/// https://github.com/jlcvp/fcm-node
/**
 * Represents a payment event object.
 * @typedef {Object} PushNotification
 * @property {string | null} token - fmc token.
 * @property {string | null} email - user email.
 * @property {string} title - The title of the FB notification.
 * @property {string} body - The body of the FB notification.
 */
/**
 *
 * @param {PushNotification} notification
 */
function sendPushNotifications({ token, title, body }) {
  const message = {
    to: token,
    collapseKey: "verified_notifications_0234",
    collapse_key: "verified_notifications_9211",
    notification: {
      title,
      body,
    },
  };
  console.log({
    message,
  });
  fcm.send(message, function (err, response) {
    if (err) {
      console.log("Something has gone wrong!", err);
    } else {
      console.log("Successfully sent with response: ", response);
    }
  });
}
/**
 *
 * @typedef {Object} HelpRequest
 * @property {string} name - The name of the individual.
 * @property {string} email - The email of the individual.
 * @property {string} message - The message containing details or text.
 * 
 */

/**
 * @param {HelpRequest} helpRequest
 */
function sendHelpEmailNotifications(helpRequest) {
  try {
    const headers = new Headers();
    headers.append("Content-Type", "application/json");
    headers.append("Authorization", "Bearer TOKEN");


    // 
    // AbortSignal.timeout ??= function timeout(ms) {
    //   const ctrl = new AbortController()
    //   setTimeout(() => ctrl.abort(), ms)
    //   return ctrl.signal
    // }

    fetch("https://byteestudio.com/api/send-help-ticket", {
      method: "POST",
      headers: headers,
      body: JSON.stringify(helpRequest),
      //abort in 2.5 minutes
      // signal: AbortSignal.timeout(150000)
    })
      .then((response) => response.text())
      .then((result) => console.log(result))
      .catch((error) => console.error(error));
  } catch (error) {
    console.log(error);
  }
}
/**
 * 
 * @param {ServiceComplaint} data 
 */
function sendWhatsappMessage(data) {
  try {
    const host =
      process.env.NODE_ENV === "production"
        ? `whatsapp_messaging_service:9092`
        : "localhost:9092";
    let options = {
      method: "POST",
      url: `http://${host}/send`,
      headers: {
        "x-nonce": "NONCE",
        "Content-Type": "application/json",
        Authorization: "Bearer TOKEN",
      },
      body: JSON.stringify(data),
    };
    request(options, function (error, response) {
      if (error) {
        sendWhatsappSend(data);
        logger.warn(error.toString(), error)
      }
    });
  } catch (error) {
    logger.warn(error.toString(), error)
  }
}

/**
 * send a successful refund message
 * @param {HelpRequest} helpRequest
 */
function sendSuccessfulRefundEmailNotifications(helpRequest) { }
/**
 * send a thanks for payment email
 * @param {HelpRequest} helpRequest
 */
function sendSuccessfulPaymentEmailNotifications(helpRequest) { }

/**
 *
 * @param {ServiceComplaint} helpRequest
 */
function sendWhatsappSend(helpRequest) {
  try {
    const headers = new Headers();
    headers.append("Content-Type", "application/json");
    headers.append("Authorization", "Bearer TOKEN");

    const options = {
      method: "POST",
      headers,
      body: JSON.stringify(helpRequest),
    };
    const host =
      (process.env.NODE_ENV === "production"
        ? `whatsapp_messaging_service`
        : `${HOST}`) + `:9092`;
    fetch(`https://${host}/send`, options)
      .then((response) => response.json())
      .then((result) => logger.warn("SEND WA to ADMIN", result))
      .catch((error) => console.error(error));
  } catch (error) {
    logger.error(error.message, error);
  }
}

module.exports = {
  sendPushNotifications,
  sendWhatsappSend,
  sendWhatsappMessage,
  sendSuccessfulPaymentEmailNotifications,
  sendSuccessfulRefundEmailNotifications,
  sendHelpEmailNotifications,
};
