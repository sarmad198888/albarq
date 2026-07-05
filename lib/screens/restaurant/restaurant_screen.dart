import 'package:flutter/material.dart';
import 'add_order_screen.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المطعم"),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 250,
          height: 55,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text(
              "إضافة طلب جديد",
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddOrderScreen(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}