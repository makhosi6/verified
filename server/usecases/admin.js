const path = require('node:path');
const { sendHelpEmailNotifications } = require('./notifications');
const logger = require('../packages/logger');
const { sendWhatsappMessage } = require('./notifications.js')
const jsonServer = require("json-server");
const { createItem } = require('./db_operations.js');

const HOST = process.env.HOST || "0.0.0.0";
const PORT = process.env.PORT || "5400";

function _logTicket(body) {
  const _router = jsonServer.router(path.resolve("../apps/store/db/tickets.json"))
  createItem(_router, body)
}

const notifyAdmin = async (req, res) => {
  try {
    /// log ticket with internal system
    const send = _logTicket(req?.body);
    // call/message whatsapp bot
    const whatsapp = sendWhatsappMessage(req?.body);
    ///and email admin
    const email = sendHelpEmailNotifications(req?.body);

    //
    logger.success("Notify Admin", { send, whatsapp, email })
  } catch (error) {
    logger.error(error?.toString(), error)
  } finally {

    res.sendStatus(200);
  }
}

module.exports = {
  notifyAdmin
}