let FCM = require("fcm-node");
let serverKey = process.env.FB_SERVER_TOKEN ||  "PROJECT_FB_SERVER_TOKEN"; 
let fcm = new FCM(serverKey);

/// https://github.com/jlcvp/fcm-node

/**
 *
 * @param {Request} req
 * @param {Response} res
 */
function handlePushNotifications(req, res) {
  const fbToken = req.body.fbToken;
  const title = req.body.title;
  const body = req.body.subtitle;

  const message = {
    to: fbToken,
    notification: {
      title,
      body,
    },
  };

  fcm.send(message, function (err, response) {
    if (err) {
      console.log("Something has gone wrong!");
    } else {
      console.log("Successfully sent with response: ", response);
    }
  });

  res.send({
    success: true,
    message: "Notification sent successfully",
  });
}

module.exports = {
    handlePushNotifications
};
