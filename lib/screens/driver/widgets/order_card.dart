import 'package:flutter/material.dart';

import '../../../models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  final VoidCallback onCompleted;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const OrderCard({
  super.key,
  required this.order,
  required this.onCompleted,
  this.onAccept,
  this.onReject,
});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 12),

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

            if (order.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                "📝 ${order.notes}",
                style: const TextStyle(fontSize: 15),
              ),
            ],

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

            const SizedBox(height: 15),

            if (order.status == "assigned")
  Row(
    children: [
      Expanded(
        child: ElevatedButton.icon(
          onPressed: onReject,
          icon: const Icon(Icons.close),
          label: const Text("رفض"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ),

      const SizedBox(width: 10),

      Expanded(
        child: ElevatedButton.icon(
          onPressed: onAccept,
          icon: const Icon(Icons.check),
          label: const Text("قبول"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    ],
  )
else if (order.status == "delivering")
  SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton.icon(
      onPressed: onCompleted,
      icon: const Icon(Icons.check_circle),
      label: const Text(
        "تم تسليم الطلب",
        style: TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    ),
  ),

          ],
        ),
      ),
    );
  }
}