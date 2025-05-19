import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sugar_mate/features/presentation/views/receipt/receipt_img_view.dart';
import 'package:sugar_mate/utils/navigation_routes.dart';
import '../../../../utils/app_colors.dart';

class ReceiptHistoryView extends StatefulWidget {
  const ReceiptHistoryView({super.key});

  @override
  State<ReceiptHistoryView> createState() => _ReceiptHistoryViewState();
}

class _ReceiptHistoryViewState extends State<ReceiptHistoryView> {
  List<Map<String, dynamic>> receipts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReceipts();
  }

  Future<void> _fetchReceipts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // handle no user logged in scenario if needed
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('receipts')
          .where('userId', isEqualTo: user.uid)
          .orderBy('uploadedAt', descending: true)
          .get();

      final data = querySnapshot.docs.map((doc) {
        final docData = doc.data();
        return {
          'id': doc.id,
          'base64Image': docData['base64Image'] ?? '',
          'uploadedAt': (docData['uploadedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        };
      }).toList();

      setState(() {
        receipts = data;
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
      print('Error fetching receipts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : receipts.isEmpty
          ? const Center(child: Text("No receipts uploaded yet."))
          : ListView.builder(
        itemCount: receipts.length,
        itemBuilder: (context, index) {
          final data = receipts[index];
          final base64Image = data['base64Image'] as String? ?? '';
          final uploadedAt = data['uploadedAt'] as DateTime?;
          final id = data['id'] as String? ?? '';

          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.kReceiptImgView,
                arguments: ReceiptImgArgs(
                  imagePath: base64Image, // pass base64 string here
                  uploadedAt: uploadedAt ?? DateTime.now(),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: base64Image.isNotEmpty
                    ? Image.memory(
                  base64Decode(base64Image),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.receipt),
                title: Text("Uploaded: ${uploadedAt?.toLocal().toString().split('.').first ?? 'Unknown'}"),
                subtitle: Text("Receipt ID: $id"),
              ),
            ),
          );
        },
      ),
    );
  }
}
