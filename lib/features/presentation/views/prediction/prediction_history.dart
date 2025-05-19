import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sugar_mate/features/presentation/views/prediction/data/prediction_history_data.dart';

import '../../../../utils/app_colors.dart';

class PredictionHistoryView extends StatefulWidget {
  const PredictionHistoryView({super.key});

  @override
  State<PredictionHistoryView> createState() => _PredictionHistoryViewState();
}

class _PredictionHistoryViewState extends State<PredictionHistoryView> {
  bool _isLoading = false;
  final List<PredictionHistory> _history = [];
  Future<void> fetchPredictionHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // User not logged in
        setState(() {
          _history.clear();
          _isLoading = false;
        });
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('predictions')
          .where('userId', isEqualTo: currentUser.uid)
          .orderBy('timestamp', descending: true)
          .get();

      final List<PredictionHistory> loadedHistory = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        loadedHistory.add(PredictionHistory(
          age: data['age'] ?? 0,
          education: data['education'] ?? 0,
          income: data['income'] ?? 0,
          highBP: (data['highBP'] == 'Yes'),
          highChol: (data['highChol'] == 'Yes'),
          smoker: (data['smoker'] == 'Yes'),
          stroke: (data['stroke'] == 'Yes'),
          heartDisease: (data['heartDisease'] == 'Yes'),
          physActivity: (data['physActivity'] == 'Yes'),
          fruits: (data['fruits'] == 'Yes'),
          veggies: (data['veggies'] == 'Yes'),
          alcohol: (data['alcohol'] == 'Yes'),
          genHealth: data['genHealth'] ?? 0,
          mentHealth: data['mentHealth'] ?? 0,
          physHealth: data['physHealth'] ?? 0,
          diffWalk: (data['diffWalk'] == 'Yes'),
          sex: (data['sex'] == 'Male'), // assuming Male = true, Female = false
          predictionResult: data['predictionResult'] ?? '',
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        ));
      }

      setState(() {
        _history.clear();
        _history.addAll(loadedHistory);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching prediction history: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPredictionHistory();
    // Pre-populate _history with 3 hardcoded entries for testing
    // _history.addAll([
    //   PredictionHistory(
    //     age: 25,
    //     education: 1,
    //     income: 1,
    //     highBP: false,
    //     highChol: true,
    //     smoker: true,
    //     stroke: false,
    //     heartDisease: false,
    //     physActivity: true,
    //     fruits: true,
    //     veggies: true,
    //     alcohol: false,
    //     genHealth: 3,
    //     mentHealth: 2,
    //     physHealth: 1,
    //     diffWalk: false,
    //     sex: true,
    //     predictionResult: 'Positive',
    //     timestamp: DateTime.now().subtract(Duration(days: 2)),
    //   ),
    //   PredictionHistory(
    //     age: 40,
    //     education: 2,
    //     income: 2,
    //     highBP: true,
    //     highChol: false,
    //     smoker: false,
    //     stroke: false,
    //     heartDisease: true,
    //     physActivity: false,
    //     fruits: true,
    //     veggies: false,
    //     alcohol: true,
    //     genHealth: 4,
    //     mentHealth: 3,
    //     physHealth: 2,
    //     diffWalk: true,
    //     sex: false,
    //     predictionResult: 'Negative',
    //     timestamp: DateTime.now().subtract(Duration(days: 5)),
    //   ),
    //   PredictionHistory(
    //     age: 30,
    //     education: 3,
    //     income: 3,
    //     highBP: false,
    //     highChol: false,
    //     smoker: false,
    //     stroke: false,
    //     heartDisease: false,
    //     physActivity: true,
    //     fruits: false,
    //     veggies: true,
    //     alcohol: false,
    //     genHealth: 5,
    //     mentHealth: 4,
    //     physHealth: 3,
    //     diffWalk: false,
    //     sex: true,
    //     predictionResult: 'Positive',
    //     timestamp: DateTime.now().subtract(Duration(days: 10)),
    //   ),
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.appWhiteColor),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.appWhiteColor,
        title: const Text("Prediction History"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(24.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         const Text(
      //           'Prediction History',
      //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //         ),
      //         const SizedBox(height: 10),
      //         if (_history.isNotEmpty)
      //           ListView.builder(
      //             shrinkWrap: true,
      //             itemCount: _history.length,
      //             itemBuilder: (context, index) {
      //               final prediction = _history[index];
      //               return Card(
      //                 margin: const EdgeInsets.only(bottom: 10),
      //                 child: ListTile(
      //                   title: Text(
      //                     'Age: ${prediction.age}, Education: ${prediction.education}, Income: ${prediction.income}',
      //                     style: const TextStyle(fontSize: 16),
      //                   ),
      //                   subtitle: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         'Health: BP: ${prediction.highBP ? "Yes" : "No"}, Chol: ${prediction.highChol ? "Yes" : "No"}, Smoker: ${prediction.smoker ? "Yes" : "No"}',
      //                         style: const TextStyle(fontSize: 14),
      //                       ),
      //                       Text(
      //                         'Result: ${prediction.predictionResult}\nTimestamp: ${prediction.timestamp}',
      //                         style: const TextStyle(fontSize: 14),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               );
      //             },
      //           ),
      //         if (_history.isEmpty)
      //           const Center(child: Text("No prediction history available")),
      //       ],
      //     ),
      //   ),
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isNotEmpty
          ? SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Text("Prediction History", style: TextStyle(fontSize: 18),),
                  SizedBox(height: 10),
                  ListView.builder(
                          shrinkWrap: true,
                          itemCount: _history.length,
                          itemBuilder: (context, index) {
                  final prediction = _history[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(
                        'Age: ${prediction.age}, Education: ${prediction.education}, Income: ${prediction.income}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Health: BP: ${prediction.highBP ? "Yes" : "No"}, Chol: ${prediction.highChol ? "Yes" : "No"}, Smoker: ${prediction.smoker ? "Yes" : "No"}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Result: ${prediction.predictionResult}\nTimestamp: ${prediction.timestamp}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                          },
                        ),
                ],
              ),
            ),
          )
          : const Center(child: Text("No prediction history available")),

    );
  }
}
