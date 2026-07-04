import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المطعم"),
      ),
      body: const Center(
        child: Text(
          "واجهة المطعم",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}