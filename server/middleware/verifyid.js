const verifyIdHook = (req, res, next) => {
  next();
};
/**
 * Check clientid and ENV
 * @param {Object} req 
 * @param {Object} res 
 * @param {Function} next 
 */
const checkRequestClientId = (req, res, next) => {
  const { client: clientId } = req.query;
  const clientEnv = req?.headers["x-client-env"];
  console.log({ clientId, clientEnv });
  if (!clientId) {
    res.status(400).send({ error: "Client Id is required" });
    return;
  }
  if (!clientEnv) {
    res.status(400).send({ error: "Define environment" });
    return;
  }

  next();
};

module.exports = { verifyIdHook, checkRequestClientId };
