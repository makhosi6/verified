const request = require("request");
const { generateNonce } = require("../nonce.source");
const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));
const HOST = process.env.HOST || "0.0.0.0";
const PORT = process.env.PORT || "5400";

/**
 *
 * @param {string} id wallet uuid
 */
async function getWallet(id) {
  try {
    const header = new Headers();
    header.append(
      "x-nonce",
      "MjAyM184XzI1XzFfMTc1MTMyYjJmOTkwMDE1NmVkOTIzNmU0YTc3M2Y2ZGNhOGUxNzUxMzJiMmY5MWY3MjM2"
    );
    header.append("Authorization", "Bearer TOKEN");
    const host =
      (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) +
      `:5400`;
    var requestOptions = {
      method: "GET",
      headers: header,
    };

    const response = await fetch(
      `http://${host}/api/v1/wallet/resource/${id}`,
      requestOptions
    );

    const data = await response.json();

    return data;
  } catch (error) {
    console.log(error);

    return { id };
  }
}

/**
 *
 * @param {string} id user uuid
 */
async function getUserProfile(id) {
  try {
    const header = new Headers();
    header.append(
      "x-nonce",
      "MjAyM184XzI1XzFfMTc1MTMyYjJmOTkwMDE1NmVkOTIzNmU0YTc3M2Y2ZGNhOGUxNzUxMzJiMmY5MWY3MjM2"
    );
    header.append("Authorization", "Bearer TOKEN");
    const host =
      (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) +
      `:5400`;
    var requestOptions = {
      method: "GET",
      headers: header,
    };

    const response = await fetch(
      `http://${host}/api/v1/profile/resource/${id}`,
      requestOptions
    );

    const data = await response.json();

    return data;
  } catch (error) {
    console.log(error);

    return {
      id,
    };
  }
}

async function archiveRecord(record) {
  try {
    const headers = new Headers();
    headers.append("x-nonce", generateNonce());
    headers.append("Content-Type", "application/json");
    headers.append("Authorization", "Bearer TOKEN");

    const requestOptions = {
      method: "POST",
      headers: headers,
      body: JSON.stringify(record),
    };
    const host =
      (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) +
      `:5400`;
    const response = await fetch(
      `http://${host}/api/v1/archive/resource/`,
      requestOptions
    );

    const data = await response.json();
    console.log("DID ARCHIVE RECORD @ ", record?.type);
    console.table(data);
  } catch (error) {
    console.log(error);
  }
}

async function cache3rdPartResponse(data) {
  try {
    const headers = new Headers();
    headers.append("x-nonce", generateNonce());
    headers.append("Content-Type", "application/json");
    headers.append("Authorization", "Bearer TOKEN");

    const requestOptions = {
      method: "POST",
      headers: headers,
      body: JSON.stringify(data),
    };
    const host =
      (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) +
      `:5400`;
    const response = await fetch(
      `http://${host}/api/v1/cache/resource/`,
      requestOptions
    );

    const data = await response.json();
    console.log("DID CACHE RECORD @ ", data?.id);
    console.table(data);
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
