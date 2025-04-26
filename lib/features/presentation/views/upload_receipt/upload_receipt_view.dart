import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';

class UploadReceiptView extends StatefulWidget {
  const UploadReceiptView({super.key});

  @override
  State<UploadReceiptView> createState() => _UploadReceiptViewState();
}

class _UploadReceiptViewState extends State<UploadReceiptView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: AppColors.appWhiteColor
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.appWhiteColor,
        title: Text("Upload Receipt"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
      ),
    );
  }
}
