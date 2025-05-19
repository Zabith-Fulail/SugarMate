import 'dart:math';

import 'package:tflite_flutter/tflite_flutter.dart';

class DiabetesPredictor {
  Interpreter? _interpreter;

  // Replace with your actual means and stds from Python
  final List<double> _means = [
    0.56317083, 0.5247467, 29.88198681, 0.47537708, 0.0618358, 0.14687108,
    0.70457801, 0.61386664, 0.78938341, 0.0435167, 2.83406716, 3.74139303,
    5.77863243, 0.2510919, 0.45843722, 8.57676869, 4.92255053, 5.69925557,
  ];

  final List<double> _stds = [
    0.49599339, 0.49938723, 7.10240249, 0.49939334, 0.24085708, 0.35397735,
    0.45623222, 0.48686178, 0.40774654, 0.20401715, 1.11181404, 8.1465422,
    10.04141135, 0.43364128, 0.49826954, 2.85296793, 1.03047795, 2.17492644,
  ];

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/models/diabetes_model.tflite');
  }

  List<double> _standardScale(List<double> input) {
    return List.generate(input.length, (i) => (input[i] - _means[i]) / _stds[i]);
  }


  Future<double> predict(List<double> inputData) async {
    if (_interpreter == null) {
      throw Exception("Interpreter not loaded");
    }

    final scaledInput = _standardScale(inputData);
    var input = [scaledInput]; // shape [1, 18]
    var output = List.filled(1 * 1, 0.0).reshape([1, 1]); // shape [1, 1]

    _interpreter!.run(input, output);

    final rawLogit = output[0][0];
    final sigmoid = 1 / (1 + exp(-rawLogit)); // apply sigmoid manually

    print("Raw output: $rawLogit");
    print("Sigmoid probability: $sigmoid");

    return sigmoid;
  }

}
