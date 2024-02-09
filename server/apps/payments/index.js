const express = require('express')
const fs = require('node:fs');
const path = require('node:path');
const morgan = require('morgan');
const { handlePaymentEvents, handleYocoRefund, handleYocoPayment } = require('../../usecases/payments');
const { analytics, security, authorization, authenticate } = require('../../middleware/universal');
const { paymentsHook } = require('../../middleware/payments');
const app = express()

const PORT = process.env.PAYMENTS_PORT || process.env.PORT || 5400;
const HOST = process.env.HOST || "0.0.0.0";

/// logger middleware
const accessLogStream = fs.createWriteStream(path.join(__dirname , '..', '..','/log/payments/access.log'), { flags: 'a+', interval: '1d', });
app.use(morgan('combined', { stream: accessLogStream }))

// middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(analytics);
app.use(security);
app.use(authorization);
app.use(authenticate);
app.use(paymentsHook)

//register routes
app.get('/', (req, res) => res.redirect('https://byteestudio.com'))
app.post("/api/v1/payment-events", handlePaymentEvents);
app.post("/api/v1/payment/yoco", handleYocoPayment);
app.post("/api/v1/refund/yoco/:checkoutId", handleYocoRefund);

/// listen to incoming requests
app.listen(PORT, () => console.log(`Payments app running @ http://${HOST}:${PORT}`))