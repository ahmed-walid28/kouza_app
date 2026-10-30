import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ModelService {
  late Interpreter _interpreter;

  ModelService() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/crop_recommendation_model.tflite');
      debugPrint("Model loaded successfully!");
    } catch (e) {
      debugPrint("Error loading model: $e");
    }
  }

  // Crop labels based on the dataset
  final List<String> _labels = [
    'apple',
    'banana',
    'blackgram',
    'chickpea',
    'coconut',
    'coffee',
    'cotton',
    'grapes',
    'jute',
    'kidneybeans',
    'lentil',
    'maize',
    'mango',
    'mothbeans',
    'mungbean',
    'muskmelon',
    'orange',
    'papaya',
    'pigeonpeas',
    'pomegranate',
    'rice',
    'watermelon',
  ];

  // Normalization factors based on training dataset
  final Map<String, double> _normalizationFactors = {
    'nitrogen': 120.0,  // Replace with the max value for nitrogen
    'phosphorus': 100.0, // Replace with the max value for phosphorus
    'potassium': 120.0,  // Replace with the max value for potassium
    'temperature': 50.0, // Replace with the max value for temperature
    'humidity': 100.0,   // Replace with the max value for humidity
    'ph': 14.0,          // Replace with the max value for pH
    'rainfall': 300.0,   // Replace with the max value for rainfall
  };

  Map<String, double> predictCrop(Map<String, double> inputFeatures) {
    // Normalize the input features
    List<double> input = [
      (inputFeatures['nitrogen'] ?? 0.0) / (_normalizationFactors['nitrogen'] ?? 1.0),
      (inputFeatures['phosphorus'] ?? 0.0) / (_normalizationFactors['phosphorus'] ?? 1.0),
      (inputFeatures['potassium'] ?? 0.0) / (_normalizationFactors['potassium'] ?? 1.0),
      (inputFeatures['temperature'] ?? 0.0) / (_normalizationFactors['temperature'] ?? 1.0),
      (inputFeatures['humidity'] ?? 0.0) / (_normalizationFactors['humidity'] ?? 1.0),
      (inputFeatures['ph'] ?? 0.0) / (_normalizationFactors['ph'] ?? 1.0),
      (inputFeatures['rainfall'] ?? 0.0) / (_normalizationFactors['rainfall'] ?? 1.0),
    ];

    // Prepare input for the TFLite model
    var inputTensor = [input];
    var outputTensor = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

    // Run the interpreter
    try {
      _interpreter.run(inputTensor, outputTensor);
    } catch (e) {
      debugPrint("Error during model inference: $e");
      return {};
    }

    // Extract probabilities from the output
    List<double> probabilities = outputTensor[0];

    // Map labels to probabilities
    Map<String, double> predictionMap = {};
    for (int i = 0; i < _labels.length; i++) {
      predictionMap[_labels[i]] = probabilities[i] * 100; // Convert to percentage
    }

    // Sort predictions by confidence
    var sortedPredictions = Map.fromEntries(
        predictionMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value))
    );

    return sortedPredictions;
  }
}
