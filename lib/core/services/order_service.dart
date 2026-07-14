import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/order_model.dart';
import 'driver_service.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// إنشاء طلب جديد
  Future<void> createOrder({
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required int totalPrice,
  required int deliveryPrice,
  String notes = "",
  String restaurantId = "restaurant_1",
  String restaurantName = "برجر هاوس",
}) async {

  final orderRef =
      _firestore.collection('orders').doc();

  await orderRef.set({
    'customerName': customerName,
    'customerPhone': customerPhone,
    'customerAddress': customerAddress,
    'totalPrice': totalPrice,
    'deliveryPrice': deliveryPrice,
    'notes': notes,
    'restaurantId': restaurantId,
    'restaurantName': restaurantName,
    'driverId': '',
    'driverName': '',
    'status': 'pending',
    'createdAt': FieldValue.serverTimestamp(),
  });

  // التعيين التلقائي
  final driverService = DriverService();

  final driver = await driverService.getNextDriver();

  if (driver != null) {

    await driverService.assignOrder(
      driverId: driver.id,
      driverName: driver.name,
      orderId: orderRef.id,
    );

    await driverService.moveDriverToEnd(driver.id);

  }
}

  /// جميع الطلبات
Stream<List<OrderModel>> getOrders() {
  return _firestore
      .collection('orders')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList();
      });
}

  /// الطلبات الجديدة فقط
  Stream<List<OrderModel>> getPendingOrders() {
    return _firestore
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// تغيير حالة الطلب
  Future<void> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    final orderRef =
    _firestore.collection('orders').doc();

await orderRef.set({
      'status': status,
    });
    final orderId = orderRef.id;

final driverService = DriverService();

final driver = await driverService.getNextDriver();

if (driver != null) {
  await driverService.assignOrder(
    driverId: driver.id,
    driverName: driver.name,
    orderId: orderId,
  );

  await driverService.moveDriverToEnd(driver.id);
}
  }

  /// تعيين مندوب
  Future<void> assignDriver({
    required String orderId,
    required String driverId,
    required String driverName,
  }) async {
    await _firestore.collection('orders').doc(orderId).update({
      'driverId': driverId,
      'driverName': driverName,
      'status': 'assigned',
    });
  }

  /// إنهاء الطلب
  Future<void> completeOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'completed',
    });
  }

  /// إلغاء الطلب
  Future<void> cancelOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'cancelled',
    });
  }
  /// طلبات المندوب
Stream<List<OrderModel>> getDriverOrders(String driverId) {
  return _firestore
      .collection('orders')
      .where('driverId', isEqualTo: driverId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList();
      });
}
/// قبول الطلب
Future<void> acceptOrder(String orderId) async {
  await _firestore.collection('orders').doc(orderId).update({
    'status': 'delivering',
  });
}

/// رفض الطلب
Future<void> rejectOrder(String orderId) async {
  final orderRef = _firestore.collection('orders').doc(orderId);

  final orderDoc = await orderRef.get();

  if (!orderDoc.exists) return;

  final data = orderDoc.data()!;

  final String driverId = data['driverId'] ?? '';

  final batch = _firestore.batch();

  // إعادة الطلب إلى الانتظار
  batch.update(orderRef, {
    'driverId': '',
    'driverName': '',
    'status': 'pending',
  });

  // تحرير المندوب
  if (driverId.isNotEmpty) {
    batch.update(
      _firestore.collection('drivers').doc(driverId),
      {
        'currentOrderId': '',
      },
    );
  }

  await batch.commit();

  // إعادة توزيع الطلب مباشرة

}

Future<void> assignNextPendingOrder(
 
) 
async {
  try {
    print("STEP 1");

    final pendingOrders = await _firestore
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();

    print("Pending = ${pendingOrders.docs.length}");

    if (pendingOrders.docs.isEmpty) {
      print("NO PENDING");
      return;
    }

    final driverService = DriverService();

 final driver = await driverService.getNextDriver();
    print("Driver = ${driver?.name}");

    if (driver == null) {
      print("NO DRIVER");
      return;
    }

    final order = pendingOrders.docs.first;

    print("Assigning order ${order.id}");

    await driverService.assignOrder(
      driverId: driver.id,
      driverName: driver.name,
      orderId: order.id,
    );

    print("Assigned");

    await driverService.moveDriverToEnd(driver.id);

    print("DONE");
  } catch (e, s) {
    print("=========== ERROR ===========");
    print(e);
    print(s);
    print("=============================");
  }
}
}