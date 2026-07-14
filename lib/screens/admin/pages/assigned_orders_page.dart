import 'package:flutter/material.dart';

import '../../../core/services/admin_service.dart';
import '../../../models/order_model.dart';
import '../widgets/order_card.dart';

class AssignedOrdersPage extends StatelessWidget {
  const AssignedOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminService adminService = AdminService();

    return StreamBuilder<List<OrderModel>>(
      stream: adminService.getAssignedOrders(),
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

        final orders = snapshot.data ?? [];

        if (orders.isEmpty) {
          return const Center(
            child: Text("لا توجد طلبات قيد التوصيل"),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return OrderCard(
              order: orders[index],
            );
          },
        );
      },
    );
  }
}