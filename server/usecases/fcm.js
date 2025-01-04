const admin = require('firebase-admin');

/**
 * Sends a push notification using the Firebase Cloud Messaging (FCM) v1 API.
 *
 * @param {string} fcmToken - The FCM token of the target device.
 * @param {object} notification - The notification object to send.
 * @returns {Promise<void>} - A promise that resolves when the notification is sent.
 */
const sendFCMNotification = async (token, notification) => {
    try {
        /**
         * @type {string} Service Account Path - Path to the service account JSON file.
         */
        const serviceAccountPath = process.env.SERVICE_ACCOUNT_PATH || './service_account.json'
        const key = require(serviceAccountPath)
        admin.initializeApp({
            credential: admin.credential.cert(key),
        });

        const messaging = admin.messaging();

        const message = {
            token, notification,
        };

        // Send the message
        const response = await messaging.send(message);
        console.log('Successfully sent message:', response);
    } catch (error) {
        console.error('Error sending message:', error);
    }
};


module.exports = {
    sendFCMNotification
}