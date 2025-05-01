import 'package:flutter/material.dart';
import 'package:sugar_mate/features/presentation/widgets/app_text_field.dart';

import '../../../../utils/app_colors.dart';

class PredictionDetailsView extends StatefulWidget {
  const PredictionDetailsView({super.key});

  @override
  State<PredictionDetailsView> createState() => _PredictionDetailsViewState();
}

class _PredictionDetailsViewState extends State<PredictionDetailsView> {
  // Declare variables for each feature with initial values (false = 0, true = 1)
  bool _highBP = false;
  bool _highChol = false;
  bool _smoker = false;
  bool _stroke = false;
  bool _heartDisease = false;
  bool _physActivity = false;
  bool _fruits = false;
  bool _veggies = false;
  bool _alcohol = false;
  bool _genHealth = false;
  bool _mentHealth = false;
  bool _physHealth = false;
  bool _diffWalk = false;
  bool _sex = false;
  // int _age = 0;  // Age as an integer (e.g., 25)
  // int _education = 0;  // Education level (can be treated as a numeric scale)
  // int _income = 0;  // Income as a numeric value (e.g., 1 for low, 2 for medium, 3 for high)

  TextEditingController _ageController = TextEditingController();
  TextEditingController _educationController = TextEditingController();
  TextEditingController _incomeController = TextEditingController();
  String? _predictionResult;
  bool _isLoading = false;

  Future<void> _predict() async {
    // Gather the feature values as a list
    final inputData = [
      _highBP ? 1 : 0,
      _highChol ? 1 : 0,
      26.0, // Replace with real data for BMI
      _smoker ? 1 : 0,
      _stroke ? 1 : 0,
      _heartDisease ? 1 : 0,
      _physActivity ? 1 : 0,
      _fruits ? 1 : 0,
      _veggies ? 1 : 0,
      _alcohol ? 1 : 0,
      _genHealth ? 1 : 0,
      _mentHealth ? 1 : 0,
      _physHealth ? 1 : 0,
      _diffWalk ? 1 : 0,
      _sex ? 1 : 0,
      double.tryParse(_ageController.text),
      double.tryParse(_educationController.text),
      double.tryParse(_incomeController.text),
    ];

    setState(() {
      _isLoading = true;
      _predictionResult = null;
    });

    // Simulate an API call (replace with actual API call or TensorFlow Lite prediction)
    await Future.delayed(const Duration(seconds: 2));

    // Simulating a positive prediction result for demonstration
    setState(() {
      _isLoading = false;
      _predictionResult = "Prediction: Positive ✅"; // Example result
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.appWhiteColor),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.appWhiteColor,
        title: const Text("Prediction"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle buttons for binary inputs (e.g., HighBP, HighChol, etc.)
              _buildToggle("High BP", _highBP, (val) => setState(() => _highBP = val)),
              _buildToggle("High Chol", _highChol, (val) => setState(() => _highChol = val)),
              _buildToggle("Smoker", _smoker, (val) => setState(() => _smoker = val)),
              _buildToggle("Stroke", _stroke, (val) => setState(() => _stroke = val)),
              _buildToggle("Heart Disease", _heartDisease, (val) => setState(() => _heartDisease = val)),
              _buildToggle("Physical Activity", _physActivity, (val) => setState(() => _physActivity = val)),
              _buildToggle("Fruits Consumption", _fruits, (val) => setState(() => _fruits = val)),
              _buildToggle("Veggies Consumption", _veggies, (val) => setState(() => _veggies = val)),
              _buildToggle("Alcohol Consumption", _alcohol, (val) => setState(() => _alcohol = val)),
              _buildToggle("Good General Health", _genHealth, (val) => setState(() => _genHealth = val)),
              _buildToggle("Mental Health", _mentHealth, (val) => setState(() => _mentHealth = val)),
              _buildToggle("Physical Health", _physHealth, (val) => setState(() => _physHealth = val)),
              _buildToggle("Difficulty Walking", _diffWalk, (val) => setState(() => _diffWalk = val)),
              _buildToggle("Sex", _sex, (val) => setState(() => _sex = val)),

              // Numeric inputs for age, education, and income
              AppTextField(controller: _ageController, labelText: "Age"),
              const SizedBox(height: 24),
              AppTextField(controller: _educationController, labelText: "Education"),
              const SizedBox(height: 24),
              AppTextField(controller: _incomeController, labelText: "Income"),
              const SizedBox(height: 24),
              // _buildNumericInput("Age", _age, (val) => setState(() => _age = val)),
              // _buildNumericInput("Education", _education, (val) => setState(() => _education = val)),
              // _buildNumericInput("Income", _income, (val) => setState(() => _income = val)),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _predict,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Predict",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.appWhiteColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (_isLoading) const CircularProgressIndicator(),
              if (_predictionResult != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _predictionResult!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for toggle switch (true/false values)
  Widget _buildToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }

  // Widget for numeric inputs (e.g., Age, Education, Income)
  Widget _buildNumericInput(String label, int value, ValueChanged<int> onChanged) {
    return Row(
      children: [
        Text(label),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: value.toString()),
            onChanged: (val) => onChanged(int.parse(val)),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
