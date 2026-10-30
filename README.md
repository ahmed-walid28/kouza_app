# كــــوزة (Kooza) — مساعدك الزراعي الذكي 🌱🇪🇬
### Your Smart Agricultural Assistant

تطبيق زراعي ذكي مبني بإطار عمل **Flutter** ومدعوم بنموذج تعلم آلي مدمج (**TensorFlow Lite**) ومساعد محادثة ذكي (**Conversational AI**)، مصمم خصيصاً لخدمة المزارع المصري وطلاب كليات الزراعة والباحثين في تحسين إنتاجية المحاصيل وإدارة التربة والمياه.

---

## 🌟 مميزات التطبيق الرئيسية (Core Features)

1. **تحليل التربة وتوصية المحاصيل الذكية (Soil Analysis & ML Recommendation):**
   - استدلال محلي فائق السرعة عبر نموذج `crop_recommendation_model.tflite` دون الحاجة للإنترنت.
   - تحليل 7 مدخلات أساسية: النيتروجين ($N$)، الفوسفور ($P$)، البوتاسيوم ($K$)، درجة الحموضة ($pH$)، الحرارة، الرطوبة، ومعدل المطر.
   - ترشيح المحصول الأمثل من بين 22 محصولاً زراعياً مع نسبة التوافق وقائمة المحاصيل البديلة.

2. **موسوعة المحاصيل الزراعية (22 Verified Crop Profiles):**
   - دليل معرفي شامل لكل محصول يوضح نوع التربة المناسبة، الاحتياجات المائية، الحرارة المثلى، مواسم الزراعة، وأهم إرشادات الخدمة والتحذيرات.

3. **اسأل كوزة — المساعد الزراعي الذكي (Ask Kooza AI Chatbot):**
   - مستشار زراعي ودود يتحدث باللهجة المصرية/العربية المبسطة للإجابة عن أسئلة التسميد والري ومشاكل التربة وأعراض نقص العناصر.

4. **نصائح كوزة الزراعية اليومية (Categorized Daily Tips):**
   - نصائح يومية مقسمة حسب الفئات (التربة، الري، التسميد، الآفات، الطقس، المحاصيل).

5. **كشف أمراض النبات بالصور (Plant Disease Detection):**
   - إمكانية تصوير أو رفع صور أوراق النبات للتشخيص السريع للأمراض والأعراض الشائعة.

6. **الطقس والمناخ التلقائي عبر GPS (Weather & Climate Integration):**
   - إمكانية جلب قراءات الطقس الحالية مباشرة من موقع الحقل لتسهيل عملية التحليل.

---

## 🔬 مواصفات نموذج الذكاء الاصطناعي (ML Technical Specs)

- **الملف:** `assets/crop_recommendation_model.tflite`
- **حجم النموذج:** 16.3 KB
- **مصفوفة المدخلات (Input Tensor):** `[1, 7]` بقيم معيارية مقسومة على القواسم التدريبية:
  1. `Nitrogen`: مقسوم على `120.0`
  2. `Phosphorus`: مقسوم على `100.0`
  3. `Potassium`: مقسوم على `120.0`
  4. `Temperature`: مقسوم على `50.0`
  5. `Humidity`: مقسوم على `100.0`
  6. `pH`: مقسوم على `14.0`
  7. `Rainfall`: مقسوم على `300.0`
- **مصفوفة المخرجات (Output Tensor):** `[1, 22]` احتمالات الـ 22 محصولاً.
- **المحاصيل المدعومة:** التفاح، الموز، الماش الأسود، الحمص، جوز الهند، البن، القطن، العنب، الجوت، الفاصوليا الحمراء، العدس، الذرة، المانجو، لوبيا موث، الماش، الشمام، البرتقال، البابايا، بازلاء الحمام، الرمان، الأرز، البطيخ.

---

## 🏛️ هيكلية الكود (Folder Structure)

```
lib/
├── core/
│   ├── constants/ (app_colors.dart, app_strings.dart, app_assets.dart)
│   └── theme/ (app_theme.dart)
├── data/
│   ├── models/ (soil_input_model.dart, crop_prediction_result.dart, crop_info_model.dart, ...)
│   └── static_data/ (crops_database.dart, farming_tips_database.dart)
├── services/
│   ├── soil_prediction_service.dart  # تغليف آمن لنموذج التعلم الآلي TFLite
│   ├── weather_service.dart          # خدمة الطقس و GPS
│   ├── ai_assistant_service.dart     # محرك المساعد الزراعي الذكي
│   ├── plant_disease_service.dart    # فحص أمراض النبات
│   └── translation_service.dart      # الترجمة والمصطلحات
├── screens/
│   ├── splash/ (kooza_splash_screen.dart)
│   ├── onboarding/ (kooza_onboarding_screen.dart)
│   ├── main_layout/ (kooza_main_navigation_screen.dart)
│   ├── home/ (kooza_home_screen.dart)
│   ├── soil_analysis/ (soil_analysis_screen.dart, prediction_result_screen.dart)
│   ├── crop_library/ (crop_library_screen.dart, crop_detail_screen.dart)
│   ├── tips/ (agricultural_tips_screen.dart)
│   ├── ai_assistant/ (ask_kooza_screen.dart)
│   └── plant_disease_detection.dart
└── widgets/ (kooza_character_card.dart, custom_text_field.dart, stat_card.dart, loading_dialog.dart)
```

---

## 🚀 تشغيل المشروع (How to Run)

1. تأكد من تثبيت بيئة **Flutter SDK 3.x** و **Dart 3.5+**:
   ```bash
   flutter doctor
   ```
2. تثبيت الحزم والمكتبات:
   ```bash
   flutter pub get
   ```
3. تشغيل الاختبارات الآلية:
   ```bash
   flutter test
   ```
4. تشغيل التطبيق على الهاتف أو المحاكي:
   ```bash
   flutter run --dart-define=OPENWEATHER_API_KEY=YOUR_API_KEY
   ```

   مفتاح OpenWeather لا يتم تخزينه داخل الكود أو المستودع. استبدل
   `YOUR_API_KEY` بمفتاحك المحلي عند التشغيل، ولا تضع المفتاح الحقيقي في
   ملفات المشروع المرفوعة إلى GitHub.
