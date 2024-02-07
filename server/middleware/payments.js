const paymentsHook = (req, res, next) => {
    console.log("payments hook");
    next()
}


module.exports = { paymentsHook }