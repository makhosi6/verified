let FCM = require("fcm-node");
let serverKey = process.env.FB_SERVER_TOKEN || "FB_SERVER_TOKEN";
let fcm = new FCM(serverKey);

/// https://github.com/jlcvp/fcm-node
console.log(serverKey)
/**
 *
 * @param {express.Request} req
 * @param {express.Response} res
 */
function handlePushNotifications(req, res) {

  const { fbToken, title, body } = req?.body;
  console.log({ body: req?.body })
  const message = {
    to: fbToken,
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

  res.send({
    success: true,
    message: message?.notification
  });
}

module.exports = {
  handlePushNotifications
};
