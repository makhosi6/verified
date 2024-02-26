let FCM = require("fcm-node");
let serverKey = process.env.FB_SERVER_TOKEN || "FB_SERVER_TOKEN";
let fcm = new FCM(serverKey);

/// https://github.com/jlcvp/fcm-node
console.log(serverKey)
/**
 * Represents a payment event object.
 * @typedef {Object} Notification
 * @property {string} token - fmc token.
 * @property {string} title - The title of the FB notification.
 * @property {string} body - The body of the FB notification.
 */
/**
 * 
 * @param {Notification} notification 
 */
function handlePushNotifications({ token, title, body }) {

  const message = {
    to: token,
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

module.exports = {
  handlePushNotifications
};
