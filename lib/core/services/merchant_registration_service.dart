import 'package:cloud_firestore/cloud_firestore.dart';

class MerchantRegistrationService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> registerMerchant({
    required String businessName,
    required String ownerName,
    required String phone,
    required String password,
    required String category,
    required String address,
    required String openingTime,
    required String closingTime,
  }) async {

    // التحقق من عدم تكرار رقم الهاتف
    final exist = await _firestore
        .collection("users")
        .where("username", isEqualTo: phone)
        .limit(1)
        .get();

    if (exist.docs.isNotEmpty) {
      throw Exception("رقم الهاتف مستخدم مسبقاً");
    }

    // إنشاء المستخدم
    final userRef =
        _firestore.collection("users").doc();

    await userRef.set({
      "username": phone,
      "password": password,
      "role": "merchant",
      "active": true,
      "approved": false,
      "name": ownerName,
      "phone": phone,
    });

    // إنشاء بيانات الشريك
    final merchantRef =
    _firestore.collection("merchants").doc(userRef.id);

    await merchantRef.set({
      "businessName": businessName,
      "ownerName": ownerName,
      "phone": phone,
      "username": phone,
      "userId": userRef.id,
      "category": category,
      "address": address,
      "openingTime": openingTime,
      "closingTime": closingTime,
      "isActive": true,
      "createdAt":
          FieldValue.serverTimestamp(),
    });
  }
}