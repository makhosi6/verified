const jsonServer = require("json-server");
const morgan = require('morgan')
const path = require('node:path')
const fs = require('node:fs')
const { generateNonce } = require("./nonce");
const server = jsonServer.create();
const defaultMiddleware = jsonServer.defaults();
///
const Queue = require('./queue')

const queue = new Queue({ results: [], autostart: true, timeout: 30000 });
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
  addTimestamps,
  authenticate,
  authorization,
  addIdentifiers,
  security,
  lastLoginHook
} = require("./middleware");

///
const { notifyAdmin } = require("./usecases");
///
const tickets = jsonServer.router(path.join(__dirname, "db/tickets.json"));
const history = jsonServer.router(path.join(__dirname, "db/history.json"));
const profile = jsonServer.router(path.join(__dirname, "db/profile.json"));
const promotion = jsonServer.router(path.join(__dirname, "db/promotion.json"));
const wallet = jsonServer.router(path.join(__dirname, "db/wallet.json"));


// setup the logger
const accessLogStream = fs.createWriteStream(path.join(__dirname + '/log/', 'access.log'), { flags: 'a+', interval: '1d', });
server.use(morgan('combined', { stream: accessLogStream }))

// Set default middlewares (logger, static, cors and no-cache)
server.use(defaultMiddleware);
server.use(jsonServer.bodyParser);
server.use(analytics);
server.use(security);
server.use(authorization);
server.use(authenticate);
server.use(addTimestamps);
server.use(addIdentifiers);

// Use default router
server.post("/api/v1/help", notifyAdmin);
server.get(["/api/v1/my_credits", "/api/v1/health-check"], (req, res) => {
  const rnd = Math.floor(Math.random() * 10)
  if (rnd > 6) {
    res.status(500);
  } else {

    res.status(200).json({
      "Status": "Success",
      "Result": {
        "credits": rnd
      }
    })
  }
});
server.post("/api/v1/contact_enquiry", (req, res) => {
  const { contact_number, reason } = req?.body;
  console.table(req?.body)

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

server.use("/api/v1/health-check", (req, res) => res.send({
  status: 200,
},),);


server.use("/api/v1/ticket", tickets);
server.use("/api/v1/history", history);
server.use("/api/v1/profile", lastLoginHook, profile);
server.use("/api/v1/promotion", promotion);
server.use("/api/v1/wallet", wallet);
server.get("/log", (req, res) => res.send({
  status: 200,
}),);
server.listen(4343, () => {
  console.log("JSON Server is running");
});

