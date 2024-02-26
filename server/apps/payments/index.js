const express = require('express')
const fs = require('node:fs');
const path = require('node:path');
const morgan = require('morgan');
const { handlePaymentEvents, handleYocoRefund, handleYocoPayment } = require('../../usecases/payments');
const { analytics, security, authorization, authenticate } = require('../../middleware/universal');
const { paymentsHook, validateWebhookSender } = require('../../middleware/payments');
const app = express()
const getRawBody = require('raw-body');

const PORT = process.env.PAYMENTS_PORT || process.env.PORT || 5400;
const HOST = process.env.HOST || "0.0.0.0";

/// logger middleware
const accessLogStream = fs.createWriteStream(path.join(__dirname, '..', '..', '/log/payments/access.log'), { flags: 'a+', interval: '1d', });
app.use(morgan('combined', { stream: accessLogStream }))

// middleware
app.use(analytics);
// exclude //api/v1/payment-events
app.use('/api/v1/payment/yoco', security);
app.use('/api/v1/payment/yoco', authorization);
app.use('/api/v1/payment/yoco', authenticate);

app.use(paymentsHook)
app.use((req, res, next) => {
    getRawBody(req, {
        length: req.headers['content-length'],
        encoding: 'utf-8'
    }, (err, rawBody) => {
        if (err) return next(err);
        req.rawBody = rawBody;
        next();
    });
});

//register routes
app.get('/', (req, res) => res.redirect('https://byteestudio.com'))
app.post("/api/v1/payment-events", validateWebhookSender, handlePaymentEvents);
app.post("/api/v1/payment/yoco", handleYocoPayment);
app.post("/api/v1/refund/yoco/:checkoutId", handleYocoRefund);

/// listen to incoming requests
app.listen(PORT, () => console.log(`Notifications app running @ http://${HOST}:${PORT}`))