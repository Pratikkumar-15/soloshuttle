class UserProfile {
  final String name;
  final String avatarUrl;
  final int level;
  final int currentXp;
  final int xpNeededForNextLevel;
  final int currentStreak;
  final int completedSessions;
  final int totalMinutes;
  final String favoriteDrill;
  final String dominantHand;

  const UserProfile({
    this.name = 'Keshav',
    this.avatarUrl = 'assets/images/logo.png',
    this.level = 4,
    this.currentXp = 450,
    this.xpNeededForNextLevel = 1000,
    this.currentStreak = 12,
    this.completedSessions = 74,
    this.totalMinutes = 1680,
    this.favoriteDrill = 'Smash Repetition',
    this.dominantHand = 'Right',
  });

  // Automatically calculated skill level based on XP, sessions, minutes, and streak
  String get calculatedSkillLevel {
    if (currentXp >= 5000 || completedSessions >= 75 || totalMinutes >= 1800) {
      return 'Pro Player';
    } else if (currentXp >= 2000 || completedSessions >= 30 || totalMinutes >= 600) {
      return 'Advanced';
    } else if (currentXp >= 500 || completedSessions >= 10 || totalMinutes >= 120) {
      return 'Intermediate';
    }
    return 'Beginner';
  }

  String get calculatedLevelTitle {
    return '$calculatedSkillLevel (Level $level)';
  }

  UserProfile copyWith({
    String? name,
    String? avatarUrl,
    int? level,
    int? currentXp,
    int? xpNeededForNextLevel,
    int? currentStreak,
    int? completedSessions,
    int? totalMinutes,
    String? favoriteDrill,
    String? dominantHand,
  }) {
    return UserProfile(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      xpNeededForNextLevel: xpNeededForNextLevel ?? this.xpNeededForNextLevel,
      currentStreak: currentStreak ?? this.currentStreak,
      completedSessions: completedSessions ?? this.completedSessions,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      favoriteDrill: favoriteDrill ?? this.favoriteDrill,
      dominantHand: dominantHand ?? this.dominantHand,
    );
  }
}
