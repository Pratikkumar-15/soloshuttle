import '../domain/entities/user_profile.dart';

class UserStats {
  final String totalTime;
  final int currentStreak;
  final int completedSessions;
  final String favoriteDrill;
  final int level;
  final int currentXp;
  final int xpNeededForNextLevel;

  const UserStats({
    required this.totalTime,
    required this.currentStreak,
    required this.completedSessions,
    required this.favoriteDrill,
    this.level = 4,
    this.currentXp = 450,
    this.xpNeededForNextLevel = 1000,
  });

  factory UserStats.fromProfile(UserProfile profile) {
    return UserStats(
      totalTime: '${profile.totalMinutes ~/ 60} hrs',
      currentStreak: profile.currentStreak,
      completedSessions: profile.completedSessions,
      favoriteDrill: profile.favoriteDrill,
      level: profile.level,
      currentXp: profile.currentXp,
      xpNeededForNextLevel: profile.xpNeededForNextLevel,
    );
  }
}
