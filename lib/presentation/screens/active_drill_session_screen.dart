import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/voice_coach_service.dart';
import '../../domain/entities/drill.dart';
import '../../providers/user_provider.dart';
import '../../providers/training_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';

class ActiveDrillSessionScreen extends StatefulWidget {
  const ActiveDrillSessionScreen({
    super.key,
    required this.drill,
  });

  final Drill drill;

  @override
  State<ActiveDrillSessionScreen> createState() => _ActiveDrillSessionScreenState();
}

class _ActiveDrillSessionScreenState extends State<ActiveDrillSessionScreen> {
  final VoiceCoachService _tts = VoiceCoachService();
  int _currentPhaseIndex = 0;
  late int _secondsRemaining;
  bool _isPaused = false;
  bool _isCompleted = false;
  Timer? _timer;
  int _totalWorkSecondsTrained = 0;

  List<DrillPhase> get _phases {
    if (widget.drill.phases.isNotEmpty) {
      return widget.drill.phases;
    }
    return [
      DrillPhase(
        title: 'Get Ready (15s)',
        description: 'Prepare posture and balance for Round 1 of ${widget.drill.title}.',
        durationSeconds: 15,
        type: PhaseType.explanation,
      ),
      DrillPhase(
        title: 'Round 1 – Base Execution',
        description: widget.drill.objective,
        durationSeconds: widget.drill.durationSeconds > 0 ? widget.drill.durationSeconds ~/ 3 : 45,
        type: PhaseType.work,
        coachTip: widget.drill.coachCue,
      ),
      const DrillPhase(
        title: 'Rest & Reset',
        description: 'Hydrate and catch your breath before Round 2.',
        durationSeconds: 20,
        type: PhaseType.rest,
      ),
      DrillPhase(
        title: 'Round 2 – Increased Tempo',
        description: 'Increase movement pace while maintaining solid balance.',
        durationSeconds: widget.drill.durationSeconds > 0 ? widget.drill.durationSeconds ~/ 3 : 45,
        type: PhaseType.work,
      ),
      const DrillPhase(
        title: 'Rest & Reset',
        description: 'Breathe deeply and refocus for the final round.',
        durationSeconds: 20,
        type: PhaseType.rest,
      ),
      DrillPhase(
        title: 'Final Challenge Round',
        description: 'Maximum explosive speed execution to finish the drill.',
        durationSeconds: widget.drill.durationSeconds > 0 ? widget.drill.durationSeconds ~/ 3 : 60,
        type: PhaseType.finalChallenge,
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

  @override
  void initState() {
    super.initState();
    _secondsRemaining = _currentPhase.durationSeconds;
    _startSession();
  }

  void _startSession() {
    setState(() {
      _isPaused = false;
    });
    _speakPhaseAnnouncement(_currentPhase);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (!_isPaused && _secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
          if (_currentPhase.type == PhaseType.work || _currentPhase.type == PhaseType.finalChallenge) {
            _totalWorkSecondsTrained++;
          }
        });
      } else if (!_isPaused) {
        _advancePhase();
      }
    });
  }

  void _advancePhase() {
    _timer?.cancel();
    if (_currentPhaseIndex < _phases.length - 1) {
      setState(() {
        _currentPhaseIndex++;
        _secondsRemaining = _currentPhase.durationSeconds;
      });
      _speakPhaseAnnouncement(_currentPhase);
      _startTimer();
    } else {
      _onDrillCompleted();
    }
  }

  // TASK 7: Realistic BWF Coach Speech & TASK 8: Rest Next Phase Announcement
  void _speakPhaseAnnouncement(DrillPhase phase) {
    switch (phase.type) {
      case PhaseType.explanation:
        final round1 = _phases.firstWhere(
          (p) => p.type == PhaseType.work,
          orElse: () => _currentPhase,
        );
        final tip = round1.coachTip ?? widget.drill.coachCue;
        _tts.speak(
          'Ready to go! Round 1: ${round1.title}. ${round1.description}. '
          '${tip.isNotEmpty ? "Coaching tip: $tip" : ""}',
        );
        break;
      case PhaseType.work:
        _tts.speak(
          'Starting ${phase.title}. ${phase.description} '
          '${phase.coachTip != null && phase.coachTip!.isNotEmpty ? "Coach tip: ${phase.coachTip!}" : ""}',
        );
        break;
      case PhaseType.rest:
        if (_nextPhase != null) {
          _tts.speak(
            'Rest interval. Breathe and reset. Next you will perform ${_nextPhase!.title}. ${_nextPhase!.description}',
          );
        } else {
          _tts.speak('Rest interval. Breathe and recover.');
        }
        break;
      case PhaseType.coachCue:
        _tts.speak('Coach focus: ${phase.description}');
        break;
      case PhaseType.finalChallenge:
        _tts.speak('Final challenge round! Maximum explosive speed!');
        break;
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _addRestTime(int seconds) {
    if (_currentPhase.type == PhaseType.rest) {
      setState(() {
        _secondsRemaining += seconds;
      });
    }
  }

  // TASK 8: "i" Information Button Modal handler (pauses timer, shows modal, resumes on dismiss)
  void _showPhaseInfoModal(DrillPhase targetPhase) {
    _timer?.cancel();
    setState(() {
      _isPaused = true;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.info_outline_rounded, color: AppColors.cyan, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      targetPhase.title,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Detailed Instructions',
                style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                targetPhase.description,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, height: 1.45),
              ),
              if (targetPhase.coachTip != null && targetPhase.coachTip!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tips_and_updates_rounded, color: AppColors.orange, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          targetPhase.coachTip!,
                          style: GoogleFonts.poppins(color: AppColors.orange, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              AppButton(
                text: 'RESUME WORKOUT',
                icon: Icons.play_arrow_rounded,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      if (mounted) {
        setState(() {
          _isPaused = false;
        });
        _startTimer();
      }
    });
  }

  void _onDrillCompleted() {
    _timer?.cancel();
    _tts.speak('Drill completed! Excellent work!');
    setState(() {
      _isPaused = false;
      _isCompleted = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final trainingProvider = Provider.of<TrainingProvider>(context, listen: false);

    final xp = widget.drill.xpReward;
    final minsTrained = (_totalWorkSecondsTrained / 60).ceil().clamp(1, 60);

    userProvider.addXp(xp);
    userProvider.updateMinutesTrained(minsTrained);
    trainingProvider.logCompletedTraining(
      title: widget.drill.title,
      duration: '$minsTrained min',
      xpEarned: xp,
      category: widget.drill.categoryName,
    );
  }

  Color _getPhaseColor(PhaseType type) {
    switch (type) {
      case PhaseType.explanation:
        return AppColors.cyan;
      case PhaseType.work:
        return AppColors.primaryGreen;
      case PhaseType.rest:
        return AppColors.orange;
      case PhaseType.coachCue:
        return AppColors.purple;
      case PhaseType.finalChallenge:
        return AppColors.red;
    }
  }

  String get _formattedTime {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drill = widget.drill;
    final phase = _currentPhase;
    final phaseColor = _getPhaseColor(phase.type);
    final totalPhases = _phases.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(drill.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      // TASK 6: NO SCROLLING DURING WORKOUTS – Entire view fits inSafeArea without scrolling
      body: SafeArea(
        child: _isCompleted
            ? _buildCompletionSummary(context)
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    // 1. Phase Progress Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BadgeTag(
                          label: phase.type == PhaseType.work
                              ? 'ACTIVE ROUND'
                              : phase.type == PhaseType.rest
                                  ? 'REST INTERVAL'
                                  : phase.type == PhaseType.finalChallenge
                                      ? 'FINAL CHALLENGE'
                                      : 'GET READY',
                          color: phaseColor,
                        ),
                        Text(
                          'Phase ${_currentPhaseIndex + 1} of $totalPhases',
                          style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (_currentPhaseIndex + 1) / totalPhases,
                        minHeight: 6,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation(phaseColor),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 2. Timer Circle (Auto Scaled)
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            height: 180,
                            width: 180,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surface,
                              border: Border.all(
                                color: _isPaused ? Colors.white24 : phaseColor,
                                width: 5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: phaseColor.withValues(alpha: 0.25),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isPaused
                                      ? Icons.pause_circle_rounded
                                      : phase.type == PhaseType.rest
                                          ? Icons.self_improvement_rounded
                                          : phase.type == PhaseType.finalChallenge
                                              ? Icons.local_fire_department_rounded
                                              : Icons.timer_rounded,
                                  color: phaseColor,
                                  size: 28,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formattedTime,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Text(
                                  _isPaused ? 'Paused' : phase.title,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 3. Active Phase / Next Phase Rest Card (TASK 8)
                    Expanded(
                      flex: 5,
                      child: AppCard(
                        backgroundColor: AppColors.surface,
                        borderColor: phaseColor.withValues(alpha: 0.4),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    phase.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.info_outline_rounded, color: AppColors.cyan, size: 22),
                                  onPressed: () => _showPhaseInfoModal(phase),
                                  tooltip: 'Drill Information',
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              phase.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                            ),

                            // 15s Briefing Round 1 Information Display
                            if (phase.type == PhaseType.explanation) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.cyan.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.cyan.withValues(alpha: 0.4)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.campaign_rounded, color: AppColors.cyan, size: 22),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'GET READY – ROUND 1 PREVIEW',
                                            style: GoogleFonts.poppins(color: AppColors.cyan, fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            drill.objective,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // TASK 8: Next Drill Preview during Rest Interval
                            if (phase.type == PhaseType.rest && _nextPhase != null) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.next_plan_rounded, color: AppColors.electricGreen, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'NEXT: ${_nextPhase!.title}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            _nextPhase!.description,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.info_outline_rounded, color: AppColors.electricGreen, size: 18),
                                      onPressed: () => _showPhaseInfoModal(_nextPhase!),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 4. Control Buttons (All Visible without scrolling)
                    Column(
                      children: [
                        if (phase.type == PhaseType.rest) ...[
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: '+20s REST',
                                  type: AppButtonType.outline,
                                  icon: Icons.add_circle_outline_rounded,
                                  onPressed: () => _addRestTime(20),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: AppButton(
                                  text: 'SKIP REST',
                                  icon: Icons.fast_forward_rounded,
                                  onPressed: _advancePhase,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],

                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                text: _isPaused ? 'RESUME' : 'PAUSE',
                                type: AppButtonType.outline,
                                icon: _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                                onPressed: _togglePause,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppButton(
                                text: 'NEXT PHASE',
                                icon: Icons.skip_next_rounded,
                                onPressed: _advancePhase,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCompletionSummary(BuildContext context) {
    final drill = widget.drill;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 80,
            width: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.electricGreen, size: 48),
          ),
          const SizedBox(height: 16),
          Text(
            'Session Completed!',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Great effort coach! Consistency is key to badminton excellence.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
          ),

          const SizedBox(height: 24),

          AppCard(
            backgroundColor: AppColors.surface,
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat('${_phases.length}', 'Rounds'),
                Container(height: 32, width: 1, color: Colors.white12),
                _buildSummaryStat('${(_totalWorkSecondsTrained / 60).ceil()} min', 'Work Time'),
                Container(height: 32, width: 1, color: Colors.white12),
                _buildSummaryStat('+${drill.xpReward}', 'XP Earned'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          AppCard(
            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderColor: AppColors.primaryGreen.withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite_rounded, color: AppColors.primaryGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Post-Drill Recovery Tip',
                      style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Hydrate with water and perform 2 minutes of dynamic quad stretches before your next routine.',
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          AppButton(
            text: 'CLAIM XP & FINISH',
            icon: Icons.emoji_events_rounded,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('🎉 ${drill.title} Complete! +${drill.xpReward} XP Added!')),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }
}
