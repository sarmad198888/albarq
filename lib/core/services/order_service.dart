import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createOrder({
    required String restaurantId,
    required String restaurantName,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    required double totalPrice,
    required double deliveryPrice,
    required String notes,
  }) async {
    await _firestore.collection('orders').add({
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'totalPrice': totalPrice,
      'deliveryPrice': deliveryPrice,
      'notes': notes,
      'status': 'pending',
      'driverId': '',
      'driverName': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}