import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "لوحة الإدارة",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [

          OrderCard(),

          SizedBox(height: 20),

          OrderCard(),

          SizedBox(height: 20),

          OrderCard(),

        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

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

            Row(
              children: const [

                Icon(Icons.store, color: Colors.red),

                SizedBox(width: 10),

                Text(
                  "برجر هاوس",
                  style: TextStyle(fontSize: 18),
                ),

              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: const [

                Icon(Icons.person, color: Colors.blue),

                SizedBox(width: 10),

                Text(
                  "أحمد علي",
                  style: TextStyle(fontSize: 18),
                ),

              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: const [

                Icon(Icons.phone,color: Colors.green),

                SizedBox(width:10),

                Text(
                  "07701234567",
                  style: TextStyle(fontSize:18),
                ),

              ],
            ),

            const SizedBox(height:12),

            Row(
              children: const [

                Icon(Icons.payments,color: Colors.orange),

                SizedBox(width:10),

                Text(
                  "18000 د.ع",
                  style: TextStyle(fontSize:18),
                ),

              ],
            ),

            const SizedBox(height:12),

            Row(
              children: const [

                Icon(Icons.location_on,color: Colors.red),

                SizedBox(width:10),

                Expanded(
                  child: Text(
                    "تكريت - القادسية",
                    style: TextStyle(fontSize:18),
                  ),
                ),

              ],
            ),

            const SizedBox(height:25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                onPressed: () {},

                icon: const Icon(
                  Icons.delivery_dining,
                  color: Colors.white,
                ),

                label: const Text(
                  "إسناد لمندوب",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:18,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}