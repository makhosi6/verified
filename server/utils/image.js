const logger = require("../packages/logger");

const fetch = (...args) =>
    import("node-fetch").then(({ default: fetch }) => fetch(...args));

/**
 * Fetches an image from a URL and converts it to a Base64 data URL.
 * 
 * @param {string} imageUrl
 * @returns {Promise<string>} - resolves to the Base64 data URL
 * @throws {Error} - Throws an error if fetching the image fails or the file type is unsupported.
 */
async function getImageAsBase64(imageUrl) {
    // Supported image types based on file extensions
    const supportedExtensions = {
        'jpg': 'image/jpeg',
        'jpeg': 'image/jpeg',
        'png': 'image/png',
    };

    const extension = imageUrl.split('.').pop().toLowerCase();

    if (!supportedExtensions[extension]) {
        throw new Error('Unsupported image type');
    }

    try {
        // Fetch the image as a Blob
        const response = await fetch(imageUrl);
        if (!response.ok) {
            throw new Error('Failed to fetch the image');
        }
        const buffer = await response.buffer();

        const base64String = buffer.toString('base64');

        return `data:${supportedExtensions[extension]};base64,${base64String}`;
    } catch (error) {
        logger.error('IMAGE_URL ', imageUrl)
        throw new Error(`Error converting image to Base64: ${error.message}`);
    }
}
// getImageAsBase64('http://192.168.0.121:4334/static/1726375540143_436197820__CAP4403647766963341549.jpg').then(console.log)

module.exports = {
    getImageAsBase64
}