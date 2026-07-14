import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(

    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    ),
    cardTheme: const CardThemeData(
  color: Color.fromARGB(35, 130, 128, 127), // غيّر هذا اللون إلى أي لون تريده
  surfaceTintColor: Colors.transparent,
  elevation: 3,
),

    fontFamily: "Cairo",

  );

}