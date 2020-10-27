const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
const database = admin.database();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
    response.send("Hello from Firebase!");
});

exports.detectCountChange = functions.database.ref("var/val").onUpdate((change, context) => {
        var type = 0;
        var title = "";
        var body = "";
        if (change.after.val() <= 5) type = 1;
        functions.logger.info("the count is changed");
        console.log(change.after.val());
        functions.logger.info(change.before.val());
        console.log(isNaN(change.after.val()));
        if (change.after.val() < change.before.val()) {
            functions.logger.info("the count is changed - inside the if condition");
            functions.logger.info(change.before);
            type = 2;
        }

        if (type === 0) return "nothing";

        if (type === 1) {
            title = "Inhaler status";
            body = `Inhaler used. Remaining count is : ${change.after.val()}`;
        }
        else if (type === 2) {
            title = "Inhaler status";
            body = `Inhaler level critically low. Remaining count is : ${change.after.val()}`;
        }
        const payload = {
            notification: {
                title: title,
                body: body,
                sound: "default",
            },
            data: { click_action: "FLUTTER_NOTIFICATION_CLICK" },
        };
        const options = {
            priority: "high",
            timeToLive: 60 * 60 * 24,
        };
        return admin
            .messaging()
            .sendToTopic("pushNotifications", payload, options);
    });

exports.checkIfConnected = functions.database
    .ref("chk/f")
    .onUpdate((change, context) => {
        if (change.after.val() === 0) {
            const title = "Inhaler status";
            const body = "Inhaler disconnected";
            const payload = {
                notification: {
                    title: title,
                    body: body,
                    sound: "default",
                },
                data: { click_action: "FLUTTER_NOTIFICATION_CLICK" },
            };
            const options = {
                priority: "high",
                timeToLive: 60 * 60 * 24,
            };
            return admin
                .messaging()
                .sendToTopic("pushNotifications", payload, options);
        } else if (change.after.val() === 1) {
            const title = "Inhaler status";
            const body = "Inhaler connected";
            const payload = {
                notification: {
                    title: title,
                    body: body,
                    sound: "default",
                },
                data: { click_action: "FLUTTER_NOTIFICATION_CLICK" },
            };
            const options = {
                priority: "high",
                timeToLive: 60 * 60 * 24,
            };
            return admin
                .messaging()
                .sendToTopic("pushNotifications", payload, options);
        }
    });
