

const notificationsHook = (req, res, next) => {
    console.log("notifications hook");
    next()
}


module.exports = { notificationsHook }