import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/soil_input_model.dart';
import '../../services/soil_prediction_service.dart';
import '../../services/weather_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/kooza_character_card.dart';
import '../../widgets/loading_dialog.dart';
import 'prediction_result_screen.dart';

class SoilAnalysisScreen extends StatefulWidget {
  const SoilAnalysisScreen({super.key});

  @override
  State<SoilAnalysisScreen> createState() => _SoilAnalysisScreenState();
}

class _SoilAnalysisScreenState extends State<SoilAnalysisScreen> {
  final _formKey = GlobalKey<FormState>();
  final SoilPredictionService _predictionService = SoilPredictionService();
  final WeatherService _weatherService = WeatherService();

  final TextEditingController _nitrogenController = TextEditingController();
  final TextEditingController _phosphorusController = TextEditingController();
  final TextEditingController _potassiumController = TextEditingController();
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();
  final TextEditingController _rainfallController = TextEditingController();

  bool _isAutoWeatherLoading = false;
  String? _fetchedLocationName;

  @override
  void dispose() {
    _nitrogenController.dispose();
    _phosphorusController.dispose();
    _potassiumController.dispose();
    _phController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _rainfallController.dispose();
    super.dispose();
  }

  Future<void> _fetchAutoWeather() async {
    setState(() {
      _isAutoWeatherLoading = true;
    });

    try {
      final weather = await _weatherService.fetchCurrentWeather();
      setState(() {
        _temperatureController.text = weather.temperature.toStringAsFixed(1);
        _humidityController.text = weather.humidity.toString();
        // If rainfall from API is 0, give a sensible regional default (e.g. 50 mm) or the actual recorded rainfall
        if (weather.rainfall > 0) {
          _rainfallController.text = weather.rainfall.toStringAsFixed(1);
        } else if (_rainfallController.text.isEmpty) {
          _rainfallController.text = '50'; // standard Nile valley average
        }
        _fetchedLocationName = '${weather.locationName} (${weather.conditionArabic})';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.success,
            content: Text(
              'تم جلب بيانات الطقس لموقع: $_fetchedLocationName بنجاح! 🌤️',
              style: const TextStyle(fontFamily: 'Saudi'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(
              'تعذر جلب الطقس تلقائياً: ${e.toString().replaceAll("Exception:", "").trim()}',
              style: const TextStyle(fontFamily: 'Saudi'),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAutoWeatherLoading = false;
        });
      }
    }
  }

  void _fillSampleData() {
    setState(() {
      _nitrogenController.text = '90';
      _phosphorusController.text = '42';
      _potassiumController.text = '43';
      _phController.text = '6.5';
      _temperatureController.text = '24.5';
      _humidityController.text = '72';
      _rainfallController.text = '180';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تعبئة نموذج تجريبي لاختبار التحليل 🌱'),
      ),
    );
  }

  void _clearForm() {
    setState(() {
      _nitrogenController.clear();
      _phosphorusController.clear();
      _potassiumController.clear();
      _phController.clear();
      _temperatureController.clear();
      _humidityController.clear();
      _rainfallController.clear();
      _fetchedLocationName = null;
    });
  }

  Future<void> _submitAnalysis() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.warning,
          content: Text(
            'يرجى التأكد من ملء جميع الحقول المطلوبة بقيم صحيحة',
            style: TextStyle(fontFamily: 'Saudi'),
          ),
        ),
      );
      return;
    }

    // Hide keyboard
    FocusScope.of(context).unfocus();

    KoozaLoadingDialog.show(context, message: AppStrings.analyzingProgress);

    try {
      final input = SoilInput.fromControllers(
        nitrogen: _nitrogenController.text,
        phosphorus: _phosphorusController.text,
        potassium: _potassiumController.text,
        temperature: _temperatureController.text,
        humidity: _humidityController.text,
        ph: _phController.text,
        rainfall: _rainfallController.text,
      );

      // Add a slight realistic delay so the user feels the smart processing
      await Future.delayed(const Duration(milliseconds: 600));

      final predictionResult = await _predictionService.predictCrop(input);

      if (mounted) {
        KoozaLoadingDialog.hide(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PredictionResultScreen(
              result: predictionResult,
              input: input,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        KoozaLoadingDialog.hide(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text(
              'حصلت مشكلة في تحليل البيانات: ${e.toString().replaceAll("Exception:", "").trim()}',
              style: const TextStyle(fontFamily: 'Saudi'),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('تحليل خصائص التربة 🧪'),
          actions: [
            IconButton(
              tooltip: 'تعبئة بيانات تجريبية',
              icon: const Icon(Icons.auto_fix_high),
              onPressed: _fillSampleData,
            ),
            IconButton(
              tooltip: 'مسح الحقول',
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: _clearForm,
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Kooza helper speech card
              const KoozaCharacterCard(
                title: 'جاهز أحلل أرضك يا غالي!',
                message:
                    'دخل نتائج تحليل المعمل أو التقديرات لتربتك، وكوزة هيختارلك المحصول اللي يجيب أعلى إنتاجية وأعلى ربح.',
                compact: true,
              ),
              const SizedBox(height: 16),

              // Section 1: Chemical & Soil Properties
              _buildSectionHeader(
                icon: Icons.science_outlined,
                title: 'العناصر الغذائية ودرجة حموضة التربة',
                subtitle: 'نسب العناصر في عينة التربة (ملغم / كغم)',
              ),
              const SizedBox(height: 10),

              CustomSoilTextField(
                label: AppStrings.nitrogenLabel,
                helper: AppStrings.nitrogenHelper,
                unit: 'N',
                controller: _nitrogenController,
                prefixIcon: Icons.eco,
                minValue: 0,
                maxValue: 180,
              ),
              CustomSoilTextField(
                label: AppStrings.phosphorusLabel,
                helper: AppStrings.phosphorusHelper,
                unit: 'P',
                controller: _phosphorusController,
                prefixIcon: Icons.grass,
                minValue: 0,
                maxValue: 180,
              ),
              CustomSoilTextField(
                label: AppStrings.potassiumLabel,
                helper: AppStrings.potassiumHelper,
                unit: 'K',
                controller: _potassiumController,
                prefixIcon: Icons.local_florist,
                minValue: 0,
                maxValue: 250,
              ),
              CustomSoilTextField(
                label: AppStrings.phLabel,
                helper: AppStrings.phHelper,
                unit: 'pH',
                controller: _phController,
                prefixIcon: Icons.water,
                minValue: 3.0,
                maxValue: 10.0,
              ),
              const SizedBox(height: 16),

              // Section 2: Climate & Environmental Data
              _buildSectionHeader(
                icon: Icons.wb_sunny_outlined,
                title: 'الظروف المناخية والمطر',
                subtitle: 'درجة الحرارة والرطوبة ومعدل المطر في منطقتك',
              ),
              const SizedBox(height: 10),

              // Auto-weather fetch CTA card
              Card(
                color: const Color(0xFFE3F2FD),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.blue, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'جلب الطقس تلقائياً عبر GPS',
                              style: TextStyle(
                                fontFamily: 'Saudi',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                            if (_fetchedLocationName != null)
                              Text(
                                _fetchedLocationName!,
                                style: const TextStyle(
                                  fontFamily: 'Saudi',
                                  fontSize: 11,
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed:
                            _isAutoWeatherLoading ? null : _fetchAutoWeather,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                        ),
                        child: _isAutoWeatherLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'جلب الآن',
                                style: TextStyle(
                                  fontFamily: 'Saudi',
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              CustomSoilTextField(
                label: AppStrings.temperatureLabel,
                helper: AppStrings.temperatureHelper,
                unit: '°C',
                controller: _temperatureController,
                prefixIcon: Icons.thermostat,
                minValue: 5,
                maxValue: 55,
              ),
              CustomSoilTextField(
                label: AppStrings.humidityLabel,
                helper: AppStrings.humidityHelper,
                unit: '%',
                controller: _humidityController,
                prefixIcon: Icons.cloud_queue,
                minValue: 5,
                maxValue: 100,
              ),
              CustomSoilTextField(
                label: AppStrings.rainfallLabel,
                helper: AppStrings.rainfallHelper,
                unit: 'ملم',
                controller: _rainfallController,
                prefixIcon: Icons.water_drop,
                minValue: 0,
                maxValue: 500,
              ),
              const SizedBox(height: 20),

              // Big Analyze Button
              ElevatedButton.icon(
                onPressed: _submitAnalysis,
                icon: const Icon(Icons.insights, size: 22),
                label: const Text(
                  AppStrings.analyzeButton,
                  style: TextStyle(
                    fontFamily: 'Saudi',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Saudi',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Saudi',
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
