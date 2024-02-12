const { v4: uuidv4 } = require('uuid');
const { generateNonce } = require('../placeholder');
const { addWallet } = require('./universal');
const request = require('request')
const fetch = (...args) => import('node-fetch').then(({
    default: fetch
}) => fetch(...args));
const { Request, Response, NextFunction } = require('express')
const HOST = process.env.HOST || "0.0.0.0";
const PORT = process.env.PORT || "5400";


/**
 * 
 * @param {Request} req 
 * @param {Response} res 
 * @param {NextFunction} next 
 */
const addTimestamps = (req, res, next) => {
    console.log("add_timestamp hook");
    const METHOD = req.method.toUpperCase();
    if (METHOD === 'POST') {
        req.body["updatedAt"] = Math.floor(Date.now() / 1000)
        req.body["createdAt"] = Math.floor(Date.now() / 1000)
    }
    if (req.url.includes("profile/resource")) {
        req.body["account_created_at"] = Math.floor(Date.now() / 1000)
        req.body["accountCreatedAt"] = Math.floor(Date.now() / 1000)
    }
    if (METHOD == "PUT") {
        req.body["updatedAt"] = Math.floor(Date.now() / 1000)
    }
    if (METHOD == "DELETE") {
        req.body["deletedAt"] = Math.floor(Date.now() / 1000)
    } else {
        // res.body.last_login_at = Math.floor(Date.now() /1000)
    }
    next()
}


/**
 *  A middleware to add unique identifier to a POST requests
 * @param {Request} req 
 * @param {Response} res 
 * @param {NextFunction} next 
 */
const addIdentifiers = (req, res, next) => {
    console.log("add_IDs hook   " + req.url);
    const METHOD = req.method.toUpperCase();
    // Check if the request is a POST request is not profile or wallet, then add a primary unique identifier
    if (METHOD === 'POST' && !req.url.includes("profile/resource") && !req.url.includes("wallet/resource")) {


        req.body.id = uuidv4();
    }

    console.table({ ...req.body, URL: req.url });
    next()
}

/**
 * 
 * @param {Request} req 
 * @param {Response} res 
 * @param {NextFunction} next 
 */
const lastLoginHook = (req, res, next) => {

    const id = req.url.split("/").pop().replace("?role=system", '');
    const method = req.method.toUpperCase();
    if (id && method == "GET" && !(req.url.includes("?role=system"))) {

        global.queue.push(() => updateLastSeen(id))
    }

    next()
}

/**
 * 
 * @param {Request} req 
 * @param {Response} res 
 * @param {NextFunction} next 
 */
const addWalletHook = (req, res, next) => {
    const walletId = uuidv4();
    const method = req.method.toUpperCase();

    /// also create a wallet on account creation
    if (method == "POST" && req.url.includes("profile/resource")) {
        /// add wallet to profile
        req.body["walletId"] = walletId

        console.log(JSON.stringify({ PROFILE: req.body }, null, 2));
        global.queue.push(() => addWallet({
            id: walletId,
            profileId: req.body.id,
            balance: 0,
            createdAt: Math.floor(Date.now() / 1000),
            updatedAt: Math.floor(Date.now() / 1000),
            deletedAt: null,
            isoCurrencyCode: "ZAR",

            /// add new account promotions
            promotions: [],
            accountHolderName: req.body.name,
            accountName: "----0000",
            expDate: "00/00",
        }))
    }
    next()
}
/**
 * 
 * @param {Request} req 
 * @param {Response} res 
 * @param {NextFunction} next 
 */
async function updateLastSeen(id) {
    try {
        const headers = {
            "x-nonce": generateNonce(),
            "Authorization": "Bearer TOKEN",
            "Content-Type": "application/json"
        }
        const host = (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) + `:${PORT}`
        console.log({ host });
        const response = await fetch(`http://${host}/api/v1/profile/resource/${id}?role=system`, {
            method: 'GET',
            headers
        })
        const data = await response.json();

        fetch(`http://${host}/api/v1/profile/resource/${id}?role=system`, {
            method: 'PUT',
            headers,
            body: JSON.stringify({
                ...data,
                "last_login_at": Math.floor(Date.now() / 1000)
            }),
        })
            .then(response => response.text())
            .then(result => console.log("Successful Last seen update!!"))
            .catch(error => console.log('error', error));
    } catch (error) {
        console.log({
            error
        });
    }
}
/**
 * 
 * @param {Request} req 
 * @param {Response} res 
 * @param {NextFunction} next 
 */
async function updateWalletLastTopUp({ id, amount }) {
    try {
        const headers = {
            "x-nonce": generateNonce(),
            "Authorization": "Bearer TOKEN",
            "Content-Type": "application/json"
        }
        const host = (process.env.NODE_ENV === "production" ? `store_service` : `${HOST}`) + `:${PORT}`
        console.log({ host });
        const response = await fetch(`http://${host}/api/v1/wallet/resource/${id}?role=system`, {
            method: 'GET',
            headers
        })
        const data = await response.json();

        fetch(`http://${host}/api/v1/wallet/resource/${id}?role=system`, {
            method: 'PUT',
            headers,
            body: JSON.stringify({
                ...data,
                balance: (data?.balance || 0) + amount,
                lastDepositAt: Math.floor(Date.now() / 1000),

            }),
        })
            .then(response => response.text())
            .then(result => console.log("Successful Last seen update!!"))
            .catch(error => console.log('error', error));
    } catch (error) {
        console.log({
            error
        });
    }
}

// export all functions
module.exports = { addTimestamps, addIdentifiers, lastLoginHook, updateLastSeen, addWalletHook }
