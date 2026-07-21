import 'package:flutter/material.dart';

import '../../../models/order_model.dart';
import '../pages/order_details_screen.dart';
import '../select_driver_screen.dart';
import '../../../core/services/driver_service.dart';
import '../../../core/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
final DriverService driverService = DriverService();
   OrderCard({
    super.key,
    required this.order,
  });

  Color _statusColor() {
    switch (order.status) {
      case "pending":
        return Colors.orange;

      case "assigned":
        return Colors.blue;

      case "completed":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  String _statusText() {
    switch (order.status) {
      case "pending":
        return "جديد";

      case "assigned":
        return "قيد التوصيل";

      case "completed":
        return "مكتمل";

      case "cancelled":
        return "ملغي";

      default:
        return order.status;
    }
  }
String formatDateTime(Timestamp? timestamp) {
  if (timestamp == null) return "";

  return DateFormat(
    "dd/MM/yyyy   hh:mm a",
  ).format(timestamp.toDate());
}
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// اسم المطعم
            Row(
              children: [

                const Icon(
                  Icons.restaurant,
                  color: Colors.red,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    order.restaurantName,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),

            const Divider(height: 25),

            Text(
              "👤 ${order.customerName}",
              style: const TextStyle(fontSize: 16),
            ),

            Text(
              "📞 ${order.customerPhone}",
              style: const TextStyle(fontSize: 16),
            ),

            Text(
              "📍 ${order.customerAddress}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                Expanded(
                  child: Text(
                    "💰 ${order.totalPrice} د.ع",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Text(
                  "🚚 ${order.deliveryPrice} د.ع",
                ),

              ],
            ),

            if (order.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text("📝 ${order.notes}"),
            ],

            const SizedBox(height: 15),

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
    ),
  ),

const SizedBox(height: 12),


            Row(
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor().withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusText(),
                    style: TextStyle(
                      color: _statusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Spacer(),

                if (order.driverName.isNotEmpty)
                  Row(
                    children: [

                      const Icon(
                        Icons.delivery_dining,
                        color: Colors.green,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        order.driverName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),

              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => SelectDriverScreen(
        orderId: order.id,
      ),
    ),
  );
},
                
                    icon: const Icon(Icons.info_outline),
                    label: const Text("التفاصيل"),
                  ),
                ),

                if (order.status == "pending") ...[
                  const SizedBox(width: 10),

                

                
Expanded(
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SelectDriverScreen(
            orderId: order.id,
          ),
        ),
      );
    },
    icon: const Icon(Icons.delivery_dining),
    label: const Text("اختيار مندوب"),
  ),
),

                ],

              ],
            ),

          ],
        ),
      ),
    );
  }
}