import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/voice_coach_service.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  bool _isSoundEnabled = true;
  bool _isVoiceGuidanceEnabled = true;
  bool _isNotificationsEnabled = true;
  double _voiceVolume = 0.9;
  String _unitSystem = 'Metric (km/m)';
  String _language = 'English';
  String _voiceProfile = 'male_normal'; // 'male_normal', 'male_deep', 'female_normal', 'female_deep'

  bool get isDarkMode => _isDarkMode;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isVoiceGuidanceEnabled => _isVoiceGuidanceEnabled;
  bool get isNotificationsEnabled => _isNotificationsEnabled;
  double get voiceVolume => _voiceVolume;
  String get unitSystem => _unitSystem;
  String get language => _language;
  String get voiceProfile => _voiceProfile;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
      _isSoundEnabled = prefs.getBool('isSoundEnabled') ?? true;
      _isVoiceGuidanceEnabled = prefs.getBool('isVoiceGuidanceEnabled') ?? true;
      _isNotificationsEnabled = prefs.getBool('isNotificationsEnabled') ?? true;
      _voiceVolume = prefs.getDouble('voiceVolume') ?? 0.9;
      _unitSystem = prefs.getString('unitSystem') ?? 'Metric (km/m)';
      _language = prefs.getString('language') ?? 'English';
      _voiceProfile = prefs.getString('voiceProfile') ?? 'male_normal';

      VoiceCoachService().setVoiceProfile(_voiceProfile);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> setSoundEnabled(bool value) async {
    _isSoundEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSoundEnabled', value);
  }

  Future<void> setVoiceGuidanceEnabled(bool value) async {
    _isVoiceGuidanceEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVoiceGuidanceEnabled', value);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _isNotificationsEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationsEnabled', value);
  }

  Future<void> setVoiceVolume(double value) async {
    _voiceVolume = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('voiceVolume', value);
    VoiceCoachService().setVolume(value);
  }

  Future<void> setVoiceProfile(String profileId) async {
    _voiceProfile = profileId;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('voiceProfile', profileId);
    VoiceCoachService().setVoiceProfile(profileId);
  }

  Future<void> setUnitSystem(String unit) async {
    _unitSystem = unit;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('unitSystem', unit);
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }
}
