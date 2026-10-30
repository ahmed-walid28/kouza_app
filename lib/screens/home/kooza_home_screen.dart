import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';
import '../../data/static_data/farming_tips_database.dart';
import '../../widgets/kooza_character_card.dart';
import '../plant_disease_detection.dart';
import '../survay_screen.dart';

class KoozaHomeScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const KoozaHomeScreen({super.key, required this.onNavigateTab});

  @override
  State<KoozaHomeScreen> createState() => _KoozaHomeScreenState();
}

class _KoozaHomeScreenState extends State<KoozaHomeScreen> {
  int _currentBannerIndex = 0;

  final List<Map<String, String>> _newsArticles = [
    {
      'title': 'أصناف جديدة من القمح والذرة مقاومة للجفاف والحرارة',
      'date': 'اليوم',
      'image': AppAssets.image1,
    },
    {
      'title': 'أحدث الطرق العلمية لترشيد مياه الري والتسميد الحديث',
      'date': 'أمس',
      'image': AppAssets.image2,
    },
    {
      'title': 'برامج التوعية والإرشاد الزراعي الرقمي لدعم المزارع المصري',
      'date': 'منذ يومين',
      'image': AppAssets.image3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final dailyTip = FarmingTipsDatabase.getDailyTip();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(child: Image.asset(AppAssets.logo)),
              ),
              const SizedBox(width: 8),
              const Text(
                'كوزة - Kouza | مساعدك الزراعي',
                style: TextStyle(
                  fontFamily: 'Saudi',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 500));
            setState(() {});
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 1. Kooza Greeting & Character Hero Card
              KoozaCharacterCard(
                title: 'أهلاً بيك يا حاج 👋',
                message: AppStrings.koozaGreeting,
                actionButton: ElevatedButton.icon(
                  onPressed: () => widget.onNavigateTab(1), // Soil Analysis tab
                  icon: const Icon(Icons.analytics_outlined, size: 18),
                  label: const Text('ابدأ تحليل تربتك الآن 🌱'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Main Soil Analysis Hero Banner
              GestureDetector(
                onTap: () => widget.onNavigateTab(1),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.biotech,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تحليل التربة وترشيح المحصول',
                              style: TextStyle(
                                fontFamily: 'Saudi',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              AppStrings.koozaSoilPrompt,
                              style: TextStyle(
                                fontFamily: 'Saudi',
                                fontSize: 12,
                                color: Colors.white70,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 3. Quick Action Grid
              _buildSectionHeader('الخدمات الذكية السريعة ⚡'),
              const SizedBox(height: 10),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _buildServiceCard(
                    title: 'تحليل التربة',
                    subtitle: 'توصية المحصول الأنسب',
                    icon: Icons.science_outlined,
                    color: AppColors.primary,
                    onTap: () => widget.onNavigateTab(1),
                  ),
                  _buildServiceCard(
                    title: 'موسوعة المحاصيل',
                    subtitle: 'دليل 22 محصول زراعي',
                    icon: Icons.menu_book,
                    color: AppColors.secondary,
                    onTap: () => widget.onNavigateTab(2),
                  ),
                  _buildServiceCard(
                    title: 'اسأل كوزة 🌱',
                    subtitle: 'مستشارك الزراعي الموثوق',
                    icon: Icons.chat_bubble_outline,
                    color: const Color(0xFF2E7D32),
                    onTap: () => widget.onNavigateTab(4),
                  ),
                  _buildServiceCard(
                    title: 'كشف الأمراض 📸',
                    subtitle: 'فحص النبات بالصور',
                    icon: Icons.document_scanner_outlined,
                    color: Colors.orange.shade800,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PlantDiseaseDetectionScreen(
                                  isEnglish: false),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 4. Daily Tip Card
              _buildSectionHeader('نصيحة اليوم من كوزة 💡🌱'),
              const SizedBox(height: 8),
              Card(
                color: const Color(0xFFF1F8E9),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          dailyTip.iconEmoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dailyTip.title,
                              style: const TextStyle(
                                fontFamily: 'Saudi',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dailyTip.content,
                              style: TextStyle(
                                fontFamily: 'Saudi',
                                fontSize: 12,
                                height: 1.4,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 5. News & Awareness Carousel
              _buildSectionHeader('أخبار وإرشادات زراعية 📰'),
              const SizedBox(height: 10),

              CarouselSlider(
                options: CarouselOptions(
                  height: 180.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.9,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentBannerIndex = index;
                    });
                  },
                ),
                items: _newsArticles.map((article) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage(article['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.all(14.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              article['title']!,
                              style: const TextStyle(
                                fontFamily: 'Saudi',
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _newsArticles.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentBannerIndex == index ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentBannerIndex == index
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 6. Community / Survey Option
              Card(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.assignment_outlined,
                        color: AppColors.primary),
                  ),
                  title: const Text(
                    'استبيان المزارع الميداني 📋',
                    style: TextStyle(
                      fontFamily: 'Saudi',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'شاركنا بيانات أرضك ومحاصيلك لتحسين دقة التوصيات',
                    style: TextStyle(fontFamily: 'Saudi', fontSize: 11),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SurveyScreen(isEnglish: false),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Saudi',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryDark,
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Saudi',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Saudi',
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
