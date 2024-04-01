const express = require('express');
const { render } = require('@react-email/render');
const nodemailer = require('nodemailer');

const app = express()
const port = 3002

const transporter = nodemailer.createTransport({
    host: process.env.EMAIL_HOST || 'smtp.forwardemail.net',
    port: 465,
    secure: true,
    auth: {
        user: process.env.EMAIL_USER || 'user',
        pass: process.env.EMAIL_USER_PASS || 'pas5w0rd',
    },
});
/**
 * @param {User} user 
 */
function welcome(user) { }
/**
 * user feedback
 * @param {User} user 
 */
function feedback(user) { }
/**
 * @param {User} user 
 */
function feedbackOnAccountDelete(user) { }
/**
 * @param {User} user 
 */
function signUp() { }
/**
 * @param {Payment} payment 
 */
function paymentConfirmation(payment) { }
/**
 * @param {Refund} refund 
 */
function refundConfirmation(refund) { }
/**
 * @param {User} user 
 */
function productRoadMap(user) { }
/**
 * @param {User} user 
 */
function joinOurCommunity(user) { }
/**
 * @param {User} user 
 */
function newDevice(user) { }



app.get('/welcome', (req, res) => welcome(req?.body))
app.get('/feedback', (req, res) => feedback(req?.body))
app.get('/feedback-on-delete', (req, res) => feedbackOnAccountDelete(req.body))
app.get('/signup', (req, res) => signUp(req?.body))
app.get('/payment', (req, res) => paymentConfirmation(req?.body))
app.get('/refund', (req, res) => refundConfirmation(req?.body))
app.get('/product-roadmap', (req, res) => productRoadMap(req?.body))
app.get('/join-community', (req, res) => joinOurCommunity(req?.body))
app.get('/product-road-map', (req, res) => productRoadMap(req?.body))
app.get('/new-device', (req, res) => newDevice(req?.body))
app.listen(port, () => console.log(`Mailer app listening on port ${port}!`))





/**
 * @typedef {Object} User
 * @property {string} id - Unique identifier for the user.
 * @property {string} actualName - User's full name.
 * @property {string} displayName - Name displayed to the user.
 * @property {string} email - User's email address.
 * @property {string} phone - User's phone number.
 * @property {string} profileId - Unique identifier for the user profile.
 * @property {string} walletId - Unique identifier for the user's wallet.
 * @property {string} historyId - Unique identifier for the user's history.
 * @property {boolean} active - Whether the user account is active or not.
 * @property {boolean} softDeleted - Whether the user account is soft deleted.
 * @property {string} avatar - URL to the user's avatar image. (This might be a RoboHash URL with Gravatar fallback)
 * @property {number} last_login_at - Unix timestamp of the user's last login in milliseconds.
 * @property {number} account_created_at - Unix timestamp of the user account creation in milliseconds.
 * @property {number} accountCreatedAt - Alias for account_created_at (might be deprecated).
 * @property {number} updatedAt - Unix timestamp of the user data last update in milliseconds.
 * @property {Object} devices {'iphone_6s':{}}
 */


/**
 * Represents the detailed information about the refund.
 * @typedef {Object} Refund
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
 * Represents the detailed information about the payment.
 * @typedef {Object} Payment
 * @property {string} id - The unique identifier of the payment.
 * @property {string} type - The type of the object, e.g., 'payment'.
 * @property {string} createdDate - The creation date of the payment in ISO format.
 * @property {number} amount - The amount of the payment.
 * @property {string} currency - The three-letter ISO currency code representing the currency in which the payment was made.
 * @property {string} status - The status of the payment, e.g., 'succeeded'.
 * @property {string} mode - The mode of the payment, e.g., 'live'.
 * @property {Metadata} metadata - Additional information or data associated with the payment.
 */
