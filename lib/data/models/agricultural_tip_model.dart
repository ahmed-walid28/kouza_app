class AgriculturalTip {
  final String id;
  final String title;
  final String content;
  final String category; // 'التربة', 'الري', 'المحاصيل', 'الآفات', 'الطقس', 'التسميد'
  final String iconEmoji;
  final bool isFeatured;

  const AgriculturalTip({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.iconEmoji,
    this.isFeatured = false,
  });
}
