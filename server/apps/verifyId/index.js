const morgan = require('morgan')
const express = require('express')
const cors = require("cors");
const path = require('node:path')
const fs = require('node:fs')

const PORT = process.env.PORT || 4300;
const HOST = process.env.HOST || "192.168.0.132";
const server = express()
///
const {
    analytics,
    authenticate,
    authorization,
    security,
} = require("./middleware");

///

// setup the logger
const accessLogStream = fs.createWriteStream(path.join(__dirname + '/log/verify_id/', 'access.log'), { flags: 'a+', interval: '1d', });
server.use(morgan('combined', { stream: accessLogStream }))

// Set default middlewares (logger, static, cors and no-cache)
server.use(analytics);
server.use(security);
server.use(authorization);
server.use(authenticate);
server.use();


server.get("/api/v1/health-check", getCreditsReq);
server.get("/api/v1/my_credits", getCreditsReq);
server.post("/api/v1/contact_enquiry", (req, res) => {
    const { contact_number, reason } = req?.body;

    console.table(req.body)
    res.status(200).send({
        "status": "Success",
        "contactEnquiry": {
            "results": [
                {
                    "idnumber": "09877087090987",
                    "forename1": "JUST",
                    "forename2": contact_number,
                    "surname": "GOOFY"
                },
                {
                    "idnumber": "7865765786576",
                    "forename1": "SAKIO",
                    "forename2": "NIXON",
                    "surname": "MALATJI"
                },
                {
                    "idnumber": "74567456745645",
                    "forename1": "JUST",
                    "forename2": "FRED",
                    "surname": "LONGONE"
                },
                {
                    "idnumber": "345234523452345",
                    "forename1": "GUMMY",
                    "forename2": "",
                    "surname": "BEAR"
                }
            ]
        }
    });
});

server.post("/api/v1/said_verification", (req, res) => {
    const { idnumber, reason } = req?.body;
    console.table(req?.body)
    res.status(200).send({

        "status": "ID Number Valid",
        "verification": {
            "firstnames": "JUST",
            "lastname": "GOOFY",
            "dob": "1979-05-01",
            "age": 39,
            "idNumber": idnumber,
            "gender": "Male",
            "citizenship": "South African",
            "dateIssued": "1997-07-25T00:00:00+02:00"
        }

    });
});

server.listen(PORT, () => {
    console.log(`JSON Server is running @ http://${HOST}:${PORT}`);
});