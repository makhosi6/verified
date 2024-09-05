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

        fetch(`${baseUrl}/jobs/resource/${uuid}?role=system`, requestOptions)
            .then((response) => response.text())
            .then((result) => console.log(result))
            .catch((error) => console.error(error));

    } catch (error) {

    } finally {
        res.send({ message: "success", status: 'OK', });
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
        headers.append("x-caller", '_getJob')

        const requestOptions = {
            method: "GET",
            headers: headers,
            redirect: "follow"
        };

        const response = await fetch(`${baseUrl}/jobs/resource/${id}?role=system`, requestOptions);

        const data = await response.json();

        return data;
    } catch (error) {
        console.log(error);

        return null;
    }
}
/**
 * 
 * @param {*} req 
 * @param {*} res 
 * @returns 
 */
async function handleCreateJob(req, res) {
    try {
        let data = await req?.body
        const instanceId = data?.person?.instanceId || data?.instanceId
        data.id = instanceId;

        const existingJob = await _getJobs(instanceId || data?.id)
        console.log({ existingJob, data });
        if (existingJob != null && typeof existingJob === 'object' && Object.keys(existingJob).length > 0) {
            delete data.updatedAt;
            delete data.createdAt;
            delete data.id;
            res.status(409).json({
                status: 'error',
                message: 'Conflict / Resource already exists',
                data
            });
            return;
        }
        const output = await _createJob(data);

        res.send({ message: "success", status: 'OK', data: output, });
    } catch (error) {
        console.log(error);
        res.send({ message: error.toString(), status: 'ERROR', data: req.body })
    }
}
async function _updateJob(id, data) {
    try {
        const headers = new Headers();
        headers.append("x-nonce", generateNonce());
        headers.append("Content-Type", "application/json");
        headers.append("Authorization", "Bearer TOKEN");
        headers.append("x-caller", '_updateJob')
        ///
        let storedData = await _getJobs(id);
        const jobExists = storedData != null && typeof storedData === 'object' && Object.keys(storedData).length > 0
        const method = jobExists ? 'PUT' : 'POST'
        if (!jobExists) storedData = {};
        const body = JSON.stringify({ ...storedData, ...data });
        const options = { method, headers, body };
        ///
        const response = await fetch(`${baseUrl}/jobs/resource/${id}`, options);
        const output = await response.json()

        return output;
    } catch (error) {
        console.log(error);
        return null;
    }
}
/// make a doc/comment
async function _createJob(data) {
    const instanceId = data?.instanceId || data?.person?.instanceId;
    if (data.id !== instanceId) throw new Error('Deformed input data, `instanceId` should be equals to `id`')
    const headers = new Headers();
    headers.append("x-nonce", generateNonce());
    headers.append("Authorization", "Bearer TOKEN");
    headers.append("Content-Type", "application/json");
    headers.append("x-caller", 'createJob')
    const body = JSON.stringify(data);
    console.log({ body });

    const requestOptions = { method: "POST", headers, body };
    const response = await fetch(`${baseUrl}/jobs/resource`, requestOptions);
    const output = await response.json()
    if (output.id !== data.id) throw new Error('Bad data, check logs')
    return output;
}

/**
 * 
 * @param {*} req 
 * @param {*} res 
 * @returns 
 */
async function handleVerificationRequest(req, res) {
    try {
        const instanceId = req?.body.verifeeRequest.jobUuid || req?.body.verifeeRequest.jobUuid;
        const updatedData = _updateJob(instanceId, req?.body);
        res.send({ message: "success", status: 'OK', data: updatedData, });
    } catch (error) {
        console.log(error);
        res.send({ message: error.toString(), status: 'ERROR', data: req.body })
    }
}



module.exports = { updateCommsForJobs, handleCreateJob, handleVerificationRequest }