const verifyIdHook = (req, res, next) => {
  next();
};
/**
 * 
 * @param {Object} req 
 * @param {Object} res 
 * @param {Function} next 
 */
const checkRequestClientId = (req, res, next) => {
  const { client: clientId } = req.query;
console.log({clientId });
  if (clientId) {
    next();
  } else {
    res.status(400).send({ error: "Client Id is required" });
    
  }
};

module.exports = { verifyIdHook, checkRequestClientId };
