import 'package:flutter/material.dart';
import 'package:sugar_mate/features/presentation/widgets/app_text_field.dart';

import '../../../../core/predictor/diabetes_predictor.dart';
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


  late DiabetesPredictor predictor;
  bool _modelLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    predictor = DiabetesPredictor();
    await predictor.loadModel();
    setState(() {
      _modelLoaded = true;
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

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _predict,
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

  Future<void> _predict() async {
    if (!_modelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Model not yet loaded. Please wait...")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _predictionResult = null;
    });

    // Raw input data
    List<double> inputData = [
      _highBP ? 1 : 0,
      _highChol ? 1 : 0,
      26.0, // Replace with actual BMI input if needed
      _smoker ? 1 : 0,
      _stroke ? 1 : 0,
      _heartDisease ? 1 : 0,
      _physActivity ? 1 : 0,
      _fruits ? 1 : 0,
      _veggies ? 1 : 0,
      _alcohol ? 1 : 0,
      _genHealth ? 1.0 : 0.0, // Adjust if you're modeling general health as categorical
      _mentHealth ? 1.0 : 0.0,
      _physHealth ? 1.0 : 0.0,
      _diffWalk ? 1 : 0,
      _sex ? 1 : 0,
      double.tryParse(_ageController.text) ?? 0,
      double.tryParse(_educationController.text) ?? 0,
      double.tryParse(_incomeController.text) ?? 0,
    ];

    // List<double> inputData = [1, 1, 20, 0, 0, 1, 1, 1, 0, 0, 4, 0, 30, 1, 0, 13, 6, 5];

    // Means and standard deviations (from your StandardScaler in Python)
    List<double> means = [
      0.56317083, 0.5247467, 29.88198681, 0.47537708, 0.0618358, 0.14687108,
      0.70457801, 0.61386664, 0.78938341, 0.0435167, 2.83406716, 3.74139303,
      5.77863243, 0.2510919, 0.45843722, 8.57676869, 4.92255053, 5.69925557
    ];

    List<double> stds = [
      0.49599339, 0.49938723, 7.10240249, 0.49939334, 0.24085708, 0.35397735,
      0.45623222, 0.48686178, 0.40774654, 0.20401715, 1.11181404, 8.1465422,
      10.04141135, 0.43364128, 0.49826954, 2.85296793, 1.03047795, 2.17492644
    ];

    // Standard scaling function
    List<double> standardScale(List<double> input, List<double> means, List<double> stds) {
      return List.generate(input.length, (i) => (input[i] - means[i]) / stds[i]);
    }

    // Normalize the input
    List<double> normalizedInput = standardScale(inputData, means, stds);

    // Get prediction from TFLite model
    double prediction = await predictor.predict(normalizedInput);

    setState(() {
      _isLoading = false;
      _predictionResult = prediction > 0.5
          ? "Prediction: Positive ✅"
          : "Prediction: Negative ❌";
      print('Prediction: $prediction');
    });
  }



}
