import 'package:flutter/material.dart';
import 'package:sugar_mate/features/presentation/views/home_view/home_main_view.dart';
import 'package:sugar_mate/features/presentation/views/landing_page/landing_screen.dart';
import 'package:sugar_mate/features/presentation/views/login/login_screen.dart';
import 'package:sugar_mate/features/presentation/views/signup/signup_screen.dart';
import 'package:sugar_mate/features/presentation/views/splash_screen/splash_screen.dart';

import '../features/presentation/views/doctors/data/doctor.dart';
import '../features/presentation/views/doctors/doctor_details.dart';
import '../features/presentation/views/doctors/doctors_view.dart';
import '../features/presentation/views/prediction/prediction_details_view.dart';
import '../features/presentation/views/profile_view/profile_view.dart';
import '../features/presentation/views/settings/settings_view.dart';
import '../features/presentation/views/upload_receipt/upload_receipt_view.dart';
import 'app_colors.dart';
import 'app_styling.dart';

class Routes {
  static const String kSplashScreen = "kSplashScreen";
  static const String kLandingScreen = "kLandingScreen";
  static const String kLoginScreen = "kLoginScreen";
  static const String kSignupScreen = "kSignupScreen";
  static const String kHomeMainView = "kHomeMainView";
  static const String kDoctorsView = "kDoctorsView";
  static const String kProfileView = "kProfileView";
  static const String kDoctorDetails = "kDoctorDetails";
  static const String kSettingsView = "kSettingsView";
  static const String kUploadReceiptView = "kUploadReceiptView";
  static const String kPredictionView = "kPredictionView";

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
      case Routes.kHomeMainView:
        page = const HomeMainView();
        break;
      case Routes.kDoctorsView:
        page = const DoctorsView();
        break;
      case Routes.kProfileView:
        page = const ProfileView();
        break;
      case Routes.kSettingsView:
        page = const SettingsView();
        break;
      case Routes.kDoctorDetails:
        page = DoctorDetails(
          doctor: settings.arguments as Doctor,
        );
      case Routes.kUploadReceiptView:
        page = UploadReceiptView();
        break;
      case Routes.kPredictionView:
        page = PredictionDetailsView();
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
