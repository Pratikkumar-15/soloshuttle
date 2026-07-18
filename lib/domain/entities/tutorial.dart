class Tutorial {
  final String id;
  final String title;
  final String description;
  final String category; // 'Strokes', 'Net Play', 'Serves', 'Defense'
  final String level; // 'Beginner', 'Intermediate', 'Advanced'
  final String duration;
  final String thumbnailUrl;
  final String grip;
  final List<String> technique;
  final String contactPoint;
  final String bodyPosition;
  final List<String> commonMistakes;
  final String coachTip;

  const Tutorial({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.duration,
    required this.thumbnailUrl,
    required this.grip,
    required this.technique,
    required this.contactPoint,
    required this.bodyPosition,
    required this.commonMistakes,
    required this.coachTip,
  });
}
