const morgan = require("morgan");
const express = require("express");
const cors = require("cors");
const path = require("node:path");
const fs = require("node:fs");

const PORT = process.env.VERIFYID_PORT || process.env.PORT || 5400;
const HOST = process.env.HOST || "0.0.0.0";
const server = express();
///
const Queue = require('../../packages/queue')


const queue = new Queue({
    results: [],
    autostart: true,
    timeout: 30000
});
queue.addEventListener('success', e => {
    console.log('job finished processing:', JSON.stringify(e, null, 2))
    console.log('The result is:', e.toString())
})
queue.addEventListener('error', e => {
    console.log('job finished processing with an error:', JSON.stringify(e, null, 2))
    console.log('The result is:', e.toString())
})
queue.start(err => {
    if (err) console.error("Queue Error", err)

    console.log('all done:', queue.results)
})

global.queue = queue;
///
const {
    analytics,
    authenticate,
    authorization,
    security,
} = require("../../middleware/universal");
const {
    verifyIdHook,
    getRequestClientId,
    deductCreditsAfterTransaction
} = require("../../middleware/verifyid");


const {
    handleSaidVerification,
    handleContactEnquiry,
    handleGetCreditsReq,
} = require("../../usecases/verifyid");

///

// setup the logger
const accessLogStream = fs.createWriteStream(
    path.join(__dirname, "..", "..", "/log/verify_id/access.log"), {
        flags: "a+",
        interval: "1d"
    });
server.use(morgan("combined", {
    stream: accessLogStream
}));

// Set default middlewares (logger, static, cors and no-cache)
server.use(cors());
server.use(express.json());
server.use(express.urlencoded({
    extended: true
}));
server.use(analytics);
server.use(security);
server.use(authorization);
server.use(authenticate);
server.use(verifyIdHook);
server.use(getRequestClientId);
server.disable('x-powered-by');

server.get("/api/v1/health-check", handleGetCreditsReq);
server.get("/api/v1/my_credits", handleGetCreditsReq);
server.post("/api/v1/contact_enquiry", handleContactEnquiry);
server.post("/api/v1/said_verification", handleSaidVerification);

server.listen(PORT, () => {
    console.log(`JSON Server is running @ http://${HOST}:${PORT}`);
});