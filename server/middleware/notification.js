const {
    notifyTaggedPersons
} = require("../usecases/notifications");
const {
    createNotionTask
} = require("../usecases/notion");


const notificationsHook = async (req, res, next) => {
    const url = req.url || req.originalUrl;
    const event = (url.includes('v1/contact_enquiry') || url.includes('v1/said_verification')) ?
        "QUICK_VERIFICATION" :
        (url.includes('v1/comprehensive_verification') ?
            'COMP_VERIFICATION' : 'UNKNOWN');

    if (url && !event.includes('UNKNOWN')) {
        const task = await createNotionTask("New Task Created in Notion", `${event}: A new task has been created in Notion. ${url}`, taggedEmails);

        if (task) {
            await notifyTaggedPersons(task?.url || url, { event: task, request: req.body });
        }
    }
    next()
}


module.exports = {
    notificationsHook
}