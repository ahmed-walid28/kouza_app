import '../models/agricultural_tip_model.dart';

class FarmingTipsDatabase {
  static const List<AgriculturalTip> tips = [
    AgriculturalTip(
      id: 'tip_1',
      title: 'تحسين خصوبة التربة بالمادة العضوية',
      content: 'إضافة الكمبوست أو السماد العضوي المتحلل تماماً بمعدل 15-20 م³ للفدان أثناء الخدمة الشتوية يحسن تهوية التربة الطينية ويزيد احتفاظ التربة الرملية بالمياه والمغذيات.',
      category: 'التربة',
      iconEmoji: '🌱',
      isFeatured: true,
    ),
    AgriculturalTip(
      id: 'tip_2',
      title: 'تنظيم الري وقت اشتداد الحرارة',
      content: 'تجنب الري بالغمر أو الرش في أوقات الظهيرة الحارة (بين 12 ظهراً و 4 عصراً) لتفادي صدمة الجذور وتبخر المياه؛ يفضل دائماً الري في الصباح الباكر أو بعد غروب الشمس.',
      category: 'الري',
      iconEmoji: '💧',
      isFeatured: true,
    ),
    AgriculturalTip(
      id: 'tip_3',
      title: 'التسميد البوتاسي ومرحلة التحجيم',
      content: 'عنصر البوتاسيوم هو المحرك الأساسي لنقل السكريات والكربوهيدرات من الأوراق إلى الثمار والدرنات؛ ركز على سلفات البوتاسيوم في مرحلة التحجيم لتحسين الوزن والصلابة.',
      category: 'التسميد',
      iconEmoji: '🧪',
      isFeatured: true,
    ),
    AgriculturalTip(
      id: 'tip_4',
      title: 'أهمية الدورة الزراعية ومقاومة الآفات',
      content: 'تناوب زراعة المحاصيل البقولية (مثل البرسيم، الفول، العدس) مع المحاصيل النجيلية (مثل القمح، الذرة) يكسر دورة حياة الحشرات الفطرية ويغذي الأرض بالنيتروجين الطبيعي.',
      category: 'المحاصيل',
      iconEmoji: '🌾',
      isFeatured: false,
    ),
    AgriculturalTip(
      id: 'tip_5',
      title: 'المكافحة الوقائية لدودة الحشد الخريفية',
      content: 'افحص قلب نباتات الذرة الشامية باستمرار بمجرد الإنبات؛ الرش في الصباح الباكر بالمركبات الحيوية مثل (باسيلوس ثورينجينسيس) يمنع انتشار الدودة قبل توغلها بالبلعوم.',
      category: 'الآفات',
      iconEmoji: '🐛',
      isFeatured: false,
    ),
    AgriculturalTip(
      id: 'tip_6',
      title: 'التعامل مع الصقيع والموجات الباردة',
      content: 'عند توقع موجات صقيع شتوي، قم برية سريعة خفيفة (على الحامي) للأرض مساءً مع رش سلفات البوتاسيوم وسيليكات البوتاسيوم أو الأحماض الأمينية لحماية خلايا النبات.',
      category: 'الطقس',
      iconEmoji: '❄️',
      isFeatured: false,
    ),
    AgriculturalTip(
      id: 'tip_7',
      title: 'علاج ملوحة التربة ومياه الري',
      content: 'استخدام الجبس الزراعي بمعدل 1 - 2 طن للفدان في الأراضي القلوية مع إضافة الهيوميك أسيد ومحسنات التربة يساعد في طرد الصوديوم الضار وتبادله مع الكالسيوم.',
      category: 'التربة',
      iconEmoji: '🧂',
      isFeatured: false,
    ),
    AgriculturalTip(
      id: 'tip_8',
      title: 'حقن الأسمدة مع شبكات الري بالتنقيط (Fertigation)',
      content: 'تجزئة السماد الكيماوي على دفعات صغيرة مع مياه الري بالتنقيط يرفع كفاءة امتصاص النبات للعناصر بنسبة تزيد عن 80% مقارنة بنثر السماد التقليدي.',
      category: 'التسميد',
      iconEmoji: '⚗️',
      isFeatured: false,
    ),
  ];

  static List<AgriculturalTip> getTipsByCategory(String category) {
    if (category == 'الكل') return tips;
    return tips.where((tip) => tip.category == category).toList();
  }

  static AgriculturalTip getDailyTip() {
    final dayIndex = DateTime.now().day % tips.length;
    return tips[dayIndex];
  }
}
