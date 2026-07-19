import 'package:flutter_tts/flutter_tts.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    _initialized = true;
  }

  Future<void> playWorkoutStart() async {
    await _init();
    await _tts.setPitch(1.3);
    await _tts.speak('Ready... Go!');
  }

  Future<void> playRoundStart() async {
    await _init();
    await _tts.setPitch(1.2);
    await _tts.speak('Round Start!');
  }

  Future<void> playRestInterval() async {
    await _init();
    await _tts.setPitch(0.9);
    await _tts.speak('Rest interval. Recover.');
  }

  Future<void> playNextRound() async {
    await _init();
    await _tts.setPitch(1.1);
    await _tts.speak('Get ready.');
  }

  Future<void> playWorkoutComplete() async {
    await _init();
    await _tts.setPitch(1.4);
    await _tts.speak('Workout Complete! Outstanding performance!');
  }
}
