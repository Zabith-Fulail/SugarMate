import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sugar_mate/features/presentation/widgets/app_text_field.dart';
import 'package:sugar_mate/utils/navigation_routes.dart';

import '../../../../core/predictor/diabetes_predictor.dart';
import '../../../../utils/app_colors.dart';
import '../../widgets/app_dropdown.dart';

class PredictionView extends StatefulWidget {
  const PredictionView({super.key});

  @override
  State<PredictionView> createState() => _PredictionViewState();
}

class _PredictionViewState extends State<PredictionView> {
  final _formKey = GlobalKey<FormState>();
  String? _highBP;
  String? _highChol;
  String? _smoker;
  String? _stroke;
  String? _heartDisease ;
  String? _physActivity ;
  String? _fruits ;
  String? _veggies ;
  String? _alcohol ;
  int? _genHealth;
  int? _mentHealth;
  int? _physHealth;
  final TextEditingController _bmiController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  String? _diffWalk ;

  String? _sex;
  int? _education;
  int? _income;
  int? _age;
  String? _predictionResult;
  bool _isLoading = false;

  late DiabetesPredictor predictor;
  bool _modelLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    _bmiController.dispose();
    super.dispose();
  }

  Future<void> _loadModel() async {
    predictor = DiabetesPredictor();
    await predictor.loadModel();
    setState(() {
      _modelLoaded = true;
    });
  }


  Future<void> uploadPredictionResult(String userId, String predictionLabel) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference predictionCollection =
    firestore.collection('predictions');

    try {
      final timestamp = Timestamp.now();

      await predictionCollection// Collection name
          .add({
        'prediction': predictionLabel,
        'userId': userId,
        'age': _age,
        'education': _education,
        'income': _income,
        'highBP': _highBP,
        'highChol': _highChol,
        'smoker': _smoker,
        'stroke': _stroke,
        'heartDisease': _heartDisease,
        'physActivity': _physActivity,
        'fruits': _fruits,
        'veggies': _veggies,
        'alcohol': _alcohol,
        'genHealth': _genHealth,
        'mentHealth': _mentHealth,
        'physHealth': _physHealth,
        'diffWalk': _diffWalk,
        'sex': _sex,
        'predictionResult': _predictionResult,
        'timestamp': timestamp,
      });

      print('Prediction uploaded successfully!');
    } catch (e) {
      print('Error uploading prediction: $e');
    }
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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppDropdown<String>(
                        labelText: "High BP",
                        value: _highBP,
                        onChanged: (val) => setState(() => _highBP = val!),
                        items: [
                          DropdownMenuItem(value: 'Yes', child: Text("Yes")),
                          DropdownMenuItem(value: 'No', child: Text("No")),
                        ],
                        validator: (value){
                          if(_highBP == null){
                            return "Select Bp level";
                          }
                          return null;
                        },
                      ),SizedBox(height: 16,),
                      AppDropdown<String>(
                        value: _highChol,
                        labelText: "High Chol",
                        onChanged: (val) => setState(() => _highChol = val!),
                        items: [
                          DropdownMenuItem(value: 'Yes', child: Text("Yes")),
                          DropdownMenuItem(value: 'No', child: Text("No")),
                        ],
                        validator: (value){
                          if(_highChol == null){
                            return "Select High Chol";
                          }
                          return null;
                        },
                      ),SizedBox(height: 16,),
                      AppDropdown<String>(
                        labelText: "Smoker",
                        value: _smoker,
                        onChanged: (val) => setState(() => _smoker = val!),
                        items: [
                          DropdownMenuItem(value: 'Yes', child: Text("Yes")),
                          DropdownMenuItem(value: 'No', child: Text("No")),
                        ],
                        validator: (value){
                          if(_smoker == null){
                            return "Select Smoker";
                          }
                          return null;
                        },
                      ),SizedBox(height: 16,),
                      AppDropdown<String>(
                        labelText: "Stroke",
                        value: _stroke,
                        onChanged: (val) => setState(() => _stroke = val!),
                        items: [
                          DropdownMenuItem(value: 'Yes', child: Text("Yes")),
                          DropdownMenuItem(value: 'No', child: Text("No")),
                        ],
                        validator: (value){
                          if(_stroke == null){
                            return "Select Stroke";
                          }
                          return null;
                        },
                      ),SizedBox(height: 16,),
                      AppDropdown<String>(
                        labelText: "Heart Disease or Attack",
                        value: _heartDisease,
                        onChanged: (val) => setState(() => _heartDisease = val!),
                        items: [
                          DropdownMenuItem(value: 'Yes', child: Text("Yes")),
                          DropdownMenuItem(value: 'No', child: Text("No")),
                        ],
                        validator: (value){
                          if(_heartDisease == null){
                            return "Select Heart Disease or Attack";
                          }
                          return null;
                        },
                      ),SizedBox(height: 16,),
                      AppDropdown<String>(
                        labelText: "Physical Activity",
                        value: _physActivity,
                        onChanged: (val) => setState(() => _physActivity = val!),
                        items: [
                          DropdownMenuItem(value: 'Yes', child: Text("Yes")),
                          DropdownMenuItem(value: 'No', child: Text("No")),
                        ],
                        validator: (value){
                          if(_physActivity == null){
                            return "Select Bp level";
                          }
                          return null;
                        },
                      ),SizedBox(height: 16,),
                      AppDropdown<String>(
                        value: _fruits,
                        labelText: "Fruits Consumption",
                        onChanged: (val) => setState(() => _fruits = val!),
                        items: [
                          DropdownMenuItem(value: 'Yes', child: Text("Yes")),
                          DropdownMenuItem(value: 'No', child: Text("No")),
                        ],
                        validator: (value){
                          if(_fruits == null){
                            return "Select Fruits Consumption";
                          }
                          return null;
                        },
                      ),SizedBox(height: 16,),
                      AppDropdown<String>(
                        value: _veggies,
                        labelText: "Veggies Consumption",
                        onChanged: (val) => setState(() => _veggies = val!),
                        items: [
                          DropdownMenuItem(value: 'Yes', child: Text("Yes")),
                          DropdownMenuItem(value: 'No', child: Text("No")),
                        ],
                        validator: (value){
                          if(_veggies == null){
                            return "Select Veggies Consumption";
                          }
                          return null;
                        },
                      ),SizedBox(height: 16,),
                      AppDropdown<String>(
                        labelText: "Alcohol Consumption",
                        value: _alcohol,
                        onChanged: (val) => setState(() => _alcohol = val!),
                        items: [
                          DropdownMenuItem(value: 'Yes', child: Text("Yes")),
                          DropdownMenuItem(value: 'No', child: Text("No")),
                        ],
                        validator: (value){
                          if(_alcohol == null){
                            return "Select Alcohol Consumption";
                          }
                          return null;
                        },
                      ),SizedBox(height: 16,),
                      AppDropdown<String>(
                        value: _diffWalk,
                        labelText: "Difficulty Walking",
                        onChanged: (val) => setState(() => _diffWalk = val!),
                        items: [
                          DropdownMenuItem(value: 'Yes', child: Text("Yes")),
                          DropdownMenuItem(value: 'No', child: Text("No")),
                        ],
                        validator: (value){
                          if(_diffWalk == null){
                            return "Select Difficulty Walking";
                          }
                          return null;
                        },
                      ),




                      // _buildToggle(
                      //     "High BP", _highBP, (val) => setState(() => _highBP = val)),
                      // _buildToggle("High Chol", _highChol,
                      //     (val) => setState(() => _highChol = val)),
                      // _buildToggle(
                      //     "Smoker", _smoker, (val) => setState(() => _smoker = val)),
                      // _buildToggle(
                      //     "Stroke", _stroke, (val) => setState(() => _stroke = val)),
                      // _buildToggle("Heart Disease or Attack", _heartDisease,
                      //     (val) => setState(() => _heartDisease = val)),
                      // _buildToggle("Physical Activity", _physActivity,
                      //     (val) => setState(() => _physActivity = val)),
                      // _buildToggle("Fruits Consumption", _fruits,
                      //     (val) => setState(() => _fruits = val)),
                      // _buildToggle("Veggies Consumption", _veggies,
                      //     (val) => setState(() => _veggies = val)),
                      // _buildToggle("Alcohol Consumption", _alcohol,
                      //     (val) => setState(() => _alcohol = val)),
                      // _buildToggle("Difficulty Walking", _diffWalk,
                      //     (val) => setState(() => _diffWalk = val)),
                      SizedBox(height: 16,),
                      AppDropdown<String>(
                        value: _sex,
                        validator: (val){
                          if(val == null){
                            return "Gender Required";
                          }
                          return null;
                        },
                        labelText: "Gender",
                        items: const [
                          DropdownMenuItem(value: 'Male', child: Text("Male")),
                          DropdownMenuItem(value: 'Female', child: Text("Female")),
                        ],
                        onChanged: (val) => setState(() => _sex = val!),
                      ),
                      const SizedBox(height: 24),
                      AppTextField(
                        controller: _bmiController,
                        keyboardType: TextInputType.number,
                        labelText: "BMI",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'BMI is required';
                          }
                          final bmi = double.tryParse(value);
                          if (bmi == null) {
                            return 'Please enter a valid number';
                          }
                          if (bmi < 10 || bmi > 100) {
                            return 'BMI should be between 10 and 100';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),
                      AppDropdown<int>(
                        value: _genHealth,
                        validator: (value){
                          if(value == null){
                            return "General Health Required";
                          }
                          return null;
                        },
                        labelText: "General Health (1-5)",
                        items: List.generate(
                          5,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text('${index + 1}'),
                          ),
                        ),
                        onChanged: (val) => setState(() => _genHealth = val!),
                      ),
                      const SizedBox(height: 16),
                      AppDropdown<int>(
                        value: _mentHealth,
                        labelText: "Mental Health Days (1-30)",
                        validator: (value){
                          if(value == null){
                            return "Mental Health Required";
                          }
                          return null;
                        },
                        items: List.generate(
                          31,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text('$index'),
                          ),
                        ),
                        onChanged: (val) => setState(() => _mentHealth = val!),
                      ),
                      const SizedBox(height: 16),
                      AppDropdown<int>(
                        value: _physHealth,
                        validator: (value){
                          if(value == null){
                            return "Physical Health Required";
                          }
                          return null;
                        },
                        labelText: "Physical Health Days (1-30)",
                        items: List.generate(
                          31,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text('$index'),
                          ),
                        ),
                        onChanged: (val) => setState(() => _physHealth = val!),
                      ),
                      const SizedBox(height: 16),
                      AppDropdown<int>(
                        value: _age,
                        validator: (value){
                          if(value == null){
                            return "Age Required";
                          }
                          return null;
                        },
                        labelText: "Age",
                        items: List.generate(
                          120,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text('${index + 1}'),
                          ),
                        ),
                        onChanged: (val) => setState(() => _age = val!),
                      ),

                      const SizedBox(height: 24),
                      AppDropdown<int>(
                        value: _education,
                        labelText: "Education (1-10)",
                        validator: (value){
                          if(value == null){
                            return "Education Health Required";
                          }
                          return null;
                        },
                        items: List.generate(
                          10,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text('${index + 1}'),
                          ),
                        ),
                        onChanged: (val) => setState(() => _education = val!),
                      ),
                      const SizedBox(height: 24),
                      AppDropdown<int>(
                        value: _income,
                        validator: (value){
                          if(value == null){
                            return "Income Health Required";
                          }
                          return null;
                        },
                        labelText: "Income (1-10)",
                        items: List.generate(
                          10,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text('${index + 1}'),
                          ),
                        ),
                        onChanged: (val) => setState(() => _income = val!),
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(height: 24),

                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formKey.currentState!.validate()) {
                          _predict();
                        }
                      },
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
                ],
              ),
            )
          ],
        ),
      ),
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

    List<double> inputData = [
      _highBP == "Yes" ? 1 : 0,
      _highChol == "Yes" ? 1 : 0,
      double.tryParse(_bmiController.text) ?? 0.0,
      _smoker == "Yes" ? 1 : 0,
      _stroke == "Yes" ? 1 : 0,
      _heartDisease == "Yes" ? 1 : 0,
      _physActivity == "Yes" ? 1 : 0,
      _fruits == "Yes" ? 1 : 0,
      _veggies == "Yes" ? 1 : 0,
      _alcohol == "Yes" ? 1 : 0,
      _genHealth!.toDouble(),
      _mentHealth!.toDouble(),
      _physHealth!.toDouble(),
      _diffWalk == "Yes" ? 1 : 0,
      _sex == 'Male' ? 1.0 : 0.0,
      _age!.toDouble(),
      _education!.toDouble(),
      _income!.toDouble(),
    ];

    // List<double> inputData = [0, 1, 26, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 13, 5, 6];

    // Means and standard deviations (from your StandardScaler in Python)
    List<double> means = [
      0.56317083,
      0.5247467,
      29.88198681,
      0.47537708,
      0.0618358,
      0.14687108,
      0.70457801,
      0.61386664,
      0.78938341,
      0.0435167,
      2.83406716,
      3.74139303,
      5.77863243,
      0.2510919,
      0.45843722,
      8.57676869,
      4.92255053,
      5.69925557
    ];

    List<double> stds = [
      0.49599339,
      0.49938723,
      7.10240249,
      0.49939334,
      0.24085708,
      0.35397735,
      0.45623222,
      0.48686178,
      0.40774654,
      0.20401715,
      1.11181404,
      8.1465422,
      10.04141135,
      0.43364128,
      0.49826954,
      2.85296793,
      1.03047795,
      2.17492644
    ];

    // Standard scaling function
    List<double> standardScale(
        List<double> input, List<double> means, List<double> stds) {
      return List.generate(
          input.length, (i) => (input[i] - means[i]) / stds[i]);
    }

    // Normalize the input
    List<double> normalizedInput = standardScale(inputData, means, stds);

    // Get prediction from TFLite model
    double prediction = await predictor.predict(normalizedInput);

    setState(() {
      _isLoading = false;
      _predictionResult =
          prediction < 1 ? "Prediction: Positive ✅" : "Prediction: Negative ❌";
    });
    print(inputData[2]);
    print(prediction);
    print(_predictionResult);
    await uploadPredictionResult(user!.uid, _predictionResult =
    prediction < 1 ? "Positive" : "Negative");
