const request = require('request')
const fetch = (...args) => import('node-fetch').then(({
  default: fetch
}) => fetch(...args));
const { sendWhatsappMessage } = require('./notifications.js')

const HOST = process.env.HOST || "0.0.0.0";
const PORT = process.env.PORT || "5400";


const notifyAdmin = async (req, res) => {
  /// log a the ticket
  const send = _logTicket(req?.body)
  // call whatsapp bot
  const whatsapp = sendWhatsappMessage(req?.body)

  res.sendStatus(200);
}

function _logTicket(body) {
  const host = (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) + `:${PORT}`
  let options = {
    'method': 'POST',
    'url': `http://${host}/api/v1/ticket/resource/`,
    'headers': {
      'x-nonce': 'MjAyM184XzI1XzFfMTc1MTMyYjJmOTkwMDE1NmVkOTIzNmU0YTc3M2Y2ZGNhOGUxNzUxMzJiMmY5MWY3MjM2',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer TOKEN'
    },
    body: JSON.stringify(body)

  };
  request(options, function (error, response) {
    if (error) throw new Error(error);
  });
}


module.exports = {
  notifyAdmin
}