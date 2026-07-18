class Drill {
  final String id;
  final String title;
  final String description;
  final String objective;
  final String duration;
  final int durationSeconds;
  final String difficulty; // 'Beginner', 'Intermediate', 'Advanced'
  final int xpReward;
  final String categoryId;
  final String categoryName;
  final String emoji;
  final List<String> instructions;
  final String coachCue;
  final List<String> commonMistakes;
  final bool isFavorite;

  const Drill({
    required this.id,
    required this.title,
    required this.description,
    required this.objective,
    required this.duration,
    required this.durationSeconds,
    required this.difficulty,
    required this.xpReward,
    required this.categoryId,
    required this.categoryName,
    this.emoji = '🏸',
    this.instructions = const [],
    this.coachCue = '',
    this.commonMistakes = const [],
    this.isFavorite = false,
  });

  Drill copyWith({
    String? id,
    String? title,
    String? description,
    String? objective,
    String? duration,
    int? durationSeconds,
    String? difficulty,
    int? xpReward,
    String? categoryId,
    String? categoryName,
    String? emoji,
    List<String>? instructions,
    String? coachCue,
    List<String>? commonMistakes,
    bool? isFavorite,
  }) {
    return Drill(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      objective: objective ?? this.objective,
      duration: duration ?? this.duration,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      difficulty: difficulty ?? this.difficulty,
      xpReward: xpReward ?? this.xpReward,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      emoji: emoji ?? this.emoji,
      instructions: instructions ?? this.instructions,
      coachCue: coachCue ?? this.coachCue,
      commonMistakes: commonMistakes ?? this.commonMistakes,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
