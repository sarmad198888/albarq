import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/driver_model.dart';

class DriverService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// جميع المندوبين المتاحين
  Stream<List<DriverModel>> getDrivers() {
    return _firestore
        .collection('drivers')
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => DriverModel.fromFirestore(doc))
          .toList();
    });
  }

  /// الحصول على Document ID الخاص بالمندوب
  Future<String?> getDriverDocumentId(String userId) async {
    print("SESSION USER ID = $userId");

    final result = await _firestore
        .collection('drivers')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    print("FOUND = ${result.docs.length}");

    if (result.docs.isNotEmpty) {
      print("DRIVER DOC ID = ${result.docs.first.id}");
      print("DATA = ${result.docs.first.data()}");
      return result.docs.first.id;
    }

    return null;
  }

  /// حفظ FCM Token للمندوب
  Future<void> saveFcmToken({
    required String driverId,
    required String token,
  }) async {
    await _firestore
        .collection('drivers')
        .doc(driverId)
        .update({
      'fcmToken': token,
    });
  }

  /// إسناد الطلب إلى مندوب
  Future<void> assignOrder({
    required String driverId,
    required String orderId,
    required String driverName,
  }) async {
    final batch = _firestore.batch();

    final orderRef =
        _firestore.collection('orders').doc(orderId);

    final driverRef =
        _firestore.collection('drivers').doc(driverId);

    batch.update(orderRef, {
      'driverId': driverId,
      'driverName': driverName,
      'status': 'assigned',
    });

    batch.update(driverRef, {
      'currentOrderId': orderId,
    });

    await batch.commit();
  }

  Future<void> finishOrder({
  required String driverId,
  required String orderId,
}) async {
  final batch = _firestore.batch();

  // إنهاء الطلب
  batch.update(
    _firestore.collection('orders').doc(orderId),
    {
      'status': 'completed',
    },
  );

  // تحرير المندوب
  batch.update(
    _firestore.collection('drivers').doc(driverId),
    {
      'currentOrderId': '',
    },
  );

  await batch.commit();

  // إعادة المندوب إلى نهاية الطابور
  await moveDriverToEnd(driverId);
}
  /// إضافة المندوب إلى طابور الانتظار
  Future<void> joinQueue(String driverId) async {
  final queueRef =
      _firestore.collection('system').doc('driver_queue');

  final snapshot = await queueRef.get();

  List<dynamic> drivers = snapshot['drivers'] ?? [];

  if (!drivers.contains(driverId)) {
    drivers.add(driverId);

    await queueRef.update({
      'drivers': drivers,
    });
  }
}

Future<DriverModel?> getNextDriver() async {

  final queueDoc = await _firestore
      .collection('system')
      .doc('driver_queue')
      .get();

  if (!queueDoc.exists) return null;

  final List drivers =
      List.from(queueDoc['drivers'] ?? []);

  if (drivers.isEmpty) return null;

  for (final driverId in drivers) {

    final driverDoc = await _firestore
        .collection('drivers')
        .doc(driverId)
        .get();

    if (!driverDoc.exists) {
      continue;
    }

    final driver = DriverModel.fromFirestore(driverDoc);

    final currentOrder =
        driver.currentOrderId.trim();

    if (driver.active &&
        currentOrder.isEmpty) {
      return driver;
    }
  }

  return null;
}

Future<void> moveDriverToEnd(String driverId) async {
 
  final ref = _firestore
      .collection('system')
      .doc('driver_queue');

  final doc = await ref.get();

  List drivers = List.from(doc['drivers'] ?? []);

  drivers.remove(driverId);

  drivers.add(driverId);

  await ref.update({
    'drivers': drivers,
  });
}
}