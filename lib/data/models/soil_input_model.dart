class SoilInput {
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double temperature;
  final double humidity;
  final double ph;
  final double rainfall;

  const SoilInput({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.temperature,
    required this.humidity,
    required this.ph,
    required this.rainfall,
  });

  Map<String, double> toFeaturesMap() {
    return {
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
      'temperature': temperature,
      'humidity': humidity,
      'ph': ph,
      'rainfall': rainfall,
    };
  }

  factory SoilInput.fromControllers({
    required String nitrogen,
    required String phosphorus,
    required String potassium,
    required String temperature,
    required String humidity,
    required String ph,
    required String rainfall,
  }) {
    return SoilInput(
      nitrogen: double.parse(nitrogen.trim()),
      phosphorus: double.parse(phosphorus.trim()),
      potassium: double.parse(potassium.trim()),
      temperature: double.parse(temperature.trim()),
      humidity: double.parse(humidity.trim()),
      ph: double.parse(ph.trim()),
      rainfall: double.parse(rainfall.trim()),
    );
  }
}
