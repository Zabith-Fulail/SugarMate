import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utils/app_colors.dart';

class UploadReceiptView extends StatefulWidget {
  const UploadReceiptView({super.key});

  @override
  State<UploadReceiptView> createState() => _UploadReceiptViewState();
}

class _UploadReceiptViewState extends State<UploadReceiptView> {
  File? _selectedImage;
  Future<void> _uploadReceipt() async {
    if (_selectedImage == null) return;

    try {
      final fileName = 'receipts/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(fileName);

      // Upload image to Firebase Storage
      final uploadTask = await storageRef.putFile(_selectedImage!);
      final downloadUrl = await storageRef.getDownloadURL();

      // Get current user ID (if using Firebase Auth)
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

      // Save metadata to Firestore
      await FirebaseFirestore.instance.collection('receipt_uploads').add({
        'userId': userId,
        'url': downloadUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Receipt uploaded successfully")),
      );

      setState(() {
        _selectedImage = null;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.appWhiteColor),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.appWhiteColor,
        title: const Text("Upload Receipt"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: DottedBorderContainer(
                child: _selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined,
                              size: 60, color: AppColors.primaryColor),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to upload receipt',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: GestureDetector(
                              onTap: _removeImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(Icons.close,
                                      size: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedImage != null ? _uploadReceipt : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  disabledBackgroundColor:
                      AppColors.primaryColor.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.appWhiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Helper widget for the dashed-border container
class DottedBorderContainer extends StatelessWidget {
  final Widget child;

  const DottedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: child,
    );
  }
}
