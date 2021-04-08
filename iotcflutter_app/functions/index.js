const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
const database = admin.database();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

var ref = functions.database.ref("user");
var usersRef = database.ref("user");
const tokens = [];

usersRef.on("child_changed", (snapshot) => {
    console.log("user was changed !!");
    var i = 0;
    snapshot.forEach(function(childSnapshot) {
        // key will be "ada" the first time and "alan" the second time
        var key = childSnapshot.key;
        var childData = childSnapshot.val();
        console.log("snaphot :" + i + " " + key + " " + childData);
        if (key === "token") tokens.push(childData);
        if (key === "var") {
            console.log("value :" + childData["val"]);
            if (childData["val"] > 10) tokens.pop();
        }

        // childData will be the actual contents of the child

        // console.log("snaphot2 :" + childData);
        i++;
    });
    i = 0;
    tokens.forEach((data) => {
        console.log("uid : " + i++ + data);
    });
    var title = "this is title";
    var body = "this is body";
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
    console.log("1 2 3");
    let uniqueChars = [...new Set(tokens)];
    console.log("length id : " + tokens.length);
    return admin.messaging().sendToDevice(uniqueChars, payload, options);
    // admin.messaging().sendToTopic("pushNotifications", payload, options);
});
// functions
//     .database
//     .ref()
//     .on("value", function(snapshot) {
//         print(snapshot);
//     });
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//     response.send("Hello from Firebase!");
// });

// exports.detectCountChange = functions.database
//     .ref("var/val")
//     .onUpdate((change, context) => {
//         var type = 0;
//         var title = "";
//         var body = "";
//         if (change.after.val() < change.before.val()) {
//             type = 2;
//         }
//         if (change.after.val() <= 5) type = 1;

//         if (type === 0) return "nothing";

//         if (type === 2) {
//             title = "Inhaler status";
//             body = `Inhaler used. Remaining count is : ${change.after.val()}`;
//         } else if (type === 1) {
//             title = "Inhaler status";
//             body = `Inhaler level critically low. Remaining count is : ${change.after.val()}`;
//         }
//         const payload = {
//             notification: {
//                 title: title,
//                 body: body,
//                 sound: "default",
//             },
//             data: { click_action: "FLUTTER_NOTIFICATION_CLICK" },
//         };
//         const options = {
//             priority: "high",
//             timeToLive: 60 * 60 * 24,
//         };
//         return admin.messaging().sendToTopic("pushNotifications", payload, options);
//     });

// exports.checkIfConnected = functions.database
//     .ref("chk/f")
//     .onUpdate((change, context) => {
//         if (change.after.val() === 0) {
//             const title = "Inhaler status";
//             const body = "Inhaler disconnected";
//             const payload = {
//                 notification: {
//                     title: title,
//                     body: body,
//                     sound: "default",
//                 },
//                 data: { click_action: "FLUTTER_NOTIFICATION_CLICK" },
//             };
//             const options = {
//                 priority: "high",
//                 timeToLive: 60 * 60 * 24,
//             };
//             return admin
//                 .messaging()
//                 .sendToTopic("pushNotifications", payload, options);
//         } else if (change.after.val() === 1) {
//             const title = "Inhaler status";
//             const body = "Inhaler connected";
//             const payload = {
//                 notification: {
//                     title: title,
//                     body: body,
//                     sound: "default",
//                 },
//                 data: { click_action: "FLUTTER_NOTIFICATION_CLICK" },
//             };
//             const options = {
//                 priority: "high",
//                 timeToLive: 60 * 60 * 24,
//             };
//             return admin
//                 .messaging()
//                 .sendToTopic("pushNotifications", payload, options);
//         }
//     });

// exports.batteryPercentage = functions.database
//     .ref("bat/perc")
//     .onUpdate((change, context) => {
//         if (change.after.val() === 20) {
//             const title = "Battery status";
//             const body = `Battery critically low. Please charge. Battery percentage:${change.after.val()}`;
//             const payload = {
//                 notification: {
//                     title: title,
//                     body: body,
//                     sound: "default",
//                 },
//                 data: { click_action: "FLUTTER_NOTIFICATION_CLICK" },
//             };
//             const options = {
//                 priority: "high",
//                 timeToLive: 60 * 60 * 24,
//             };
//             return admin
//                 .messaging()
//                 .sendToTopic("pushNotifications", payload, options);
//         }
//     });