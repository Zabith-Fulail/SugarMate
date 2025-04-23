import 'package:flutter/material.dart';
import 'package:sugar_mate/utils/app_colors.dart';
import 'package:sugar_mate/utils/navigation.dart';

import '../features/auth/login/login_screen.dart';
import '../features/auth/signup/signup_screen.dart';
import '../features/landing/landing_screen.dart';
import '../screen/splash_screen.dart';
import '../utils/app_strings.dart';

class SugarMateApp extends StatefulWidget {
  const SugarMateApp({super.key});

  @override
  State<SugarMateApp> createState() => _SugarMateAppState();
}

class _SugarMateAppState extends State<SugarMateApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signup: (context) => const SignupScreen(),
        AppRoutes.landing: (context) => const LandingScreen(),
      },
    );
  }
}
