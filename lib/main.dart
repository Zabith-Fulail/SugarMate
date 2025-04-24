import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'core/my_app.dart';
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
  await di.setupLocator();

  runApp(MaterialApp(
    title: AppStrings.appName,
    theme: ThemeData(
      primaryColor: AppColors.primaryColor,
      // ... other theme settings
    ),
    initialRoute: Routes.kSplashScreen,
    onGenerateRoute: Routes.generateRoute,
  ));
}
