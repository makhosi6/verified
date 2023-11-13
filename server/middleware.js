const {
    v4: uuidv4
} = require('uuid');
const fetch = (...args) => import('node-fetch').then(({
    default: fetch
}) => fetch(...args));

const analytics = (req, res, next) => {
    console.log("analytics hook");
    const IP = "";
    const time = Math.floor(Date.now() / 1000)
    const sessionId = ""
    const headers = {};

    next();
}
async function updateLastSeen(id) {
    try {
        const headers = {
            "x-nonce": "MjAyM184XzI1XzFfMTc1MTMyYjJmOTkwMDE1NmVkOTIzNmU0YTc3M2Y2ZGNhOGUxNzUxMzJiMmY5MWY3MjM2",
            "Authorization": "Bearer TOKEN",
            "Content-Type": "application/json"
        }

        const response = await fetch(`http://localhost:4343/api/v1/profile/resource/${id}?role=system`, {
            method: 'GET',
            headers
        })
        const data = await response.json();

        fetch(`http://localhost:4343/api/v1/profile/resource/${id}?role=system`, {
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
 * @param {*} res 
 * @param {*} next 
 */
const lastLoginHook = (req, res, next) => {

    const id = req.url.split("/").pop().replace("?role=system", '');
    const method = req.method.toUpperCase();
    if (id && method == "GET" && !(req.url.includes("?role=system"))) {

        global.queue.push(() => updateLastSeen(id))
    }

    next()
}


const addTimestamps = (req, res, next) => {
    console.log("add_timestamp hook");
    const METHOD = req.method.toUpperCase();
    if (METHOD === 'POST') {
        req.body.createdAt = Math.floor(Date.now() / 1000)
        req.body.account_created_at = Math.floor(Date.now() / 1000)

    }
    if (METHOD == "PUT") {
        req.body.updatedAt = Math.floor(Date.now() / 1000)
    }
    if (METHOD == "DELETE") {
        req.body.deletedAt = Math.floor(Date.now() / 1000)
    } else {
        // res.body.last_login_at = Math.floor(Date.now() /1000)
    }
    next()
}

const addIdentifiers = (req, res, next) => {
    console.log("add_IDs hook   " + req.url);
    const METHOD = req.method.toUpperCase();
    if (METHOD === 'POST' && !req.url.includes("profile/resource")) {
        req.body.id = uuidv4();
    } 
    next()
}

const security = (req, res, next) => {
    console.log("Security hook");
    next()
}
const authenticate = (req, res, next) => {
    console.log("authenticate hook");
    next()
}

const authorization = (req, res, next) => {
    try {
        console.log("authorization hook");
        let isAuthorized =
            `${req.headers?.authorization}`.includes("TOKEN") ||
            `${req.headers?.authorization}`.includes("TOKEN_1") ||
            `${req.query?.key}` == "KEY";

        if (isAuthorized) {
            next();
        } else {
            res.sendStatus(401);
        }
    } catch (error) {
        console.table({
            error: error.message
        });
        res.sendStatus(500);
    }
}




module.exports = {
    analytics,
    security,
    addTimestamps,
    authenticate,
    authorization,
    addIdentifiers,
    lastLoginHook
}