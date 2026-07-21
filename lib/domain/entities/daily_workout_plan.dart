class DailyWorkoutPlan {
  final String id;
  final String dayName;
  final String pillar; // 'Footwork', 'Reaction', 'Technique', 'Physical', 'Recovery'
  final String title;
  final String subtitle;
  final String description;
  final int durationMinutes;
  final int xpReward;
  final String drillId;
  final String coachFocus;
  final List<String> targetSkills;

  const DailyWorkoutPlan({
    required this.id,
    required this.dayName,
    required this.pillar,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.durationMinutes,
    required this.xpReward,
    required this.drillId,
    required this.coachFocus,
    required this.targetSkills,
  });

  DailyWorkoutPlan copyWith({
    String? id,
    String? dayName,
    String? pillar,
    String? title,
    String? subtitle,
    String? description,
    int? durationMinutes,
    int? xpReward,
    String? drillId,
    String? coachFocus,
    List<String>? targetSkills,
  }) {
    return DailyWorkoutPlan(
      id: id ?? this.id,
      dayName: dayName ?? this.dayName,
      pillar: pillar ?? this.pillar,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      xpReward: xpReward ?? this.xpReward,
      drillId: drillId ?? this.drillId,
      coachFocus: coachFocus ?? this.coachFocus,
      targetSkills: targetSkills ?? this.targetSkills,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayName': dayName,
      'pillar': pillar,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'durationMinutes': durationMinutes,
      'xpReward': xpReward,
      'drillId': drillId,
      'coachFocus': coachFocus,
      'targetSkills': targetSkills,
    };
  }

  factory DailyWorkoutPlan.fromJson(Map<String, dynamic> json) {
    return DailyWorkoutPlan(
      id: json['id'] as String,
      dayName: json['dayName'] as String,
      pillar: json['pillar'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      description: json['description'] as String,
      durationMinutes: json['durationMinutes'] as int,
      xpReward: json['xpReward'] as int,
      drillId: json['drillId'] as String,
      coachFocus: json['coachFocus'] as String,
      targetSkills: List<String>.from(json['targetSkills'] ?? []),
    );
  }
}
