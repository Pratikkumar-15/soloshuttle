import 'assessment.dart';
import 'goal.dart';

class UserProfile {
  final String id;
  final String? email;
  final String username;
  final String name;
  final String avatarUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final String dominantHand;
  final String playingLevel;
  final String primaryGoal;
  final String? playingStyle;
  final int level;
  final int currentXp;
  final int xpNeededForNextLevel;
  final int currentStreak;
  final int completedSessions;
  final int totalMinutes;
  final String favoriteDrill;
  final bool dailyReminder;
  final bool restDayReminder;
  final bool weeklyReport;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isCloudSynced;

  // New fields aligned with soloshuttle_feature_suggestions.md
  final Map<String, int> skillRatings; // 'Technical', 'Footwork', 'Tactical', 'Physical', 'Mental', 'Consistency'
  final String playerJourneyStage; // Explorer, Beginner, Developing Player, Intermediate, Advanced, Competitive Player, Elite Athlete
  final List<Assessment> assessmentHistory;
  final DailyGoal dailyGoal;
  final WeeklyGoal weeklyGoal;
  final List<String> streakHistory; // List of ISO date strings 'YYYY-MM-DD' when player trained

  const UserProfile({
    this.id = 'usr_local_01',
    this.email,
    this.username = 'athlete',
    this.name = 'Athlete',
    this.avatarUrl = 'assets/images/logo.png',
    this.dateOfBirth,
    this.gender,
    this.dominantHand = 'Right-handed',
    this.playingLevel = 'Beginner',
    this.primaryGoal = 'Improve Footwork',
    this.playingStyle = 'Both',
    this.level = 1,
    this.currentXp = 0,
    this.xpNeededForNextLevel = 500,
    this.currentStreak = 0,
    this.completedSessions = 0,
    this.totalMinutes = 0,
    this.favoriteDrill = 'None yet',
    this.dailyReminder = true,
    this.restDayReminder = true,
    this.weeklyReport = true,
    this.createdAt,
    this.updatedAt,
    this.isCloudSynced = false,
    this.skillRatings = const {
      'Technical': 45,
      'Footwork': 55,
      'Tactical': 40,
      'Physical': 50,
      'Mental': 42,
      'Consistency': 35,
    },
    this.playerJourneyStage = 'Beginner',
    this.assessmentHistory = const [],
    this.dailyGoal = const DailyGoal(
      id: 'dg_default',
      title: 'Daily Footwork Practice',
      description: 'Complete 15 minutes of Footwork Training',
      targetMinutes: 15,
    ),
    this.weeklyGoal = const WeeklyGoal(
      id: 'wg_default',
      title: 'Weekly 4-Day Discipline',
      targetDays: 4,
      targetSessions: 6,
    ),
    this.streakHistory = const [],
  });

  // Calculate age from dateOfBirth
  int? get age {
    if (dateOfBirth == null) return null;
    final today = DateTime.now();
    int calculatedAge = today.year - dateOfBirth!.year;
    if (today.month < dateOfBirth!.month || (today.month == dateOfBirth!.month && today.day < dateOfBirth!.day)) {
      calculatedAge--;
    }
    return calculatedAge >= 0 ? calculatedAge : null;
  }

  // Display label for skill level
  String get calculatedSkillLevel {
    if (currentXp >= 5000 || completedSessions >= 75 || totalMinutes >= 1800) {
      return 'Pro Player';
    } else if (currentXp >= 2000 || completedSessions >= 30 || totalMinutes >= 600) {
      return 'Advanced';
    } else if (currentXp >= 500 || completedSessions >= 10 || totalMinutes >= 120) {
      return 'Intermediate';
    }
    return playingLevel.isNotEmpty ? playingLevel : 'Beginner';
  }

  String get calculatedLevelTitle {
    return '$calculatedSkillLevel (Level $level)';
  }

  // Calculate 7-stage Player Journey
  String get calculatedJourneyStage {
    if (completedSessions >= 100 || currentXp >= 10000) return 'Elite Athlete';
    if (completedSessions >= 60 || currentXp >= 6000) return 'Competitive Player';
    if (completedSessions >= 35 || currentXp >= 3500) return 'Advanced';
    if (completedSessions >= 20 || currentXp >= 1800) return 'Intermediate';
    if (completedSessions >= 8 || currentXp >= 700) return 'Developing Player';
    if (completedSessions >= 2 || currentXp >= 150) return 'Beginner';
    return 'Explorer';
  }

  // Strongest Skill
  String get strongestSkill {
    if (skillRatings.isEmpty) return 'Footwork';
    var topSkill = 'Footwork';
    var topScore = -1;
    skillRatings.forEach((key, val) {
      if (val > topScore) {
        topScore = val;
        topSkill = key;
      }
    });
    return topSkill;
  }

