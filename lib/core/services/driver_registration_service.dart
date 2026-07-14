import 'package:cloud_firestore/cloud_firestore.dart';

class DriverRegistrationService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> registerDriver({
    required String name,
    required String phone,
    required String username,
    required String password,
    required String vehicleType,
    required String vehicleNumber,
  }) async {

    // التحقق من عدم تكرار اسم المستخدم
    final exist = await _firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .limit(1)
        .get();

    if (exist.docs.isNotEmpty) {
      throw Exception("اسم المستخدم مستخدم مسبقاً");
    }

    // إنشاء مستخدم جديد
    final userRef =
        _firestore.collection("users").doc();

    await userRef.set({
  "username": username,
  "password": password,
  "role": "driver",
  "active": true,
  "approved": false,
  "name": name,
  "phone": phone,
});

    // إنشاء بيانات المندوب
    final driverRef =
        _firestore.collection("drivers").doc();

    await driverRef.set({
      "name": name,
      "phone": phone,
      "userId": userRef.id,
      "vehicleType": vehicleType,
      "vehicleNumber": vehicleNumber,
      "currentOrderId": "",
      "active": true,
      "latitude": 0,
      "longitude": 0,
      "fcmToken": "",
      "lastLocationUpdate":
          FieldValue.serverTimestamp(),
    });
  }
}