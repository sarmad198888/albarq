import 'package:flutter/material.dart';
import 'widgets/status_card.dart';
import 'widgets/current_order_card.dart';

class RiderScreen extends StatelessWidget {
  const RiderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "البرق",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(Icons.notifications_none, color: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(Icons.person_outline, color: Colors.black),
          ),
        ],
      ),

      body: SingleChildScrollView(
  padding: const EdgeInsets.all(20),
  child: Column(
    children: const [

      StatusCard(),

      SizedBox(height: 25),

      const CurrentOrderCard(),

    ],
  ),
)
    );
  }
}