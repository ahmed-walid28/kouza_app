# المعمارية الفنية وتدفق البيانات — تطبيق كــــوزة (Kooza Architecture)

وثيقة معمارية البرمجيات لنظام كوزة، توضح تدفق البيانات من مدخلات المزارع وحتى التنبؤ بنموذج التعلم الآلي وعرض التوصيات الزراعية.

---

## 1. مخطط تدفق البيانات (End-to-End Data Flow)

```mermaid
sequenceDiagram
    autonumber
    actor Farmer as المزارع / المستخدم
    participant UI as واجهة كوزة (SoilAnalysisScreen)
    participant Validation as وحدة التحقق والتنسيق (SoilInput)
    participant Service as خدمة التنبؤ (SoilPredictionService)
    participant TFLite as محرك الذكاء الاصطناعي (ModelService / TFLite)
    participant DB as موسوعة كوزة (CropsDatabase)
    participant ResultUI as شاشة النتيجة (PredictionResultScreen)

    Farmer->>UI: إدخال قيم (N, P, K, pH, Temp, Humidity, Rain) أو جلب GPS
    Farmer->>UI: الضغط على "تحليل التربة وتحديد المحصول"
    UI->>Validation: إنشاء كائن SoilInput والتحقق من النطاقات
    Validation-->>UI: بيانات صالحة (Valid)
    UI->>Service: predictCrop(SoilInput)
    Service->>TFLite: تجهيز المصفوفة [1, 7] وتطبيق معاملات القسمة
    Note over TFLite: Normalization:<br/>N/120, P/100, K/120,<br/>Temp/50, Humidity/100,<br/>pH/14, Rain/300
    TFLite-->>Service: مصفوفة احتمالات [1, 22] لجميع المحاصيل
    Service->>DB: ربط المفاتيح (e.g. 'maize') بالأسماء والتفاصيل العربية
    Service-->>UI: كائن النتيجة المكتمل (CropPredictionResult)
    UI->>ResultUI: الانتقال وعرض المحصول الأول + نسبة التوافق + البدائل + الإرشادات
```

---

## 2. الفصل المعماري بين التعلم الآلي (ML) والمساعد الذكي (Conversational AI)

> [!IMPORTANT]
> **قاعدة الفصل الهندسي:** تم الفصل الكامل بين نظامين ذكيين مستقلين في التطبيق:

1. **نظام توصية المحاصيل (Crop Recommendation ML Model):**
   - **النوع:** نموذج تعلم آلي مصنف (Multi-class Classifier) بصيغة `.tflite`.
   - **المهمة:** حساب احتمالية نجاح كل محصول بناءً على خصائص التربة الكيميائية والفيزيائية والمناخية فقط.
   - **الموقع:** يعمل محلياً بالكامل 100% Offline داخل تطبيق الهاتف.

2. **المساعد الزراعي التفاعلي (Conversational AI Assistant - Ask Kooza):**
   - **النوع:** محرك إجابات واستشارات زراعية تفاعلية.
   - **المهمة:** الرد على استفسارات المزارعين اللغوية حول طرق الري، التسميد، مواعيد الزراعة، والتعامل مع الآفات بلهجة مصرية ودودة.

---

## 3. طبقات البرمجيات (Software Layering)

1. **طبقة الواجهات (Presentation Layer):**
   - `screens/` و `widgets/` معتمدة على مبادئ Clean UI ومتحكمة في الحالة عبر `StatefulWidget` المنظم وتدفق المعطيات الصريح.
2. **طبقة النطاق والبيانات (Data & Domain Layer):**
   - `models/`: تمثيل DTOs مثل `SoilInput` و `CropPredictionResult` و `CropInfo`.
   - `static_data/`: قواعد بيانات زراعية ثابتة موثوقة (`CropsDatabase`, `FarmingTipsDatabase`).
3. **طبقة الخدمات والبنية التحتية (Services & Infrastructure Layer):**
   - `SoilPredictionService` الملتزم بنموذج TFLite دون تعديل.
   - `WeatherService` للاستعلام عن GPS والطقس.
   - `AiAssistantService` لإدارة الحوار الزراعي.
   - `PlantDiseaseService` لفحص الصور عبر API.
