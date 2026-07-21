import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../core/services/storage_service.dart';
import '../domain/entities/user_profile.dart';
import '../domain/entities/assessment.dart';
import '../domain/entities/goal.dart';

class UserProvider extends ChangeNotifier {
  final StorageService _storage;

  UserProfile _user = const UserProfile();
  bool _isInitialized = false;
  bool _hasCompletedOnboarding = false;

  UserProfile get user => _user;
  bool get isInitialized => _isInitialized;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  UserProvider(this._storage) {
    _loadUserFromStorage();
  }

  // ──────────────────────────────────────────────
  // PERSISTENCE
  // ──────────────────────────────────────────────

  Future<void> _loadUserFromStorage() async {
    try {
      await _storage.init();
      _hasCompletedOnboarding = await _storage.getBool(StorageKeys.hasCompletedOnboarding) ?? false;
      final userString = await _storage.getString(StorageKeys.userProfile);
      if (userString != null) {
        final Map<String, dynamic> data = jsonDecode(userString);
        _user = UserProfile.fromJson(data);
      }
      _resetDailyGoalIfNewDay();
      _resetWeeklyGoalIfNewWeek();
    } catch (e) {
      debugPrint('Failed to load user profile: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _saveUserToStorage() async {
    try {
      await _storage.init();
      await _storage.setBool(StorageKeys.hasCompletedOnboarding, _hasCompletedOnboarding);
      await _storage.setString(StorageKeys.userProfile, jsonEncode(_user.toJson()));
    } catch (e) {
      debugPrint('Failed to save user profile: $e');
    }
  }

  // ──────────────────────────────────────────────
  // ONBOARDING
  // ──────────────────────────────────────────────

  Future<void> completeOnboarding(UserProfile newProfile) async {
    _user = newProfile.copyWith(
      updatedAt: DateTime.now(),
      createdAt: newProfile.createdAt ?? DateTime.now(),
      playerJourneyStage: newProfile.calculatedJourneyStage,
    );
    _hasCompletedOnboarding = true;
    notifyListeners();
    await _saveUserToStorage();
  }

  Future<void> updateFullProfile(UserProfile updatedProfile) async {
    _user = updatedProfile.copyWith(
      updatedAt: DateTime.now(),
      playerJourneyStage: updatedProfile.calculatedJourneyStage,
    );
    notifyListeners();
    await _saveUserToStorage();
  }

  Future<void> resetOnboarding() async {
    try {
      await _storage.init();
      await _storage.remove(StorageKeys.hasCompletedOnboarding);
      await _storage.remove(StorageKeys.userProfile);
      await _storage.remove(StorageKeys.lastDailyGoalDate);
      await _storage.remove(StorageKeys.weeklyGoalWeekStart);
    } catch (e) {
      debugPrint('Failed to reset prefs: $e');
    }
    _hasCompletedOnboarding = false;
    _user = const UserProfile();
    notifyListeners();
  }

  // ──────────────────────────────────────────────
  // XP & SKILL RATINGS (with diminishing returns)
  // ──────────────────────────────────────────────

  void addXp(int amount, {String? category}) {
    int newXp = _user.currentXp + amount;
    int newLevel = _user.level;
    int needed = _user.xpNeededForNextLevel;

    while (newXp >= needed) {
      newXp -= needed;
      newLevel += 1;
      needed = (needed * 1.25).toInt();
    }

    // Update streak history for today
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final updatedStreakList = List<String>.from(_user.streakHistory);
    if (!updatedStreakList.contains(todayStr)) {
      updatedStreakList.add(todayStr);
    }

    // Update skill ratings with diminishing returns
    final updatedRatings = Map<String, int>.from(_user.skillRatings);
    if (category != null) {
      updatedRatings[category] = _applyDiminishingReturns(updatedRatings[category] ?? 0);
    }
    updatedRatings['Consistency'] = _applyDiminishingReturns(updatedRatings['Consistency'] ?? 0);

    // Update weekly goal tracking
    final updatedWeeklyGoal = _user.weeklyGoal;
    final newCompletedSessions = updatedWeeklyGoal.completedSessions + 1;
    // Count unique training days this week
    final weekStart = _getWeekStartDate(DateTime.now());
    final uniqueDaysThisWeek = updatedStreakList
        .where((dateStr) {
          final date = DateTime.tryParse(dateStr);
          return date != null && !date.isBefore(weekStart);
        })
        .toSet()
        .length;

    _user = _user.copyWith(
      currentXp: newXp,
      level: newLevel,
      xpNeededForNextLevel: needed,
      completedSessions: _user.completedSessions + 1,
      currentStreak: _calculateConsecutiveStreak(updatedStreakList),
      skillRatings: updatedRatings,
      streakHistory: updatedStreakList,
      playerJourneyStage: _user.calculatedJourneyStage,
      weeklyGoal: updatedWeeklyGoal.copyWith(
        completedSessions: newCompletedSessions,
        completedDays: uniqueDaysThisWeek,
        isCompleted: uniqueDaysThisWeek >= updatedWeeklyGoal.targetDays &&
            newCompletedSessions >= updatedWeeklyGoal.targetSessions,
      ),
      updatedAt: DateTime.now(),
    );

    notifyListeners();
    _saveUserToStorage();
  }

  /// Diminishing returns formula: gain decreases as skill approaches 100.
  /// At 0: +5, at 50: +3, at 80: +1.5, at 95: +0.5
  int _applyDiminishingReturns(int currentScore) {
    final remaining = 100 - currentScore;
    final gain = (remaining * 0.05).clamp(0.25, 5.0);
    return (currentScore + gain).round().clamp(0, 100);
  }

  // ──────────────────────────────────────────────
  // STREAK CALCULATION (consecutive days)
  // ──────────────────────────────────────────────

  /// Calculates the current consecutive-day training streak.
  /// Walks backwards from today, counting each consecutive day present in history.
  int _calculateConsecutiveStreak(List<String> streakHistory) {
    if (streakHistory.isEmpty) return 0;

    final dates = streakHistory
        .map((s) => DateTime.tryParse(s))
        .whereType<DateTime>()
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    if (dates.isEmpty) return 0;

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    // If the most recent training date is not today or yesterday, streak is 0
    final daysDiff = todayNormalized.difference(dates.first).inDays;
    if (daysDiff > 1) return 0;

    int streak = 0;
    DateTime checkDate = daysDiff == 0 ? todayNormalized : todayNormalized.subtract(const Duration(days: 1));

    for (final date in dates) {
      if (date == checkDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (date.isBefore(checkDate)) {
        break;
      }
    }

    return streak;
  }

  // ──────────────────────────────────────────────
  // DAILY GOAL AUTO-RESET
  // ──────────────────────────────────────────────

  /// Resets daily goal if the stored date differs from today.
  void _resetDailyGoalIfNewDay() {
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    _storage.getString(StorageKeys.lastDailyGoalDate).then((lastDate) {
      if (lastDate != todayStr) {
        final smartGoal = _generateSmartDailyGoal();
        _user = _user.copyWith(dailyGoal: smartGoal);
        _storage.setString(StorageKeys.lastDailyGoalDate, todayStr);
        notifyListeners();
        _saveUserToStorage();
      }
    });
  }

  /// Generates an AI-driven daily goal based on training patterns.
  DailyGoal _generateSmartDailyGoal() {
    final weekday = DateTime.now().weekday;
    final weakest = _user.weakestSkill;

    // Recovery day on Sunday or after 4+ consecutive training days
    if (weekday == 7 || _user.currentStreak >= 4) {
      return const DailyGoal(
        id: 'dg_recovery',
        title: 'Active Recovery Day',
        description: 'Light mobility work and serve practice',
        targetMinutes: 10,
        xpReward: 40,
        category: 'Recovery',
      );
    }

    // Target weakest skill
    switch (weakest) {
      case 'Footwork':
        return const DailyGoal(
          id: 'dg_footwork',
          title: 'Footwork Improvement',
          description: 'Complete 15 minutes of footwork training',
          targetMinutes: 15,
          xpReward: 60,
          category: 'Footwork',
        );
      case 'Technical':
        return const DailyGoal(
          id: 'dg_technical',
          title: 'Stroke Technique Focus',
          description: 'Complete 12 minutes of solo drills',
          targetMinutes: 12,
          xpReward: 55,
          category: 'Technical',
        );
      case 'Tactical':
        return const DailyGoal(
          id: 'dg_tactical',
          title: 'Tactical IQ Training',
          description: 'Solve 5 tactical puzzles',
          targetMinutes: 10,
          xpReward: 50,
          category: 'Tactical',
        );
      case 'Physical':
        return const DailyGoal(
          id: 'dg_physical',
          title: 'Physical Conditioning',
          description: 'Complete 20 minutes of court agility',
          targetMinutes: 20,
          xpReward: 70,
          category: 'Physical',
        );
      case 'Mental':
        return const DailyGoal(
          id: 'dg_mental',
          title: 'Mental Sharpness',
          description: 'Complete focus timer and reaction drill',
          targetMinutes: 10,
          xpReward: 45,
          category: 'Mental',
        );
      default:
        return const DailyGoal(
          id: 'dg_consistency',
          title: 'Daily Training Habit',
          description: 'Complete any 15-minute training session',
          targetMinutes: 15,
          xpReward: 50,
          category: 'Footwork',
        );
    }
  }

  // ──────────────────────────────────────────────
  // WEEKLY GOAL AUTO-RESET
  // ──────────────────────────────────────────────

  /// Resets weekly goal if the current week differs from stored week.
  void _resetWeeklyGoalIfNewWeek() {
    final currentWeekStart = _getWeekStartDate(DateTime.now()).toIso8601String().substring(0, 10);
    _storage.getString(StorageKeys.weeklyGoalWeekStart).then((storedWeekStart) {
      if (storedWeekStart != currentWeekStart) {
        _user = _user.copyWith(
          weeklyGoal: WeeklyGoal(
            id: 'wg_${currentWeekStart.replaceAll('-', '')}',
            title: 'Weekly ${_user.level >= 5 ? "5" : "4"}-Day Discipline',
            targetDays: _user.level >= 5 ? 5 : 4,
            targetSessions: _user.level >= 5 ? 8 : 6,
          ),
        );
        _storage.setString(StorageKeys.weeklyGoalWeekStart, currentWeekStart);
        notifyListeners();
        _saveUserToStorage();
      }
    });
  }

  /// Returns the Monday of the current ISO week.
  DateTime _getWeekStartDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  // ──────────────────────────────────────────────
  // MINUTES & DAILY GOAL TRACKING
  // ──────────────────────────────────────────────

  void updateMinutesTrained(int minutes) {
    final currentDailyGoal = _user.dailyGoal;
    final updatedMinutes = currentDailyGoal.completedMinutes + minutes;
    final isDone = updatedMinutes >= currentDailyGoal.targetMinutes;

    _user = _user.copyWith(
      totalMinutes: _user.totalMinutes + minutes,
      dailyGoal: currentDailyGoal.copyWith(
        completedMinutes: updatedMinutes,
        isCompleted: isDone,
      ),
      updatedAt: DateTime.now(),
    );
    notifyListeners();
    _saveUserToStorage();
  }

  // ──────────────────────────────────────────────
  // ASSESSMENTS
  // ──────────────────────────────────────────────

  void logAssessment(Assessment assessment) {
    final updatedHistory = List<Assessment>.from(_user.assessmentHistory)..add(assessment);

    final updatedRatings = Map<String, int>.from(_user.skillRatings);
    if (assessment.type.contains('Footwork')) {
      updatedRatings['Footwork'] = (assessment.score.toInt()).clamp(0, 100);
    } else if (assessment.type.contains('Reaction')) {
      updatedRatings['Tactical'] = (assessment.score.toInt()).clamp(0, 100);
    }

    _user = _user.copyWith(
      assessmentHistory: updatedHistory,
      skillRatings: updatedRatings,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
    _saveUserToStorage();
  }

  // ──────────────────────────────────────────────
  // PROFILE UPDATES
  // ──────────────────────────────────────────────

  void updateSkillRating(String skillCategory, int newScore) {
    final updatedRatings = Map<String, int>.from(_user.skillRatings);
    updatedRatings[skillCategory] = newScore.clamp(0, 100);
    _user = _user.copyWith(
      skillRatings: updatedRatings,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
    _saveUserToStorage();
  }

  void updateProfileName(String name) {
    _user = _user.copyWith(name: name, updatedAt: DateTime.now());
    notifyListeners();
    _saveUserToStorage();
  }

  void updateDominantHand(String hand) {
    _user = _user.copyWith(dominantHand: hand, updatedAt: DateTime.now());
    notifyListeners();
    _saveUserToStorage();
  }

  void updateAvatarUrl(String avatarUrl) {
    _user = _user.copyWith(avatarUrl: avatarUrl, updatedAt: DateTime.now());
    notifyListeners();
    _saveUserToStorage();
  }
}
