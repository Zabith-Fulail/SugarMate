import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../widgets/app_text_field.dart'; // Import your AppTextField

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _bmiResult = '';
  String _bmiCategory = '';

  void _calculateBMI() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight == null || height == null || weight <= 0 || height <= 0) {
      setState(() {
        _bmiResult = 'Invalid input';
        _bmiCategory = '';
      });
      return;
    }

    final bmi = weight / (height * height);

    setState(() {
      _bmiResult = bmi.toStringAsFixed(2);

      // BMI categories based on the result
      if (bmi < 18.5) {
        _bmiCategory = 'Underweight';
      } else if (bmi >= 18.5 && bmi < 24.9) {
        _bmiCategory = 'Normal weight';
      } else if (bmi >= 25 && bmi < 29.9) {
        _bmiCategory = 'Overweight';
      } else {
        _bmiCategory = 'Obesity';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.appWhiteColor),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.appWhiteColor,
        title: const Text("BMI Calculator"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Weight input
            AppTextField(
              controller: _weightController,
              labelText: 'Weight (kg)',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),

            // Height input
            AppTextField(
              controller: _heightController,
              labelText: 'Height (m)',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 40),

            // Calculate BMI button
            ElevatedButton(
              onPressed: _calculateBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Calculate BMI',
                style: TextStyle(fontSize: 18,color: AppColors.appWhiteColor),
              ),
            ),
            const SizedBox(height: 30),

            // Display result
            if (_bmiResult.isNotEmpty) ...[
              Text(
                'BMI: $_bmiResult',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Category: $_bmiCategory',
                style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
