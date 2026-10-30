import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/agricultural_tip_model.dart';
import '../../data/static_data/farming_tips_database.dart';
import '../../widgets/kooza_character_card.dart';

class AgriculturalTipsScreen extends StatefulWidget {
  const AgriculturalTipsScreen({super.key});

  @override
  State<AgriculturalTipsScreen> createState() => _AgriculturalTipsScreenState();
}

class _AgriculturalTipsScreenState extends State<AgriculturalTipsScreen> {
  String _selectedCategory = 'الكل';

  final List<String> _categories = [
    'الكل',
    'التربة',
    'الري',
    'التسميد',
    'المحاصيل',
    'الآفات',
    'الطقس',
  ];

  @override
  Widget build(BuildContext context) {
    final tips = FarmingTipsDatabase.getTipsByCategory(_selectedCategory);
    final dailyTip = FarmingTipsDatabase.getDailyTip();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('نصائح وإرشادات كوزة 💡🌱'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Daily Tip Hero Card
            KoozaCharacterCard(
              title: 'نصيحة كوزة لليوم 🌾',
              message: '${dailyTip.title}:\n${dailyTip.content}',
            ),
            const SizedBox(height: 16),

            // Filter Chips
            const Text(
              'تصنيفات النصائح الزراعية',
              style: TextStyle(
                fontFamily: 'Saudi',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        fontFamily: 'Saudi',
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Tips List
            ...tips.map((tip) => _buildTipCard(tip)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(AgriculturalTip tip) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              tip.iconEmoji,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        title: Text(
          tip.title,
          style: const TextStyle(
            fontFamily: 'Saudi',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            'تصنيف: ${tip.category}',
            style: TextStyle(
              fontFamily: 'Saudi',
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tip.content,
                style: const TextStyle(
                  fontFamily: 'Saudi',
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
