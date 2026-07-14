import 'package:flutter/material.dart';

import '../../../core/services/admin_service.dart';
import '../widgets/driver_card.dart';
import '../details/driver_details_screen.dart';

class DriversPage extends StatelessWidget {
  const DriversPage({super.key});

  @override
  Widget build(BuildContext context) {
    final adminService = AdminService();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: adminService.getDrivers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("حدث خطأ"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final drivers = snapshot.data ?? [];

        if (drivers.isEmpty) {
          return const Center(
            child: Text("لا يوجد مندوبون"),
          );
        }

        return ListView.builder(
          itemCount: drivers.length,
          itemBuilder: (context, index) {
            final driver = drivers[index];

            return DriverCard(
  name: driver['name'] ?? '',
  phone: driver['phone'] ?? '',
  active: driver['active'] ?? false,
  currentOrders: driver['currentOrders'] ?? 0,
  onTap: () {
    
    debugPrint("Driver ID = ${driver['id']}");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DriverDetailsScreen(
          driverId: driver['id'],
        ),
      ),
    );
  },
);
          },
        );
      },
    );
  }
}