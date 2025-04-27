import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/services/dependency_injection.dart' as di;
import 'utils/app_colors.dart';
import 'utils/app_strings.dart';
import 'utils/navigation_routes.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.whiteColor,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: const FirebaseOptions(
    //   apiKey: "AIzaSyD-7v0x1X2g3Z5k4z5v0x1X2g3Z5k4z5v0",
    //   appId: "1:1234567890:android:1234567890abcdef",
    //   messagingSenderId: "1234567890",
    //   projectId: "your-project-id",
    // ),
  );
  await di.setupLocator();

  runApp(MaterialApp(
    title: AppStrings.appName,
    theme: ThemeData(
      primaryColor: AppColors.primaryColor,
    ),
    initialRoute: Routes.kSplashScreen,
    onGenerateRoute: Routes.generateRoute,
  ));
}
