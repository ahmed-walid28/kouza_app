import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../data/models/crop_prediction_result.dart';
import '../../data/models/soil_input_model.dart';
import '../../data/static_data/crops_database.dart';
import '../crop_library/crop_detail_screen.dart';

class PredictionResultScreen extends StatelessWidget {
  final CropPredictionResult result;
  final SoilInput input;

  const PredictionResultScreen({
    super.key,
    required this.result,
    required this.input,
  });

  @override
  Widget build(BuildContext context) {
    final topCropInfo = CropsDatabase.getCrop(result.topCrop.cropKey);
    final topCropName = topCropInfo?.arabicName ?? result.topCrop.arabicName;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('نتيجة تحليل التربة 🌱'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kooza Recommendation Hero Card
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border:
                                Border.all(color: AppColors.accent, width: 2),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              AppAssets.logo,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person,
                                      color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'كوزة شايف إن أنسب محصول لأرضك هو:',
                            style: TextStyle(
                              fontFamily: 'Saudi',
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Top Crop Icon & Name
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            topCropInfo?.iconEmoji ?? '🌱',
                            style: const TextStyle(fontSize: 36),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            topCropName,
                            style: const TextStyle(
                              fontFamily: 'Saudi',
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Confidence Bar
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'نسبة التوافق والتطابق مع التربة:',
                            style: TextStyle(
                              fontFamily: 'Saudi',
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${result.topCrop.confidence.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontFamily: 'Saudi',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Why this crop?
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb_outline,
                              color: AppColors.accent, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'ليه المحصول ده مناسب لأرضك؟',
                            style: TextStyle(
                              fontFamily: 'Saudi',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'التوصية الزراعية مبنية على خصائص التربة التي أدخلتها (N: ${input.nitrogen.toStringAsFixed(0)}, P: ${input.phosphorus.toStringAsFixed(0)}, K: ${input.potassium.toStringAsFixed(0)}, pH: ${input.ph.toStringAsFixed(1)}) بالإضافة لمعدل الحرارة والرطوبة والمطر؛ وتعتبر هذه البيئة مثالية لإنتاجية وجودة محصول $topCropName.',
                        style: const TextStyle(
                          fontFamily: 'Saudi',
                          fontSize: 13,
                          height: 1.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (topCropInfo != null) ...[
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          '🌱 التربة المناسبة: ${topCropInfo.suitableSoil}',
                          style: TextStyle(
                            fontFamily: 'Saudi',
                            fontSize: 12,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '💧 الري: ${topCropInfo.waterRequirements}',
                          style: TextStyle(
                            fontFamily: 'Saudi',
                            fontSize: 12,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CropDetailScreen(crop: topCropInfo),
                                ),
                              );
                            },
                            icon: const Icon(Icons.menu_book, size: 18),
                            label: const Text('عرض الدليل الزراعي الكامل للمحصول'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Alternative Crops
              if (result.alternativeCrops.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    'محاصيل بديلة مناسبة لتربتك 🌱',
                    style: TextStyle(
                      fontFamily: 'Saudi',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...result.alternativeCrops.map((item) {
                  final altInfo = CropsDatabase.getCrop(item.cropKey);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Text(
                        altInfo?.iconEmoji ?? '🌾',
                        style: const TextStyle(fontSize: 26),
                      ),
                      title: Text(
                        item.arabicName,
                        style: const TextStyle(
                          fontFamily: 'Saudi',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        altInfo?.category ?? 'محصول زراعي',
                        style: TextStyle(
                          fontFamily: 'Saudi',
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${item.confidence.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontFamily: 'Saudi',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (altInfo != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CropDetailScreen(crop: altInfo),
                            ),
                          );
                        }
                      },
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],

              // Actions
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.refresh),
                label: const Text('تحليل أرض جديدة 🔄'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم نسخ ملخص التحليل للمشاركة بنجاح! 📋'),
                    ),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('مشاركة نتيجة التحليل 📤'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
