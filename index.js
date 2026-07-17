const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Triggers a Push Notification to Rider whenever a Driver places a counter-offer
exports.onCounterOfferReceived = functions.firestore
  .document('trips/{tripId}')
  .onUpdate(async (change, context) => {
    const prevData = change.before.data();
    const newData = change.after.data();

    const prevOffers = Object.keys(prevData.counterOffers || {}).length;
    const newOffers = Object.keys(newData.counterOffers || {}).length;

    if (newOffers > prevOffers) {
      // Find the newly added counter offer driver uid
      const currentDrivers = Object.keys(newData.counterOffers);
      const newDriverId = currentDrivers.find(id => !prevData.counterOffers[id]);

      if (newDriverId) {
        const targetRiderId = newData.riderId;
        const proposedFare = newData.counterOffers[newDriverId];

        // Fetch rider push token
        const riderSnap = await admin.firestore().collection('users').doc(targetRiderId).get();
        const fcmToken = riderSnap.data()?.fcmToken;

        if (fcmToken) {
          const payload = {
            notification: {
              title: "New Fare Proposal! - Oran Ride",
              body: `A driver proposed ${proposedFare} DZD for your ride request!`,
              clickAction: "FLUTTER_NOTIFICATION_CLICK"
            }
          };
          await admin.messaging().sendToDevice(fcmToken, payload);
          console.log(`Notification sent to rider: ${targetRiderId}`);
        }
      }
    }
  });
