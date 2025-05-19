import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptListScreen extends StatelessWidget {
  Stream<QuerySnapshot> fetchUserReceipts() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    return FirebaseFirestore.instance
        .collection('receipts')
        .where('userId', isEqualTo: user.uid)
        .orderBy('uploadedAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Uploaded Receipts")),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchUserReceipts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(child: Text("No receipts uploaded"));

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final imageUrl = data['imageUrl'];

              return Card(
                margin: EdgeInsets.all(10),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              );
            },
          );
        },
      ),
    );
  }
}
