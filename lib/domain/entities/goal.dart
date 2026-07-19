class DailyGoal {
  final String id;
  final String title;
  final String description;
  final int targetMinutes;
  final int completedMinutes;
  final bool isCompleted;
  final int xpReward;
  final String category;

  const DailyGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetMinutes,
    this.completedMinutes = 0,
    this.isCompleted = false,
    this.xpReward = 50,
    this.category = 'Footwork',
  });

  double get progress => targetMinutes > 0 ? (completedMinutes / targetMinutes).clamp(0.0, 1.0) : 0.0;

  DailyGoal copyWith({
    String? id,
    String? title,
    String? description,
    int? targetMinutes,
    int? completedMinutes,
    bool? isCompleted,
    int? xpReward,
    String? category,
  }) {
    return DailyGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      completedMinutes: completedMinutes ?? this.completedMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      xpReward: xpReward ?? this.xpReward,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetMinutes': targetMinutes,
      'completedMinutes': completedMinutes,
      'isCompleted': isCompleted,
      'xpReward': xpReward,
      'category': category,
    };
  }

  factory DailyGoal.fromJson(Map<String, dynamic> json) {
    return DailyGoal(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targetMinutes: json['targetMinutes'] as int? ?? 15,
      completedMinutes: json['completedMinutes'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      xpReward: json['xpReward'] as int? ?? 50,
      category: json['category'] as String? ?? 'Footwork',
    );
  }
}

class WeeklyGoal {
  final String id;
  final String title;
  final int targetDays;
  final int completedDays;
  final int targetSessions;
  final int completedSessions;
  final bool isCompleted;
  final int xpReward;

  const WeeklyGoal({
    required this.id,
    required this.title,
    required this.targetDays,
    this.completedDays = 0,
    required this.targetSessions,
    this.completedSessions = 0,
    this.isCompleted = false,
    this.xpReward = 200,
  });

  double get dayProgress => targetDays > 0 ? (completedDays / targetDays).clamp(0.0, 1.0) : 0.0;

  WeeklyGoal copyWith({
    String? id,
    String? title,
    int? targetDays,
    int? completedDays,
    int? targetSessions,
    int? completedSessions,
    bool? isCompleted,
    int? xpReward,
  }) {
    return WeeklyGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      targetDays: targetDays ?? this.targetDays,
      completedDays: completedDays ?? this.completedDays,
      targetSessions: targetSessions ?? this.targetSessions,
      completedSessions: completedSessions ?? this.completedSessions,
      isCompleted: isCompleted ?? this.isCompleted,
      xpReward: xpReward ?? this.xpReward,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetDays': targetDays,
      'completedDays': completedDays,
      'targetSessions': targetSessions,
      'completedSessions': completedSessions,
      'isCompleted': isCompleted,
      'xpReward': xpReward,
    };
  }

  factory WeeklyGoal.fromJson(Map<String, dynamic> json) {
    return WeeklyGoal(
      id: json['id'] as String,
      title: json['title'] as String,
      targetDays: json['targetDays'] as int? ?? 4,
      completedDays: json['completedDays'] as int? ?? 0,
      targetSessions: json['targetSessions'] as int? ?? 6,
      completedSessions: json['completedSessions'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      xpReward: json['xpReward'] as int? ?? 200,
    );
  }
}

class MonthlyReport {
  final String id;
  final String monthYear;
  final int daysTrained;
  final int totalMinutes;
  final int xpEarned;
  final String strongestSkill;
  final String focusArea;
  final String coachAdvice;
  final List<String> nextMonthGoals;

  const MonthlyReport({
    required this.id,
    required this.monthYear,
    required this.daysTrained,
    required this.totalMinutes,
    required this.xpEarned,
    required this.strongestSkill,
    required this.focusArea,
    required this.coachAdvice,
    required this.nextMonthGoals,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monthYear': monthYear,
      'daysTrained': daysTrained,
      'totalMinutes': totalMinutes,
      'xpEarned': xpEarned,
      'strongestSkill': strongestSkill,
      'focusArea': focusArea,
      'coachAdvice': coachAdvice,
      'nextMonthGoals': nextMonthGoals,
    };
  }

  factory MonthlyReport.fromJson(Map<String, dynamic> json) {
    return MonthlyReport(
      id: json['id'] as String,
      monthYear: json['monthYear'] as String,
      daysTrained: json['daysTrained'] as int? ?? 0,
      totalMinutes: json['totalMinutes'] as int? ?? 0,
      xpEarned: json['xpEarned'] as int? ?? 0,
      strongestSkill: json['strongestSkill'] as String? ?? 'Footwork Speed',
      focusArea: json['focusArea'] as String? ?? 'Backhand Clear',
      coachAdvice: json['coachAdvice'] as String? ?? 'Maintain consistent recovery timing.',
      nextMonthGoals: (json['nextMonthGoals'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
