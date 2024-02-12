const request = require('request')
const fetch = (...args) => import('node-fetch').then(({
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
        const header = new Headers();
        header.append("x-nonce", "MjAyM184XzI1XzFfMTc1MTMyYjJmOTkwMDE1NmVkOTIzNmU0YTc3M2Y2ZGNhOGUxNzUxMzJiMmY5MWY3MjM2");
        header.append("Authorization", "Bearer TOKEN");
        const host = (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) + `:5400`
        var requestOptions = {
            method: 'GET',
            headers: header
        };

        const response = await fetch(`http://${host}/api/v1/wallet/resource/${id}`, requestOptions);


        const data = await response.json();
    } catch (error) {
        console.log(error);

        return {};
    }

}

module.exports = {
    getWallet
}