import 'package:flutter/material.dart';

import '../../../models/order_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RestaurantOrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;

  const RestaurantOrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

Future<void> _callCustomer() async {
  final uri = Uri.parse("tel:${order.customerPhone}");

  await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );
}

Future<void> _callDriver() async {
  final uri = Uri.parse("tel:${order.driverPhone}");

  await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );
}
String formatDateTime(Timestamp? timestamp) {
  if (timestamp == null) return "";

  return DateFormat(
  "dd/MM/yyyy • hh:mm a",
).format(timestamp.toDate());
}
  @override
  Widget build(BuildContext context) {
    Color statusColor;

    switch (order.status) {
      case "pending":
        statusColor = Colors.orange;
        break;

      case "assigned":
        statusColor = Colors.blue;
        break;

      case "completed":
        statusColor = Colors.green;
        break;

      default:
        statusColor = Colors.grey;
    }
    String statusText;

switch (order.status) {
  case "pending":
    statusText = "طلب جديد";
    break;

  case "assigned":
    statusText = "قيد التوصيل";
    break;

  case "completed":
    statusText = "مكتمل";
    break;

  default:
    statusText = order.status;
}

final price =
    NumberFormat("#,###").format(order.totalPrice);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [

                  CircleAvatar(
  radius: 20,
  backgroundColor: const Color(0xFFF5F5F5),
  child: const Icon(
    Icons.person,
    size: 26,
    color: Colors.red,
  ),
),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      order.customerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                   child: Text(
  statusText,
  style: TextStyle(
    color: statusColor,
    fontWeight: FontWeight.bold,
  ),
),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 22,
                      color: Color.fromARGB(255, 235, 60, 51)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(order.customerAddress),
                  ),
                ],
              ),
              const SizedBox(height: 8),

Row(
  children: [
    const Icon(
      Icons.phone,
      size: 22,
      color: Colors.blue,
    ),
    const SizedBox(width: 6),
    Text(
      order.customerPhone,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
    ),
  ],
),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.payments,
                      size: 22,
                      color: Colors.green),
                  const SizedBox(width: 6),
                  Text(
                   "$price د.ع",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Text(
  "📅 إنشاء الطلب: ${formatDateTime(order.createdAt)}",
  style: const TextStyle(
    fontSize: 13,
    color: Colors.grey,
  ),
),

if (order.completedAt != null)
  Text(
    "✅ اكتمال الطلب: ${formatDateTime(order.completedAt)}",
    style: const TextStyle(
      fontSize: 13,
      color: Colors.green,
      fontWeight: FontWeight.bold,
    ),
  ),

const SizedBox(height: 12),

             if (order.driverName.isNotEmpty) ...[
  Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    Text(
      order.driverName,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ),

    const SizedBox(width: 6),

    const Icon(
      Icons.delivery_dining,
      color: Color.fromARGB(255, 201, 25, 25),
      size: 30,
    ),
  ],
),
  ),
],

Row(
  children: [
    Expanded(
      child: OutlinedButton.icon(
        onPressed: _callCustomer,
        icon: const Icon(Icons.person),
        label: const Text("اتصال بالزبون"),
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: OutlinedButton.icon(
        onPressed: _callDriver,
        icon: const Icon(Icons.delivery_dining),
        label: const Text("اتصال بالمندوب"),
      ),
      
    ),
  ],
),
            ],
          ),
        ),
      ),
    );
  }
}