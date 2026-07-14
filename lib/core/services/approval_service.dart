import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';

class ApprovalService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// جميع المندوبين بانتظار الموافقة
  Stream<List<UserModel>> pendingDrivers() {
    return _firestore
        .collection("users")
        .where("role", isEqualTo: "driver")
        .where("approved", isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (e) => UserModel.fromMap(
              e.id,
              e.data(),
            ),
          )
          .toList();
    });
  }

  /// الموافقة على المندوب
  Future<void> approveDriver(
    String userId,
  ) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .update({
      "approved": true,
    });
  }

  /// رفض المندوب
  Future<void> rejectDriver(
    String userId,
  ) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .delete();
  }
}