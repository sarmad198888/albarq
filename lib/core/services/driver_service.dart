import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/driver_model.dart';

class DriverService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;
     Stream<int> getDriverCurrentOrders(String driverId) {
  return FirebaseFirestore.instance
      .collection('orders')
      .where('driverId', isEqualTo: driverId)
      .where('status', isEqualTo: 'delivering')
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
}
Stream<int> getDriverPendingOrders(String driverId) {
  return FirebaseFirestore.instance
      .collection('orders')
      .where('driverId', isEqualTo: driverId)
      .where('status', isEqualTo: 'assigned')
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
}
Stream<int> getDeliveringOrders(String driverId) {
  return _firestore
      .collection('orders')
      .where('driverId', isEqualTo: driverId)
      .where('status', isEqualTo: 'delivering')
      .snapshots()
      .map((e) => e.docs.length);
}

Stream<int> getPendingOrders(String driverId) {
  return _firestore
      .collection('orders')
      .where('driverId', isEqualTo: driverId)
      .where('status', isEqualTo: 'assigned')
      .snapshots()
      .map((e) => e.docs.length);
}

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

    final driverDoc =
    await _firestore.collection('drivers').doc(driverId).get();

    final driverData = driverDoc.data() ?? {};

    final driverPhone = driverData['phone'] ?? '';

    final batch = _firestore.batch();

    final orderRef =
        _firestore.collection('orders').doc(orderId);

    final driverRef =
        _firestore.collection('drivers').doc(driverId);

   batch.update(orderRef, {
  'driverId': driverId,
  'driverName': driverName,
  'driverPhone': driverPhone,
  'status': 'assigned',
});

    batch.update(driverRef, {
  'currentOrderId': orderId,
  'assignedToday': FieldValue.increment(1),
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
    'completedAt': FieldValue.serverTimestamp(),
  },
);

  // تحرير المندوب
  batch.update(
  _firestore.collection('drivers').doc(driverId),
  {
    'currentOrderId': '',
    'completedToday': FieldValue.increment(1),
  },
);

  try {
  print("COMMIT START");
  await batch.commit();
  print("COMMIT DONE");
} catch (e) {
  print("COMMIT ERROR: $e");
}

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

Future<DriverModel?> getNextDriver({
  List<String> excludedDrivers = const [],
}) async {

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

    print("CURRENT DRIVER ID = ${driver.id}");

    if (excludedDrivers.contains(driver.id)) {
  print("SKIPPING DRIVER: ${driver.name}");
  continue;
}

print("========== DRIVER ==========");
print("Name: ${driver.name}");
print("Status: ${driver.status}");
print("CurrentOrder: '${driver.currentOrderId}'");
print("LastSeen: ${driver.lastSeen}");

    final currentOrder =
        driver.currentOrderId.trim();

        final lastSeen = driver.lastSeen;

if (lastSeen == null) {
  continue;
}

final seconds =
    DateTime.now()
        .difference(lastSeen.toDate())
        .inSeconds;

print("Seconds: $seconds");
print("CHECKING ${driver.name}");
print("status = ${driver.status}");
print("currentOrder = '$currentOrder'");
print("seconds = $seconds");

 if (driver.status == "online" &&
    currentOrder.isEmpty &&
    seconds <= 60) {
      print("SELECTED DRIVER");
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
/// تحديث حالة اتصال المندوب
Future<void> updateDriverStatus({
  required String driverId,
  required String status,
}) async {
  await _firestore
      .collection('drivers')
      .doc(driverId)
      .update({
    'status': status,
    'lastSeen': FieldValue.serverTimestamp(),
  });
}
}