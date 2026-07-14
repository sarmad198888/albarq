import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _userIdKey = "userId";
  static const String _roleKey = "role";

  /// حفظ بيانات تسجيل الدخول
  Future<void> saveSession({
    required String userId,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_roleKey, role);
  }

  /// قراءة User ID
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// قراءة الصلاحية
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  /// هل يوجد مستخدم مسجل؟
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.containsKey(_userIdKey);
  }

  /// حذف الجلسة (تسجيل خروج)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userIdKey);
    await prefs.remove(_roleKey);
  }
}