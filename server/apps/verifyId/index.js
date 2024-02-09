const morgan = require("morgan");
const express = require("express");
const cors = require("cors");
const path = require("node:path");
const fs = require("node:fs");

const PORT = process.env.VERIFYID_PORT || process.env.PORT  || 5400;
const HOST = process.env.HOST || "0.0.0.0";
const server = express();
///
const {
    analytics,
    authenticate,
    authorization,
    security,
} = require("../../middleware/universal");
const { verifyIdHook
} = require("../../middleware/verifyid");


const {
    handleSaidVerification,
    handleContactEnquiry,
    getCreditsReq,
} = require("../../usecases/verifyid");

///

// setup the logger
const accessLogStream = fs.createWriteStream(
    path.join(__dirname, "..", "..", "/log/verify_id/access.log"), { flags: "a+", interval: "1d" });
server.use(morgan("combined", { stream: accessLogStream }));

// Set default middlewares (logger, static, cors and no-cache)
server.use(cors());
server.use(express.json());
server.use(express.urlencoded({ extended: true }));
server.use(analytics);
server.use(security);
server.use(authorization);
server.use(authenticate);
server.use(verifyIdHook);

server.get("/api/v1/health-check", getCreditsReq);
server.get("/api/v1/my_credits", getCreditsReq);
server.post("/api/v1/contact_enquiry", handleContactEnquiry);
server.post("/api/v1/said_verification", handleSaidVerification);

server.listen(PORT, () => {
    console.log(`JSON Server is running @ http://${HOST}:${PORT}`);
});
