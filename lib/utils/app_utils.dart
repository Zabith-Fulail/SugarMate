import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void vibrate(BuildContext context) {
  switch (Theme.of(context).platform) {
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
      HapticFeedback.vibrate();
    case TargetPlatform.iOS:
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
      break;
  }
}

class AppUtils {
  static String convertImageBase64(String image) {
    final String base64Img = base64Encode(File(image).readAsBytesSync());
    return base64Img;
  }

  static Uint8List convertBase64Image(String base64Image) {
    final Uint8List image = base64.decode(base64Image);
    return image;
  }

  static String getMonth(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Unknown';
    }
  }

  static String getWeekDay(DateTime date, bool? isLong) {
    int weekday = date.weekday;

    switch (weekday) {
      case DateTime.monday:
        if (isLong!) {
          return 'Monday';
        } else {
          return 'Mon';
        }
      case DateTime.tuesday:
        if (isLong!) {
          return 'Tuesday';
        } else {
          return 'Tue';
        }
      case DateTime.wednesday:
        if (isLong!) {
          return 'Wednesday';
        } else {
          return 'Wed';
        }
      case DateTime.thursday:
        if (isLong!) {
          return 'Thursday';
        } else {
          return 'Thu';
        }
      case DateTime.friday:
        if (isLong!) {
          return 'Friday';
        } else {
          return 'Fri';
        }
      case DateTime.saturday:
        if (isLong!) {
          return 'Saturday';
        } else {
          return 'Sat';
        }
      case DateTime.sunday:
        if (isLong!) {
          return 'Sunday';
        } else {
          return 'Sun';
        }
      default:
        return 'Unknown';
    }
  }

  static String formatDuration(Duration duration, String pattern) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return pattern
        .replaceAll('HH', twoDigits(hours))
        .replaceAll('H', hours.toString())
        .replaceAll('mm', twoDigits(minutes))
        .replaceAll('m', minutes.toString())
        .replaceAll('ss', twoDigits(seconds))
        .replaceAll('s', seconds.toString());
  }

  static String getGreating(DateTime date) {
    if (date.hour < 12) {
      return 'Good Morning!';
    } else if (date.hour < 15) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  static String capitalizeEachWord(String input) {
    String capitalize(String input) {
      if (input.isEmpty) return input;
      return input[0].toUpperCase() + input.substring(1);
    }
    return input.split(' ').map((word) => capitalize(word)).join(' ');
  }

  static Future<String?> convertBase64PdfPath(String base64String) async {
    try {
      // Decode base64 string
      Uint8List bytes = base64Decode(base64String);

      // Get temporary directory
      final directory = await getTemporaryDirectory();

      // Create a file in the temporary directory
      final file = File('${directory.path}/document.pdf');

      // Write bytes to the file
      await file.writeAsBytes(bytes);

      return file.path;
    } catch (e) {
      print('Error loading PDF: $e');
      return null;
    }
  }
}
