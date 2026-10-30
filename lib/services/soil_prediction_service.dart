import '../model_services.dart';
import '../data/models/soil_input_model.dart';
import '../data/models/crop_prediction_result.dart';
import '../data/static_data/crops_database.dart';

class SoilPredictionService {
  final ModelService _modelService;

  SoilPredictionService({ModelService? modelService})
      : _modelService = modelService ?? ModelService();

  /// Predicts the best crop given verified soil input features.
  /// Exactly follows the existing TFLite model without altering feature order or normalization factors.
  Future<CropPredictionResult> predictCrop(SoilInput input) async {
    try {
      final featuresMap = input.toFeaturesMap();
      final rawPredictions = _modelService.predictCrop(featuresMap);

      if (rawPredictions.isEmpty) {
        throw Exception('لم يتمكن النموذج من استخراج التنبؤات. يرجى مراجعة القيم المدخلة.');
      }

      final List<CropPredictionItem> predictionItems = [];
      rawPredictions.forEach((cropKey, confidence) {
        final arabicName = CropsDatabase.getArabicName(cropKey);
        predictionItems.add(CropPredictionItem(
          cropKey: cropKey,
          arabicName: arabicName,
          confidence: confidence,
        ));
      });

      // Sort descending by confidence
      predictionItems.sort((a, b) => b.confidence.compareTo(a.confidence));

      return CropPredictionResult(
        topCrop: predictionItems.first,
        allPredictions: predictionItems,
        rawProbabilities: rawPredictions,
      );
    } catch (e) {
      rethrow;
    }
  }
}
