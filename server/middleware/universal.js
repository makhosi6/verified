const { v4: uuidv4 } = require('uuid');
const fetch = (...args) => import('node-fetch').then(({
    default: fetch
}) => fetch(...args));

const PORT = process.env.PORT || 4300;
const HOST = process.env.HOST || "192.168.0.132";

const analytics = (req, res, next) => {
    console.log("analytics hook");
    const IP = "";
    const time = Math.floor(Date.now() / 1000)
    const sessionId = ""
    const headers = {};

    next();
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
    authenticate,
    authorization
}