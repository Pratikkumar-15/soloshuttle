import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../core/services/storage_service.dart';
import '../domain/data/drill_catalog.dart';
import '../domain/entities/drill.dart';
import '../domain/entities/drill_category.dart';
import '../domain/entities/daily_workout_plan.dart';
import '../domain/entities/training_log.dart';
import '../domain/entities/monthly_report.dart';

class TrainingProvider extends ChangeNotifier {
  final StorageService _storage;

  List<Drill> _drills = [];
  List<DrillCategory> _categories = [];
  List<TrainingLog> _recentLogs = [];
  List<DailyWorkoutPlan> _dailyPlans = [];
  bool _dailyChallengeCompleted = false;

  List<Drill> get drills => _drills;
  List<DrillCategory> get categories => _categories;
  List<TrainingLog> get recentLogs => _recentLogs;
  List<DailyWorkoutPlan> get dailyPlans => _dailyPlans;
  bool get dailyChallengeCompleted => _dailyChallengeCompleted;

  List<Drill> get favoriteDrills {
    final Map<String, int> completionCounts = {};
    for (final log in _recentLogs) {
      completionCounts[log.title] = (completionCounts[log.title] ?? 0) + 1;
    }

    final sorted = List<Drill>.from(_drills);
    sorted.sort((a, b) {
      final countA = completionCounts[a.title] ?? (a.isFavorite ? 1 : 0);
      final countB = completionCounts[b.title] ?? (b.isFavorite ? 1 : 0);
      return countB.compareTo(countA);
    });

    return sorted.take(3).toList();
  }

  List<Drill> get footworkDrills => _drills.where((d) => d.categoryId == 'cat_footwork').toList();
  List<Drill> get soloDrills => _drills.where((d) => d.categoryId == 'cat_solo').toList();

  /// Returns today's training plan using day-of-week (Monday=0 through Sunday=6).
  /// This ensures stable sequential rotation: Monday → plan_mon, Tuesday → plan_tue, etc.
  DailyWorkoutPlan get todaysTrainingPlan {
    final weekday = DateTime.now().weekday; // 1=Monday ... 7=Sunday
    final index = (weekday - 1) % _dailyPlans.length;
    return _dailyPlans[index];
  }

  Drill get todaysDrill {
    final plan = todaysTrainingPlan;
    return _drills.firstWhere(
      (d) => d.id == plan.drillId,
      orElse: () => _drills.first,
    );
  }

  TrainingProvider(this._storage) {
    _initializeCatalog();
    _loadLogs();
  }

  void _initializeCatalog() {
    _categories = List.from(DrillCatalog.categories);
    _dailyPlans = List.from(DrillCatalog.dailyPlans);
    _drills = List.from(DrillCatalog.drills);
  }

  Future<void> _loadLogs() async {
    try {
      await _storage.init();
      final logsString = await _storage.getString(StorageKeys.trainingLogs);
      if (logsString != null) {
        final List<dynamic> jsonList = jsonDecode(logsString);
        _recentLogs = jsonList.map((j) => TrainingLog.fromJson(j)).toList();
      } else {
        _recentLogs = [];
      }
    } catch (e) {
      debugPrint('Failed to load training logs: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> clearLogs() async {
    _recentLogs = [];
    notifyListeners();
    try {
      await _storage.init();
      await _storage.remove(StorageKeys.trainingLogs);
    } catch (e) {
      debugPrint('Failed to clear logs: $e');
    }
  }

  Future<void> logCompletedTraining({
    required String title,
    required String duration,
    required int xpEarned,
    String category = 'Footwork',
    int? qualityScore,
  }) async {
    final newLog = TrainingLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      duration: duration,
      xpEarned: xpEarned,
      date: DateTime.now(),
      category: category,
      qualityScore: qualityScore,
    );

    _recentLogs.insert(0, newLog);
    notifyListeners();

    try {
      await _storage.init();
      final jsonList = _recentLogs.map((l) => l.toJson()).toList();
      await _storage.setString(StorageKeys.trainingLogs, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Failed to save log: $e');
    }
  }

  void toggleFavorite(String drillId) {
    final index = _drills.indexWhere((d) => d.id == drillId);
    if (index != -1) {
      final current = _drills[index];
      _drills[index] = current.copyWith(isFavorite: !current.isFavorite);
      notifyListeners();
    }
  }

  void completeDailyChallenge() {
    _dailyChallengeCompleted = true;
    notifyListeners();
  }

  MonthlyReport generateMonthlyReport(DateTime month) {
    final logsForMonth = _recentLogs.where((log) =>
        log.date.year == month.year && log.date.month == month.month).toList();

    int totalMins = 0;
    int xp = 0;
    final Map<String, int> byCategory = {};

    for (final log in logsForMonth) {
      final mins = int.tryParse(log.duration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      totalMins += mins;
      xp += log.xpEarned;
      byCategory[log.category] = (byCategory[log.category] ?? 0) + 1;
    }

    String topCategory = 'None';
    int topCount = 0;
    byCategory.forEach((cat, count) {
      if (count > topCount) {
        topCount = count;
        topCategory = cat;
      }
    });

    return MonthlyReport(
      id: 'rep_${month.year}_${month.month}',
      month: month,
      totalSessions: logsForMonth.length,
      totalMinutes: totalMins,
      xpEarned: xp,
      mostTrainedCategory: topCategory,
      sessionsByCategory: byCategory,
    );
  }
}
