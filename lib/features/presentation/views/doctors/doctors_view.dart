import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';

class DoctorsView extends StatefulWidget {
  const DoctorsView({super.key});

  @override
  State<DoctorsView> createState() => _DoctorsViewState();
}

class _DoctorsViewState extends State<DoctorsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
        iconTheme: IconThemeData(
            color: AppColors.appWhiteColor
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: const Center(
        child: Text('Doctors List'),
      ),
    );
  }
}
