import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TranslationService {
  // Free public translation API (for demonstration purposes)
  // In a production app, you should use a proper translation service with API key
  static const String _translationApiUrl = 'https://api.mymemory.translated.net/get';
  
  // Simple cache to avoid re-translating the same text
  static final Map<String, String> _translationCache = {};
  
  // Disease name translations (pre-defined for common diseases)
  static final Map<String, String> _diseaseTranslations = {
    'Apple Black Rot': 'تعفن التفاح الأسود',
    'Apple Scab': 'جرب التفاح',
    'Apple Cedar Rust': 'صدأ التفاح السيدر',
    'Apple Healthy': 'تفاح صحي',
    'Corn Gray Leaf Spot': 'بقعة الذرة الرمادية',
    'Corn Common Rust': 'صدأ الذرة الشائع',
    'Corn Northern Leaf Blight': 'لفحة أوراق الذرة الشمالية',
    'Corn Healthy': 'ذرة صحية',
    'Grape Black Rot': 'تعفن العنب الأسود',
    'Grape Esca (Black Measles)': 'إسكا العنب (الحصبة السوداء)',
    'Grape Leaf Blight': 'لفحة أوراق العنب',
    'Grape Healthy': 'عنب صحي',
    'Potato Early Blight': 'اللفحة المبكرة للبطاطس',
    'Potato Late Blight': 'اللفحة المتأخرة للبطاطس',
    'Potato Healthy': 'بطاطس صحية',
    'Tomato Bacterial Spot': 'البقعة البكتيرية للطماطم',
    'Tomato Early Blight': 'اللفحة المبكرة للطماطم',
    'Tomato Late Blight': 'اللفحة المتأخرة للطماطم',
    'Tomato Leaf Mold': 'عفن أوراق الطماطم',
    'Tomato Septoria Leaf Spot': 'تبقع الأوراق سبتوريا للطماطم',
    'Tomato Spider Mites': 'عناكب الطماطم',
    'Tomato Target Spot': 'البقعة المستهدفة للطماطم',
    'Tomato Yellow Leaf Curl Virus': 'فيروس تجعد أوراق الطماطم الأصفر',
    'Tomato Mosaic Virus': 'فيروس موزاييك الطماطم',
    'Tomato Healthy': 'طماطم صحية',
    'No treatment needed': 'لا يحتاج إلى علاج',
  };

  // Common phrases for prevention and treatment
  static final Map<String, String> _commonPhraseTranslations = {
    'Apply fungicide': 'استخدم مبيد فطري',
    'Remove infected': 'إزالة المصابة',
    'Prune': 'تقليم',
    'Plant resistant varieties': 'زراعة أصناف مقاومة',
    'Rotate crops': 'تناوب المحاصيل',
    'Good airflow': 'تدفق هواء جيد',
    'Water at the base': 'الري عند القاعدة',
    'Avoid overhead watering': 'تجنب الري العلوي',
    'Apply copper-based': 'استخدم المنتجات القائمة على النحاس',
    'Maintain proper spacing': 'الحفاظ على المسافة المناسبة',
    'Healthy': 'صحي',
    'Disease': 'مرض',
    'Prevention': 'الوقاية',
    'Treatment': 'العلاج',
    'No treatment': 'لا علاج',
    'Infection': 'عدوى',
    'Fungicide': 'مبيد فطري',
    'Pesticide': 'مبيد حشري',
    'Spray': 'رش',
    'Sanitation': 'الصرف الصحي',
    'Ensure proper drainage': 'ضمان الصرف المناسب',
    'Remove and destroy': 'إزالة وتدمير',
    'Monitoring': 'مراقبة',
    'Infected plants': 'النباتات المصابة',
    'Organic': 'عضوي',
    'Chemical treatment': 'علاج كيميائي',
    'Regular inspection': 'فحص منتظم',
    'Early detection': 'الكشف المبكر',
    'Symptoms': 'أعراض',
    'Leaves': 'أوراق',
    'Fruit': 'فاكهة',
    'Stem': 'ساق',
    'Roots': 'جذور',
    'Copper fungicide': 'مبيد فطري نحاسي',
    'Organic solution': 'حل عضوي',
    'Neem oil': 'زيت النيم',
    'Baking soda solution': 'محلول صودا الخبز',
    'Commercial fungicide': 'مبيد فطري تجاري',
    'Planting': 'زراعة',
    'Harvest': 'حصاد',
    'Growth': 'نمو',
    'Soil': 'تربة',
    'Water': 'ماء',
    'Sunlight': 'ضوء الشمس',
    'Temperature': 'درجة الحرارة',
    'Humidity': 'رطوبة',
    'Compost': 'سماد عضوي',
    'Fertilizer': 'سماد',
    'Organic fertilizer': 'سماد عضوي',
    'Chemical fertilizer': 'سماد كيميائي',
    'Apply treatment': 'تطبيق العلاج',
    'During growing season': 'خلال موسم النمو',
    'Before symptoms appear': 'قبل ظهور الأعراض',
    'After symptoms appear': 'بعد ظهور الأعراض',
    'Weekly': 'أسبوعيًا',
    'Monthly': 'شهريًا',
    'Seasonally': 'موسميًا',
    'Follow instructions': 'اتبع التعليمات',
    'According to label': 'وفقًا للملصق',
    'Manufacturer recommendations': 'توصيات الشركة المصنعة',
  };

  // Get a translated disease name from the predefined map
  static String translateDiseaseName(String englishName) {
    return _diseaseTranslations[englishName] ?? englishName;
  }

  // Get a translated phrase from the predefined map (for partial matches)
  static String translateCommonPhrase(String englishPhrase) {
    // Check for exact match first
    if (_commonPhraseTranslations.containsKey(englishPhrase)) {
      return _commonPhraseTranslations[englishPhrase]!;
    }
    
    // Check for partial matches
    for (var entry in _commonPhraseTranslations.entries) {
      if (englishPhrase.contains(entry.key)) {
        englishPhrase = englishPhrase.replaceAll(
          entry.key, entry.value
        );
      }
    }
    
    return englishPhrase;
  }

  // Translate a longer text by using predefined phrases and words
  static String translateText(String englishText) {
    if (englishText.isEmpty) return englishText;
    
    // Check if we've already translated this text
    if (_translationCache.containsKey(englishText)) {
      return _translationCache[englishText]!;
    }
    
    String translatedText = englishText;
    
    // First check for disease names
    for (var entry in _diseaseTranslations.entries) {
      if (translatedText.contains(entry.key)) {
        translatedText = translatedText.replaceAll(
          entry.key, entry.value
        );
      }
    }
    
    // Then check for common phrases
    for (var entry in _commonPhraseTranslations.entries) {
      if (translatedText.contains(entry.key)) {
        translatedText = translatedText.replaceAll(
          entry.key, entry.value
        );
      }
    }
    
    // Cache the translation if it's different from the original
    if (translatedText != englishText) {
      _translationCache[englishText] = translatedText;
    }
    
    return translatedText;
  }

  // Split long text into sentences for better translation
  static List<String> _splitIntoSentences(String text) {
    // Split by common sentence endings with a space after them
    final sentenceRegex = RegExp(r'[.!?]\s+');
    final sentences = text.split(sentenceRegex);
    
    // If the original text ends with a sentence-ending punctuation,
    // the last element might be empty; remove it
    if (sentences.isNotEmpty && sentences.last.isEmpty) {
      sentences.removeLast();
    }
    
    // Handle case where there are no sentence endings
    if (sentences.length == 1 && sentences[0] == text) {
      // Try splitting by commas if it's a long sentence
      if (text.length > 100 && text.contains(',')) {
        return text.split(',').map((s) => s.trim()).toList();
      }
    }
    
    return sentences.map((s) => s.trim()).toList();
  }

  // Translate text using the API (for longer texts not covered by predefined translations)
  static Future<String> translateTextWithApi(String text, {bool fallbackToBase = true}) async {
    if (text.isEmpty) return text;
    
    // Check cache first
    if (_translationCache.containsKey(text)) {
      return _translationCache[text]!;
    }
    
    // First try with our predefined translations
    String translated = translateText(text);
    
    // If we got a good translation with our predefined phrases, return it
    if (translated != text) {
      return translated;
    }
    
    // Otherwise, use the API for translation
    if (!fallbackToBase) {
      return text; // Don't use API, just return original
    }
    
    try {
      String translatedText = '';
      
      // For longer texts, split into sentences and translate each separately
      if (text.length > 500) {
        final sentences = _splitIntoSentences(text);
        for (final sentence in sentences) {
          if (sentence.isNotEmpty) {
            final sentenceTranslation = await _translateSingleChunk(sentence);
            translatedText += '$sentenceTranslation ';
          }
        }
        translatedText = translatedText.trim();
      } else {
        translatedText = await _translateSingleChunk(text);
      }
      
      // Cache the result
      _translationCache[text] = translatedText;
      return translatedText;
    } catch (e) {
      debugPrint('Translation API error: $e');
      return text;
    }
  }
  
  // Helper method to translate a single chunk of text
  static Future<String> _translateSingleChunk(String text) async {
    // First try our dictionary-based translation
    final localTranslation = translateText(text);
    if (localTranslation != text) {
      return localTranslation;
    }
    
    try {
      final response = await http.get(
        Uri.parse('$_translationApiUrl?q=${Uri.encodeComponent(text)}&langpair=en|ar')
      ).timeout(const Duration(seconds: 8));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['responseStatus'] == 200) {
          return data['responseData']['translatedText'] as String;
        }
      }
      
      // If translation fails, return original text
      return text;
    } catch (e) {
      debugPrint('API translation chunk error: $e');
      return text;
    }
  }

  // Auto-translate any text - main public method for all text translation
  static Future<String> autoTranslate(String text) async {
    if (text.isEmpty) return text;
    
    // Try cached or dictionary translation first
    if (_translationCache.containsKey(text)) {
      return _translationCache[text]!;
    }
    
    // Then try dictionary-based translation
    final dictionaryTranslation = translateText(text);
    if (dictionaryTranslation != text) {
      return dictionaryTranslation;
    }
    
    // Finally, try API translation
    return translateTextWithApi(text);
  }

  // Translate a plant disease prediction result
  static Future<Map<String, dynamic>> translatePrediction(Map<String, dynamic> prediction) async {
    if (prediction.isEmpty) return prediction;
    
    // Create a copy to avoid modifying the original
    final translatedPrediction = Map<String, dynamic>.from(prediction);
    
    // Translate class name using our predefined translations
    if (prediction['class_name'] != null) {
      translatedPrediction['class_name'] = translateDiseaseName(prediction['class_name']);
    }
    
    // Translate description (try local first, then API if needed)
    if (prediction['description'] != null) {
      translatedPrediction['description'] = await autoTranslate(prediction['description']);
    }
    
    // Translate prevention
    if (prediction['prevention'] != null) {
      translatedPrediction['prevention'] = await autoTranslate(prediction['prevention']);
    }
    
    // Translate treatment
    if (prediction['treatment'] != null) {
      translatedPrediction['treatment'] = await autoTranslate(prediction['treatment']);
    }
    
    return translatedPrediction;
  }

  // Translate all predictions in a result
  static Future<Map<String, dynamic>> translatePredictionResults(Map<String, dynamic> results) async {
    if (results.isEmpty) return results;
    
    // Create a copy to avoid modifying the original
    final translatedResults = Map<String, dynamic>.from(results);
    
    // Translate each prediction
    for (var key in results.keys) {
      if (results[key] is Map<String, dynamic>) {
        translatedResults[key] = await translatePrediction(results[key]);
      }
    }
    
    return translatedResults;
  }
  
  // Clear the translation cache
  static void clearCache() {
    _translationCache.clear();
  }
} 