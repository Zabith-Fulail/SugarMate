import 'package:flutter/material.dart';
import 'package:sugar_mate/utils/app_colors.dart';

import '../utils/app_strings.dart';
import '../utils/navigation_routes.dart';

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
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
      ),
      initialRoute: Routes.kSplashScreen,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
