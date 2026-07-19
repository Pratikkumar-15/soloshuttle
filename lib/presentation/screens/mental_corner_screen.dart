import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/voice_coach_service.dart';
import '../../providers/user_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';

class MentalCornerScreen extends StatefulWidget {
  const MentalCornerScreen({super.key});

  @override
  State<MentalCornerScreen> createState() => _MentalCornerScreenState();
}

class _MentalCornerScreenState extends State<MentalCornerScreen> {
  final _voiceCoach = VoiceCoachService();
  bool _isBreathingActive = false;
  int _breathTimerSeconds = 120;
  String _breathPhase = 'Inhale';
  Timer? _timer;

  final List<Map<String, String>> _preMatchCards = const [
    {
      'title': 'Trust Your Preparation',
      'quote': 'Confidence comes from quality practice. Focus on executing your next shot correctly, not the scoreboard.',
    },
    {
      'title': 'Stay Present',
      'quote': 'The previous point is history. The next shot is the only thing you control right now. Reset immediately.',
    },
    {
      'title': 'Process Over Outcome',
      'quote': 'Winning is the natural consequence of consistently performing the process well. Stay composed.',
    },
  ];

  final List<Map<String, String>> _selfTalkReframes = const [
    {
      'negative': '"I always miss this smash under pressure."',
      'positive': '"Prepare early, contact high, and snap the wrist gently."',
    },
    {
      'negative': '"I am losing control of this match."',
      'positive': '"Slow down the rally tempo, breathe deeply, and focus on base recovery."',
    },
    {
      'negative': '"My opponent is too fast for me."',
      'positive': '"Control shuttle placement to force them to lift. Focus on my court positioning."',
    },
  ];

  void _startMindfulnessTimer() {
    setState(() {
      _isBreathingActive = true;
      _breathTimerSeconds = 120;
      _breathPhase = 'Inhale';
    });
    _voiceCoach.speak('Breathe in deeply through your nose. Focus your mind.');

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_breathTimerSeconds > 1) {
        setState(() {
          _breathTimerSeconds--;
          final cycle = _breathTimerSeconds % 8;
          if (cycle >= 4) {
            _breathPhase = 'Inhale';
          } else {
            _breathPhase = 'Exhale';
          }
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isBreathingActive = false;
        });
        _voiceCoach.speak('Mindfulness focus complete. You are calm and ready to train.');
        Provider.of<UserProvider>(context, listen: false).addXp(50, category: 'Mental');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Mental Corner & Psychology', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2-Minute Breathing & Focus Timer Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B2942), Color(0xFF111E30)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.cyan.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      BadgeTag(label: '2-MINUTE MINDFULNESS TIMER', color: AppColors.cyan),
                      const Spacer(),
                      const Icon(Icons.self_improvement_rounded, color: AppColors.cyan, size: 24),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_isBreathingActive) ...[
                    Text(
                      _breathPhase.toUpperCase(),
                      style: GoogleFonts.poppins(color: AppColors.cyan, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$_breathTimerSeconds s',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        _timer?.cancel();
                        setState(() {
                          _isBreathingActive = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
                      child: const Text('STOP TIMER'),
                    ),
                  ] else ...[
                    Text(
                      'Pre-Training Breathing & Focus',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Clear your mind and calm heart rate before starting technical sessions.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12.5),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _startMindfulnessTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cyan,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('BEGIN 2-MIN BREATHING', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pre-Match Mental Prep Cards
            Text(
              'Pre-Match Mental Preparation',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ..._preMatchCards.map((card) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.psychology_rounded, color: AppColors.purple, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            card['title']!,
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '"${card['quote']!}"',
                        style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12.5, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // Positive Self-Talk Engine
            Text(
              'Positive Self-Talk Reframing',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Replace negative self-criticism with constructive technical action cues.',
              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 12),

            ..._selfTalkReframes.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.cancel_outlined, color: AppColors.red, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item['negative']!,
                            style: GoogleFonts.poppins(color: AppColors.red, fontSize: 12, decoration: TextDecoration.lineThrough),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, color: AppColors.electricGreen, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item['positive']!,
                            style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 12.5, fontWeight: FontWeight.bold),
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
