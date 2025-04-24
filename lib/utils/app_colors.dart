import 'package:flutter/material.dart';

class AppColors {
  static const Color appWhiteColor = Color(0xFFFFFFFF); // Card/Surface
  static const Color appBackgroundColor = Color(0xFFF8F9F9); // Light background
  static const Color primaryColor = Color(0xFFC9FAFF); // Fresh green
  static const Color primaryVariant = Color(0xFF388E3C); // Darker green for buttons/headers
  static const Color secondaryColor = Color(0xFF00BCD4); // Teal accent
  static const Color appBlackColor = Color(0xFF2C3E50); // Dark text
  static const Color appGreyColor = Color(0xFF7F8C8D); // Medium grey
  static const Color appRedColor = Color(0xFFE74C3C); // Error red
  static const Color successColor = Color(0xFF43A047); // Success/positive
  static const Color appListBoxColor =
      Color(0xFFE0E0E0); // Optional light grey for cards or dividers

  ///Colors
  // static const Color primaryColor = Color(0xff6728c5);
  static const Color darkBlue = Color(0xff084297);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF2C3E50);
  static const Color lightGrey = Color(0xffF7F7F9);
  static const Color bgColor = Color(0xffF8F9FC);
  static const Color darkGrey = Color(0xff707B81);
  static const Color lineSeparationColor = Color(0xff6A6A6A);
  static const Color errorColor = Color(0xFFFF2212);
  static const Color yellowColor = Color(0xFFF6FF00);
  static const Color transparent = Colors.transparent;
  static const Color orangeColor = Color.fromRGBO(255, 101, 0, 1.0);
  static const Color darkYellowColor = Color(0xff806800);
  static const Color darkGreen = Color(0xff005e14);
  static const Color darkRed = Color(0xff880c00);

  /// ShortCut Button Colors
  static const Color lightBlue = Color(0xff39AFD1);
  static const Color lightPink = Color(0xffFA5C7C);
  static const Color lightGreen = Color(0xff00D459);
  static const Color green = Color(0xff00ca2b);
  static const Color red = Color(0xffEA4335);
  static const Color purple = Color(0xffcb67ff);
  static const Color darkPurple = Color(0xff640295);
  static const Color yellow = Color(0xffFFCC00);
  static const Color darkPink = Color(0xffFF2D55);

  static const RadialGradient appBarGradient = RadialGradient(
    colors: [Color(0xff287efd), Color(0xff084297)],
    stops: [0, 1],
    center: Alignment(-0.54, 0.7),
    radius: 1,
  );
  static const RadialGradient fabGradient = RadialGradient(
    colors: [Color(0xff287efd), Color(0xff084297)],
    stops: [0, 1],
    center: Alignment(0, 0),
    radius: 1,
  );
}
