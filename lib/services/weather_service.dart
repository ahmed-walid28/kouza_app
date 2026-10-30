import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherDataResult {
  final double temperature;
  final int humidity;
  final double rainfall;
  final String condition;
  final String conditionArabic;
  final String locationName;

  const WeatherDataResult({
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    required this.condition,
    required this.conditionArabic,
    required this.locationName,
  });
}

class WeatherService {
  static const String _apiKey = String.fromEnvironment('OPENWEATHER_API_KEY');

  Future<WeatherDataResult> fetchCurrentWeather() async {
    try {
      if (_apiKey.isEmpty) {
        throw Exception(
          'مفتاح OpenWeather غير مُعد. شغّل التطبيق مع '
          '--dart-define=OPENWEATHER_API_KEY=YOUR_API_KEY.',
        );
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('خدمات الموقع (GPS) مغلقة. يرجى تفعيلها أو إدخال البيانات يدوياً.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('تم رفض إذن الوصول إلى الموقع. يرجى تفعيله أو إدخال البيانات يدوياً.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('إذن الموقع مرفوض نهائياً من إعدادات الهاتف.');
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final url = 'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric&lang=ar';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final double temp = (data['main']?['temp'] as num?)?.toDouble() ?? 25.0;
        final int hum = (data['main']?['humidity'] as num?)?.toInt() ?? 60;
        final double rain = (data['rain']?['1h'] as num?)?.toDouble() ?? 0.0;
        final String mainCond = data['weather']?[0]?['main'] ?? 'Clear';
        final String descAr = data['weather']?[0]?['description'] ?? 'صافي';
        final String name = data['name'] ?? 'موقعك الحالي';

        return WeatherDataResult(
          temperature: temp,
          humidity: hum,
          rainfall: rain > 0 ? rain : 0.0,
          condition: mainCond,
          conditionArabic: descAr,
          locationName: name,
        );
      } else {
        throw Exception('تعذر استلام بيانات الطقس من الخادم (رمز: ${response.statusCode})');
      }
    } catch (e) {
      rethrow;
    }
  }
}
