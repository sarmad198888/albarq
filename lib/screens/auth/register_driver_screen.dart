import 'package:flutter/material.dart';
import '../../core/services/driver_registration_service.dart';

class RegisterDriverScreen extends StatefulWidget {
  const RegisterDriverScreen({super.key});

  @override
  State<RegisterDriverScreen> createState() =>
      _RegisterDriverScreenState();
}

class _RegisterDriverScreenState
    extends State<RegisterDriverScreen> {

  final registrationService =
      DriverRegistrationService();

  final nameController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final vehicleNumberController =
      TextEditingController();

  String vehicleType = "دراجة";

  bool loading = false;

Future<void> register() async {
  setState(() {
    loading = true;
  });

  try {
    await registrationService.registerDriver(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumberController.text.trim(),
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

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("تسجيل مندوب جديد"),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "الاسم الكامل",
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
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: "اسم المستخدم",
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
            value: vehicleType,
            decoration: const InputDecoration(
              labelText: "نوع المركبة",
            ),
            items: const [
              DropdownMenuItem(
                value: "دراجة",
                child: Text("دراجة"),
              ),
              DropdownMenuItem(
                value: "سيارة",
                child: Text("سيارة"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                vehicleType = value!;
              });
            },
          ),

          const SizedBox(height: 15),

          TextField(
            controller: vehicleNumberController,
            decoration: const InputDecoration(
              labelText: "رقم المركبة",
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: loading ? null : register,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("إرسال طلب التسجيل"),
            ),
          ),

        ],
      ),
    ),
  );
}
}