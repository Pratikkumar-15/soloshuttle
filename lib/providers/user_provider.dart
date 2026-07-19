import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/user_profile.dart';
import '../domain/entities/assessment.dart';

class UserProvider extends ChangeNotifier {
  UserProfile _user = const UserProfile();
  bool _isInitialized = false;
  bool _hasCompletedOnboarding = false;

  UserProfile get user => _user;
  bool get isInitialized => _isInitialized;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;

  UserProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _hasCompletedOnboarding = prefs.getBool('has_completed_onboarding') ?? false;
      final userString = prefs.getString('user_profile');
      if (userString != null) {
        final Map<String, dynamic> data = jsonDecode(userString);
        _user = UserProfile.fromJson(data);
      }
    } catch (e) {
      debugPrint('Failed to load user profile: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _saveUserToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_completed_onboarding', _hasCompletedOnboarding);
      await prefs.setString('user_profile', jsonEncode(_user.toJson()));
    } catch (e) {
      debugPrint('Failed to save user profile: $e');
    }
  }

  Future<void> completeOnboarding(UserProfile newProfile) async {
    _user = newProfile.copyWith(
      updatedAt: DateTime.now(),
      createdAt: newProfile.createdAt ?? DateTime.now(),
      playerJourneyStage: newProfile.calculatedJourneyStage,
    );
    _hasCompletedOnboarding = true;
    notifyListeners();
    await _saveUserToPrefs();
  }

  Future<void> updateFullProfile(UserProfile updatedProfile) async {
    _user = updatedProfile.copyWith(
      updatedAt: DateTime.now(),
      playerJourneyStage: updatedProfile.calculatedJourneyStage,
    );
    notifyListeners();
    await _saveUserToPrefs();
  }

  Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('has_completed_onboarding');
      await prefs.remove('user_profile');
    } catch (e) {
      debugPrint('Failed to reset prefs: $e');
    }
    _hasCompletedOnboarding = false;
    _user = const UserProfile();
    notifyListeners();
  }

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

    // Update skill ratings based on training category
    final updatedRatings = Map<String, int>.from(_user.skillRatings);
    if (category != null) {
      final currentCategoryScore = updatedRatings[category] ?? 50;
      updatedRatings[category] = (currentCategoryScore + 2).clamp(0, 100);
    }
    // Consistency rating increases with sessions
    updatedRatings['Consistency'] = ((updatedRatings['Consistency'] ?? 40) + 1).clamp(0, 100);

    _user = _user.copyWith(
      currentXp: newXp,
      level: newLevel,
      xpNeededForNextLevel: needed,
      completedSessions: _user.completedSessions + 1,
      skillRatings: updatedRatings,
      streakHistory: updatedStreakList,
      playerJourneyStage: _user.calculatedJourneyStage,
      updatedAt: DateTime.now(),
    );

    notifyListeners();
    _saveUserToPrefs();
  }

  void updateMinutesTrained(int minutes) {
    // Update daily goal completed minutes
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
    _saveUserToPrefs();
  }

  void logAssessment(Assessment assessment) {
    final updatedHistory = List<Assessment>.from(_user.assessmentHistory)..add(assessment);
    
    // Impact skill ratings based on assessment score
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
    _saveUserToPrefs();
  }

  void updateSkillRating(String skillCategory, int newScore) {
    final updatedRatings = Map<String, int>.from(_user.skillRatings);
    updatedRatings[skillCategory] = newScore.clamp(0, 100);
    _user = _user.copyWith(
      skillRatings: updatedRatings,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
    _saveUserToPrefs();
  }

  void updateProfileName(String name) {
    _user = _user.copyWith(name: name, updatedAt: DateTime.now());
    notifyListeners();
    _saveUserToPrefs();
  }

  void updateDominantHand(String hand) {
    _user = _user.copyWith(dominantHand: hand, updatedAt: DateTime.now());
    notifyListeners();
    _saveUserToPrefs();
  }
}
