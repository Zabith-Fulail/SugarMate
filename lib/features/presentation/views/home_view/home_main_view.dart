import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sugar_mate/features/presentation/views/home_view/widget/hamburger_menu.dart';
import 'package:sugar_mate/features/presentation/views/home_view/widget/option_card.dart';
import 'package:sugar_mate/utils/navigation_routes.dart';

import '../../../../utils/app_colors.dart';
import '../../widgets/carousel_item.dart';

class HomeMainView extends StatefulWidget {
  const HomeMainView({super.key});

  @override
  State<HomeMainView> createState() => _HomeMainViewState();
}

class _HomeMainViewState extends State<HomeMainView> {
  int _currentCarouselIndex = 0;
  Uint8List? _imageBytes;
  String? _profileImageUrl;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final List<Map<String, String>> carouselItems = [
    {
      'imageUrl': 'assets/images/health1.jpg',
      'title': 'Track Your Health',
      'description': 'Monitor your diabetes metrics in real-time',
    },
    {
      'imageUrl': 'assets/images/health2.png',
      'title': 'Smart Predictions',
      'description': 'AI-powered diabetes management insights',
    },
    {
      'imageUrl': 'assets/images/health3.jpg',
      'title': 'Easy Upload',
      'description': 'Quickly upload and manage your medical receipts',
    },
  ];
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
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text('Dashboard'),
        iconTheme: IconThemeData(color: AppColors.appWhiteColor),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.appWhiteColor,
            backgroundImage: _imageBytes != null
          ? MemoryImage(_imageBytes!)
            : const AssetImage('assets/images/default_profile.png'),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.kProfileView);
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: HamburgerMenu(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Carousel
            CarouselSlider.builder(
              itemCount: carouselItems.length,
              carouselController: _carouselController,
              options: CarouselOptions(
                height: 200,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                enlargeCenterPage: true,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentCarouselIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return CarouselItem(
                  imageUrl: carouselItems[index]['imageUrl']!,
                  title: carouselItems[index]['title']!,
                  description: carouselItems[index]['description']!,
                );
              },
            ),
            const SizedBox(height: 16),
            // Carousel Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: carouselItems.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor.withValues(
                      alpha: _currentCarouselIndex == entry.key ? 1.0 : 0.4,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            // Main Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What would you like to do?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OptionCard(
                          icon: Icons.analytics,
                          title: 'Prediction',
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.kPredictionView);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OptionCard(
                          icon: Icons.upload_file,
                          title: 'Upload Receipts',
                          onTap: () {
                            Navigator.pushNamed(context, Routes.kUploadReceiptView);
                            // Navigator.pushNamed(
                            //     context, Routes.kUploadReceiptView);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(

                    children: [
                      Expanded(
                        child: OptionCard(
                          icon: Icons.medical_information,
                          title: 'Medicine',
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.kMedicineSearchView);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OptionCard(
                          icon: Icons.calculate,
                          title: 'BMI',
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.kBMICalculator);
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
