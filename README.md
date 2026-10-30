# Kooza - Smart Agricultural Assistant

<p align="center">
  <img src="assets/kouza_icon_app.png" alt="Kooza app icon" width="220">
</p>

Kooza is a Flutter application designed to help farmers, agriculture students,
and researchers improve crop production and manage soil, irrigation, and plant
health. The app combines local machine learning, agricultural knowledge, an AI
assistant, and live weather data in a simple Arabic-friendly experience.

## Features

### Soil Analysis and Crop Recommendations

- Runs local TensorFlow Lite inference without requiring an internet
  connection.
- Analyzes seven inputs:
  nitrogen, phosphorus, potassium, pH, temperature, humidity, and rainfall.
- Recommends the most suitable crop from 22 supported crops.
- Displays the recommendation score and alternative crop suggestions.

### Crop Library

Includes agricultural profiles for 22 crops with information about:

- Suitable soil types
- Water requirements
- Recommended temperatures
- Planting seasons
- Growing guidance and warnings

### Ask Kooza AI Assistant

The conversational agricultural assistant answers questions about:

- Fertilization
- Irrigation
- Soil problems
- Plant symptoms
- Nutrient deficiencies

### Daily Agricultural Tips

Tips are organized into practical categories, including soil, irrigation,
fertilization, pests, weather, and crops.

### Plant Disease Detection

Users can take or upload a plant leaf photo for quick detection of common
diseases and symptoms.

### Live Weather Integration

The app can use the device location to retrieve current weather conditions,
including temperature, humidity, rainfall, and a localized weather description.

## Technical Overview

- **Framework:** Flutter
- **Language:** Dart
- **Machine learning:** TensorFlow Lite
- **Weather provider:** OpenWeather
- **Platforms:** Android, iOS, Linux, macOS, Web, and Windows

### Crop Recommendation Model

- **Model:** `assets/crop_recommendation_model.tflite`
- **Input tensor:** `[1, 7]`
- **Output tensor:** `[1, 22]`
- **Supported crops:** apple, banana, black gram, chickpea, coconut, coffee,
  cotton, grapes, jute, kidney beans, lentil, maize, mango, moth beans, mung
  bean, muskmelon, orange, papaya, pigeon peas, pomegranate, rice, and
  watermelon.

The model normalizes inputs using the following divisors:

| Input | Divisor |
|---|---:|
| Nitrogen | `120.0` |
| Phosphorus | `100.0` |
| Potassium | `120.0` |
| Temperature | `50.0` |
| Humidity | `100.0` |
| pH | `14.0` |
| Rainfall | `300.0` |

## Project Structure

```text
lib/
├── core/
│   ├── constants/       # Colors, strings, and asset references
│   └── theme/           # Application theme
├── data/
│   ├── models/          # Application data models
│   └── static_data/     # Crop profiles and agricultural tips
├── services/
│   ├── soil_prediction_service.dart
│   ├── weather_service.dart
│   ├── ai_assistant_service.dart
│   ├── plant_disease_service.dart
│   └── translation_service.dart
├── screens/
│   ├── splash/
│   ├── onboarding/
│   ├── main_layout/
│   ├── home/
│   ├── soil_analysis/
│   ├── crop_library/
│   ├── tips/
│   ├── ai_assistant/
│   └── plant_disease_detection.dart
└── widgets/             # Reusable UI components
```

## Requirements

- Flutter SDK 3.x
- Dart 3.5 or later
- An OpenWeather API key for live weather data

Check your Flutter installation with:

```bash
flutter doctor
```

## Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/ahmed-walid28/kouza_app.git
   cd kouza_app
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the tests:

   ```bash
   flutter test
   ```

4. Run static analysis:

   ```bash
   flutter analyze
   ```

5. Run the application:

   ```bash
   flutter run --dart-define=OPENWEATHER_API_KEY=YOUR_API_KEY
   ```

Replace `YOUR_API_KEY` with your local OpenWeather API key.

## API Key Security

The OpenWeather API key is intentionally not stored in the source code or
repository. Pass it at build or run time using
`--dart-define=OPENWEATHER_API_KEY=YOUR_API_KEY`.

Do not commit API keys, passwords, tokens, or other credentials to the
repository. If a key has previously been exposed, revoke it and create a new
one from the provider dashboard.

## License

No license has been specified for this project yet.
