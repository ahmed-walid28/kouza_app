import 'package:flutter/material.dart';

class SurveyScreen extends StatefulWidget {
  final bool isEnglish; // Receive language state from previous screen

  const SurveyScreen({super.key, required this.isEnglish});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int currentPage = 0;

  // Input Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController farmSizeController = TextEditingController();
  final TextEditingController mainCropsController = TextEditingController();

  final TextEditingController nitrogenController = TextEditingController();
  final TextEditingController phosphorusController = TextEditingController();
  final TextEditingController potassiumController = TextEditingController();
  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController humidityController = TextEditingController();
  final TextEditingController phController = TextEditingController();
  final TextEditingController rainfallController = TextEditingController();
  final TextEditingController cropPricesController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    farmSizeController.dispose();
    mainCropsController.dispose();
    nitrogenController.dispose();
    phosphorusController.dispose();
    potassiumController.dispose();
    temperatureController.dispose();
    humidityController.dispose();
    phController.dispose();
    rainfallController.dispose();
    cropPricesController.dispose();
    super.dispose();
  }

  // Translation Map
  final Map<String, Map<String, String>> translations = {
    'en': {
      'title': 'Submit Survey',
      'general_data': 'General Data',
      'dataset_data': 'Dataset and Pricing Data',
      'name': 'Name',
      'age': 'Age',
      'farm_size': 'Farm Size (hectares)',
      'main_crops': 'Main Crops Grown',
      'nitrogen': 'Nitrogen Content (N)',
      'phosphorus': 'Phosphorus Content (P)',
      'potassium': 'Potassium Content (K)',
      'temperature': 'Average Temperature (°C)',
      'humidity': 'Humidity (%)',
      'ph': 'Soil pH',
      'rainfall': 'Rainfall (mm)',
      'crop_prices': 'Prices Sold (per kg)',
      'submit': 'Submit',
      'next': 'Next',
      'previous': 'Previous',
      'survey_success': 'Survey submitted successfully!',
      'survey_failed': 'Failed to submit survey.',
    },
    'ar': {
      'title': 'إرسال الاستبيان',
      'general_data': 'البيانات العامة',
      'dataset_data': 'البيانات وأسعار المحاصيل',
      'name': 'الاسم',
      'age': 'العمر',
      'farm_size': 'حجم المزرعة (فدان - قيراط - سهم)',
      'main_crops': 'المحاصيل الرئيسية المزروعة',
      'nitrogen': 'محتوى النيتروجين (N)',
      'phosphorus': 'محتوى الفوسفور (P)',
      'potassium': 'محتوى البوتاسيوم (K)',
      'temperature': 'درجة الحرارة المتوسطة (°C)',
      'humidity': 'الرطوبة (%)',
      'ph': 'الرقم الهيدروجيني للتربة',
      'rainfall': 'هطول الأمطار (ملم)',
      'crop_prices': 'أسعار البيع (لكل كجم)',
      'submit': 'إرسال',
      'next': 'التالي',
      'previous': 'السابق',
      'survey_success': 'تم إرسال الاستبيان بنجاح!',
      'survey_failed': 'فشل إرسال الاستبيان.',
    },
  };

  String getTranslation(String key) {
    return translations[widget.isEnglish ? 'en' : 'ar']?[key] ?? key;
  }

  void submitSurvey(BuildContext context) {
    if (nameController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        farmSizeController.text.isNotEmpty &&
        nitrogenController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getTranslation('survey_success'))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getTranslation('survey_failed'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF6E4), // Warm beige background
        appBar: AppBar(
          title: Text(
            getTranslation('title'),
            style: TextStyle(
              color: Colors.white,
              fontFamily: widget.isEnglish ? null : 'Saudi',
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF8B4513), // Brown color
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Progress Indicator
              LinearProgressIndicator(
                value: (currentPage + 1) / 2,
                backgroundColor: const Color(0xFFD7CCC8), // Light brown
                color: const Color(0xFF8B4513), // Brown
              ),
              const SizedBox(height: 16.0),
              // Current Page Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: currentPage == 0
                      ? _buildGeneralDataPage()
                      : _buildDatasetDataPage(),
                ),
              ),
              const SizedBox(height: 16.0),
              // Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentPage > 0)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentPage -= 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513), // Brown
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0),
                      ),
                      child: Text(
                        getTranslation('previous'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: widget.isEnglish ? null : 'Saudi',
                        ),
                      ),
                    ),
                  if (currentPage < 1)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentPage += 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513), // Brown
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0),
                      ),
                      child: Text(
                        getTranslation('next'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: widget.isEnglish ? null : 'Saudi',
                        ),
                      ),
                    ),
                  if (currentPage == 1)
                    ElevatedButton(
                      onPressed: () => submitSurvey(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513), // Brown
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0),
                      ),
                      child: Text(
                        getTranslation('submit'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: widget.isEnglish ? null : 'Saudi',
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralDataPage() {
    return SingleChildScrollView(
      child: Column(
        key: const ValueKey(0), // Unique key for AnimatedSwitcher
        children: [
          _buildTile(getTranslation('name'), nameController, TextInputType.name),
          _buildTile(getTranslation('age'), ageController, TextInputType.number),
          _buildTile(getTranslation('farm_size'), farmSizeController,
              TextInputType.number),
          _buildTile(
              getTranslation('main_crops'), mainCropsController, TextInputType.text),
        ],
      ),
    );
  }

  Widget _buildDatasetDataPage() {
    return SingleChildScrollView(
      child: Column(
        key: const ValueKey(1), // Unique key for AnimatedSwitcher
        children: [
          _buildTile(
              getTranslation('nitrogen'), nitrogenController, TextInputType.number),
          _buildTile(getTranslation('phosphorus'), phosphorusController,
              TextInputType.number),
          _buildTile(
              getTranslation('potassium'), potassiumController, TextInputType.number),
          _buildTile(
              getTranslation('temperature'), temperatureController, TextInputType.number),
          _buildTile(
              getTranslation('humidity'), humidityController, TextInputType.number),
          _buildTile(getTranslation('ph'), phController, TextInputType.number),
          _buildTile(
              getTranslation('rainfall'), rainfallController, TextInputType.number),
          _buildTile(
              getTranslation('crop_prices'), cropPricesController, TextInputType.text),
        ],
      ),
    );
  }

  Widget _buildTile(String label, TextEditingController controller,
      TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: widget.isEnglish ? null : 'Saudi',
          ),
        ),
        subtitle: TextFormField(
          controller: controller,
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(
              fontFamily: widget.isEnglish ? null : 'Saudi',
            ),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
