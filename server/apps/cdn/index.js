const multer = require('multer');
const express = require('express')
const fs = require('fs')
const path = require('path')
const compression = require('compression');
const morgan = require('morgan')
const app = express()
const PORT = process.env.PORT || 4334;
const HOST = process.env.HOST || "0.0.0.0";
const { analytics } = require('../../middleware/universal');

/// middleware
const accessLogStream = fs.createWriteStream(path.join(__dirname, '..', '..', '/log/cdn/access.log'), { flags: 'a+', interval: '1d', });
app.use(morgan('combined', { stream: accessLogStream }))
app.use(analytics);

//register routes
app.use(compression());
app.use(express.json({ limit: "100mb" }));
app.use(express.urlencoded({ limit: "100mb" }));
app.disable('x-powered-by');

// Set up storage engine with multer
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, path.join(__dirname, 'static'));
    },
    filename: function (req, file, cb) {
        const uniquePrefix = Date.now() + '_' + Math.round(Math.random() * 1E9)
        cb(null, uniquePrefix + '_' + file.originalname);
    }
});

const upload = multer({ storage: storage });


function handleFileUpload(req, res) {
    if (req?.file || req?.files) {
        res.json({
            message: 'File uploaded successfully', files: req?.file ? [{ filename: req?.file.filename, size: req?.file.size, mimetype: req?.file.mimetype }] : req?.files.map(file => {
                return { filename: file.filename, size: file.size, mimetype: file.mimetype }
            })
        });
    } else {
        res.status(400).send({ message: 'No file uploaded', files: null });
    }
}
/**
 * Static files
 */

app.use('/static', express.static(path.join(__dirname, '/static')));
app.use('/media', express.static(path.join(__dirname, '/static')));
///

// hidden security files
app.use('/', express.static(path.join(__dirname, '/root')));
// Route to handle file upload
app.post('/api/v1/media/upload', upload.array('files', 4), handleFileUpload);
/// listen to incoming requests
app.listen(PORT, () => console.log(`CDN running @ http://${HOST}:${PORT}`))