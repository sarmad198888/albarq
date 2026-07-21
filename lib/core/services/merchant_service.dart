import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_service.dart';

class MerchantService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final AuthService _authService =
      AuthService();

  Future<Map<String, dynamic>?> getMerchant() async {
    final user =
    await _authService.getCurrentUser();

print("USER ID = ${user?.id}");

final result = await _firestore
    .collection("merchants")
    .where("userId", isEqualTo: user?.id)
    .limit(1)
    .get();

print("FOUND = ${result.docs.length}");

if (result.docs.isEmpty) {
  return null;
}

print(result.docs.first.data());

return result.docs.first.data();
  }
}