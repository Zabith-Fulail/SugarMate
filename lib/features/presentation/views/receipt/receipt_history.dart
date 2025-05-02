import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReceiptHistoryView extends StatefulWidget {
  const ReceiptHistoryView({super.key});

  @override
  State<ReceiptHistoryView> createState() => _ReceiptHistoryViewState();
}

class _ReceiptHistoryViewState extends State<ReceiptHistoryView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: getUserReceipts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final urls = snapshot.data!;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: urls.length,
          itemBuilder: (context, index) {
            return Image.network(urls[index]);
          },
        );
      },
    );
  }

  Stream<List<String>> getUserReceipts() {
    final user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('receipts')
        .where('userId', isEqualTo: user!.uid)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc['url'] as String).toList());
  }

}
