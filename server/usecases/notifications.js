let FCM = require("fcm-node");
const request = require('request')
const fetch = (...args) => import('node-fetch').then(({
    default: fetch
}) => fetch(...args));
let serverKey = process.env.FB_SERVER_TOKEN || "FB_SERVER_TOKEN";
let fcm = new FCM(serverKey);

/// https://github.com/jlcvp/fcm-node
console.log(serverKey)
/**
 * Represents a payment event object.
 * @typedef {Object} Notification
 * @property {string | null} token - fmc token.
 * @property {string | null} email - user email.
 * @property {string} title - The title of the FB notification.
 * @property {string} body - The body of the FB notification.
 */
/**
 * 
 * @param {Notification} notification 
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
console.log({message});
  fcm.send(message, function (err, response) {
    if (err) {
      console.log("Something has gone wrong!", err);
    } else {
      console.log("Successfully sent with response: ", response);
    }
  });
}
/**
 * @param {Notification} notification 
 */
function sendEmailNotifications({ email, title, body }){

}

function sendWhatsappMessage(data) {
  const host = (process.env.NODE_ENV === "production" ? `whatsapp_messaging_service:9092`: "localhost:9092")
  let options = {
    'method': 'POST',
    'url': `http://${host}/send`,
    'headers': {
      'x-nonce': "NONCE",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer TOKEN'
    },
    body: JSON.stringify(data)

  };
  request(options, function (error, response) {
    if (error) throw new Error(error);
  });
}

module.exports = {
  sendPushNotifications, sendEmailNotifications, sendWhatsappMessage
};
