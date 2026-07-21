import 'package:flutter/foundation.dart';
import '../core/services/storage_service.dart';
import '../domain/entities/goal.dart';
import 'user_provider.dart';

class GoalProvider extends ChangeNotifier {
  final StorageService _storage;
  final UserProvider _userProvider;

  DailyGoal? _dailyGoal;
  WeeklyGoal? _weeklyGoal;

  DailyGoal? get dailyGoal => _dailyGoal;
  WeeklyGoal? get weeklyGoal => _weeklyGoal;

  GoalProvider(this._storage, this._userProvider) {
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    await _storage.init();
    
    // Check daily goal
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final lastDailyDate = await _storage.getString(StorageKeys.lastDailyGoalDate);
    
    if (lastDailyDate != todayStr) {
      _dailyGoal = _generateSmartDailyGoal();
      await _storage.setString(StorageKeys.lastDailyGoalDate, todayStr);
    } else {
      // Need to load from storage. For now, since they were in UserProfile,
      // we'll just fall back to generating or using the user's existing one.
      _dailyGoal = _userProvider.user.dailyGoal;
    }

    // Check weekly goal
    final currentWeekStart = _getWeekStartDate(DateTime.now()).toIso8601String().substring(0, 10);
    final storedWeekStart = await _storage.getString(StorageKeys.weeklyGoalWeekStart);

    if (storedWeekStart != currentWeekStart) {
      _weeklyGoal = WeeklyGoal(
        id: 'wg_${currentWeekStart.replaceAll('-', '')}',
        title: 'Weekly ${_userProvider.user.level >= 5 ? "5" : "4"}-Day Discipline',
        targetDays: _userProvider.user.level >= 5 ? 5 : 4,
        targetSessions: _userProvider.user.level >= 5 ? 8 : 6,
      );
      await _storage.setString(StorageKeys.weeklyGoalWeekStart, currentWeekStart);
    } else {
      _weeklyGoal = _userProvider.user.weeklyGoal;
    }

    notifyListeners();
  }

  void updateTrainingProgress(int minutes, String category) {
    if (_dailyGoal != null && !_dailyGoal!.isCompleted) {
      final updatedMinutes = _dailyGoal!.completedMinutes + minutes;
      _dailyGoal = _dailyGoal!.copyWith(
        completedMinutes: updatedMinutes,
        isCompleted: updatedMinutes >= _dailyGoal!.targetMinutes,
      );
    }

    if (_weeklyGoal != null && !_weeklyGoal!.isCompleted) {
      // Weekly goal updates are handled in UserProvider's streak tracking currently,
      // but ideally we'd track sessions here.
      // We will sync with UserProvider's weekly goal state.
      _weeklyGoal = _userProvider.user.weeklyGoal;
    }

    notifyListeners();
  }

  DailyGoal _generateSmartDailyGoal() {
    final weekday = DateTime.now().weekday;
    final weakest = _userProvider.user.weakestSkill;

    if (weekday == 7 || _userProvider.user.currentStreak >= 4) {
      return const DailyGoal(
        id: 'dg_recovery',
        title: 'Active Recovery Day',
        description: 'Light mobility work and serve practice',
        targetMinutes: 10,
        xpReward: 40,
        category: 'Recovery',
      );
    }

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

  DateTime _getWeekStartDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }
}
