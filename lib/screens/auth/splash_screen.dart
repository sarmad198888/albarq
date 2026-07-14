import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/session_service.dart';
import '../admin/admin_screen.dart';
import '../restaurant/restaurant_screen.dart';
import 'login_screen.dart';
import '../driver/driver_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SessionService _session = SessionService();

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await Future.delayed(const Duration(seconds: 2));

    final loggedIn = await _session.isLoggedIn();

    if (!mounted) return;

    if (!loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
      return;
    }

    final role = await _session.getRole();

    if (!mounted) return;

    switch (role) {
      case "super_admin":
      case "admin":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AdminScreen(),
          ),
        );
        break;

      case "restaurant":
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantScreen(),
          ),
        );
        break;

      // مؤقتاً حتى نبني شاشة المندوب
      case "driver":
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const DriverScreen(),
    ),
  );
  break;

      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flash_on,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              "البرق",
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}