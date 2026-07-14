const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { logger } = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendDriverNotification = onDocumentUpdated(
  "orders/{orderId}",
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();

    // إذا لم يتغير المندوب لا تفعل شيئاً
    if (before.driverId === after.driverId) {
      return;
    }

    // إذا لا يوجد مندوب
    if (!after.driverId) {
      return;
    }

    // جلب بيانات المندوب
    const driverDoc = await admin
        .firestore()
        .collection("drivers")
        .doc(after.driverId)
        .get();

    if (!driverDoc.exists) {
      logger.log("Driver not found");
      return;
    }

    const driver = driverDoc.data();

    if (!driver.fcmToken) {
      logger.log("Driver has no FCM Token");
      return;
    }

    const message = {
      token: driver.fcmToken,

      notification: {
        title: "طلب جديد 🚚",
        body: `${after.restaurantName} - ${after.customerName}`,
      },

      data: {
        orderId: event.params.orderId,
        type: "new_order",
      },
    };

    await admin.messaging().send(message);

    logger.log("Notification Sent");
  }
);