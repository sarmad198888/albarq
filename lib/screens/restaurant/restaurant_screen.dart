import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/order_service.dart';
import '../../models/order_model.dart';
import '../auth/login_screen.dart';
import 'create_order/create_order_screen.dart';
import 'widgets/restaurant_dashboard_card.dart';
import 'widgets/restaurant_order_card.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'widgets/current_time_widget.dart';
import 'package:albarq/screens/restaurant/add_order_screen.dart';

enum RestaurantView {
  pending,
  assigned,
  completed,
}

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() =>
      _RestaurantScreenState();
}

class _RestaurantScreenState
    extends State<RestaurantScreen> {

  RestaurantView currentView =
      RestaurantView.pending;
      

  final OrderService orderService = OrderService();
  final AuthService authService = AuthService();





  Future<void> _logout(BuildContext context) async {
    await authService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddOrderScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("إضافة طلب"),
      ),
      body: StreamBuilder<List<OrderModel>>(
  stream: orderService.getOrders(),
  builder: (context, snapshot) {

    if (snapshot.connectionState ==
        ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Text(snapshot.error.toString()),
      );
    }

    final orders = snapshot.data ?? [];

    final pendingCount =
        orders.where((o) => o.status == "pending").length;

    final assignedCount =
        orders.where((o) => o.status == "assigned").length;

    final completedCount =
        orders.where((o) => o.status == "completed").length;

    final filteredOrders =
        _filteredOrders(orders);

    return Column(
      children: [
        Padding(
  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color.fromARGB(0, 50, 48, 48),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [

Align(
  alignment: Alignment.topRight,
  child: IconButton(
    icon: const Icon(
      Icons.logout,
      color: Color.fromARGB(255, 15, 13, 13),
    ),
    tooltip: "تسجيل الخروج",
    onPressed: () => _logout(context),
  ),
),

const SizedBox(height: 10),

       Container(
  margin: const EdgeInsets.only(bottom: 14),
  padding: const EdgeInsets.symmetric(
    horizontal: 34,
    vertical: 15,
  ),
  decoration: BoxDecoration(
    color: const Color.fromARGB(147, 198, 8, 8),
    borderRadius: BorderRadius.circular(40),
    boxShadow: [
      BoxShadow(
        color: Colors.red.withValues(alpha: 0.25),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [

      Text(
        "🍔",
        style: TextStyle(fontSize: 30),
      ),

      SizedBox(width: 10),

      Text(
        "برجر هاوس",
        style: TextStyle(
          color: Color.fromARGB(255, 60, 70, 34),
          fontSize: 30,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),

    ],
  ),
),

        const SizedBox(height: 10),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Icon(
      Icons.calendar_today,
      size: 18,
      color: Colors.red,
    ),
    const SizedBox(width: 8),
    const CurrentTimeWidget(),
  ],
),

      ],
    ),
  ),
),

    Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [

         Expanded(
  child: RestaurantDashboardCard(
  title: "طلبات جديدة",
  value: pendingCount.toString(),
    color: Colors.orange,
    icon: Icons.receipt_long,
    selected: currentView == RestaurantView.pending,
    onTap: () {
      setState(() {
        currentView = RestaurantView.pending;
      });
    },
  ),
),

          const SizedBox(width: 10),

          Expanded(
  child: RestaurantDashboardCard(
    title: "قيد التوصيل",
    value: assignedCount.toString(),
    color: Colors.blue,
    icon: Icons.delivery_dining,
    selected: currentView == RestaurantView.assigned,
    onTap: () {
      setState(() {
        currentView = RestaurantView.assigned;
      });
    },
  ),
),
          const SizedBox(width: 10),

         Expanded(
  child: RestaurantDashboardCard(
    title: "مكتملة",
    value: completedCount.toString(),
    color: Colors.green,
    icon: Icons.check_circle,
    selected: currentView == RestaurantView.completed,
    onTap: () {
      setState(() {
        currentView = RestaurantView.completed;
      });
    },
  ),
),

        ],
      ),
    ),

    Expanded(
      child: StreamBuilder<List<OrderModel>>(
        stream: orderService.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final orders = snapshot.data ?? [];
          final pendingCount =
               orders.where((o) => o.status == "pending").length;

          final assignedCount =
                orders.where((o) => o.status == "assigned").length;

          final completedCount =
                orders.where((o) => o.status == "completed").length;
          final filteredOrders = _filteredOrders(orders);
          if (orders.isEmpty) {
            return const Center(
              child: Text(
                "لا توجد طلبات حالياً",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];

              return RestaurantOrderCard(
  order: order,
  onTap: () {
    // سنضيف شاشة التفاصيل لاحقاً
  },
);
            },
          );
        },
      ),
    ),
  ],
);
  },
),

    ); // نهاية Scaffold
  } // نهاية build

  List<OrderModel> _filteredOrders(List<OrderModel> orders) {
  switch (currentView) {
    case RestaurantView.pending:
      return orders
          .where((o) => o.status == "pending")
          .toList();

    case RestaurantView.assigned:
      return orders
          .where((o) => o.status == "assigned")
          .toList();

    case RestaurantView.completed:
      return orders
          .where((o) => o.status == "completed")
          .toList();
  }
}

}