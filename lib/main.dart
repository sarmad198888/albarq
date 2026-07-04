import 'package:albarq/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';


import 'core/theme/app_theme.dart';


void main() {
  runApp(const AlBarqApp());
}

class AlBarqApp extends StatelessWidget {
  const AlBarqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "البرق",

      theme: AppTheme.lightTheme,

      home: const WelcomeScreen(),
    );
  }
}