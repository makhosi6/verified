const express = require('express')
const morgan = require('morgan');
const { handlePushNotifications } = require('../../usecases/notifications');
const app = express()

const PORT = process.env.PORT || 4300;
const HOST = process.env.HOST || "192.168.0.132";

/// logger middleware
const accessLogStream = fs.createWriteStream(path.join(__dirname , '..' , '..' , '/log/notification/access.log'), { flags: 'a+', interval: '1d', });
app.use(morgan('combined', { stream: accessLogStream }))

// middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

//register routes
app.get('/', (req, res) => res.redirect('https://byteestudio.com'))
app.post("/api/v1/notification", handlePushNotifications);

/// listen to incoming requests
app.listen(PORT, () => console.log(`Payments app listening on port ${PORT}!`))


