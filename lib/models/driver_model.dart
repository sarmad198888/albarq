import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  final String id;

  final String userId;

  final String name;
  final String phone;

  final String vehicleType;
  final String vehicleNumber;

  final bool active;

  final String currentOrderId;

  /// FCM Token للإشعارات
  final String fcmToken;

  final Timestamp? createdAt;

  const DriverModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.active,
    required this.currentOrderId,
    required this.fcmToken,
    required this.createdAt,
  });

  factory DriverModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DriverModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      vehicleType: data['vehicleType'] ?? '',
      vehicleNumber: data['vehicleNumber'] ?? '',
      active: data['active'] ?? true,
      currentOrderId: data['currentOrderId'] ?? '',
      fcmToken: data['fcmToken'] ?? '',
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'phone': phone,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'active': active,
      'currentOrderId': currentOrderId,
      'fcmToken': fcmToken,
      'createdAt': createdAt,
    };
  }
}