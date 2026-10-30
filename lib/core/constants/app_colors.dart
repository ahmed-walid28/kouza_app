import 'package:flutter/material.dart';

class AppColors {
  // Official Kooza Brand Color Palette (من دليل هوية شخصية كوزة)
  static const Color primary = Color(0xFF2E7D32);       // #2E7D32 الأخضر الزراعي المعتمد
  static const Color primaryDark = Color(0xFF1B5E20);   // أخضر داكن للتباين
  static const Color primaryLight = Color(0xFFA5C76E);  // #A5C76E الأخضر الفاتح (لون النبتة)
  static const Color secondary = Color(0xFF8B5E3C);     // #8B5E3C بني التربة وطمي النيل المعتمد
  static const Color secondaryLight = Color(0xFFD6B98A);// #D6B98A بيج رملي دافئ
  static const Color accent = Color(0xFFE69B24);        // ذهبي الحصاد
  static const Color accentLight = Color(0xFFFFF3CD);   // قمح فاتح

  // Backgrounds
  static const Color background = Color(0xFFFAF7F0);    // خلفية دافئة ناصعة مريحة للعين
  static const Color surface = Colors.white;            // أسطح البطاقات
  static const Color surfaceVariant = Color(0xFFF2E8D0);// #F2E8D0 البيج الكريمي الرسمي المعتمد
  
  // Status Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFE65100);
  static const Color error = Color(0xFFC62828);
  static const Color info = Color(0xFF1565C0);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);   // رمادي داكن واضح
  static const Color textSecondary = Color(0xFF5A6B5C); // رمادي مائل للزيتي
  static const Color textTertiary = Color(0xFF8B9E8E);  // رمادي فاتح
  static const Color textOnPrimary = Colors.white;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFF8B5E3C), Color(0xFFD6B98A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFAF7F0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient harvestGradient = LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFFA5C76E), Color(0xFF8B5E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
