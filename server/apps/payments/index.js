const express = require('express')
const morgan = require('morgan');
const { handlePaymentEvents, handleYocoRefund, handleYocoPayment } = require('../../usecases');
const { analytics, security, authorization, authenticate } = require('../../middleware/universal');
const { paymentsHook } = require('../../middleware/payments');
const app = express()

const PORT = process.env.PORT || 4300;
const HOST = process.env.HOST || "192.168.0.132";

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
app.listen(PORT, () => console.log(`Payments app listening on port ${PORT}`))