// Show dialog after prediction is available
    showDialog(
      context: context,
      builder: (context) {
        final isPositive = prediction > 0.5;

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(16),
          title: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPositive ? Colors.red.shade100 : Colors.green.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isPositive
                      ? Icons.warning_rounded
                      : Icons.check_circle_rounded,
                  color: isPositive ? Colors.red : Colors.green,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  isPositive ? 'Diabetes Risk Detected' : 'No Diabetes Risk',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isPositive
                        ? Colors.red.shade900
                        : Colors.green.shade900,
                  ),
                ),
              ],
            ),
          ),
          content: Text(
            isPositive
                ? 'Based on the analysis, there appears to be a risk of diabetes. It is recommended to consult with a healthcare professional.'
                : 'No significant risk of diabetes was detected. Keep up the healthy lifestyle!',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            if (!isPositive)
              InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    height: 60,
                    width: 100,
                    decoration: BoxDecoration(
                      color: isPositive
                          ? Colors.red.shade100
                          : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "Ok",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isPositive
                              ? Colors.red.shade900
                              : Colors.green.shade900,
                        ),
                      ),
                    ),
                  )),
            if (isPositive)
              Row(
                children: [
                  InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 60,
                        width: 100,
                        decoration: BoxDecoration(
                          color: isPositive
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Ok",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isPositive
                                  ? Colors.red.shade900
                                  : Colors.green.shade900,
                            ),
                          ),
                        ),
                      )),
                  if (isPositive)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 32.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.pushNamed(context, Routes.kDoctorSuggestionView);
                            },
                            child: Container(
                              height: 60,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "Consult",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade900,
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ),
                ],
              ),

            // TextButton(
            //   onPressed: () => Navigator.of(context).pop(),
            //   child: const Text('OK'),
            // ),
          ],
        );
      },
    );
  }
}
