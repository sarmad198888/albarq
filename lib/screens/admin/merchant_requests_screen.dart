import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MerchantRequestsScreen extends StatelessWidget {
  const MerchantRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("طلبات الشركاء"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("role", isEqualTo: "merchant")
            .where("approved", isEqualTo: false)
            .snapshots(),
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

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text("لا توجد طلبات حالياً"),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data =
                  docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(data["name"] ?? ""),
                  subtitle: Text(data["phone"] ?? ""),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(docs[index].id)
                          .update({
                        "approved": true,
                      });

                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text("تمت الموافقة"),
                          ),
                        );
                      }
                    },
                    child: const Text("موافقة"),
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