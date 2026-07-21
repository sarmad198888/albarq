import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/driver_service.dart';
import '../../core/services/location_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/order_service.dart';
import '../../core/services/session_service.dart';
import '../../models/order_model.dart';
import '../auth/login_screen.dart';
import 'widgets/order_card.dart';
import '../restaurant/widgets/current_time_widget.dart';
import '../restaurant/widgets/restaurant_dashboard_card.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
  
}

enum DriverView {
  pending,
  assigned,
  completed,
}

class _DriverScreenState extends State<DriverScreen> {
  final SessionService sessionService = SessionService();
  final DriverService driverService = DriverService();
  final OrderService orderService = OrderService();
  final LocationService locationService = LocationService();
  final NotificationService notificationService =
      NotificationService();
  final AuthService authService = AuthService();

  Timer? _locationTimer;
  DriverView currentView = DriverView.pending;
  
  

  @override
  void initState() {
    super.initState();

    notificationService.initialize();

    _sendLocationOnce();

    _locationTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) {
        _sendLocationOnce();
      },
    );
  }

  Future<void> _sendLocationOnce() async {
    final userId = await sessionService.getUserId();

    if (userId == null) return;

    final driverId =
    await driverService.getDriverDocumentId(userId);

if (driverId == null) return;

// تحديث حالة المندوب
await driverService.updateDriverStatus(
  driverId: driverId,
  status: "online",
);

// إضافة المندوب إلى الطابور
await driverService.joinQueue(driverId);

// تحديث الموقع
await locationService.updateDriverLocation(driverId);
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  Future<void> _logout() async {
  _locationTimer?.cancel();

  final userId = await sessionService.getUserId();

  if (userId != null) {
    final driverId =
        await driverService.getDriverDocumentId(userId);

    if (driverId != null) {
      await driverService.updateDriverStatus(
        driverId: driverId,
        status: "offline",
      );
    }
  }

  await authService.logout();

  if (!mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ),
    (route) => false,
  );
}
  List<OrderModel> _filteredOrders(List<OrderModel> orders) {
  switch (currentView) {
    case DriverView.pending:
      return orders.where((o) => o.status == "assigned").toList();

    case DriverView.assigned:
      return orders.where((o) => o.status == "delivering").toList();

    case DriverView.completed:
      return orders.where((o) => o.status == "completed").toList();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  automaticallyImplyLeading: false,
  title: const SizedBox(),
  elevation: 0,
  backgroundColor: Colors.transparent,
  actions: [
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: _logout,
    ),
  ],
),

      body: FutureBuilder<String?>(
        future: sessionService.getUserId(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final userId = userSnapshot.data!;
          debugPrint("USER ID = $userId");

          return FutureBuilder<String?>(
            future: driverService.getDriverDocumentId(userId),
            builder: (context, driverSnapshot) {
              print("STATE = ${driverSnapshot.connectionState}");
              print("HAS DATA = ${driverSnapshot.hasData}");
              print("DATA = ${driverSnapshot.data}");
              print("ERROR = ${driverSnapshot.error}");

              if (driverSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (driverSnapshot.hasError) {
                return Center(
                  child: Text(driverSnapshot.error.toString()),
                );
              }

              final driverId = driverSnapshot.data;
              debugPrint("DRIVER ID = $driverId");

              if (driverId == null || driverId.isEmpty) {
                return const Center(
                  child: Text("تعذر العثور على بيانات المندوب"),
                );
              }

              return Column(
                children: [
                 Padding(
  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color.fromARGB(0, 198, 122, 122),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        

        const SizedBox(height: 0),

        Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 55,
    vertical: 12,
  ),
  decoration: BoxDecoration(
    color: const Color.fromARGB(255, 86, 119, 169),
    borderRadius: BorderRadius.circular(30),
    boxShadow: const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: const Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.delivery_dining,
        color: Colors.white,
      ),
      SizedBox(width: 8),
      Text(
  "المندوب",
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),

        const SizedBox(height: 4),

        Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [

      Row(
        children: [
          const Icon(
            Icons.calendar_today,
            color: Colors.red,
            size: 18,
          ),
          const SizedBox(width: 6),
          CurrentTimeWidget(),
        ],
      ),

      const Row(
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: Colors.green,
          ),
          SizedBox(width: 6),
          Text(
            "متصل",
            style: TextStyle(
              color: Color.fromARGB(255, 6, 11, 6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

    ],
  ),
),

        const SizedBox(height: 18),
      ],
    ),
  ),
),

                  Expanded(
                    child: StreamBuilder<List<OrderModel>>(
                      stream: orderService.getDriverOrders(driverId),
                      builder: (context, snapshot) {
                        debugPrint(
                            "ORDERS = ${snapshot.data?.length}");

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child:
                                Text(snapshot.error.toString()),
                          );
                        }

                        final orders = snapshot.data ?? [];
                        for (final order in orders) {
  print("STATUS = ${order.status}");
}
                        final pendingCount =
    orders.where((o) => o.status == "assigned").length;

                        final assignedCount =
    orders.where((o) => o.status == "delivering").length;

                        final completedCount =
                              orders.where((o) => o.status == "completed").length;
                       final filteredOrders = _filteredOrders(orders);
                       debugPrint(
  "View=$currentView | Pending=$pendingCount | Assigned=$assignedCount | Completed=$completedCount | Filtered=${filteredOrders.length}",
);

                        

                       return Column(
                             children: [

    Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [

          Expanded(
            child: RestaurantDashboardCard(
              title: "طلبات جديدة",
              value: pendingCount.toString(),
              icon: Icons.receipt_long,
              color: Colors.orange,
              selected: currentView == DriverView.pending,
              onTap: () {
                setState(() {
                  currentView = DriverView.pending;
                });
              },
            ),
          ),


          const SizedBox(width: 10),

          Expanded(
            child: RestaurantDashboardCard(
              title: "قيد التوصيل",
              value: assignedCount.toString(),
              icon: Icons.delivery_dining,
              color: Colors.blue,
              selected: currentView == DriverView.assigned,
              onTap: () {
                setState(() {
                  currentView = DriverView.assigned;
                });
              },
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: RestaurantDashboardCard(
              title: "مكتملة",
              value: completedCount.toString(),
              icon: Icons.check_circle,
              color: Colors.green,
              selected: currentView == DriverView.completed,
              onTap: () {
                setState(() {
                  currentView = DriverView.completed;
                });
              },
            ),
          ),

        ],
      ),
    ),

      Expanded(
  child: filteredOrders.isEmpty
      ? const Center(
          child: Text("لا يوجد طلبات حالياً"),
        )
      : ListView.builder(
          itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];

          return OrderCard(
  order: order,

  onAccept: () async {
    await orderService.acceptOrder(order.id);
  },

  onReject: () async {
    await orderService.rejectOrder(order.id);
  },

onCompleted: () async {

  print("ORDER COMPLETED");

  await driverService.finishOrder(
    driverId: order.driverId,
    orderId: order.id,
  );

  print("SEARCHING FOR PENDING ORDER");

  await orderService.assignNextPendingOrder();

  print("DONE");
  

},

);
                            
                          },
                          
                          ),
                          
                          ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}