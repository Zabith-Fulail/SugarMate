import 'package:flutter/material.dart';
import 'package:sugar_mate/features/presentation/views/landing_page/landing_screen.dart';
import 'package:sugar_mate/features/presentation/views/login/login_screen.dart';
import 'package:sugar_mate/features/presentation/views/signup/signup_screen.dart';
import 'package:sugar_mate/features/presentation/views/splash_screen/splash_screen.dart';

import 'app_colors.dart';
import 'app_stylings.dart';

class Routes {
  static const String kSplashScreen = "kSplashScreen";
  static const String kLandingScreen = "kLandingScreen";
  static const String kLoginScreen = "kLoginScreen";
  static const String kSignupScreen = "kSignupScreen";
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case Routes.kSplashScreen:
        page = const SplashScreen();
        break;
      case Routes.kLandingScreen:
        page = const LandingScreen();
        break;
      case Routes.kLoginScreen:
        page = const LoginScreen();
        break;
      case Routes.kSignupScreen:
        page = const SignupScreen();
        break;
      default:
        page = Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: Center(
            child: Text(
              "Invalid Route",
              style: AppStyling.regular14Grey.copyWith(
                color: AppColors.blackColor,
              ),
            ),
          ),
        );
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var fadeAnimation = animation.drive(tween);

        return FadeTransition(opacity: fadeAnimation, child: child);
      },
    );
  }
}
