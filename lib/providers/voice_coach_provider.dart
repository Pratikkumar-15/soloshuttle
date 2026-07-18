import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/voice_coach_service.dart';

enum VoiceCoachMode { sequential, random, reaction }

class VoiceCoachProvider extends ChangeNotifier {
  final VoiceCoachService _ttsService = VoiceCoachService();
  
  VoiceCoachMode _mode = VoiceCoachMode.random;
  bool _isActive = false;
  bool _isPaused = false;
  bool _hasSeenOnboarding = false;
  int _intervalSeconds = 3;
  String _currentCallout = 'READY';
  int _totalCalloutsMade = 0;
  Timer? _calloutTimer;
  Timer? _countdownTimer;
  int _countdownSeconds = 3;

  // Active Corner Filters (6 Court Positions: Front Left, Front Right, Mid Left, Mid Right, Back Left, Back Right)
  final Map<String, bool> _activeCornersMap = {
    'Front Left': true,
    'Front Right': true,
    'Mid Left': true,
    'Mid Right': true,
    'Back Left': true,
    'Back Right': true,
  };

  static const List<String> courtCorners = [
    'Front Left',
    'Front Right',
    'Mid Left',
    'Mid Right',
    'Back Left',
    'Back Right',
  ];

  VoiceCoachMode get mode => _mode;
  bool get isActive => _isActive;
  bool get isPaused => _isPaused;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  int get intervalSeconds => _intervalSeconds;
  String get currentCallout => _currentCallout;
  int get totalCalloutsMade => _totalCalloutsMade;
  int get countdownSeconds => _countdownSeconds;
  Map<String, bool> get activeCornersMap => _activeCornersMap;
  VoiceCoachService get ttsService => _ttsService;

  VoiceCoachProvider() {
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _hasSeenOnboarding = prefs.getBool('hasSeenVoiceCoachOnboarding') ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading voice coach onboarding: $e');
    }
  }

  Future<void> completeOnboarding() async {
    _hasSeenOnboarding = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenVoiceCoachOnboarding', true);
    } catch (e) {
      debugPrint('Error saving voice coach onboarding: $e');
    }
  }

  void setMode(VoiceCoachMode newMode) {
    _mode = newMode;
    notifyListeners();
  }

  void setInterval(int seconds) {
    _intervalSeconds = seconds.clamp(1, 10);
    notifyListeners();
  }

  void toggleCornerFilter(String corner) {
    if (_activeCornersMap.containsKey(corner)) {
      _activeCornersMap[corner] = !(_activeCornersMap[corner] ?? true);
      notifyListeners();
    }
  }

  Future<void> startSession() async {
    _isActive = true;
    _isPaused = false;
    _totalCalloutsMade = 0;
    _countdownSeconds = 3;
    _currentCallout = 'GET READY (3)';
    notifyListeners();

    await _ttsService.speak('Get ready. 3');

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      _countdownSeconds--;
      if (_countdownSeconds > 0) {
        _currentCallout = 'GET READY ($_countdownSeconds)';
        notifyListeners();
        await _ttsService.speak('$_countdownSeconds');
      } else {
        timer.cancel();
        _currentCallout = 'START!';
        notifyListeners();
        await _ttsService.speak('Start!');
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _calloutTimer?.cancel();
    _calloutTimer = Timer.periodic(Duration(seconds: _intervalSeconds), (_) {
      if (!_isPaused && _isActive) {
        _triggerCallout();
      }
    });
  }

  void _triggerCallout() {
    final enabledCorners = _activeCornersMap.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    final pool = enabledCorners.isNotEmpty ? enabledCorners : courtCorners;
    final random = Random();
    final callout = pool[random.nextInt(pool.length)];

    _currentCallout = callout;
    _totalCalloutsMade++;
    notifyListeners();
    _ttsService.speak(callout);
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
    if (_isPaused) {
      _ttsService.speak('Paused');
    } else {
      _ttsService.speak('Resuming');
    }
  }

  Future<void> stopSession() async {
    _countdownTimer?.cancel();
    _calloutTimer?.cancel();
    _isActive = false;
    _isPaused = false;
    _currentCallout = 'SESSION COMPLETE';
    notifyListeners();
    await _ttsService.speak('Session complete. Great effort!');
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _calloutTimer?.cancel();
    _ttsService.stop();
    super.dispose();
  }
}
