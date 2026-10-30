class CropInfo {
  final String key;
  final String arabicName;
  final String englishName;
  final String category;
  final String description;
  final String suitableSoil;
  final String waterRequirements;
  final String idealTemperature;
  final String growingSeason;
  final List<String> careTips;
  final List<String> commonWarnings;
  final String iconEmoji;

  const CropInfo({
    required this.key,
    required this.arabicName,
    required this.englishName,
    required this.category,
    required this.description,
    required this.suitableSoil,
    required this.waterRequirements,
    required this.idealTemperature,
    required this.growingSeason,
    required this.careTips,
    required this.commonWarnings,
    required this.iconEmoji,
  });
}
