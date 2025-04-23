import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../features/presentation/widgets/custom_dialog_box.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_images.dart';
import '../permission_validator/easy_permission_validator.dart';

class AppPermissionManager {
  static requestCameraPermission(
      BuildContext context, VoidCallback onGranted) async {
    final permissionValidator = EasyPermissionValidator(
        context: context,
        appName: kAppName,
        customDialog: const AppPermissionDialog());
    final result = await permissionValidator.camera();
    if (result) onGranted();
  }

  static requestExternalStoragePermission(
      BuildContext context, VoidCallback onGranted) async {
    if (Platform.isIOS) {
      if (await Permission.storage.request().isGranted) {
        onGranted();
      }
    } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final permissionValidator = EasyPermissionValidator(
          context: context,
          appName: kAppName,
          customDialog: const AppPermissionDialog());
      // if (int.parse(androidInfo.version.release.toString()) >= 13) {
      //   onGranted();
      // } else {
      //   if (await Permission.storage.request().isGranted) {
      //
      //     onGranted();
      //   }
      // }
      final result = await permissionValidator.camera();
      if (result) onGranted();
    }
  }

  static requestGalleryPermission(
      BuildContext context, VoidCallback onGranted) async {
    final permissionValidator = EasyPermissionValidator(
        context: context,
        appName: kAppName,
        customDialog: const AppPermissionDialog());
    final result = await permissionValidator.mediaLibrary();
    if (result) onGranted();
  }

  static requestLocationPermission(
      BuildContext context, VoidCallback onGranted) async {
    final permissionValidator = EasyPermissionValidator(
        context: context,
        appName: kAppName,
        customDialog: const AppPermissionDialog());
    final result = await permissionValidator.location();
    if (result) onGranted();

  }

  static requestReadPhoneStatePermission(
      BuildContext context, VoidCallback onGranted) async {
    if (Platform.isIOS) {
      onGranted();
    } else if (await Permission.phone.request().isGranted) {
      onGranted();
    }
  }

  static requestManageStoragePermission(
      BuildContext context, VoidCallback onGranted) async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      onGranted();
    }
  }

  static requestNotificationPermission(
      BuildContext context, VoidCallback onGranted) async {
    if (await Permission.notification.request().isGranted) {
      onGranted();
    }
  }
}

class AppPermissionDialog extends StatelessWidget {
  const AppPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialogBox(
      title: kAppName,
      message: 'You have to enable the required permissions to proceed.',
      image: AppImages.failedDialog,
      negativeButtonText: 'Cancel',
      negativeButtonTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      positiveButtonText: 'Go to Settings',
      positiveButtonTap: () async {
        final bool isGranted = await openAppSettings();
        if (isGranted) Navigator.pop(context);
      },
    );
  }
}
