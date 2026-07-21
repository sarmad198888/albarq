import 'package:flutter/material.dart';

class MerchantScreen extends StatelessWidget {
  const MerchantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لوحة الشريك"),
      ),
      body: const Center(
        child: Text(
          "مرحباً بك في لوحة الشريك",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}