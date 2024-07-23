const jsonServer = require("json-server");
const morgan = require('morgan')
const cors = require("cors");
const path = require('node:path')
const fs = require('node:fs')
const { generateNonce } = require("../../nonce.source");
const server = jsonServer.create();
const defaultMiddleware = jsonServer.defaults();
const PORT = process.env.STORE_PORT || process.env.PORT || 5400;
const HOST = process.env.HOST || "0.0.0.0";
///
const Queue = require('../../packages/queue')


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
  authenticate,
  authorization,
  security,
  noDeleteOperation,
  archiveOnDelete,
} = require("../../middleware/universal");

const {
  addIdentifiers,
  addTimestamps,
  lastLoginHook,
  onCreateAccountOrLoginHook,
  updateOrPutHook
} = require("../../middleware/store");
const { notifyAdmin } = require("../../usecases/admin");
///
const tickets = jsonServer.router(path.join(__dirname, "db/tickets.json"));
const history = jsonServer.router(path.join(__dirname, "db/history.json"));
const profile = jsonServer.router(path.join(__dirname, "db/profile.json"));
const archive = jsonServer.router(path.join(__dirname, "db/archive.json"));
const cache = jsonServer.router(path.join(__dirname, "db/cache.json"));
const promotion = jsonServer.router(path.join(__dirname, "db/promotion.json"));
const wallet = jsonServer.router(path.join(__dirname, "db/wallet.json"));


// setup the logger
const accessLogStream = fs.createWriteStream(path.join(__dirname, '..', '..', '/log/store/access.log'), { flags: 'a+', interval: '1d', });
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
server.use(onCreateAccountOrLoginHook);
server.use(archiveOnDelete);
server.use(updateOrPutHook);
server.disable('x-powered-by');


/// routes
server.post("/api/v1/send-comms", (req,res) => res.status(200));
server.post("/api/v1/comprehensive_verification", (req,res) => res.status(200));
server.get("/api/v1/health-check", (req,res) => res.status(200));
server.post("/api/v1/help", notifyAdmin);
server.use("/api/v1/ticket", tickets);
server.use("/api/v1/history", history);
server.use("/api/v1/profile", lastLoginHook, profile);
server.use("/api/v1/promotion", promotion);
server.use("/api/v1/wallet", wallet);
server.use("/api/v1/cache", noDeleteOperation, cache);
server.use("/api/v1/archive",noDeleteOperation, archive);

/// listen 
server.listen(PORT, () => {
  console.log(`JSON Server is running @ http://${HOST}:${PORT}`);
});