import 'package:flutter/material.dart';

import 'pending_drivers_screen.dart';
import 'merchant_requests_screen.dart';

class ApprovalRequestsScreen extends StatelessWidget {
  const ApprovalRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("طلبات التسجيل"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.delivery_dining),
                text: "المندوبون",
              ),
              Tab(
                icon: Icon(Icons.store),
                text: "الشركاء",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PendingDriversScreen(),
            MerchantRequestsScreen(),
          ],
        ),
      ),
    );
  }
}