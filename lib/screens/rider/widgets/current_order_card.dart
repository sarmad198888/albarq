import 'package:flutter/material.dart';

class CurrentOrderCard extends StatelessWidget {
  const CurrentOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "طلب جديد",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Row(
              children: [
                Icon(Icons.store, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  "برجر هاوس",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Row(
              children: [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  "الزبون: أحمد",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Row(
              children: [
                Icon(Icons.payments, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  "المبلغ: 18000 د.ع",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.orange),
                SizedBox(width: 10),
                Text(
                  "المسافة: 2.3 كم",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {},
                    child: const Text(
                      "قبول",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {},
                    child: const Text(
                      "رفض",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}