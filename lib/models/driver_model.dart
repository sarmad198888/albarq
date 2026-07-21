import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  final String id;

  final String userId;

  final String name;
  final String phone;

  final String vehicleType;
  final String vehicleNumber;

  final bool active;

  final String status;

  final Timestamp? lastSeen;

  final int assignedToday;

  final int completedToday;

  final int rejectedToday;

  final String currentOrderId;

  final int currentOrders;

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
    required this.status,
    required this.lastSeen,
    required this.currentOrderId,
    required this.fcmToken,
    required this.createdAt,
    required this.assignedToday,
    required this.completedToday,
    required this.rejectedToday,
    required this.currentOrders,
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
      status: data['status'] ?? 'offline',
      lastSeen: data['lastSeen'],
      currentOrderId: data['currentOrderId'] ?? '',
      currentOrders: data['currentOrders'] ?? 0,
      fcmToken: data['fcmToken'] ?? '',
      createdAt: data['createdAt'],
      assignedToday: data['assignedToday'] ?? 0,

      completedToday: data['completedToday'] ?? 0,

      rejectedToday: data['rejectedToday'] ?? 0,
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
      'status': status,
      'lastSeen': lastSeen,
      'currentOrderId': currentOrderId,
      'currentOrders': currentOrders,
      'fcmToken': fcmToken,
      'createdAt': createdAt,
      'assignedToday': assignedToday,

      'completedToday': completedToday,

       'rejectedToday': rejectedToday,
    };
  }
}