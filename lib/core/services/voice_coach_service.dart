import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceCoachService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  double _speechRate = 0.5; // Optimal clarity for sports court callouts
  double _pitch = 1.0;
  double _volume = 1.0;
  List<dynamic> _availableVoices = [];
  String? _selectedVoice;

  double get speechRate => _speechRate;
  double get pitch => _pitch;
  double get volume => _volume;
  List<dynamic> get availableVoices => _availableVoices;
  String? get selectedVoice => _selectedVoice;

  VoiceCoachService() {
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(_speechRate);
      await _tts.setVolume(_volume);
      await _tts.setPitch(_pitch);

      // Mobile audio category & focus configuration for maximum volume & clarity
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await _tts.setSharedInstance(true);
        await _tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
            IosTextToSpeechAudioCategoryOptions.duckOthers,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
        await _tts.awaitSpeakCompletion(true);
      }

      // Query high-quality voices if supported by device engine
      try {
        final voices = await _tts.getVoices;
        if (voices != null && voices is List) {
          _availableVoices = voices;
          // Prefer English high-quality voice if available
          for (var voice in voices) {
            if (voice is Map && voice['name'] != null && voice['locale'] != null) {
              final name = voice['name'].toString().toLowerCase();
              final locale = voice['locale'].toString().toLowerCase();
              if (locale.contains('en') && (name.contains('network') || name.contains('premium') || name.contains('enhanced'))) {
                _selectedVoice = voice['name'].toString();
                await _tts.setVoice({"name": voice['name'], "locale": voice['locale']});
                break;
              }
            }
          }
        }
      } catch (e) {
        debugPrint('Voice querying limitation: $e');
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('TTS Initialization failed: $e');
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await _initTts();
    }
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      debugPrint('Error speaking text "$text": $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      debugPrint('Error stopping TTS: $e');
    }
  }

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.2, 1.0);
    try {
      await _tts.setSpeechRate(_speechRate);
    } catch (e) {
      debugPrint('Error setting speech rate: $e');
    }
  }

  Future<void> setPitch(double pitch) async {
    _pitch = pitch.clamp(0.5, 1.5);
    try {
      await _tts.setPitch(_pitch);
    } catch (e) {
      debugPrint('Error setting pitch: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    try {
      await _tts.setVolume(_volume);
    } catch (e) {
      debugPrint('Error setting TTS volume: $e');
    }
  }
}
