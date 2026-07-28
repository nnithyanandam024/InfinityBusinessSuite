import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const InfinityBusinessSuiteApp());
}

class InfinityBusinessSuiteApp extends StatelessWidget {
  const InfinityBusinessSuiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinity Business Suite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.navy,
          surface: AppColors.bgLight,
        ),
        scaffoldBackgroundColor: AppColors.bgLight,
      ),
      home: const SplashScreen(),
    );
  }
}
