const express = require('express')
const app = express()
const PORT = process.env.FB_NOTIF_PORT || process.env.PORT || 4334;
const HOST = process.env.HOST || "0.0.0.0";

app.use(analytics)


/// middleware
const accessLogStream = fs.createWriteStream(path.join(__dirname , '..' , '..' , '/log/cdn/access.log'), { flags: 'a+', interval: '1d', });
app.use(morgan('combined', { stream: accessLogStream }))
app.use(analytics);

//register routes
app.use(compression());

/**
 * Static files
 */

app.use('/static', express.static(path.join(__dirname, '/static')));

// hidden security files
app.use('/', express.static(path.join(__dirname, '/root')));

/// listen to incoming requests
app.listen(PORT, () => console.log(`CDN app running @ http://${HOST}:${PORT}`))