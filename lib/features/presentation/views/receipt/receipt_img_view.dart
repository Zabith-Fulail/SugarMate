import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sugar_mate/utils/app_styling.dart';

import '../../../../utils/app_colors.dart';

class ReceiptImgArgs {
  final String imagePath;
  final DateTime uploadedAt;

  ReceiptImgArgs({
    required this.imagePath,
    required this.uploadedAt,
  });
}

class ReceiptImgView extends StatelessWidget {
  final ReceiptImgArgs receiptImgArgs;

  const ReceiptImgView({
    super.key,
    required this.receiptImgArgs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.appWhiteColor),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.appWhiteColor,
        title: const Text("Receipt Image"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
      ),
      body: receiptImgArgs.imagePath.startsWith('http') ||
              receiptImgArgs.imagePath.startsWith('https')
          ? Image.network(receiptImgArgs.imagePath) // Show image if it's a URL
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32,),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Uploaded: ${receiptImgArgs.uploadedAt.toLocal().toString().split('.').first}",style: AppStyling.bold18Black,),
              ),
              Container(
                      margin: EdgeInsets.only(top: 32),
                  width: double.maxFinite,
                  child: Image.memory(
                    base64Decode(receiptImgArgs.imagePath),
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  )
              ),
            ],
          ),
    );
  }

  Future<void> uploadReceiptBase64() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final bytes = await file.readAsBytes();
    final base64String = base64Encode(bytes);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('receipts').add({
      'userId': user.uid,
      'base64Image': base64String,
      'uploadedAt': FieldValue.serverTimestamp(),
    });
  }

}
