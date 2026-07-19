class Tutorial {
  final String id;
  final String title;
  final String description;
  final String category; // 'Front Court', 'Mid Court', 'Rear Court'
  final String level; // 'Beginner', 'Intermediate', 'Advanced'
  final String duration;
  final String thumbnailUrl;
  final String grip;
  final List<String> technique;
  final String contactPoint;
  final String bodyPosition;
  final List<String> commonMistakes;
  final String coachTip;
  final List<String> matchSituations;
  final List<String> learningObjectives;
  final List<String> practiceSuggestions;
  final String youtubeUrl;
  final String youtubeTitle;

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
    this.matchSituations = const [],
    this.learningObjectives = const [],
    this.practiceSuggestions = const [],
    this.youtubeUrl = '',
    this.youtubeTitle = '',
  });
}

