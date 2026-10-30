import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agrihelper/plant_disease_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agrihelper/services/translation_service.dart';

class PlantDiseaseDetectionScreen extends StatefulWidget {
  final bool isEnglish;

  const PlantDiseaseDetectionScreen({super.key, required this.isEnglish});

  @override
  State<PlantDiseaseDetectionScreen> createState() => _PlantDiseaseDetectionScreenState();
}

class _PlantDiseaseDetectionScreenState extends State<PlantDiseaseDetectionScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _isAnalyzing = false;
  bool _isUploading = false;
  bool _isTranslating = false;
  String _result = '';
  String _errorMessage = '';
  Map<String, dynamic>? _predictions;
  final PlantDiseaseService _diseaseService = PlantDiseaseService();
  bool _isLabelsLoaded = false;
  bool _isLabelsLoading = false;
  bool _isApiHealthy = false;

  @override
  void initState() {
    super.initState();
    _loadLabels();
    _checkApiHealth();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkApiHealth() async {
    try {
      final health = await _diseaseService.checkApiHealth();
      setState(() {
        _isApiHealthy = health['status'] == 'healthy';
      });
      debugPrint('API health check: ${health['status']}');
    } catch (e) {
      setState(() {
        _isApiHealthy = false;
        _errorMessage = widget.isEnglish
            ? 'Could not connect to the disease detection service. Please try again later.'
            : 'تعذر الاتصال بخدمة اكتشاف الأمراض. يرجى المحاولة مرة أخرى لاحقًا.';
      });
      debugPrint('API health check failed: $e');
    }
  }

  Future<void> _loadLabels() async {
    setState(() {
      _isLabelsLoading = true;
    });

    try {
      await _diseaseService.loadLabels();
      setState(() {
        _isLabelsLoaded = true;
      });
    } catch (e) {
      setState(() {
        _result = widget.isEnglish 
            ? 'Error loading disease labels. Please try again later.'
            : 'خطأ في تحميل تسميات الأمراض. يرجى المحاولة مرة أخرى لاحقًا.';
      });
      debugPrint('Failed to load labels: $e');
    } finally {
      setState(() {
        _isLabelsLoading = false;
      });
    }
  }

  Future<void> _getImage(ImageSource source) async {
    if (!_isApiHealthy && !_isLabelsLoaded) {
      _showErrorMessage(
        widget.isEnglish
            ? 'Disease detection service is currently unavailable. Please try again later.'
            : 'خدمة اكتشاف الأمراض غير متوفرة حاليًا. يرجى المحاولة مرة أخرى لاحقًا.'
      );
      return;
    }
    
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 90,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _result = '';
          _errorMessage = '';
          _predictions = null;
          _isUploading = true;
        });
        _analyzeImage();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      _showErrorMessage(
        widget.isEnglish
            ? 'Error selecting image. Please try again.'
            : 'خطأ في اختيار الصورة. يرجى المحاولة مرة أخرى.'
      );
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _analyzeImage() async {
    if (_image == null) {
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _errorMessage = '';
    });

    try {
      // Verify API is accessible
      final isApiAvailable = await _diseaseService.testApiConnection();
      if (!isApiAvailable) {
        setState(() {
          _isUploading = false;
          _isAnalyzing = false;
          _errorMessage = widget.isEnglish
              ? 'The disease detection service is currently unavailable. Please try again later.'
              : 'خدمة اكتشاف الأمراض غير متوفرة حاليًا. يرجى المحاولة مرة أخرى لاحقًا.';
        });
        return;
      }
      
      // Upload the image to the API
      final predictions = await _diseaseService.detectDisease(_image!);
      
      // Translate predictions if in Arabic mode
      Map<String, dynamic> finalPredictions = predictions;
      if (!widget.isEnglish) {
        setState(() {
          _isTranslating = true;
        });
        
        try {
          // Use the enhanced translation service
          finalPredictions = await TranslationService.translatePredictionResults(predictions);
          debugPrint('Translation completed successfully');
        } catch (e) {
          debugPrint('Translation error: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تعذر ترجمة بعض النتائج. عرض النتائج باللغة الإنجليزية.'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        } finally {
          setState(() {
            _isTranslating = false;
          });
        }
      }
      
      setState(() {
        _predictions = finalPredictions;
        _isUploading = false;
        
        // Set result text based on top prediction
        if (finalPredictions.containsKey('prediction_1')) {
          final topDisease = finalPredictions['prediction_1'];
          if (widget.isEnglish) {
            _result = 'Detected: ${topDisease['class_name']}\n\nConfidence: ${topDisease['confidence']}\n\nDescription: ${topDisease['description']}';
          } else {
            _result = 'تم الكشف: ${topDisease['class_name']}\n\nالثقة: ${topDisease['confidence']}\n\nالوصف: ${topDisease['description']}';
          }
        } else {
          _errorMessage = widget.isEnglish
              ? 'Could not process results. Please try again.'
              : 'تعذر معالجة النتائج. يرجى المحاولة مرة أخرى.';
        }
      });
    } catch (e) {
      debugPrint('Error analyzing image: $e');
      setState(() {
        _isUploading = false;
        _errorMessage = widget.isEnglish 
            ? 'Error analyzing image: ${e.toString()}'
            : 'خطأ في تحليل الصورة: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E4),
      appBar: AppBar(
        title: Text(
          widget.isEnglish ? 'Plant Disease Detection' : 'الكشف عن أمراض النبات',
          style: TextStyle(
            color: Colors.white,
            fontFamily: widget.isEnglish ? null : 'Saudi',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF8B4513),
        actions: [
          // Translation button (only show when predictions are available and in Arabic mode)
          if (_predictions != null && !widget.isEnglish)
            IconButton(
              icon: Icon(
                Icons.translate,
                color: _isTranslating ? Colors.grey : Colors.white,
              ),
              onPressed: _isTranslating 
                ? null 
                : () => _retranslateResults(),
              tooltip: 'إعادة ترجمة النتائج',
            ),
          // API status indicator
          IconButton(
            icon: Icon(
              _isApiHealthy ? Icons.cloud_done : Icons.cloud_off,
              color: _isApiHealthy ? Colors.green : Colors.red,
            ),
            onPressed: _checkApiHealth,
            tooltip: _isApiHealthy 
                ? (widget.isEnglish ? 'Service online' : 'الخدمة متصلة')
                : (widget.isEnglish ? 'Service offline' : 'الخدمة غير متصلة'),
          ),
        ],
      ),
      body: _isLabelsLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF228B22)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.isEnglish
                        ? 'Initializing disease detection...'
                        : 'جاري تهيئة الكشف عن الأمراض...',
                    style: TextStyle(
                      color: const Color(0xFF8B4513),
                      fontFamily: widget.isEnglish ? null : 'Saudi',
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Info card
                    _buildInfoCard(),
                    const SizedBox(height: 20),
                    
                    // Error message if any
                    if (_errorMessage.isNotEmpty) _buildErrorCard(),
                    if (_errorMessage.isNotEmpty) const SizedBox(height: 20),
                    
                    // Image display area
                    _image == null
                        ? _buildPlaceholder()
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  _image!,
                                  width: double.infinity,
                                  height: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (_isAnalyzing || _isUploading || _isTranslating)
                                Container(
                                  width: double.infinity,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        _isTranslating
                                            ? (widget.isEnglish 
                                                ? 'Translating results...'
                                                : 'جاري ترجمة النتائج...')
                                            : (_isUploading
                                                ? (widget.isEnglish 
                                                    ? 'Uploading image to server...'
                                                    : 'جاري رفع الصورة إلى الخادم...')
                                                : (widget.isEnglish 
                                                    ? 'Analyzing image...'
                                                    : 'جاري تحليل الصورة...')),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: widget.isEnglish ? null : 'Saudi',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                    const SizedBox(height: 20),
                    
                    // Camera and gallery buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.camera_alt,
                          label: widget.isEnglish ? 'Camera' : 'الكاميرا',
                          onPressed: () => _getImage(ImageSource.camera),
                          color: _isApiHealthy ? const Color(0xFF228B22) : Colors.grey,
                        ),
                        _buildActionButton(
                          icon: Icons.photo_library,
                          label: widget.isEnglish ? 'Gallery' : 'المعرض',
                          onPressed: () => _getImage(ImageSource.gallery),
                          color: _isApiHealthy ? const Color(0xFF8B4513) : Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Results section
                    if (_predictions != null) _buildPredictionResults(),
                    if (_result.isNotEmpty && _predictions == null) _buildResultCard(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                widget.isEnglish ? 'Error' : 'خطأ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontFamily: widget.isEnglish ? null : 'Saudi',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red.shade800,
              fontFamily: widget.isEnglish ? null : 'Saudi',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionResults() {
    final predictions = _predictions!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isEnglish ? 'Analysis Results' : 'نتائج التحليل',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8B4513),
              fontFamily: widget.isEnglish ? null : 'Saudi',
            ),
          ),
          const SizedBox(height: 12),
          
          // Display each prediction
          ...['prediction_1', 'prediction_2', 'prediction_3'].where(
            (key) => predictions.containsKey(key)
          ).map((key) {
            final prediction = predictions[key];
            final isTopPrediction = key == 'prediction_1';
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isTopPrediction 
                    ? const Color(0xFF228B22).withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isTopPrediction
                      ? const Color(0xFF228B22).withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.3)
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (prediction['example_picture'] != null &&
                          prediction['example_picture'].toString().startsWith('http'))
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0, bottom: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: prediction['example_picture'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF228B22),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    prediction['class_name'],
                                    style: TextStyle(
                                      fontSize: isTopPrediction ? 18 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: isTopPrediction ? const Color(0xFF228B22) : Colors.black87,
                                      fontFamily: widget.isEnglish ? null : 'Saudi',
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isTopPrediction ? const Color(0xFF228B22) : Colors.grey,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    prediction['confidence'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: widget.isEnglish ? null : 'Saudi',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (isTopPrediction) const SizedBox(height: 8),
                            if (isTopPrediction && prediction['description'] != null)
                              Text(
                                prediction['description'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontFamily: widget.isEnglish ? null : 'Saudi',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  if (isTopPrediction) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    
                    // Prevention
                    if (prediction['prevention'] != null) ...[
                      Text(
                        widget.isEnglish ? 'Prevention:' : 'الوقاية:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF228B22),
                          fontFamily: widget.isEnglish ? null : 'Saudi',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        prediction['prevention'],
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: widget.isEnglish ? null : 'Saudi',
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    
                    // Treatment
                    if (prediction['treatment'] != null) ...[
                      Text(
                        widget.isEnglish ? 'Treatment:' : 'العلاج:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF228B22),
                          fontFamily: widget.isEnglish ? null : 'Saudi',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        prediction['treatment'],
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: widget.isEnglish ? null : 'Saudi',
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isApiHealthy 
            ? const Color(0xFF228B22).withValues(alpha: 0.9)
            : Colors.grey.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isApiHealthy ? Icons.check_circle : Icons.error_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.isEnglish ? 'Plant Disease Scanner' : 'ماسح أمراض النبات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: widget.isEnglish ? null : 'Saudi',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _isApiHealthy
                ? (widget.isEnglish
                    ? 'Take a photo of a plant leaf to diagnose diseases and get treatment recommendations.'
                    : 'التقط صورة لورقة نبات للكشف عن الأمراض والتشخيص الدقيق والحصول على توصيات العلاج.')
                : (widget.isEnglish
                    ? 'Disease detection service is currently offline. Please try again later.'
                    : 'خدمة اكتشاف الأمراض غير متصلة حاليًا. يرجى المحاولة مرة أخرى لاحقًا.'),
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              fontFamily: widget.isEnglish ? null : 'Saudi',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            widget.isEnglish ? 'No image selected' : 'لم يتم اختيار صورة',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontFamily: widget.isEnglish ? null : 'Saudi',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.isEnglish 
                ? (_isApiHealthy 
                    ? 'Take or select a photo of a plant leaf'
                    : 'Service offline. Please try again later.')
                : (_isApiHealthy
                    ? 'التقط أو اختر صورة لورقة نبات'
                    : 'الخدمة غير متصلة. يرجى المحاولة لاحقا.'),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontFamily: widget.isEnglish ? null : 'Saudi',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: _isApiHealthy ? onPressed : null,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontFamily: widget.isEnglish ? null : 'Saudi',
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isEnglish ? 'Analysis Results' : 'نتائج التحليل',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8B4513),
              fontFamily: widget.isEnglish ? null : 'Saudi',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _result,
            style: TextStyle(
              fontSize: 16,
              height: 1.4,
              fontFamily: widget.isEnglish ? null : 'Saudi',
            ),
          ),
        ],
      ),
    );
  }

  // Add this method to handle re-translation
  Future<void> _retranslateResults() async {
    if (_predictions == null || _isTranslating) return;
    
    setState(() {
      _isTranslating = true;
    });
    
    try {
      // Clear the translation cache to force new translations
      TranslationService.clearCache();
      
      // Re-translate the predictions
      final translatedPredictions = await TranslationService.translatePredictionResults(_predictions!);
      
      setState(() {
        _predictions = translatedPredictions;
        
        // Update result text with new translation
        if (translatedPredictions.containsKey('prediction_1')) {
          final topDisease = translatedPredictions['prediction_1'];
          _result = 'تم الكشف: ${topDisease['class_name']}\n\nالثقة: ${topDisease['confidence']}\n\nالوصف: ${topDisease['description']}';
        }
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إعادة ترجمة النتائج'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر إعادة ترجمة النتائج'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() {
        _isTranslating = false;
      });
    }
  }
} 