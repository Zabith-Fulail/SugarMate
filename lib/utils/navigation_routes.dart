import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sugar_mate/features/presentation/views/home_view/home_main_view.dart';
import 'package:sugar_mate/features/presentation/views/landing_page/landing_screen.dart';
import 'package:sugar_mate/features/presentation/views/login/login_screen.dart';
import 'package:sugar_mate/features/presentation/views/signup/signup_screen.dart';
import 'package:sugar_mate/features/presentation/views/splash_screen/splash_screen.dart';

import '../features/presentation/views/bmi/calculate_bmi_view.dart';
import '../features/presentation/views/doctors/data/doctor.dart';
import '../features/presentation/views/doctors/doctor_details.dart';
import '../features/presentation/views/doctors/doctor_suggestion_view.dart';
import '../features/presentation/views/doctors/doctors_list_view.dart';
import '../features/presentation/views/medicine/medicine_details_view.dart';
import '../features/presentation/views/prediction/prediction_history.dart';
import '../features/presentation/views/prediction/prediction_view.dart';
import '../features/presentation/views/profile_view/profile_view.dart';
import '../features/presentation/views/receipt/receipt_history.dart';
import '../features/presentation/views/receipt/receipt_img_view.dart';
import '../features/presentation/views/receipt/upload_receipts_screen.dart';
import '../features/presentation/views/settings/settings_view.dart';
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

  static const String kPredictionView = "kPredictionView";
  static const String kMedicineSearchView = "kMedicineSearchView";
  static const String kBMICalculator = "kBMICalculator";
  static const String kPredictionHistoryView = "kPredictionHistoryView";
  static const String kReceiptHistoryView = "kReceiptHistoryView";
  static const String kReceiptImgView = "kReceiptImgView";
  static const String kDoctorSuggestionView = "kDoctorSuggestionView";
  static const String kUploadReceiptView = "kUploadReceiptView";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.kSplashScreen:
        return PageTransition(
          type: PageTransitionType.fade,
          child: SplashScreen(),
        );
      case Routes.kLandingScreen:
        return PageTransition(
            type: PageTransitionType.fade, child: LandingScreen());
      case Routes.kLoginScreen:
        return PageTransition(
            type: PageTransitionType.fade, child: LoginScreen());
      case Routes.kSignupScreen:
        return PageTransition(
            type: PageTransitionType.fade, child: SignupScreen());
      case Routes.kHomeMainView:
        return PageTransition(
            type: PageTransitionType.fade, child: HomeMainView());
      case Routes.kDoctorsView:
        return PageTransition(
            type: PageTransitionType.fade, child: DoctorsListView());
      case Routes.kProfileView:
        return PageTransition(
            type: PageTransitionType.fade, child: ProfileView());
      case Routes.kSettingsView:
        return PageTransition(
            type: PageTransitionType.fade, child: SettingsView());
      case Routes.kDoctorDetails:
        return PageTransition(
          child: DoctorDetails(
            doctor: settings.arguments as Doctor,
          ),
          type: PageTransitionType.fade,
        );
      case Routes.kReceiptImgView:
        return PageTransition(
          child: ReceiptImgView(
            receiptImgArgs: settings.arguments as ReceiptImgArgs,
          ),
          type: PageTransitionType.fade,
        );
      case Routes.kPredictionHistoryView:
        return PageTransition(
          child: PredictionHistoryView(),
          type: PageTransitionType.fade,
        );
      // case Routes.kUploadReceiptView:
      //   return PageTransition(
      //       type: PageTransitionType.fade, child: UploadReceiptView());
      case Routes.kPredictionView:
        return PageTransition(
            type: PageTransitionType.fade, child: PredictionView());
      case Routes.kMedicineSearchView:
        return PageTransition(
            type: PageTransitionType.fade, child: MedicineSearchView());
      case Routes.kBMICalculator:
        return PageTransition(
            type: PageTransitionType.fade, child: BMICalculator());
      case Routes.kReceiptHistoryView:
        return PageTransition(
            type: PageTransitionType.fade, child: ReceiptHistoryView());
      case Routes.kDoctorSuggestionView:
        return PageTransition(
            type: PageTransitionType.fade, child: DoctorSuggestionView());
        case Routes.kUploadReceiptView:
        return PageTransition(
            type: PageTransitionType.fade, child: UploadReceipt());
      // case Routes.kUploadReceiptView:
      //   return PageTransition(
      //       type: PageTransitionType.fade, child: UploadReceiptView());
      default:
        return PageTransition(
          type: PageTransitionType.fade,
          child: Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: Center(
              child: Text(
                "Invalid Route",
                style: AppStyling.regular14Grey.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
            ),
          ),
        );
    }

    // return PageRouteBuilder(
    //   settings: settings,
    //   pageBuilder: (context, animation, secondaryAnimation) => page,
    //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //     const begin = 0.0;
    //     const end = 1.0;
    //     const curve = Curves.easeInOut;
    //
    //     var tween = Tween(
    //       begin: begin,
    //       end: end,
    //     ).chain(CurveTween(curve: curve));
    //     var fadeAnimation = animation.drive(tween);
    //
    //     return FadeTransition(opacity: fadeAnimation, child: child);
    //   },
    // );
  }
}
