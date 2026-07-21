import 'package:flutter/material.dart';
import '../../core/services/merchant_registration_service.dart';
import 'package:intl/intl.dart';

class RegisterMerchantScreen extends StatefulWidget {
  const RegisterMerchantScreen({super.key});

  @override
  State<RegisterMerchantScreen> createState() =>
      _RegisterMerchantScreenState();
}

class _RegisterMerchantScreenState
    extends State<RegisterMerchantScreen> {

  final registrationService =
      MerchantRegistrationService();

  final businessNameController =
      TextEditingController();

  final ownerNameController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final addressController =
      TextEditingController();

  final openingTimeController =
      TextEditingController();

  final closingTimeController =
      TextEditingController();

  String category = "مطعم";

  bool loading = false;

  Future<void> register() async {
    setState(() {
      loading = true;
    });

    try {
      await registrationService.registerMerchant(
        businessName:
            businessNameController.text.trim(),
        ownerName:
            ownerNameController.text.trim(),
        phone:
            phoneController.text.trim(),
        password:
            passwordController.text.trim(),
        category: category,
        address:
            addressController.text.trim(),
        openingTime:
            openingTimeController.text.trim(),
        closingTime:
            closingTimeController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم إنشاء الحساب بنجاح"),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    }

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }
Future<void> _pickTime(TextEditingController controller) async {
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (time != null) {
    final now = DateTime.now();

    final date = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    controller.text = DateFormat(
      "hh:mm a",
    ).format(date);
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("إنشاء شريك جديد"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: businessNameController,
              decoration: const InputDecoration(
                labelText: "اسم النشاط",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: ownerNameController,
              decoration: const InputDecoration(
                labelText: "اسم المسؤول",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "رقم الهاتف",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "كلمة المرور",
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(
                labelText: "نوع النشاط",
              ),
              items: const [

                DropdownMenuItem(
                  value: "مطعم",
                  child: Text("مطعم"),
                ),

                DropdownMenuItem(
                  value: "كافيه",
                  child: Text("كافيه"),
                ),

                DropdownMenuItem(
                  value: "حلويات",
                  child: Text("حلويات"),
                ),

                DropdownMenuItem(
                  value: "سوبر ماركت",
                  child: Text("سوبر ماركت"),
                ),

              ],
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "العنوان",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
  controller: openingTimeController,
  readOnly: true,
  onTap: () => _pickTime(openingTimeController),
  decoration: const InputDecoration(
    labelText: "وقت الافتتاح",
    prefixIcon: Icon(Icons.schedule),
    suffixIcon: Icon(Icons.access_time),
  ),
),

            const SizedBox(height: 15),

            TextField(
  controller: closingTimeController,
  readOnly: true,
  onTap: () => _pickTime(closingTimeController),
  decoration: const InputDecoration(
    labelText: "وقت الإغلاق",
    prefixIcon: Icon(Icons.nightlight_round),
    suffixIcon: Icon(Icons.access_time),
  ),
),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    loading ? null : register,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("إنشاء الحساب"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}