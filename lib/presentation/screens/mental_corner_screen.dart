import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/voice_coach_service.dart';
import '../../providers/user_provider.dart';

class MentalCornerScreen extends StatefulWidget {
  const MentalCornerScreen({super.key});

  @override
  State<MentalCornerScreen> createState() => _MentalCornerScreenState();
}

class _MentalCornerScreenState extends State<MentalCornerScreen>
    with SingleTickerProviderStateMixin {
  final _voiceCoach = VoiceCoachService();
  bool _isBreathingActive = false;
  bool _isBreathingPaused = false;
  int _breathTimerSeconds = 120;
  String _breathPhase = 'Inhale';
  Timer? _timer;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, String>> _preMatchCards = const [
    {
      'title': 'Trust Your Preparation',
      'category': 'COURT CONFIDENCE',
      'icon': 'psychology',
      'quote':
          'Confidence comes from quality practice. Focus on executing your next shot correctly, not the scoreboard.',
      'tip': 'Focus 100% on racket preparation and split-step timing.',
    },
    {
      'title': 'Stay Present (Next Point Reset)',
      'category': 'MINDFULNESS',
      'icon': 'center_focus_strong',
      'quote':
          'The previous point is history. The next shot is the only thing you control right now. Reset immediately.',
      'tip': 'Use a 3-second racket string adjustment as a physical reset cue.',
    },
    {
      'title': 'Process Over Outcome',
      'category': 'PRESSURE CONTROL',
      'icon': 'bolt',
      'quote':
          'Winning is the natural consequence of consistently performing the process well. Stay composed.',
      'tip': 'Stick to high-percentage tactical patterns when trailing.',
    },
  ];

  final List<Map<String, String>> _selfTalkReframes = const [
    {
      'negative': '"I always miss this smash under pressure."',
      'positive': '"Prepare early, contact high, and snap the wrist with control."',
      'category': 'ATTACK CONFIDENCE',
    },
    {
      'negative': '"I am losing control of this match pace."',
      'positive': '"Slow down between points, take a deep breath, and command base position."',
      'category': 'TEMPO CONTROL',
    },
    {
      'negative': '"My opponent is too fast for me."',
      'positive': '"Place the shuttle deep to the corners and force them to lift high."',
      'category': 'TACTICAL RESET',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startMindfulnessTimer() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isBreathingActive = true;
      _isBreathingPaused = false;
      _breathTimerSeconds = 120;
      _breathPhase = 'Inhale';
    });
    _pulseController.reset();
    _pulseController.repeat(reverse: true);
    _voiceCoach.speak('Breathe in deeply through your nose. Focus your mind.');

    _startTimerTicks();
  }

  void _startTimerTicks() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _isBreathingPaused) return;
      if (_breathTimerSeconds > 1) {
        setState(() {
          _breathTimerSeconds--;
          final cycle = _breathTimerSeconds % 8;
          if (cycle >= 4) {
            if (_breathPhase != 'Inhale') {
              _breathPhase = 'Inhale';
              HapticFeedback.lightImpact();
            }
          } else {
            if (_breathPhase != 'Exhale') {
              _breathPhase = 'Exhale';
              HapticFeedback.lightImpact();
            }
          }
        });
      } else {
        _timer?.cancel();
        _pulseController.stop();
        setState(() {
          _isBreathingActive = false;
          _isBreathingPaused = false;
        });
        HapticFeedback.heavyImpact();
        _voiceCoach.speak('Mindfulness focus complete. You are calm and ready to train.');
        Provider.of<UserProvider>(context, listen: false).addXp(50, category: 'Mental');
      }
    });
  }

  void _togglePauseBreathing() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isBreathingPaused = !_isBreathingPaused;
    });

    if (_isBreathingPaused) {
      _timer?.cancel();
      _pulseController.stop();
      _voiceCoach.speak('Session paused.');
    } else {
      _pulseController.repeat(reverse: true);
      _voiceCoach.speak('Resuming session.');
      _startTimerTicks();
    }
  }

  void _stopTimer() {
    HapticFeedback.mediumImpact();
    _timer?.cancel();
    _pulseController.stop();
    setState(() {
      _isBreathingActive = false;
      _isBreathingPaused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.courtBackground,
      appBar: AppBar(
        backgroundColor: AppColors.courtBackground,
        elevation: 0,
        title: Text(
          'Mental Corner & Psychology',
          style: GoogleFonts.poppins(
            color: AppColors.chalkWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. VISUAL 2-MINUTE BREATHING & FOCUS CARD
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.courtSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.skyBlue.withValues(alpha: 0.3),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.skyBlue.withValues(alpha: 0.12),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.skyBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.skyBlue.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          '2-MINUTE MINDFULNESS RESET',
                          style: GoogleFonts.jetBrainsMono(
                            color: AppColors.skyBlue,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.self_improvement_rounded,
                        color: AppColors.skyBlue,
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (_isBreathingActive) ...[
                    // ANIMATED BREATHING CIRCLE (INHALE EXPANDS, EXHALE CONTRACTS TO NORMAL)
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        // Smooth scale from 1.0 (normal) to 1.35 (expanded)
                        final scaleValue = 1.0 + (_pulseAnimation.value * 0.35);

                        return Transform.scale(
                          scale: scaleValue,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  (_breathPhase == 'Inhale'
                                          ? AppColors.skyBlue
                                          : AppColors.limeGreen)
                                      .withValues(alpha: 0.45),
                                  AppColors.limeGreen.withValues(alpha: 0.15),
                                  Colors.transparent,
                                ],
                              ),
                              border: Border.all(
                                color: _breathPhase == 'Inhale'
                                    ? AppColors.skyBlue
                                    : AppColors.limeGreen,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (_breathPhase == 'Inhale'
                                          ? AppColors.skyBlue
                                          : AppColors.limeGreen)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 25,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _isBreathingPaused
                                        ? 'PAUSED'
                                        : _breathPhase.toUpperCase(),
                                    style: GoogleFonts.jetBrainsMono(
                                      color: AppColors.chalkWhite,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  Text(
                                    '${_breathTimerSeconds}s',
                                    style: GoogleFonts.bebasNeue(
                                      color: AppColors.chalkWhite,
                                      fontSize: 34,
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),

                    // PAUSE & STOP BUTTON ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // PAUSE / RESUME BUTTON
                        ElevatedButton.icon(
                          onPressed: _togglePauseBreathing,
                          icon: Icon(_isBreathingPaused
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded),
                          label: Text(
                            _isBreathingPaused ? 'RESUME' : 'PAUSE',
                            style: GoogleFonts.jetBrainsMono(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              fontSize: 11.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isBreathingPaused
                                ? AppColors.corkGold
                                : AppColors.skyBlue,
                            foregroundColor: AppColors.courtBackground,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // STOP BUTTON
                        ElevatedButton.icon(
                          onPressed: _stopTimer,
                          icon: const Icon(Icons.stop_rounded),
                          label: Text(
                            'STOP',
                            style: GoogleFonts.jetBrainsMono(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              fontSize: 11.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.coral,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      'Pre-Session Focus & Calm',
                      style: GoogleFonts.bebasNeue(
                        color: AppColors.chalkWhite,
                        fontSize: 26,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lower your heart rate, clear performance anxiety, and synchronize breath for high-intensity training.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppColors.sageGray,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: _startMindfulnessTimer,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(
                        'BEGIN 2-MIN BREATHING (+50 XP)',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.skyBlue,
                        foregroundColor: AppColors.courtBackground,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 2. PRE-MATCH MENTAL PREPARATION CARDS
            Text(
              'PRE-MATCH PREPARATION',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.corkGold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Court Mindset & Focus Strategies',
              style: GoogleFonts.bebasNeue(
                color: AppColors.chalkWhite,
                fontSize: 24,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),

            ..._preMatchCards.map((card) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.courtSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.sageGray.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.softViolet
                                  .withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.psychology_rounded,
                              color: AppColors.softViolet,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              card['title']!,
                              style: GoogleFonts.inter(
                                color: AppColors.chalkWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.corkGold
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              card['category']!,
                              style: GoogleFonts.jetBrainsMono(
                                color: AppColors.corkGold,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '"${card['quote']!}"',
                        style: GoogleFonts.inter(
                          color: AppColors.chalkWhite.withValues(alpha: 0.9),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.courtBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lightbulb_outline_rounded,
                              color: AppColors.limeGreen,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                card['tip']!,
                                style: GoogleFonts.inter(
                                  color: AppColors.sageGray,
                                  fontSize: 11.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 28),

            // 3. POSITIVE SELF-TALK REFRAMING ENGINE
            Text(
              'SELF-TALK REFRAMING',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.corkGold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Constructive Action Cue Engine',
              style: GoogleFonts.bebasNeue(
                color: AppColors.chalkWhite,
                fontSize: 24,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Replace doubt with precise technical focus cues.',
              style: GoogleFonts.inter(
                color: AppColors.sageGray,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 14),

            ..._selfTalkReframes.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.courtSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.limeGreen.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['category']!,
                          style: GoogleFonts.jetBrainsMono(
                            color: AppColors.sageGray,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const Icon(
                          Icons.swap_horiz_rounded,
                          color: AppColors.sageGray,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Negative pattern
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.cancel_outlined,
                          color: AppColors.coral,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item['negative']!,
                            style: GoogleFonts.inter(
                              color: AppColors.coral,
                              fontSize: 12.5,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppColors.coral,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: Colors.white10, height: 1),
                    ),
                    // Positive reframe
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.limeGreen,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item['positive']!,
                            style: GoogleFonts.inter(
                              color: AppColors.chalkWhite,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
