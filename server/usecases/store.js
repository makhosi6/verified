const request = require("request");
const path = require("path");
const jsonServer = require("json-server");
const {
  generateNonce
} = require("../nonce.source");
const { getOne } = require("./db_operations");
const fetch = (...args) =>
  import("node-fetch").then(({
    default: fetch
  }) => fetch(...args));
const HOST = process.env.HOST || "0.0.0.0";
const PORT = process.env.PORT || "5400";

/**
 *
 * @param {string} id wallet uuid
 */
async function getWallet(id) {
  try {
    if (!id) throw new Error(`Invalid Id (${id})`);
    const _router = jsonServer.router(path.join( "apps" , "store/db/wallet.json"))
    const data = getOne(_router, id)
    return data;
  } catch (error) {
    console.log(error);

    return {
      id
    };
  }
}

/**
 *
 * @param {string} id user uuid
 */
async function getUserProfile(id) {
  try {
    //
    if (!id) throw new Error(`Invalid Id (${id})`);

    const _router = jsonServer.router(path.join( "apps" , "store/db/profile.json"))
    const user = getOne(_router, id)

    return user;
  } catch (error) {
    console.log(error);

    return {

    };
  }
}

async function archiveRecord(record) {
  try {
    const _router = jsonServer.router(path.join( "apps" , "store/db/archive.json"))
    const data = createItem(_router, record)

    console.log("DID ARCHIVE RECORD @ ", record?.type);
    console.table(data);
  } catch (error) {
    console.log(error);
  }
}

async function cache3rdPartResponse(data) {
  try {
    const _router = jsonServer.router(path.join( "apps" , "store/db/cache.json"))
    const cached = createItem(_router, data)
    console.log("DID CACHE RECORD @ ", cached?.id);
    console.table(cached);
  } catch (error) {
    console.log(error);
  }
}

module.exports = {
  getWallet,
  archiveRecord,
  cache3rdPartResponse,
  getUserProfile,
};