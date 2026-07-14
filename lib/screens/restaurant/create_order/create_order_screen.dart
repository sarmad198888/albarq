import 'package:flutter/material.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() =>
      _CreateOrderScreenState();
}

class _CreateOrderScreenState
    extends State<CreateOrderScreen> {

  final _formKey = GlobalKey<FormState>();

  final customerNameController =
      TextEditingController();

  final customerPhoneController =
      TextEditingController();

  final customerAddressController =
      TextEditingController();

  final orderPriceController =
      TextEditingController();

  final notesController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("طلب جديد"),
        centerTitle: true,
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            TextFormField(
              controller: customerNameController,
              decoration: const InputDecoration(
                labelText: "اسم الزبون",
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: customerPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "رقم الهاتف",
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: customerAddressController,
              decoration: const InputDecoration(
                labelText: "العنوان",
                prefixIcon: Icon(Icons.location_on),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: orderPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "قيمة الطلب",
                prefixIcon: Icon(Icons.payments),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "ملاحظات",
                prefixIcon: Icon(Icons.notes),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child: FilledButton.icon(
                onPressed: () {
                  // سنربطه بـ Firebase في الخطوة القادمة
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  "إنشاء الطلب",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}