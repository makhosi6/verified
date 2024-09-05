


async function delay(timeout = 3 * 60 * 1000, callback) {
    await new Promise((resolve) => {
        setTimeout(resolve, timeout);
    });
    callback();
}


module.exports = { delay }