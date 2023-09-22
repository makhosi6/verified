const jsonServer = require("json-server");
const { generateNonce } = require("./nonce");
const server = jsonServer.create();
const middlewares = jsonServer.defaults();
///
const {
  analytics,
  addTimestamps,
  authenticate,
  authorization,
  notifyAdmin,
} = require("./middleware");
///
const history = jsonServer.router("db.json");
const profile = jsonServer.router("db.json");
const promotion = jsonServer.router("db.json");
const wallet = jsonServer.router("db.json");
// Set default middlewares (logger, static, cors and no-cache)
server.use(middlewares);
server.use(jsonServer.bodyParser);
server.use(analytics);
server.use(authorization);
server.use(addTimestamps);

// Use default router
server.use("api/v1/help", notifyAdmin);
server.use("api/v1/history", history);
server.use("api/v1/profile", profile);
server.use("api/v1/promotion", promotion);
server.use("api/v1/wallet", wallet);
server.use("*", (req, res) => res.send(400));
server.listen(4343, () => {
  console.log("JSON Server is running");
});
