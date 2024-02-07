const express = require('express')
const morgan = require('morgan');
const fs = require('node:fs');
const path = require('node:path');
const { handlePushNotifications } = require('../../usecases/notifications');
const { analytics, security, authorization, authenticate } = require('../../middleware/universal');
const { notificationsHook } = require('../../middleware/notification');
const app = express()

const PORT = process.env.FB_NOTIF_PORT || 4300;
const HOST = process.env.HOST || "192.168.0.132";

/// logger middleware
const accessLogStream = fs.createWriteStream(path.join(__dirname , '..' , '..' , '/log/notifications/access.log'), { flags: 'a+', interval: '1d', });
app.use(morgan('combined', { stream: accessLogStream }))

// middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(analytics);
app.use(security);
app.use(authorization);
app.use(authenticate);
app.use(notificationsHook)

//register routes
app.get('/', (req, res) => res.redirect('https://byteestudio.com'))
app.post("/api/v1/notification", handlePushNotifications);

/// listen to incoming requests
app.listen(PORT, () => console.log(`Payments app running @ http://${HOST}:${PORT}`))


