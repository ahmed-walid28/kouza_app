class CropPredictionItem {
  final String cropKey;       // e.g. 'maize', 'rice'
  final String arabicName;    // e.g. 'الذرة', 'الأرز'
  final double confidence;    // e.g. 98.4 (%)

  const CropPredictionItem({
    required this.cropKey,
    required this.arabicName,
    required this.confidence,
  });
}

class CropPredictionResult {
  final CropPredictionItem topCrop;
  final List<CropPredictionItem> allPredictions;
  final Map<String, double> rawProbabilities;

  const CropPredictionResult({
    required this.topCrop,
    required this.allPredictions,
    required this.rawProbabilities,
  });

  List<CropPredictionItem> get alternativeCrops {
    if (allPredictions.length > 1) {
      return allPredictions.sublist(1, allPredictions.length > 5 ? 5 : allPredictions.length);
    }
    return [];
  }
}
