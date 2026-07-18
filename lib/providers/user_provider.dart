import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/user_profile.dart';

class UserProvider extends ChangeNotifier {
  UserProfile _user = const UserProfile();
  bool _isInitialized = false;

  UserProfile get user => _user;
  bool get isInitialized => _isInitialized;

  UserProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString('user_profile');
      if (userString != null) {
        final Map<String, dynamic> data = jsonDecode(userString);
        _user = UserProfile(
          name: data['name'] ?? 'Keshav',
          level: data['level'] ?? 4,
          currentXp: data['currentXp'] ?? 450,
          xpNeededForNextLevel: data['xpNeededForNextLevel'] ?? 1000,
          currentStreak: data['currentStreak'] ?? 12,
          completedSessions: data['completedSessions'] ?? 74,
          totalMinutes: data['totalMinutes'] ?? 1680,
          favoriteDrill: data['favoriteDrill'] ?? 'Smash Repetition',
          dominantHand: data['dominantHand'] ?? 'Right',
        );
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
      final data = {
        'name': _user.name,
        'level': _user.level,
        'currentXp': _user.currentXp,
        'xpNeededForNextLevel': _user.xpNeededForNextLevel,
        'currentStreak': _user.currentStreak,
        'completedSessions': _user.completedSessions,
        'totalMinutes': _user.totalMinutes,
        'favoriteDrill': _user.favoriteDrill,
        'dominantHand': _user.dominantHand,
      };
      await prefs.setString('user_profile', jsonEncode(data));
    } catch (e) {
      debugPrint('Failed to save user profile: $e');
    }
  }

  void addXp(int amount) {
    int newXp = _user.currentXp + amount;
    int newLevel = _user.level;
    int needed = _user.xpNeededForNextLevel;

    while (newXp >= needed) {
      newXp -= needed;
      newLevel += 1;
      needed = (needed * 1.25).toInt();
    }

    _user = _user.copyWith(
      currentXp: newXp,
      level: newLevel,
      xpNeededForNextLevel: needed,
      completedSessions: _user.completedSessions + 1,
    );

    notifyListeners();
    _saveUserToPrefs();
  }

  void updateMinutesTrained(int minutes) {
    _user = _user.copyWith(totalMinutes: _user.totalMinutes + minutes);
    notifyListeners();
    _saveUserToPrefs();
  }

  void updateProfileName(String name) {
    _user = _user.copyWith(name: name);
    notifyListeners();
    _saveUserToPrefs();
  }

  void updateDominantHand(String hand) {
    _user = _user.copyWith(dominantHand: hand);
    notifyListeners();
    _saveUserToPrefs();
  }
}
