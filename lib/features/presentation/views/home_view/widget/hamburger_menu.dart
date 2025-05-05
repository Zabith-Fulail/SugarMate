import 'package:flutter/material.dart';
import 'package:sugar_mate/utils/navigation_routes.dart';

import '../../../../../utils/app_colors.dart';
import '../../../widgets/drawer_menu_item.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.appWhiteColor,
              child: Icon(
                Icons.person,
                color: AppColors.primaryColor,
                size: 40,
              ),
            ),
            accountName: const Text('John Doe'),
            accountEmail: const Text('john.doe@example.com'),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerMenuItem(
                  icon: Icons.medical_services,
                  title: 'Doctors',
                  onTap: () {
                    Navigator.pushNamed(context, Routes.kDoctorsView);
                  },
                ),
                DrawerMenuItem(
                  icon: Icons.receipt_long,
                  title: 'Previous Receipts',
                  onTap: () {
                    Navigator.pushNamed(context, Routes.kReceiptHistoryView);
                  },
                ),
                DrawerMenuItem(
                  icon: Icons.history,
                  title: 'Prediction History',
                  onTap: () {
                    Navigator.pushNamed(context, Routes.kPredictionHistoryView);
                  },
                ),
                DrawerMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pushNamed(context, Routes.kSettingsView);
                  },
                ),
                const Divider(),
                DrawerMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.kLoginScreen, (route) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
