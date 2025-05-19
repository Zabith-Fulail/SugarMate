import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UploadReceiptScreen extends StatelessWidget {
  Future<void> uploadReceiptImage(BuildContext context) async {
    final picker = ImagePicker();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // In a real app, you would redirect to login
      await FirebaseAuth.instance.signInAnonymously();
    }

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File file = File(pickedFile.path);
    try {
      String filePath = 'receipts/${user!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(filePath);
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('receipts').add({
        'userId': user.uid,
        'imageUrl': downloadUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload successful!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Receipt")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => uploadReceiptImage(context),
              icon: Icon(Icons.upload),
              label: Text("Upload Receipt"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/receipts'),
              icon: Icon(Icons.list),
              label: Text("View My Receipts"),
            )
          ],
        ),
      ),
    );
  }
}
