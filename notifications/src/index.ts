import {setGlobalOptions} from "firebase-functions";
import {onDocumentUpdated} from "firebase-functions/v2/firestore";
import {getMessaging} from "firebase-admin/messaging";
import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";

initializeApp();

setGlobalOptions({
  maxInstances: 10,
});

export const sendDriverNotification = onDocumentUpdated(
  "orders/{orderId}",
  async (event) => {
    const before = event.data?.before.data();
    const after = event.data?.after.data();

    if (!before || !after) return;

    if (
      before.driverId === after.driverId ||
        !after.driverId ||
        after.status !== "assigned"
    ) {
      return;
    }

    const db = getFirestore();

    const driverDoc = await db
      .collection("drivers")
      .doc(after.driverId)
      .get();

    if (!driverDoc.exists) {
      console.log("Driver not found");
      return;
    }

    const driver = driverDoc.data();

    if (!driver?.fcmToken) {
      console.log("Driver has no FCM Token");
      return;
    }

    await getMessaging().send({
      token: driver.fcmToken,
      notification: {
        title: "🚚 طلب جديد",
        body: `تم تعيين طلب جديد لك من ${after.restaurantName}`,
      },
      data: {
        orderId: event.params.orderId,
      },
    });

    console.log("Notification sent successfully");
  },
);
