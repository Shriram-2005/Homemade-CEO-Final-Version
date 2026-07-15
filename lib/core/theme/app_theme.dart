import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.backgroundCream,
      primaryColor: AppColors.primaryNavy,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryNavy,
        secondary: AppColors.accentGold,
        surface: AppColors.backgroundCream,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.heading.copyWith(color: AppColors.textDark),
        bodyLarge: AppTextStyles.body.copyWith(color: AppColors.textDark),
      ),
    );
  }
}
