import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/order_model.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// الطلبات الجديدة
  Stream<List<OrderModel>> getPendingOrders() {
    return _firestore
        .collection('orders')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((e) => OrderModel.fromFirestore(e))
              .toList(),
        );
  }
  /// عدد الطلبات الحالية لمندوب معين
Stream<int> getDriverCurrentOrders(String driverId) {
  return _firestore
      .collection('orders')
      .where('driverId', isEqualTo: driverId)
      .where('status', isEqualTo: 'assigned')
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
}
  /// بيانات مندوب واحد
Stream<DocumentSnapshot<Map<String, dynamic>>> getDriver(
  String driverId,
) {
  return _firestore
      .collection('drivers')
      .doc(driverId)
      .snapshots();
}
  /// جميع المندوبين
 Stream<List<Map<String, dynamic>>> getDrivers() {
  return _firestore
      .collection('drivers')
      .orderBy('name')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();

          return {
            'id': doc.id,
            'name': data['name'] ?? '',
            'phone': data['phone'] ?? '',
            'active': data['active'] ?? false,
            'currentOrders': data['currentOrders'] ?? 0,
          };
        }).toList();
      });
}

  /// الطلبات قيد التوصيل
  Stream<List<OrderModel>> getAssignedOrders() {
    return _firestore
        .collection('orders')
        .where('status', isEqualTo: 'assigned')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((e) => OrderModel.fromFirestore(e))
              .toList(),
        );
  }

  /// الطلبات المكتملة
  Stream<List<OrderModel>> getCompletedOrders() {
    return _firestore
        .collection('orders')
        .where('status', isEqualTo: 'completed')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((e) => OrderModel.fromFirestore(e))
              .toList(),
        );
  }

  /// جميع المندوبين النشطين
  Stream<int> getActiveDriversCount() {
    return _firestore
        .collection('drivers')
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// المندوبون المتاحون
  Stream<int> getAvailableDriversCount() {
    return _firestore
        .collection('drivers')
        .where('active', isEqualTo: true)
        .where('currentOrderId', isEqualTo: '')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// المندوبون المشغولون
  Stream<int> getBusyDriversCount() {
    return _firestore
        .collection('drivers')
        .where('active', isEqualTo: true)
        .where('currentOrderId', isNotEqualTo: '')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}