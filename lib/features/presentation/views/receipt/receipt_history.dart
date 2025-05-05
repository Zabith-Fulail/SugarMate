import 'package:flutter/material.dart';
import 'package:sugar_mate/features/presentation/views/receipt/receipt_img_view.dart';
import 'package:sugar_mate/utils/navigation_routes.dart';

import '../../../../utils/app_colors.dart';

class ReceiptHistoryView extends StatelessWidget {
  const ReceiptHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulating receipt data (this could be a list of paths to images stored locally or assets)
    final List<Map<String, dynamic>> receipts = [
      {
        'imageUrl': 'assets/images/receipt_1.png',  // Image path (simulated)
        'uploadedAt': DateTime.now().subtract(Duration(days: 1)),
        'id': '1',
      },
      {
        'imageUrl': 'assets/images/receipt_2.png',  // Image path (simulated)
        'uploadedAt': DateTime.now().subtract(Duration(days: 2)),
        'id': '2',
      },
      // {
      //   'imageUrl': 'assets/receipt3.jpg',  // Image path (simulated)
      //   'uploadedAt': DateTime.now().subtract(Duration(days: 3)),
      //   'id': '3',
      // },
    ];
    return Scaffold(
      appBar:  AppBar(
        iconTheme: IconThemeData(color: AppColors.appWhiteColor),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.appWhiteColor,
        title: const Text("Receipt History"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
      ),
      body: receipts.isEmpty
          ? const Center(child: Text("No receipts uploaded yet."))
          : ListView.builder(
        itemCount: receipts.length,
        itemBuilder: (context, index) {
          final data = receipts[index];
          final imageUrl = data['imageUrl'] ?? '';
          final uploadedAt = data['uploadedAt'] as DateTime?;

          return InkWell(
            onTap: (){
              Navigator.pushNamed(context, Routes.kReceiptImgView,arguments: ReceiptImgArgs(
                imagePath: imageUrl,
                uploadedAt: uploadedAt ?? DateTime.now(),
              ));
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: imageUrl.isNotEmpty
                    ? Image.asset(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.receipt),
                title: Text("Uploaded: ${uploadedAt?.toLocal().toString().split('.').first ?? 'Unknown'}"),
                subtitle: Text("Receipt ID: ${data['id']}"),
              ),
            ),
          );
        },
      ),
    );
  }
}
