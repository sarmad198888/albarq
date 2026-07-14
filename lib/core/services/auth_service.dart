import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';
import 'session_service.dart';

class AuthService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final SessionService _session =
      SessionService();

  Future<UserModel?> login({
    required String username,
    required String password,
  }) async {
    final result = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.trim())
        .where('password', isEqualTo: password.trim())
        .where('active', isEqualTo: true)
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      return null;
    }
    final data = result.docs.first.data();

if (data['role'] == 'driver' &&
    (data['approved'] ?? false) == false) {
  throw Exception("بانتظار موافقة الإدارة");
}

    final user = UserModel.fromMap(
      result.docs.first.id,
      result.docs.first.data(),
    );

    await _session.saveSession(
      userId: user.id,
      role: user.role,
    );

    return user;
  }

  Future<void> logout() async {
    await _session.logout();
  }

  Future<UserModel?> getCurrentUser() async {
    final userId = await _session.getUserId();

    if (userId == null || userId.isEmpty) {
      return null;
    }

    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .get();

    if (!doc.exists) {
      return null;
    }

    return UserModel.fromMap(
      doc.id,
      doc.data()!,
    );
  }
}