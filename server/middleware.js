const { v4: uuidv4 } = require('uuid');


const analytics = (req, res, next) => {
    console.log("analytics hook");
    const IP = "";
    const time = Date.now();
    const sessionId = ""
    const headers = {};

    next();
}

const addTimestamps = (req, res, next) => {
    console.log("add_timestamp hook");
    const METHOD = req.method.toUpperCase();
    if (METHOD === 'POST') {
        req.body.createdAt = Date.now()
    } if (METHOD == "PUT") {
        req.body.updatedAt = Date.now()
    } if (METHOD == "DELETE") {
        req.body.deletedAt = Date.now()
    }
    next()
}

const addIdentifiers = (req, res, next) => {
    console.log("add_IDs hook");
    const METHOD = req.method.toUpperCase();
    if (METHOD === 'POST') {
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
        console.table({ error: error.message });
        res.sendStatus(500);
    }
}




module.exports = {
    analytics,
    security,
    addTimestamps,
    authenticate,
    authorization,
    addIdentifiers
}