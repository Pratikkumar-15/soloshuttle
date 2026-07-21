import 'package:shared_preferences/shared_preferences.dart';

abstract final class StorageKeys {
  static const String userProfile = 'user_profile';
  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String trainingLogs = 'training_logs';
  static const String lastDailyGoalDate = 'last_daily_goal_date';
  static const String weeklyGoalWeekStart = 'weekly_goal_week_start';
}

abstract class StorageService {
  Future<void> init();
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Future<bool?> getBool(String key);
  Future<void> setBool(String key, bool value);
  Future<void> remove(String key);
  Future<void> clear();
}

class SharedPreferencesStorageService implements StorageService {
  SharedPreferences? _prefs;
  
  @override
  Future<void> init() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
    } catch (e) {
      // Fallback if OS restricts shared preferences (e.g. storage full)
      _prefs = null; 
    }
  }
  
  // In-memory fallback map if _prefs is null
  final Map<String, dynamic> _fallbackMemory = {};

  SharedPreferences? get _instance {
    return _prefs;
  }
  
  @override
  Future<String?> getString(String key) async {
    if (_instance == null) return _fallbackMemory[key] as String?;
    return _instance!.getString(key);
  }
  
  @override
  Future<void> setString(String key, String value) async {
    if (_instance == null) {
      _fallbackMemory[key] = value;
      return;
    }
    await _instance!.setString(key, value);
  }
  
  @override
  Future<bool?> getBool(String key) async {
    if (_instance == null) return _fallbackMemory[key] as bool?;
    return _instance!.getBool(key);
  }
  
  @override
  Future<void> setBool(String key, bool value) async {
    if (_instance == null) {
      _fallbackMemory[key] = value;
      return;
    }
    await _instance!.setBool(key, value);
  }
  
  @override
  Future<void> remove(String key) async {
    if (_instance == null) {
      _fallbackMemory.remove(key);
      return;
    }
    await _instance!.remove(key);
  }
  
  @override
  Future<void> clear() async {
    if (_instance == null) {
      _fallbackMemory.clear();
      return;
    }
    await _instance!.clear();
  }
}
