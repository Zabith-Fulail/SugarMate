import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';
import 'package:sugar_mate/features/presentation/views/medicine/medicine_details_view.dart';

void main() {
  testWidgets('MedicineSearchView UI test', (WidgetTester tester) async {
    final mockClient = MockClient((request) async {
      await Future.delayed(const Duration(milliseconds: 100)); // simulate delay
      return http.Response(json.encode({
        "results": [
          {
            "openfda": {"brand_name": ["Panadol"]},
            "purpose": ["Pain reliever"],
            "indications_and_usage": ["Used for mild pain relief"],
            "dosage_and_administration": ["Take 1 tablet every 6 hours"],
            "warnings": ["Do not exceed 4 tablets in 24 hours"]
          }
        ]
      }), 200);
    });

    await tester.pumpWidget(
      MaterialApp(
        home: MedicineSearchView(client: mockClient),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'panadol');
    await tester.tap(find.byIcon(Icons.search));

    await tester.pump(); // Starts the async call
    expect(find.byType(CircularProgressIndicator), findsOneWidget); // Spinner appears

    await tester.pumpAndSettle(); // Finish waiting for async call

    expect(find.text("Panadol"), findsOneWidget); // Medicine info displayed
  });

  testWidgets('Displays error when no data found', (WidgetTester tester) async {
    final mockClient = MockClient((request) async {
      return http.Response(json.encode({'results': []}), 200);
    });

    await tester.pumpWidget(MaterialApp(
      home: MedicineSearchView(client: mockClient), // <-- Inject mock client
    ));

    await tester.enterText(find.byType(TextField), 'invalidmedicine');
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.textContaining('No data found'), findsOneWidget);
  });


}
