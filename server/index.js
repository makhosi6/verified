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
  console.log('job finished processing with an error:',JSON.stringify(e, null, 2))
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

