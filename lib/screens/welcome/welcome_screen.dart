import 'package:flutter/material.dart';

import '../customer/customer_screen.dart';
import '../restaurant/restaurant_screen.dart';
import '../rider/rider_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 170,
                ),

                const SizedBox(height: 30),

                const Text(
                  "مرحباً بك في البرق",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "اختر طريقة استخدام التطبيق",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 50),

                // زر العميل
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerScreen(),
                        ),
                      );
                    },
                    child: const Text("🛍️ عميل"),
                  ),
                ),

                const SizedBox(height: 15),

                // زر المطعم
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RestaurantScreen(),
                        ),
                      );
                    },
                    child: const Text("🏪 مطعم / متجر"),
                  ),
                ),

                const SizedBox(height: 15),

                // زر المندوب
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RiderScreen(),
                        ),
                      );
                    },
                    child: const Text("🛵 مندوب"),
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