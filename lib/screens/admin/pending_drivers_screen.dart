import 'package:flutter/material.dart';

import '../../core/services/approval_service.dart';
import '../../models/user_model.dart';

class PendingDriversScreen extends StatelessWidget {
  PendingDriversScreen({super.key});

  final ApprovalService approvalService =
      ApprovalService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("طلبات المندوبين"),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: approvalService.pendingDrivers(),
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

          final drivers = snapshot.data ?? [];

          if (drivers.isEmpty) {
            return const Center(
              child: Text("لا توجد طلبات جديدة"),
            );
          }

          return ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) {

              final driver = drivers[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(driver.name),
                  subtitle: Text(driver.username),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        onPressed: () async {

                          await approvalService
                              .approveDriver(driver.id);

                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        onPressed: () async {

                          await approvalService
                              .rejectDriver(driver.id);

                        },
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}