import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';
import '../admin/admin_screen.dart';
import '../driver/driver_screen.dart';
import '../restaurant/restaurant_screen.dart';
import 'register_driver_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _loading = false;

  Future<void> _login() async {
    setState(() {
      _loading = true;
    });

    final user = await _authService.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "اسم المستخدم أو كلمة المرور غير صحيحة",
          ),
        ),
      );
      return;
    }

    Widget screen;

    switch (user.role) {
      case "super_admin":
      case "admin":
      case "manager":
        screen = AdminScreen();
        break;

      case "restaurant":
        screen = RestaurantScreen();
        break;

      case "driver":
        screen =  DriverScreen();
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("هذه الصلاحية غير مدعومة"),
          ),
        );
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.flash_on,
                  color: Colors.red,
                  size: 90,
                ),
                const SizedBox(height: 15),
                const Text(
                  "البرق",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "نظام إدارة التوصيل",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "اسم المستخدم",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "كلمة المرور",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 15),

TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterDriverScreen(),
      ),
    );
  },
  child: const Text(
    "إنشاء حساب مندوب جديد",
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
),
              ],
            ),
          ),
        ),
      ),
    );
  }
}