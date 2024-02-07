

const verifyIdHook = (req, res, next) => {
    console.log("verifyId hook");
    next()
}


module.exports = { verifyIdHook }