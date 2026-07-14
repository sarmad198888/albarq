import 'package:flutter/material.dart';
import 'package:albarq/core/services/order_service.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _customerName = TextEditingController();
  final _customerPhone = TextEditingController();
  final _customerAddress = TextEditingController();
  final _totalPrice = TextEditingController();
  final _deliveryPrice = TextEditingController();
  final _notes = TextEditingController();

  bool loading = false;

  Future<void> saveOrder() async {
    print("SAVE ORDER PRESSED");
    
    setState(() {
      loading = true;
    });

    await OrderService().createOrder(
      restaurantId: "restaurant_1",
      restaurantName: "برجر هاوس",
      customerName: _customerName.text,
      customerPhone: _customerPhone.text,
      customerAddress: _customerAddress.text,
      totalPrice: int.tryParse(_totalPrice.text) ?? 0,
      deliveryPrice: int.tryParse(_deliveryPrice.text) ?? 0,
      notes: _notes.text,
    );

    setState(() {
      loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تم إرسال الطلب إلى الإدارة"),
      ),
    );

    _customerName.clear();
    _customerPhone.clear();
    _customerAddress.clear();
    _totalPrice.clear();
    _deliveryPrice.clear();
    _notes.clear();
  }

  Widget buildField(
    String title,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    int lines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة طلب"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            buildField("اسم الزبون", _customerName),

            buildField(
              "رقم الهاتف",
              _customerPhone,
              keyboard: TextInputType.phone,
            ),

            buildField(
              "العنوان",
              _customerAddress,
              lines: 2,
            ),

            buildField(
              "قيمة الطلب",
              _totalPrice,
              keyboard: TextInputType.number,
            ),

            buildField(
              "أجرة التوصيل",
              _deliveryPrice,
              keyboard: TextInputType.number,
            ),

            buildField(
              "ملاحظات",
              _notes,
              lines: 3,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading ? null : saveOrder,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "إرسال الطلب للإدارة",
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