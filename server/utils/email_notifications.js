const fetch = (...args) =>
    import("node-fetch").then(({
        default: fetch
    }) => fetch(...args));

const NotificationsApiService = {
    baseUrl: "https://byteestudio.com",

    async sendRequest(endpoint, data) {
        try {
            const NOTIFICATIONS_TOKEN = process.env.VERIFIED_NOTIFICATIONS_TOKEN || 'token_1234'
            const headers = new Headers();
            headers.append("Content-Type", "application/json");
            headers.append("Authorization", `Bearer ${NOTIFICATIONS_TOKEN}`);

            const options = {
                method: "POST",
                headers,
                body: JSON.stringify(data),
            };

            const response = await fetch(`${this.baseUrl}${endpoint}`, options);
            return await response.json();
        } catch (error) {
            console.error("API call failed:", error);
            return {
                error,
                code: '5**',
                reason: error.toString()
            }
        }
    },
    /**
     * 
     * @param {Object} data
     * @param {string} data.email 
     * @param {string} data.name 
     * @returns {Promise<Object>}
     * @returns 
     */
    async sendVerificationFailedNotification(data) {
        return this.sendRequest("/api/notify/verification-failed", data);
    },
    /**
     * 
     * @param {Object} data 
     * @param {string} data.email 
     * @param {string} data.name 
     * @returns {Promise<Object>}
     * @returns 
     */
    async sendVerificationSuccessfulNotification(data) {
        return this.sendRequest("/api/notify/verification-successful", data);
    },
    /**
     * 
     * @param {Object} data 
     * @param {string} data.email 
     * @param {string} data.name 
     * @returns {Promise<Object>}
     * @returns 
     */
    async sendVerifiedAuthWelcomeNotification(data) {
        return this.sendRequest("/api/notify/auth-welcome", data);
    },
    /**
     * 
     * @param {Object} data 
     * @param {string} data.email 
     * @param {string} data.name 
     * @param {string} data.amount
     * @returns {Promise<Object>}
     * @returns 
     */
    async sendVerifiedSuccessfulPaymentNotification(data) {
        return this.sendRequest("/api/notify/payment-successful", data);
    },
    /**
     * 
     * @param {Object} data 
     * @param {string} data.email 
     * @param {string} data.name 
     * @param {string} data.amount
     * @returns {Promise<Object>}
     * @returns 
     */
    async sendVerifiedFailedPaymentNotification(data) {
        return this.sendRequest("/api/notify/payment-failed", data);
    },
    /**
     * 
     * @param {Object} data 
     * @param {string} data.email 
     * @param {string} data.name 
     * @param {string} data.amount
     * @returns {Promise<Object>}
     * @returns 
     */
    async sendVerifiedSuccessfulRefundNotification(data) {
        return this.sendRequest("/api/notify/refund-successful", data);
    },
    /**
     * 
     * @param {Object} data 
     * @param {string} data.email 
     * @param {string} data.name 
     * @param {string} data.device
     * @param {string} data.time
     * @returns {Promise<Object>}
     * @returns 
     */
    async sendVerifiedAccountDeactivatedNotification(data) {
        return this.sendRequest("/api/notify/account-deactivated", data);
    },
    /**
     * 
     * @param {Object} data 
     * @param {string} data.email 
     * @param {string} data.name
     * @returns {Promise<Object>}
     * @returns 
     */
    async sendVerifiedSupportRequestReceivedNotification(data) {
        return this.sendRequest("/api/notify/support-request-received", data);
    }
};

export default NotificationsApiService;