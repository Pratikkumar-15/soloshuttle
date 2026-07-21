import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/services/voice_coach_service.dart';
import '../../domain/entities/drill.dart';
import '../../providers/user_provider.dart';
import '../../providers/training_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/timer_ring_widget.dart';
import '../widgets/drill_info_card.dart';
import '../widgets/voice_instruction_card.dart';
import '../widgets/pause_screen_overlay.dart';
import '../widgets/session_review_screen.dart';
import '../widgets/training_bottom_nav.dart';

class PremiumTrainingSessionScreen extends StatefulWidget {
  const PremiumTrainingSessionScreen({
    super.key,
    this.drill,
    this.customTitle,
    this.customPhases,
  });

  final Drill? drill;
  final String? customTitle;
  final List<DrillPhase>? customPhases;

  @override
  State<PremiumTrainingSessionScreen> createState() => _PremiumTrainingSessionScreenState();
}

class _PremiumTrainingSessionScreenState extends State<PremiumTrainingSessionScreen> {
  final VoiceCoachService _tts = VoiceCoachService();
  late final List<DrillPhase> _phases;
  
  int _currentPhaseIndex = 0;
  bool _isPaused = false;
  bool _isCompleted = false;
  
  Timer? _timer;

  // Use ValueNotifiers for rapidly changing timer state
  final ValueNotifier<int> _secondsRemaining = ValueNotifier<int>(0);
  final ValueNotifier<int> _elapsedTotalSeconds = ValueNotifier<int>(0);
  final ValueNotifier<int> _workSecondsTrained = ValueNotifier<int>(0);

  static const List<String> _motivationalQuotes = [
    'Champions finish what they start. Keep going!',
    'Stay focused on your footwork. Keep going!',
    'One more round to greatness. Keep going!',
    'You are improving every minute. Keep going!',
    'Breathe deeply and stay strong. Keep going!',
    'Push through the fatigue. You got this!',
  ];

  @override
  void initState() {
    super.initState();
    _initPhases();
    _secondsRemaining.value = _currentPhase.durationSeconds;
    _startCurrentPhase();
  }

  void _initPhases() {
    if (widget.customPhases != null && widget.customPhases!.isNotEmpty) {
      _phases = widget.customPhases!;
      return;
    }

    final drill = widget.drill;
    if (drill != null && drill.phases.isNotEmpty) {
      _phases = drill.phases.map((p) {
        if (p.type == PhaseType.explanation) {
          return DrillPhase(
            title: 'Get Ready',
            description: 'First round starts soon. Get into ready stance.',
            durationSeconds: 15,
            type: PhaseType.explanation,
            coachTip: drill.coachCue,
          );
        }
        return p;
      }).toList();
      return;
    }

    // Default Fallback Phases following BWF Training Standards
    final coachCue = drill?.coachCue ?? 'Stay light on your feet and recover to center.';

    _phases = [
      DrillPhase(
        title: 'Get Ready',
        description: 'First round starts soon. Prepare position.',
        durationSeconds: 15,
        type: PhaseType.explanation,
        coachTip: coachCue,
      ),
      DrillPhase(
        title: 'Round 1 – Base Execution',
        description: 'Split step, move to corner, and recover to center base.',
        durationSeconds: 45,
        type: PhaseType.work,
        coachTip: coachCue,
      ),
      const DrillPhase(
        title: 'Rest Interval',
        description: 'Hydrate and catch your breath for Round 2.',
        durationSeconds: 20,
        type: PhaseType.rest,
      ),
      DrillPhase(
        title: 'Round 2 – Increased Pace',
        description: 'Increase movement speed while maintaining court balance.',
        durationSeconds: 45,
        type: PhaseType.work,
        coachTip: 'Push hard off the front foot to recover!',
      ),
      const DrillPhase(
        title: 'Rest Interval',
        description: 'Breathe deeply and prepare for the final challenge.',
        durationSeconds: 20,
        type: PhaseType.rest,
      ),
      const DrillPhase(
        title: 'Round 3 – Final Burnout Challenge',
        description: 'Maximum explosive speed execution to complete training.',
        durationSeconds: 60,
        type: PhaseType.finalChallenge,
        coachTip: 'Give 100% speed to finish strong!',
      ),
    ];
  }

  DrillPhase get _currentPhase => _phases[_currentPhaseIndex];

