// const express = require('express')
// const morgan = require('morgan');
// const fs = require('node:fs');
// const path = require('node:path');
const { sendPushNotifications } = require('../../usecases/notifications');
// const { analytics, security, authorization, authenticate } = require('../../middleware/universal');
// const { notificationsHook } = require('../../middleware/notification');
// const app = express()

// const PORT = process.env.FB_NOTIF_PORT || process.env.PORT || 5400;
// const HOST = process.env.HOST || "0.0.0.0";

// /// logger middleware
// const accessLogStream = fs.createWriteStream(path.join(__dirname , '..' , '..' , '/log/notifications/access.log'), { flags: 'a+', interval: '1d', });
// app.use(morgan('combined', { stream: accessLogStream }))

// // middleware
// app.use(express.json());
// app.use(express.urlencoded({ extended: true }));
// app.use(analytics);
// app.use(security);
// app.use(authorization);
// app.use(authenticate);
// app.use(notificationsHook)

// //register routes
// app.get('/', (req, res) => res.redirect('https://byteestudio.com'))
// app.post("/api/v1/notification", handlePushNotifications);

// /// listen to incoming requests
// app.listen(PORT, () => console.log(`Payments app running @ http://${HOST}:${PORT}`))


// sendPushNotifications(
//     {
//         title: 'Cheers to Your Purchase!',
//         body: "We've received your payment of ZAR50.00. Thanks for choosing us!",
//         token: 'dK_AJdomTwam7mAzk2xnmG:APA91bGmdd6LNpatVcCRsp1rW7txNQ_HPyZJta258ZbedKT58DBpmCb_gWLw-cO4WR3u83IgpILnepJmvv7B3pY1SLLTCuwFuP8qn2WQznnTUa90eQxSbGoQwq9j_k2_NgEiLiDoMaqk'
      
// });