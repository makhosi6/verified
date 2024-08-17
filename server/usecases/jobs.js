const { generateNonce } = require("../nonce.source");
const fetch = (...args) =>
    import("node-fetch").then(({ default: fetch }) => fetch(...args));

const baseUrl = 'http://0.0.0.0:5400/api/v1' || 'http://192.168.0.134/store/api/v1' || 'https://verified.byteestudio.com/store/api/v1';
async function updateCommsForJobs(req, res) {
    try {
        
  
    const { sms, email, instanceId: uuid } = req?.body;
    ///
    const headers = new Headers();
    headers.append("x-nonce", generateNonce());
    headers.append("Content-Type", "application/json");
    headers.append("Authorization", "Bearer TOKEN");
    headers.append("x-caller", 'updateCommsForJobs')
    const oldData = await _getJobs(uuid);
    const raw = JSON.stringify({ ...oldData, comms: { email, sms } });

    const requestOptions = {
        method: "PUT",
        headers: headers,
        body: raw,
        redirect: "follow"
    };

    fetch(`${baseUrl}/jobs/resource/${uuid}`, requestOptions)
        .then((response) => response.text())
        .then((result) => console.log(result))
        .catch((error) => console.error(error));

    } catch (error) {
        
    }finally{
        res.send({ message: "success", status: 'OK',});
    }
}
/**
 * 
 * @param {string} id
 * @returns {object?}
 */
async function _getJobs(id) {
    try {
        const headers = new Headers();
        headers.append("x-nonce", generateNonce());
        headers.append("Content-Type", "application/json");
        headers.append("Authorization", "Bearer TOKEN");
        headers.append("x-caller", 'getJob')

        const requestOptions = {
            method: "GET",
            headers: headers,
            redirect: "follow"
        };

        const response = await fetch(`${baseUrl}/jobs/resource/${id}`, requestOptions);

        const data = await response.json();

        return data;
    } catch (error) {
        console.log(error);

        return null;
    }
}

async function createJob(req, res) {
    try {
        let data = await req?.body
        if (data.id != data?.instanceId) {
            data.id = data?.instanceId;
        }
        const headers = new Headers();
        headers.append("x-nonce", generateNonce());
        // headers.append("Content-Type", "application/json");
        headers.append("Authorization", "Bearer TOKEN");
        headers.append("x-caller", 'createJob')
        console.table(data);
        const raw = JSON.stringify(data);
        const requestOptions = {
            method: "POST",
            headers: headers,
            body: raw,
        };

        const response = await fetch(`${baseUrl}/jobs/resource/`, requestOptions);

        const output = await response.json()

        res.send({ message: "success", status: 'OK', data: output });
    } catch (error) {
        console.log(error);

        res.sendStatus(500);
    }
}

module.exports = { updateCommsForJobs, createJob }