import 'package:flutter/material.dart';
import '../../core/services/admin_service.dart';
import '../../models/order_model.dart';
import 'widgets/order_card.dart';

class CompletedOrdersScreen extends StatelessWidget {
  CompletedOrdersScreen({super.key});

  final AdminService adminService = AdminService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الطلبات المكتملة"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: adminService.getCompletedOrders(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(
              child: Text("حدث خطأ"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final orders = snapshot.data!;

          if (orders.isEmpty) {
            return const Center(
              child: Text("لا توجد طلبات مكتملة"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return OrderCard(
                order: orders[index],
              );
            },
          );
        },
      ),
    );
  }
}