const crypto = require('node:crypto');
const uuid = typeof crypto !== 'undefined' && crypto.randomUUID && crypto.randomUUID.bind(crypto);
const { v4: uuidv4 } = require("uuid");

function uniqueIdentifier(){
    if (uuid) {
      return uuid();
    }
    return uuidv4()
  }

module.exports = {
    uniqueIdentifier
}