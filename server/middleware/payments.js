const crypto = require('crypto');


const paymentsHook = (req, res, next) => {
    next()
}

function validateWebhookSender(req, res, next) {
    try {
        const headers = req.headers;
        const requestBody = req.rawBody;

        // Construct the signed content
        const id = headers['webhook-id'];
        const timestamp = headers['webhook-timestamp'];

        const signedContent = `${id}.${timestamp}.${requestBody}`;

        const secret = process.env.PAYMENT_EVENTS_SECRET || "NO_SECRET";

        const secretBytes = new Buffer(secret.split('_')[1], "base64");
        
        const expectedSignature = crypto
        .createHmac('sha256', secretBytes)
        .update(signedContent)
        .digest('base64');
        
        const signature = headers['webhook-signature'].split(' ')[0].split(',')[1]
        
        // console.log({ id, timestamp, secret, signedContent , secretBytes, signature});

        if (crypto.timingSafeEqual(Buffer.from(expectedSignature), Buffer.from(signature))) {
            console.log("\nYOCO incoming request with a 200 status.....\n");
            // process webhook event
            next()
        } else {
            console.log("\nYOCO incoming request with a 400 status.....\n");
            console.log('Signature check failed.....');
            res.status(400)
        };

        console.log("\nYOCO incoming request with a 403 status.....\n");
        // do not process webhook event
        return res.status(403);

    } catch (error) {
        console.log(error);
        console.log("\nYOCO incoming request with a 500 status.....\n");
        res.status(500)
    }
}


module.exports = { paymentsHook, validateWebhookSender }