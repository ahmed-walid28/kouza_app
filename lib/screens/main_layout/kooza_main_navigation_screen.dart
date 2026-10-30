import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../home/kooza_home_screen.dart';
import '../soil_analysis/soil_analysis_screen.dart';
import '../crop_library/crop_library_screen.dart';
import '../tips/agricultural_tips_screen.dart';
import '../ai_assistant/ask_kooza_screen.dart';

class KoozaMainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const KoozaMainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<KoozaMainNavigationScreen> createState() =>
      _KoozaMainNavigationScreenState();
}

class _KoozaMainNavigationScreenState extends State<KoozaMainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      KoozaHomeScreen(onNavigateTab: _onTabSelected),
      const SoilAnalysisScreen(),
      const CropLibraryScreen(),
      const AgriculturalTipsScreen(),
      const AskKoozaScreen(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabSelected,
          backgroundColor: Colors.white,
          elevation: 8,
          indicatorColor: AppColors.primaryLight.withValues(alpha: 0.18),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.primary),
              label: AppStrings.navHome,
            ),
            NavigationDestination(
              icon: Icon(Icons.science_outlined),
              selectedIcon: Icon(Icons.science, color: AppColors.primary),
              label: AppStrings.navSoilAnalysis,
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book, color: AppColors.primary),
              label: AppStrings.navCrops,
            ),
            NavigationDestination(
              icon: Icon(Icons.lightbulb_outline),
              selectedIcon: Icon(Icons.lightbulb, color: AppColors.primary),
              label: AppStrings.navTips,
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon:
                  Icon(Icons.chat_bubble, color: AppColors.primary),
              label: AppStrings.navAssistant,
            ),
          ],
        ),
      ),
    );
  }
}
