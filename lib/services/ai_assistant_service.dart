import '../data/models/chat_message_model.dart';

class AiAssistantService {
  /// Generates a friendly, expert Egyptian agricultural response for Kooza.
  Future<ChatMessage> getResponse(String userQuestion) async {
    // Simulate brief thinking time for realism
    await Future.delayed(const Duration(milliseconds: 600));

    final cleanQuestion = userQuestion.toLowerCase().trim();

    // 1. Soil types & sandy soil questions
    if (cleanQuestion.contains('رملي') || cleanQuestion.contains('تربة رملية') || cleanQuestion.contains('أرض رملية')) {
      return ChatMessage(
        text: 'أهلاً بيك يا غالي! 🌾 لو أرضك رملية، فدي مميزاتها إنها خفيفة وجيدة التهوية، بس عيبها إنها بتسرّب المية والعناصر بسرعة.\n\n'
            '🌱 **نصائح كوزة للأرض الرملية:**\n'
            '1. زوّد المادة العضوية والكمبوست المتحلل سنوياً لزيادة قدرتها على مسك المية.\n'
            '2. اعتمد على الري بالتنقيط على فترات متقاربة وكميات مية معتدلة.\n'
            '3. جزّأ التسميد الكيماوي على دفعات صغيرة مع ماء الري (الفرتيجيشن).\n'
            '4. من أنسب المحاصيل للأراضي الرملية: الفول السوداني، البطيخ، الكانتلوب، المانجو، والعنب.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedActions: const ['أنسب محاصيل للأرض الرملية', 'طريقة إضافة الكمبوست', 'حل مشكلة الملوحة'],
      );
    }

    // 2. Clay / delta soil questions
    if (cleanQuestion.contains('طين') || cleanQuestion.contains('أرض طينية') || cleanQuestion.contains('تربة طينية')) {
      return ChatMessage(
        text: 'يا مرحب بيك! 🌿 الأرض الطينية (أرض الدلتا والوادي السمراء) دي خير وبركة، بتحتفظ بالمية والغذاء كويس جداً.\n\n'
            '🌱 **إرشادات كوزة للأرض الطينية:**\n'
            '1. اهتم بنظافة وتعميق المصارف عشان تمنع تعفن الجذور والملوحة.\n'
            '2. احرث الأرض حرث عميق متعامد وسيبها تتشمس قبل الزراعة.\n'
            '3. متسقيش والأرض لسة طرية عشان متعملش كتمة للجذور.\n'
            '4. أنسب المحاصيل: القمح، الأرز، الذرة الشامية، والقطن المصري.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedActions: const ['مواعيد ري الأرض الطينية', 'تجهيز الأرض للقمح', 'خدمة محصول الذرة'],
      );
    }

    // 3. Yellow leaves / Nutrient deficiency
    if (cleanQuestion.contains('اصفر') || cleanQuestion.contains('أصفر') || cleanQuestion.contains('الورق اصفر') || cleanQuestion.contains('اصفرار')) {
      return ChatMessage(
        text: 'سلامة زرعك يا هندسة! 🌱 اصفرار الأوراق له كذا سبب رئيسي:\n\n'
            '1. **لو الاصفرار في الأوراق القديمة (السفلية):** يبقى نقص نيتروجين (أزوت)، محتاج تسميد يوريا أو نترات نشادر.\n'
            '2. **لو الاصفرار في القمم النامية والورق الجديد:** يبقى غالباً نقص حديد أو زنك، رشه بعناصر صغرى مخلبية.\n'
            '3. **لو الاصفرار مصحوب بذبول عام:** راجع الصرف، ممكن تكون مية زيادة سببت عفن جذور.\n\n'
            '⚠️ *نصيحة كوزة:* افحص الجذور الأول، ولو شاكك في إصابة فطرية، استشير المرشد الزراعي أو مهندس الجمعية الزراعية لمعاينة الحقل مباشرة.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedActions: const ['تسميد العناصر الصغرى', 'أعفان الجذور وطرق علاجها', 'تحليل التربة أولاً'],
      );
    }

    // 4. Wheat planting
    if (cleanQuestion.contains('قمح') || cleanQuestion.contains('غلة')) {
      return ChatMessage(
        text: 'القمح ده عمود البيت والخير كله! 🌾\n\n'
            '📅 **الميعاد الأمثل:** من 15 نوفمبر حتى 30 نوفمبر (أمثل وقت في مصر بدون تأخير).\n'
            '💧 **رية المحاياة:** بعد 21 - 25 يوم من الزراعة مع إضافة الدفعة الأولى من السماد النيتروجيني.\n'
            '🌾 **أهم الأصناف الموصى بها:** مصر 3، سخا 95، جيزة 171، سدس 14.\n'
            '⚠️ تجنب الري وقت هبوب الرياح الشديدة لتفادي الرقاد.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedActions: const ['تسميد القمح', 'مكافحة حشرة المن في القمح', 'رية المحاياة'],
      );
    }

    // 5. Corn / Maize
    if (cleanQuestion.contains('ذرة') || cleanQuestion.contains('ذره') || cleanQuestion.contains('عرانيس')) {
      return ChatMessage(
        text: 'الذرة محصول صيفي أساسي ومربح جداً! 🌽\n\n'
            '🌱 **الميعاد:** شهر مايو حتى منتصف يونيو.\n'
            '💧 **الري:** كل 10 - 12 يوم، وإياك تعطش الذرة وقت طرد الشواشي والتزهير لأن ده بيعمل عرانيس فارغة.\n'
            '🐛 **الآفات:** احذر من دودة الحشد الخريفية، ورش بقعة الإصابة بالمبيدات الحيوية الموصى بها أول بأول.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedActions: const ['مكافحة دودة الحشد', 'تسميد الذرة الشامية', 'تحليل التربة لمحصول الذرة'],
      );
    }

    // 6. Fertilization & NPK
    if (cleanQuestion.contains('سماد') || cleanQuestion.contains('تسميد') || cleanQuestion.contains('يوريا') || cleanQuestion.contains('بوتاسيوم') || cleanQuestion.contains('فوسفور')) {
      return ChatMessage(
        text: 'التسميد فن وميزان يا صديقي! 🧪\n\n'
            '1. **النيتروجين (N):** للنمو الخضري والأوراق الخضراء (يوريا / نترات / سلفات نشادر).\n'
            '2. **الفوسفور (P):** لبناء الجذور القوية والتزهير (سوبر فوسفات وقت الخدمة).\n'
            '3. **البوتاسيوم (K):** للتحجيم وتعبئة الثمار وزيادة السكر والصلابة (سلفات بوتاسيوم).\n\n'
            '💡 *نصيحة كوزة:* متسمدش عشوائي، استخدم شاشة **تحليل التربة** في التطبيق عشان تعرف أرضك محتاجة إيه بالظبط.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedActions: const ['انتقل لتحليل التربة', 'أعراض نقص العناصر', 'السماد العضوي'],
      );
    }

    // 7. Irrigation / Watering
    if (cleanQuestion.contains('ري') || cleanQuestion.contains('سقاية') || cleanQuestion.contains('اسقي') || cleanQuestion.contains('مية')) {
      return ChatMessage(
        text: 'الري المضبوط هو سر نجاح أي زرعة! 💧\n\n'
            '🌱 **القواعد الذهبية لكوزة في الري:**\n'
            '1. اسقي في الصباح الباكر أو بعد انكسار حرارة الشمس.\n'
            '2. متسقيش بالظهيرة عشان الجذور متتسلقش من سخونة المية.\n'
            '3. افحص رطوبة التربة على عمق 5 سم قبل ما تقرر تروي.\n'
            '4. في الأيام الحارة، قصر الفترات بين الريات وخفف كمية المية.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedActions: const ['أجهزة قياس الرطوبة', 'الري بالتنقيط', 'أوقات الري في الصيف'],
      );
    }

    // 8. Pests / Diseases general
    if (cleanQuestion.contains('مرض') || cleanQuestion.contains('حشرة') || cleanQuestion.contains('ديدان') || cleanQuestion.contains('رش') || cleanQuestion.contains('مبيد')) {
      return ChatMessage(
        text: 'الوقاية دائماً خير من العلاج يا هندسة! 🐛\n\n'
            '1. النظافة الحقلية وإزالة الحشائش هي أول خط دفاع ضد الحشرات.\n'
            '2. التسميد المتوازن بيقوي جدار الخلايا ويخلي النبات مقاوم طبيعي.\n'
            '3. استخدم ميزة **كشف الأمراض** في التطبيق لتصوير ورقة النبات وفحصها وتشخيص حالتها بدقة.\n\n'
            '⚠️ *تنبيه هام:* عند استخدام أي مبيد كيميائي، التزم بجرعات الشركة المصنعة وفترة الأمان قبل الحصاد (PHI)، واستشر مهندس زراعي مختص.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedActions: const ['افتح كاميرا كشف الأمراض', 'فترة الأمان للمبيدات', 'المكافحة الحيوية'],
      );
    }

    // Default Fallback
    return ChatMessage(
      text: 'يا هلا بيك! أنا كوزة رفيقك الزراعي المعتمد 🌱\n\n'
          'أنا هنا عشان أساعدك في كل ما يخص الزراعة المصرية، زي:\n'
          '• اختيار أفضل محصول يطرح في أرضك بناءً على تحليل التربة.\n'
          '• مواعيد التسميد والري ومقاومة الآفات.\n'
          '• نصائح مخصصة لمحاصيل الدلتا والصعيد والأراضي الجديدة.\n\n'
          'اسألني عن أي محصول أو مشكلة في التربة، وهجاوبك فوراً بإذن الله!',
      isUser: false,
      timestamp: DateTime.now(),
      suggestedActions: const ['أزرع إيه في أرضي؟', 'علاج اصفرار الأوراق', 'أفضل مواعيد لزراعة القمح', 'نصائح لتسميد الذرة'],
    );
  }
}
