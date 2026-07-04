import 'package:flutter/material.dart';

import '../../core/colors/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          width: 220,
        ),
      ),
    );
  }
}