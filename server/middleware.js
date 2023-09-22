const analytics = (req, res, next) => {
    const IP = "";
    const time = Date.now();
    const sessionId = ""
    const headers = {};

    next();
}

const addTimestamps = (req, res, next) => {
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

const authenticate = (req, res, next) => {

}

const authorization = (req, res, next) => {
    try {
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

const notifyAdmin = (req, res) => {
    console.log({BODY: req.body});
    // call whatsapp bot
}



module.exports = {
    analytics,
    addTimestamps,
authenticate,
    authorization,
    notifyAdmin,
}