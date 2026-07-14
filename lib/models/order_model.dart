import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;

  final String restaurantId;
  final String restaurantName;

  final String customerName;
  final String customerPhone;
  final String customerAddress;

  final int totalPrice;
  final int deliveryPrice;

  final String notes;

  final String status;

  final String driverId;
  final String driverName;

  final Timestamp? createdAt;

  const OrderModel({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.totalPrice,
    required this.deliveryPrice,
    required this.notes,
    required this.status,
    required this.driverId,
    required this.driverName,
    required this.createdAt,
  });

  factory OrderModel.fromFirestore(
    DocumentSnapshot doc,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    return OrderModel(
      id: doc.id,

      restaurantId: data['restaurantId'] ?? '',

      restaurantName: data['restaurantName'] ?? '',

      customerName: data['customerName'] ?? '',

      customerPhone: data['customerPhone'] ?? '',

      customerAddress: data['customerAddress'] ?? '',

      totalPrice: (data['totalPrice'] ?? 0).toInt(),

      deliveryPrice: (data['deliveryPrice'] ?? 0).toInt(),

      notes: data['notes'] ?? '',

      status: data['status'] ?? 'pending',

      driverId: data['driverId'] ?? '',

      driverName: data['driverName'] ?? '',

      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'totalPrice': totalPrice,
      'deliveryPrice': deliveryPrice,
      'notes': notes,
      'status': status,
      'driverId': driverId,
      'driverName': driverName,
      'createdAt': createdAt,
    };
  }
}