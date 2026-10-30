import 'package:flutter_test/flutter_test.dart';
import 'package:agrihelper/data/models/soil_input_model.dart';
import 'package:agrihelper/data/static_data/crops_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Soil Prediction & Crops Database Tests', () {
    test('Crops Database contains all 22 required crops with complete data', () {
      expect(CropsDatabase.crops.length, 22);

      for (final crop in CropsDatabase.getAllCrops()) {
        expect(crop.key.isNotEmpty, true);
        expect(crop.arabicName.isNotEmpty, true);
        expect(crop.suitableSoil.isNotEmpty, true);
        expect(crop.waterRequirements.isNotEmpty, true);
        expect(crop.idealTemperature.isNotEmpty, true);
        expect(crop.growingSeason.isNotEmpty, true);
        expect(crop.careTips.isNotEmpty, true);
      }
    });

    test('SoilInput model correctly converts to feature map with 7 keys', () {
      const input = SoilInput(
        nitrogen: 90.0,
        phosphorus: 42.0,
        potassium: 43.0,
        temperature: 20.87,
        humidity: 82.0,
        ph: 6.5,
        rainfall: 202.93,
      );

      final map = input.toFeaturesMap();
      expect(map.length, 7);
      expect(map['nitrogen'], 90.0);
      expect(map['phosphorus'], 42.0);
      expect(map['potassium'], 43.0);
      expect(map['temperature'], 20.87);
      expect(map['humidity'], 82.0);
      expect(map['ph'], 6.5);
      expect(map['rainfall'], 202.93);
    });
  });
}