  // Focus Area (Weakest Skill)
  String get weakestSkill {
    if (skillRatings.isEmpty) return 'Tactical';
    var lowestSkill = 'Tactical';
    var lowestScore = 999;
    skillRatings.forEach((key, val) {
      if (val < lowestScore) {
        lowestScore = val;
        lowestSkill = key;
      }
    });
    return lowestSkill;
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? username,
    String? name,
    String? avatarUrl,
    DateTime? dateOfBirth,
    String? gender,
    String? dominantHand,
    String? playingLevel,
    String? primaryGoal,
    String? playingStyle,
    int? level,
    int? currentXp,
    int? xpNeededForNextLevel,
    int? currentStreak,
    int? completedSessions,
    int? totalMinutes,
    String? favoriteDrill,
    bool? dailyReminder,
    bool? restDayReminder,
    bool? weeklyReport,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCloudSynced,
    Map<String, int>? skillRatings,
    String? playerJourneyStage,
    List<Assessment>? assessmentHistory,
    DailyGoal? dailyGoal,
    WeeklyGoal? weeklyGoal,
    List<String>? streakHistory,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      dominantHand: dominantHand ?? this.dominantHand,
      playingLevel: playingLevel ?? this.playingLevel,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      playingStyle: playingStyle ?? this.playingStyle,
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      xpNeededForNextLevel: xpNeededForNextLevel ?? this.xpNeededForNextLevel,
      currentStreak: currentStreak ?? this.currentStreak,
      completedSessions: completedSessions ?? this.completedSessions,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      favoriteDrill: favoriteDrill ?? this.favoriteDrill,
      dailyReminder: dailyReminder ?? this.dailyReminder,
      restDayReminder: restDayReminder ?? this.restDayReminder,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCloudSynced: isCloudSynced ?? this.isCloudSynced,
      skillRatings: skillRatings ?? this.skillRatings,
      playerJourneyStage: playerJourneyStage ?? this.playerJourneyStage,
      assessmentHistory: assessmentHistory ?? this.assessmentHistory,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      streakHistory: streakHistory ?? this.streakHistory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': name,
      'avatarUrl': avatarUrl,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'dominantHand': dominantHand,
      'playingLevel': playingLevel,
      'primaryGoal': primaryGoal,
      'playingStyle': playingStyle,
      'level': level,
      'currentXp': currentXp,
      'xpNeededForNextLevel': xpNeededForNextLevel,
      'currentStreak': currentStreak,
      'completedSessions': completedSessions,
      'totalMinutes': totalMinutes,
      'favoriteDrill': favoriteDrill,
      'dailyReminder': dailyReminder,
      'restDayReminder': restDayReminder,
      'weeklyReport': weeklyReport,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isCloudSynced': isCloudSynced,
      'skillRatings': skillRatings,
      'playerJourneyStage': playerJourneyStage,
      'assessmentHistory': assessmentHistory.map((a) => a.toJson()).toList(),
      'dailyGoal': dailyGoal.toJson(),
      'weeklyGoal': weeklyGoal.toJson(),
      'streakHistory': streakHistory,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    Map<String, int> parsedRatings = {
      'Technical': 45,
      'Footwork': 55,
      'Tactical': 40,
      'Physical': 50,
      'Mental': 42,
      'Consistency': 35,
    };
    if (json['skillRatings'] != null && json['skillRatings'] is Map) {
      final rawMap = json['skillRatings'] as Map<String, dynamic>;
      rawMap.forEach((key, value) {
        if (value is num) {
          parsedRatings[key] = value.toInt();
        }
      });
    }

    List<Assessment> parsedAssessments = [];
    if (json['assessmentHistory'] != null && json['assessmentHistory'] is List) {
      parsedAssessments = (json['assessmentHistory'] as List)
          .map((item) => Assessment.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    List<String> parsedStreaks = [];
    if (json['streakHistory'] != null && json['streakHistory'] is List) {
      parsedStreaks = (json['streakHistory'] as List).map((e) => e.toString()).toList();
    }

    return UserProfile(
      id: json['id'] ?? 'usr_local_01',
      email: json['email'],
      username: json['username'] ?? 'athlete',
      name: json['name'] ?? 'Athlete',
      avatarUrl: json['avatarUrl'] ?? 'assets/images/logo.png',
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth']) : null,
      gender: json['gender'],
      dominantHand: json['dominantHand'] ?? 'Right-handed',
      playingLevel: json['playingLevel'] ?? 'Beginner',
      primaryGoal: json['primaryGoal'] ?? 'Improve Footwork',
      playingStyle: json['playingStyle'] ?? 'Both',
      level: json['level'] ?? 1,
      currentXp: json['currentXp'] ?? 0,
      xpNeededForNextLevel: json['xpNeededForNextLevel'] ?? 500,
      currentStreak: json['currentStreak'] ?? 0,
      completedSessions: json['completedSessions'] ?? 0,
      totalMinutes: json['totalMinutes'] ?? 0,
      favoriteDrill: json['favoriteDrill'] ?? 'None yet',
      dailyReminder: json['dailyReminder'] ?? true,
      restDayReminder: json['restDayReminder'] ?? true,
      weeklyReport: json['weeklyReport'] ?? true,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      isCloudSynced: json['isCloudSynced'] ?? false,
      skillRatings: parsedRatings,
      playerJourneyStage: json['playerJourneyStage'] ?? 'Beginner',
      assessmentHistory: parsedAssessments,
      dailyGoal: json['dailyGoal'] != null
          ? DailyGoal.fromJson(json['dailyGoal'] as Map<String, dynamic>)
          : const DailyGoal(
              id: 'dg_default',
              title: 'Daily Footwork Practice',
              description: 'Complete 15 minutes of Footwork Training',
              targetMinutes: 15,
            ),
      weeklyGoal: json['weeklyGoal'] != null
          ? WeeklyGoal.fromJson(json['weeklyGoal'] as Map<String, dynamic>)
          : const WeeklyGoal(
              id: 'wg_default',
              title: 'Weekly 4-Day Discipline',
              targetDays: 4,
              targetSessions: 6,
            ),
      streakHistory: parsedStreaks,
    );
  }
}
