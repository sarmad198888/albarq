import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/admin_service.dart';

class DriverDetailsScreen extends StatelessWidget {
  final String driverId;

  const DriverDetailsScreen({
    super.key,
    required this.driverId,
  });

  Future<void> _callDriver(String phone) async {
  final uri = Uri.parse("tel:$phone");

  await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );
}

  @override
  Widget build(BuildContext context) {
final AdminService adminService = AdminService();
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  stream: adminService.getDriver(driverId),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return const Scaffold(
        body: Center(
          child: Text("حدث خطأ"),
        ),
      );
    }

    if (!snapshot.hasData) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final data = snapshot.data!.data()!;
    final int assignedToday = data['assignedToday'] ?? 0;
    final int completedToday = data['completedToday'] ?? 0;
    final int rejectedToday = data['rejectedToday'] ?? 0;


    final name = data['name'] ?? '';
    final phone = data['phone'] ?? '';
    final active = data['active'] ?? false;
    final currentOrders = data['currentOrders'] ?? 0;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  CircleAvatar(
                    radius: 35,
                    backgroundColor:
                        active ? Colors.green : Colors.grey,
                    child: const Icon(
                      Icons.delivery_dining,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(phone),

                  const SizedBox(height: 8),

                  Chip(
                    label: Text(
                      active ? "متصل" : "غير متصل",
                    ),
                  ),
                ],
              ),
            ),
          ),

Row(
  children: [

    Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const Icon(Icons.assignment, color: Colors.blue),
              const SizedBox(height: 8),
              const Text("طلبات اليوم"),
              Text(
                "$assignedToday",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(height: 8),
              const Text("مكتملة"),
              Text(
                "$completedToday",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const Icon(Icons.cancel, color: Colors.red),
              const SizedBox(height: 8),
              const Text("مرفوضة"),
              Text(
                "$rejectedToday",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),

  ],
),

const SizedBox(height: 20),
          const SizedBox(height: 20),

          Card(
  child: ListTile(
    leading: const Icon(Icons.local_shipping),
    title: const Text("الطلبات الحالية"),
    trailing: StreamBuilder<int>(
      stream: adminService.getDriverCurrentOrders(driverId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        }

        return Text(
          "${snapshot.data}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        );
      },
    ),
  ),
),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("تتبع مباشر"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Tracking Screen لاحقاً
              },
            ),
          ),

          const SizedBox(height: 10),

         Card(
  child: ListTile(
    leading: const Icon(Icons.call),
    title: const Text("اتصال بالمندوب"),
    trailing: const Icon(Icons.phone),
    onTap: () => _callDriver(phone),
  ),
),
        ],
      ),
   );
  },
);
}
}