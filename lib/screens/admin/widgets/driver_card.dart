import 'package:flutter/material.dart';

class DriverCard extends StatelessWidget {
  final String name;
  final String phone;
  final bool active;
  final int currentOrders;
  final VoidCallback? onTap;

  const DriverCard({
    super.key,
    required this.name,
    required this.phone,
    required this.active,
    required this.currentOrders,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              active ? Colors.green : Colors.grey,
          child: const Icon(
            Icons.delivery_dining,
            color: Colors.white,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(phone),
            const SizedBox(height: 4),
            Text(
              "الطلبات الحالية: $currentOrders",
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }
}