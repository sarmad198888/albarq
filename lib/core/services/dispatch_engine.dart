import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:albarq/core/services/driver_service.dart';
import 'dart:async';


class DispatchEngine {

  DispatchEngine._();

  static final DispatchEngine instance = DispatchEngine._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Timer? _engineTimer;
  bool _isDispatching = false;

void start() {
  print("========== DISPATCH ENGINE STARTED ==========");

  _engineTimer?.cancel();

  _engineTimer = Timer.periodic(
    const Duration(seconds: 3),
    (timer) async {
      print("ENGINE TICK");

await dispatchPendingOrders();
    },
  );
}
void stop() {
  _engineTimer?.cancel();
  
  

  print("========== MY TIMER START ==========");

}
Future<void> _startResponseTimer({
  required String driverId,
  required String orderId,
}) async {
  try {
    print("START RESPONSE TIMER");

    await Future.delayed(const Duration(seconds: 50));

    print("TIMEOUT FINISHED");

    await _checkDriverResponse(
      driverId: driverId,
      orderId: orderId,
    );
  } catch (e, s) {
    print("TIMER ERROR = $e");
    print(s);
  }
}


  Future<void> dispatchPendingOrders() async {
    if (_isDispatching) {
  print("DISPATCH ENGINE IS BUSY");
  return;
}

_isDispatching = true;

try {

  print("========== AUTO DISPATCH ==========");

  final pendingOrders = await _firestore
      .collection('orders')
      .where('status', isEqualTo: 'pending')
      .orderBy('createdAt')
      .get();

  print("Pending Orders = ${pendingOrders.docs.length}");

  final driverService = DriverService();


if (pendingOrders.docs.isEmpty) {
  print("NO PENDING ORDERS");
  return;
}

for (final order in pendingOrders.docs) {

  print("ORDER ID = ${order.id}");

  print("ORDER DOC = ${order.data()}");

  final rejectedDrivers =
      List<String>.from(order.data()['rejectedDrivers'] ?? []);
      print("REJECTED DRIVERS = $rejectedDrivers");

  final driver = await driverService.getNextDriver(
    excludedDrivers: rejectedDrivers,
  );

  if (driver == null) {
    print("NO AVAILABLE DRIVER");
    break;
  }

  await driverService.assignOrder(
    driverId: driver.id,
    driverName: driver.name,
    orderId: order.id,
  );
  _startResponseTimer(
  driverId: driver.id,
  orderId: order.id,
);

  await driverService.moveDriverToEnd(driver.id);

  print("ORDER ASSIGNED");
  print("Order ID : ${order.id}");
  print("Driver : ${driver.name}");
}
} finally {
  _isDispatching = false;
}

} // <-- هذا القوس الجديد يغلق dispatchPendingOrders()

Future<void> _checkDriverResponse({
  required String driverId,
  required String orderId,
}) async {

  final orderDoc = await _firestore
    .collection('orders')
    .doc(orderId)
    .get();

if (!orderDoc.exists) {
  print("ORDER NOT FOUND");
  return;
}

final data = orderDoc.data()!;

final status = data['status'];

print("========== ORDER STATUS ==========");
print("Order : $orderId");
print("Status : $status");

if (status == "assigned") {
  try {
    print("RETURNING ORDER TO QUEUE");

   await _firestore.collection('orders').doc(orderId).update({
  'status': 'pending',
  'driverId': null,
  'driverName': null,
  'rejectedDrivers': FieldValue.arrayUnion([
    driverId,
  ]),
});

    await _firestore.collection('drivers').doc(driverId).update({
      'status': 'online',
      'currentOrderId': '',
      'currentOrders': 0,
    });

    final driverDoc = await _firestore
        .collection('drivers')
        .doc(driverId)
        .get();

    print("AFTER UPDATE:");
    print(driverDoc.data());

    print("ORDER RETURNED TO QUEUE");
  } catch (e, s) {
    print("CHECK RESPONSE ERROR:");
    print(e);
    print(s);
  }
}

}
}
