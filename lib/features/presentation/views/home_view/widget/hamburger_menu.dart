import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sugar_mate/utils/navigation_routes.dart';

import '../../../../../utils/app_colors.dart';
import '../../../widgets/drawer_menu_item.dart';

class HamburgerMenu extends StatefulWidget {
  const HamburgerMenu({super.key});

  @override
  State<HamburgerMenu> createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<HamburgerMenu> {
  String? fullName;
  String? email;
  Uint8List? _imageBytes;
  String? _profileImageUrl;
  @override
  void initState() {
    super.initState();
    _loadUserProfile();

    _loadUserData();

  }


  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    print(user?.uid);
    print('user?.uid');
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();
    if (data != null) {
      final fullName = data['full_name']?.split(' ') ?? ['', ''];

      _profileImageUrl = data['profile_image'];

      _imageBytes = base64Decode(_profileImageUrl??"");
    }
  }
  @override

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        email = user.email;
        fullName = doc.data()?['full_name'] ?? 'No Name';
      });
    }
  }

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
              backgroundImage: _imageBytes != null
                  ? MemoryImage(_imageBytes!)
                  : const AssetImage('assets/images/default_profile.png'),
              // child: Icon(
              //   Icons.person,
              //   color: AppColors.primaryColor,
              //   size: 40,
              // ),
            ),
            accountName: Text(fullName ?? ""),
            accountEmail: Text(email ?? ""),
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
