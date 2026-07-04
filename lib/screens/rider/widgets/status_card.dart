import 'package:flutter/material.dart';

class StatusCard extends StatefulWidget {
  const StatusCard({super.key});

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {

  String status = "متاح";
  Color statusColor = Colors.green;

  void changeStatus() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                ),
                title: const Text("متاح"),
                onTap: () {
                  setState(() {
                    status = "متاح";
                    statusColor = Colors.green;
                  });
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                ),
                title: const Text("مشغول"),
                onTap: () {
                  setState(() {
                    status = "مشغول";
                    statusColor = Colors.orange;
                  });
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                ),
                title: const Text("خارج الخدمة"),
                onTap: () {
                  setState(() {
                    status = "خارج الخدمة";
                    statusColor = Colors.red;
                  });
                  Navigator.pop(context);
                },
              ),

            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(

          children: [

            const Text(
              "حالة المندوب",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                CircleAvatar(
                  radius: 8,
                  backgroundColor: statusColor,
                ),

                const SizedBox(width: 10),

                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: changeStatus,
                child: const Text("تغيير الحالة"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}