import 'package:flutter/material.dart';

import '../../core/services/admin_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/order_service.dart';
import '../../models/order_model.dart';
import '../auth/login_screen.dart';
import 'completed_orders_screen.dart';
import 'pages/pending_orders_page.dart';
import 'pages/assigned_orders_page.dart';
import 'pages/drivers_page.dart';
import '../../shared/widgets/dashboard_card.dart';
import '../../core/services/driver_service.dart';

enum AdminView {
  pending,
  assigned,
  drivers,
}
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  AdminView currentView = AdminView.pending;

  final OrderService orderService = OrderService();
  final AuthService authService = AuthService();
  final AdminService adminService = AdminService();
  final DriverService driverService = DriverService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لوحة الإدارة"),
        centerTitle: true,
        actions: [
          IconButton(
  icon: const Icon(Icons.history),
  tooltip: "الطلبات المكتملة",
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompletedOrdersScreen(),
      ),
    );
  },
),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "تسجيل الخروج",
            onPressed: () async {
              await authService.logout();

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),

      body: Column(
        children: [

          /// بطاقات الإحصائيات
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [

                Expanded(
                  child: _buildCounterCard(
                    "طلبات جديدة",
                    adminService.getPendingOrders(),
                    Colors.orange,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _buildCounterCard(
                    "قيد التوصيل",
                    adminService.getAssignedOrders(),
                    Colors.blue,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
  child: StreamBuilder<int>(
    stream: adminService.getActiveDriversCount(),
    builder: (context, snapshot) {
      final count = snapshot.data ?? 0;

      return DashboardCard(
        title: "مندوبون",
        value: "$count",
        color: Colors.green,
        icon: Icons.delivery_dining,
        onTap: () {
  setState(() {
    currentView = AdminView.drivers;
  });
},
      );
    },
  ),
),

                

              ],
            ),
          ),

          /// قائمة الطلبات
          Expanded(
  child: Builder(
    builder: (_) {
      switch (currentView) {
        case AdminView.pending:
          return const PendingOrdersPage();

        case AdminView.assigned:
          return const AssignedOrdersPage();

        case AdminView.drivers:
          return const DriversPage();
      }
    },
  ),
),
        ],
      ),
    );
  }

 Widget _buildCounterCard(
  String title,
  Stream<List<OrderModel>> stream,
  Color color,
) {
  return StreamBuilder<List<OrderModel>>(
    stream: stream,
    builder: (context, snapshot) {

      final count = snapshot.data?.length ?? 0;

    return DashboardCard(
  title: title,
  value: "$count",
  color: color,
  icon: _getCardIcon(title),
  onTap: () {
    setState(() {
      if (title == "طلبات جديدة") {
        currentView = AdminView.pending;
      } else if (title == "قيد التوصيل") {
        currentView = AdminView.assigned;
      } else if (title == "مندوبون") {
        currentView = AdminView.drivers;
      }
    });
  },
);
    },
  );
}
IconData _getCardIcon(String title) {
  switch (title) {
    case "طلبات جديدة":
      return Icons.receipt_long;

    case "قيد التوصيل":
      return Icons.delivery_dining;

    case "مكتملة":
      return Icons.check_circle;

    case "مندوبون":
      return Icons.delivery_dining;

    default:
      return Icons.dashboard;
  }
}
}