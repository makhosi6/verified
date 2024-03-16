const verifyIdHook = (req, res, next) => {
  next();
};
/**
 * 
 * @param {Object} req 
 * @param {Object} res 
 * @param {Function} next 
 */
const getRequestClientId = (req, res, next) => {
  const { client: clientId } = req.query;

  if (clientId) {
    next();
  } else {
    res.status(400).send({ error: "Client Id is required" });
    
  }
};

module.exports = { verifyIdHook, getRequestClientId };
