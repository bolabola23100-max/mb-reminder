import 'package:flutter/material.dart';
import 'package:mb_reminder/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,

    colorScheme: const ColorScheme.light(
      primary: AppColors.black,
      secondary: AppColors.grey,
      surface: AppColors.white,
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.black,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.white,
      secondary: AppColors.grey,
      surface: AppColors.black,
    ),
  );
}
