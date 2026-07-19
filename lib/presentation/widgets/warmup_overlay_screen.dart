import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/voice_coach_service.dart';

class WarmupOverlayScreen extends StatefulWidget {
  final VoidCallback onWarmupComplete;
  final bool allowSkip;

  const WarmupOverlayScreen({
    super.key,
    required this.onWarmupComplete,
    this.allowSkip = false,
  });

  @override
  State<WarmupOverlayScreen> createState() => _WarmupOverlayScreenState();
}

class _WarmupOverlayScreenState extends State<WarmupOverlayScreen> {
  final _voiceCoach = VoiceCoachService();
  int _currentStepIndex = 0;
  int _secondsRemaining = 30;
  Timer? _timer;

  final List<Map<String, String>> _warmupSteps = const [
    {
      'title': 'Light Jog & Arm Swings',
      'desc': 'Increase heart rate & shoulder mobility.',
      'cue': 'Light on your toes, swing arms smoothly.',
    },
    {
      'title': 'Dynamic Leg & Hip Stretch',
      'desc': 'Prepare hamstrings, calves & hip flexors.',
      'cue': 'Step forward with controlled lunges.',
    },
    {
      'title': 'Footwork Activation Pre-Hop',
      'desc': 'Activate calf tendons & reaction speed.',
      'cue': 'Brisk pre-hops on balls of feet.',
    },
    {
      'title': 'Racket Shadow Swings',
      'desc': 'Loosen wrist & forearm for high contact.',
      'cue': 'Reach high, rotate shoulder naturally.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _voiceCoach.speak('Starting pre-training warm up routine. Stay light on your feet.');
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _nextStep();
      }
    });
  }

  void _nextStep() {
    if (_currentStepIndex < _warmupSteps.length - 1) {
      setState(() {
        _currentStepIndex++;
        _secondsRemaining = 30;
      });
      final step = _warmupSteps[_currentStepIndex];
      _voiceCoach.speak('${step['title']}. ${step['cue']}');
    } else {
      _timer?.cancel();
      _voiceCoach.speak('Warm up complete. Let us begin your training session.');
      widget.onWarmupComplete();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = _warmupSteps[_currentStepIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PRE-SESSION WARM-UP • STEP ${_currentStepIndex + 1}/${_warmupSteps.length}',
                      style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (widget.allowSkip)
                    TextButton(
                      onPressed: () {
                        _timer?.cancel();
                        widget.onWarmupComplete();
                      },
                      child: Text('Skip Warm-up', style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12)),
                    ),
                ],
              ),
              const Spacer(),
              // Big Timer Circle
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: _secondsRemaining / 30.0,
                      strokeWidth: 8,
                      backgroundColor: Colors.white12,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$_secondsRemaining',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 52, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'SECONDS',
                        style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Text(
                step['title']!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                step['desc']!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.electricGreen.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.volume_up_rounded, color: AppColors.electricGreen, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Coach Cue: "${step['cue']}"',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.5, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  _currentStepIndex < _warmupSteps.length - 1 ? 'NEXT EXERCISE ➔' : 'START MAIN DRILL ➔',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
