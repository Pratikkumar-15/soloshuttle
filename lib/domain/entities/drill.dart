enum PhaseType {
  explanation,
  work,
  rest,
  coachCue,
  finalChallenge,
}

class DrillPhase {
  final String title;
  final String description;
  final int durationSeconds;
  final PhaseType type;
  final String? coachTip;

  const DrillPhase({
    required this.title,
    required this.description,
    required this.durationSeconds,
    required this.type,
    this.coachTip,
  });
}

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
  final List<String> skillsImproved;
  final List<String> equipmentRequired;
  final List<String> safetyReminders;
  final List<String> coachingTips;
  final List<DrillPhase> phases;
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
    this.skillsImproved = const [],
    this.equipmentRequired = const [],
    this.safetyReminders = const [],
    this.coachingTips = const [],
    this.phases = const [],
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
    List<String>? skillsImproved,
    List<String>? equipmentRequired,
    List<String>? safetyReminders,
    List<String>? coachingTips,
    List<DrillPhase>? phases,
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
      skillsImproved: skillsImproved ?? this.skillsImproved,
      equipmentRequired: equipmentRequired ?? this.equipmentRequired,
      safetyReminders: safetyReminders ?? this.safetyReminders,
      coachingTips: coachingTips ?? this.coachingTips,
      phases: phases ?? this.phases,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