  DrillPhase? get _nextPhase {
    if (_currentPhaseIndex + 1 < _phases.length) {
      return _phases[_currentPhaseIndex + 1];
    }
    return null;
  }

  int get _workPhaseCount => _phases.where((p) => p.type == PhaseType.work || p.type == PhaseType.finalChallenge).length;

  int get _currentWorkRoundNumber {
    int count = 0;
    for (int i = 0; i <= _currentPhaseIndex; i++) {
      if (_phases[i].type == PhaseType.work || _phases[i].type == PhaseType.finalChallenge) {
        count++;
      }
    }
    return count > 0 ? count : 1;
  }

  String get _trainingTitle {
    if (widget.drill != null) return widget.drill!.title;
    if (widget.customTitle != null) return widget.customTitle!;
    return 'Shadow Drill Routine';
  }

  void _startCurrentPhase() {
    setState(() {
      _secondsRemaining.value = _currentPhase.durationSeconds;
    });

    _speakPhaseInstruction();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || _isPaused || _isCompleted) return;

      _elapsedTotalSeconds.value++;
      if (_currentPhase.type == PhaseType.work || _currentPhase.type == PhaseType.finalChallenge) {
        _workSecondsTrained.value++;
      }

      if (_secondsRemaining.value > 1) {
        _secondsRemaining.value--;
        _triggerSecondBasedVoiceCallouts();
      } else {
        _advanceToNextPhase();
      }
    });
  }

  void _triggerSecondBasedVoiceCallouts() {
    if (_currentPhase.type == PhaseType.work || _currentPhase.type == PhaseType.finalChallenge) {
      final totalSeconds = _currentPhase.durationSeconds;
      final elapsedInPhase = totalSeconds - _secondsRemaining.value;

      // After 10 seconds: Direct coaching advice tone
      if (elapsedInPhase == 10) {
        final cue = _getFocusCue();
        _tts.stop();
        _tts.speak('Remember to $cue');
        return;
      }

      // After 20 seconds: Direct coaching warning advice tone
      if (elapsedInPhase == 20) {
        final mistake = _getMistakeToAvoid();
        _tts.stop();
        _tts.speak('Make sure not to $mistake');
        return;
      }
    }

    if (_secondsRemaining.value <= 3 && _secondsRemaining.value >= 1) {
      HapticFeedback.mediumImpact();
      _tts.stop();
      _tts.speak('${_secondsRemaining.value}');
    }
  }

  String _getFocusCue() {
    String cue = 'keep your racket head high and land on your heel.';
    if (widget.drill != null && widget.drill!.shortFocusCues.isNotEmpty) {
      final index = _currentPhaseIndex % widget.drill!.shortFocusCues.length;
      cue = widget.drill!.shortFocusCues[index];
    } else if (_currentPhase.coachTip != null && _currentPhase.coachTip!.isNotEmpty) {
      cue = _currentPhase.coachTip!;
    }
    if (cue.isNotEmpty) {
      cue = cue[0].toLowerCase() + cue.substring(1);
    }
    return cue;
  }

  String _getMistakeToAvoid() {
    String mistake = 'cross your feet or drop your racket arm.';
    if (widget.drill != null && widget.drill!.shortMistakesToAvoid.isNotEmpty) {
      final index = _currentPhaseIndex % widget.drill!.shortMistakesToAvoid.length;
      mistake = widget.drill!.shortMistakesToAvoid[index];
    }
    if (mistake.toLowerCase().startsWith("don't ") || mistake.toLowerCase().startsWith("do not ")) {
      mistake = mistake.substring(mistake.indexOf(' ') + 1);
    }
    if (mistake.isNotEmpty) {
      mistake = mistake[0].toLowerCase() + mistake.substring(1);
    }
    return mistake;
  }

  void _speakPhaseInstruction() {
    _tts.stop();
    final quote = _motivationalQuotes[_currentPhaseIndex % _motivationalQuotes.length];

    switch (_currentPhase.type) {
      case PhaseType.explanation:
        _tts.speak('Get ready! Start ${_currentPhase.title}.');
        break;

      case PhaseType.work:
      case PhaseType.finalChallenge:
        _tts.speak('Start ${_currentPhase.title}!');
        break;

      case PhaseType.rest:
        _tts.speak('Rest! $quote');
        break;

      case PhaseType.coachCue:
        _tts.speak('Get ready for ${_currentPhase.title}.');
        break;
    }
  }

  void _advanceToNextPhase() {
    HapticFeedback.heavyImpact();
    _timer?.cancel();
    if (_currentPhaseIndex < _phases.length - 1) {
      setState(() {
        _currentPhaseIndex++;
      });
      _startCurrentPhase();
    } else {
      _completeSession();
    }
  }

  void _goToPreviousPhase() {
    if (_currentPhaseIndex > 0) {
      _timer?.cancel();
      setState(() {
        _currentPhaseIndex--;
      });
      _startCurrentPhase();
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    if (!_isPaused) {
      _startTimer();
    }
  }

  void _restartSession() {
    _timer?.cancel();
    setState(() {
      _currentPhaseIndex = 0;
      _isPaused = false;
      _isCompleted = false;
    });
    _elapsedTotalSeconds.value = 0;
    _workSecondsTrained.value = 0;
    _startCurrentPhase();
  }

  void _completeSession() {
    _timer?.cancel();
    _tts.speak('Workout complete! Excellent training performance!');

    setState(() {
      _isCompleted = true;
      _isPaused = false;
    });
  }

  String get _statusBadgeLabel {
    if (_isCompleted) return 'COMPLETED';
    if (_isPaused) return 'PAUSED';

    switch (_currentPhase.type) {
      case PhaseType.explanation:
        return 'GET READY';
      case PhaseType.work:
      case PhaseType.finalChallenge:
        return 'PRACTICE';
      case PhaseType.rest:
        return 'REST';
      case PhaseType.coachCue:
        return 'GET READY';
    }
  }

  Color get _statusBadgeColor {
    if (_isCompleted) return AppColors.purple;
    if (_isPaused) return Colors.amberAccent;

    switch (_currentPhase.type) {
      case PhaseType.explanation:
        return AppColors.cyan;
      case PhaseType.work:
      case PhaseType.finalChallenge:
        return AppColors.electricGreen;
      case PhaseType.rest:
        return AppColors.orange;
      case PhaseType.coachCue:
        return AppColors.cyan;
    }
  }

  String get _timerContextText {
    if (_isPaused) return 'PAUSED';

    switch (_currentPhase.type) {
      case PhaseType.explanation:
        return 'BE READY';
      case PhaseType.work:
      case PhaseType.finalChallenge:
        return 'START NOW';
      case PhaseType.rest:
        return 'RECOVER';
      case PhaseType.coachCue:
        return 'BE READY';
    }
  }

  String _formatSeconds(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tts.stop();
    _secondsRemaining.dispose();
    _elapsedTotalSeconds.dispose();
    _workSecondsTrained.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompleted) {
      final xp = widget.drill?.xpReward ?? 90;
      final mins = (_workSecondsTrained.value / 60).ceil().clamp(1, 60);

      return SessionReviewScreen(
        drillTitle: _trainingTitle,
        category: widget.drill?.categoryName ?? 'Footwork',
        xpEarned: xp,
        durationMinutes: mins,
        onFinish: (int qualityScore) {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          final trainingProvider = Provider.of<TrainingProvider>(context, listen: false);

          userProvider.addXp(xp, category: widget.drill?.categoryName ?? 'Footwork');
          userProvider.updateMinutesTrained(mins);
          trainingProvider.logCompletedTraining(
            title: _trainingTitle,
            duration: '$mins min',
            xpEarned: xp,
            category: widget.drill?.categoryName ?? 'Footwork',
            qualityScore: qualityScore,
          );
          Navigator.pop(context);
        },
      );
    }

    if (_isPaused) {
      final totalWork = _phases.fold<int>(0, (sum, p) => sum + p.durationSeconds);
      final pct = totalWork > 0 ? ((_elapsedTotalSeconds.value / totalWork) * 100).clamp(0.0, 99.0) : 50.0;
      final remSecs = (totalWork - _elapsedTotalSeconds.value).clamp(0, 7200);

      return PauseScreenOverlay(
        completedPercentage: pct,
        elapsedFormatted: _formatSeconds(_elapsedTotalSeconds.value),
        remainingFormatted: _formatSeconds(remSecs),
        currentRound: _currentWorkRoundNumber,
        roundsLeft: (_workPhaseCount - _currentWorkRoundNumber).clamp(0, 10),
        onContinue: _togglePause,
        onRestart: _restartSession,
        onExit: () => Navigator.pop(context),
      );
    }

    final overallProgress = (_currentPhaseIndex + 1) / _phases.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              if (details.primaryVelocity! < -300) {
                _advanceToNextPhase();
              } else if (details.primaryVelocity! > 300) {
                _goToPreviousPhase();
              }
            }
          },
          child: Column(
            children: [
              // TOP SECTION
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: const Color(0xFF162238),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                title: Text(
                                  'Exit Workout?',
                                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  'Your session progress will be lost.',
                                  style: GoogleFonts.poppins(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text('Resume', style: GoogleFonts.poppins(color: Colors.white60)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text('Exit', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: Text(
                            _trainingTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Round $_currentWorkRoundNumber of $_workPhaseCount',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: _statusBadgeColor.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _statusBadgeColor.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                _statusBadgeLabel,
                                style: GoogleFonts.poppins(
                                  color: _statusBadgeColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Top Animated Overall Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: overallProgress,
                        minHeight: 6,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation(_statusBadgeColor),
                      ),
                    ),
                  ],
                ),
              ),

              // MAIN CONTENT SCROLL VIEW
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // MAIN TIMER RING
                      ValueListenableBuilder<int>(
                        valueListenable: _secondsRemaining,
                        builder: (context, seconds, child) {
                          return TimerRingWidget(
                            secondsRemaining: seconds,
                            totalSeconds: _currentPhase.durationSeconds,
                            contextText: _timerContextText,
                            primaryColor: _statusBadgeColor,
                            size: 210,
                            isPaused: _isPaused,
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      // VOICE INSTRUCTION CARD
                      ValueListenableBuilder<bool>(
                        valueListenable: _tts.isSpeaking,
                        builder: (context, speaking, child) {
                          return ValueListenableBuilder<String>(
                            valueListenable: _tts.currentSpokenText,
                            builder: (context, spokenText, child) {
                              return VoiceInstructionCard(
                                isSpeaking: speaking,
                                spokenSentence: spokenText.isNotEmpty
                                    ? spokenText
                                    : _currentPhase.type == PhaseType.explanation
                                        ? 'Round One starts soon. Get into ready stance.'
                                        : _currentPhase.type == PhaseType.rest
                                            ? 'Recover, hydrate, prepare for next round.'
                                            : 'Split step. Recover to center.',
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 14),

                      // REST INTERVAL OR DRILL INFO CARD
                      if (_currentPhase.type == PhaseType.rest) ...[
                        GlassCard(
                          padding: const EdgeInsets.all(20),
                          borderColor: AppColors.orange.withValues(alpha: 0.3),
                          glowColor: AppColors.orange.withValues(alpha: 0.12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.self_improvement_rounded, color: AppColors.orange, size: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    'REST & RECOVER',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.orange,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Recover. Hydrate. Prepare for next round.',
                                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '"${_motivationalQuotes[_currentPhaseIndex % _motivationalQuotes.length]}"',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 14),

                              if (_nextPhase != null) ...[
                                Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
                                const SizedBox(height: 12),
                                Text(
                                  'NEXT ROUND PREVIEW',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.cyan,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _nextPhase!.title,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _nextPhase!.description,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ] else ...[
                        DrillInfoCard(
                          drillName: _currentPhase.title,
                          drillEmoji: widget.drill?.emoji ?? '🏸',
                          durationBadge: '${_currentPhase.durationSeconds} SEC',
                          focusCues: widget.drill?.shortFocusCues ?? const [
                            'Stay low.',
                            'Explode to corner.',
                          ],
                          commonMistake: "Don't cross your feet.",
                          mistakesToAvoid: widget.drill?.shortMistakesToAvoid ?? const [
                            "Don't cross your feet.",
                            "Don't stand upright.",
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // BOTTOM NAVIGATION
              TrainingBottomNav(
                isFirstPhase: _currentPhaseIndex == 0,
                isLastPhase: _currentPhaseIndex == _phases.length - 1,
                isPaused: _isPaused,
                onPreviousPhase: _goToPreviousPhase,
                onTogglePause: _togglePause,
                onNextPhase: _advanceToNextPhase,
                requiresSkipConfirmation: _currentPhase.type == PhaseType.work || _currentPhase.type == PhaseType.finalChallenge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
