import 'package:flutter/material.dart';

import '../../core/services/driver_service.dart';
import '../../models/driver_model.dart';

class SelectDriverScreen extends StatelessWidget {
  final String orderId;

  SelectDriverScreen({
    super.key,
    required this.orderId,
  });

  final DriverService driverService = DriverService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اختيار المندوب"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<DriverModel>>(
        stream: driverService.getDrivers(),
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
              child: Text("لا يوجد مندوبون"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              final driver = drivers[index];

              final bool busy =
                  driver.currentOrderId.isNotEmpty;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [

                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            busy
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                        child: Icon(
                          Icons.delivery_dining,
                          color: busy
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              driver.name,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(driver.phone),

                            const SizedBox(height: 8),

                            Row(
                              children: [

                                Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: busy
                                      ? Colors.red
                                      : Colors.green,
                                ),

                                const SizedBox(width: 6),

                                Text(
                                  busy
                                      ? "مشغول بتوصيل طلب"
                                      : "متاح",
                                  style: TextStyle(
                                    color: busy
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () async {

                          await driverService.assignOrder(
                            driverId: driver.id,
                            driverName: driver.name,
                            orderId: orderId,
                          );

                          if (!context.mounted) return;

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Colors.green,
                              content: Text(
                                "تم إسناد الطلب إلى ${driver.name}",
                              ),
                            ),
                          );
                        },
                        child: const Text("اختيار"),
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