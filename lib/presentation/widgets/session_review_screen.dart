import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/voice_coach_service.dart';
import '../../providers/ai_coach_provider.dart';

class SessionReviewScreen extends StatefulWidget {
  final String drillTitle;
  final String category;
  final int xpEarned;
  final int durationMinutes;
  final void Function(int qualityScore) onFinish;

  const SessionReviewScreen({
    super.key,
    required this.drillTitle,
    required this.category,
    required this.xpEarned,
    required this.durationMinutes,
    required this.onFinish,
  });

  @override
  State<SessionReviewScreen> createState() => _SessionReviewScreenState();
}

class _SessionReviewScreenState extends State<SessionReviewScreen>
    with SingleTickerProviderStateMixin {
  final _voiceCoach = VoiceCoachService();
  int _selectedRating = 5;

  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _rotationAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    );

    _rotationAnim = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    _animController.forward();
    HapticFeedback.heavyImpact();

    _voiceCoach.speak(
        'Congratulations! Workout completed! Exceptional court performance and dedication!');
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aiCoach = Provider.of<AiCoachProvider>(context, listen: false);

    final feedback = aiCoach.generatePostSessionFeedback(
      drillTitle: widget.drillTitle,
      durationMinutes: widget.durationMinutes,
      xpEarned: widget.xpEarned,
      qualityStars: _selectedRating,
    );

    return Scaffold(
      backgroundColor: AppColors.courtBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // CELEBRATION CONFETTI PARTICLE BACKGROUND PAINTER
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: ConfettiCelebrationPainter(
                    progress: _animController.value,
                  ),
                );
              },
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // 1. ANIMATED TROPHY CELEBRATION HEADER
                  Center(
                    child: Column(
                      children: [
                        ScaleTransition(
                          scale: _scaleAnim,
                          child: RotationTransition(
                            turns: _rotationAnim,
                            child: Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: AppColors.corkGold.withValues(alpha: 0.18),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.corkGold,
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.corkGold
                                        .withValues(alpha: 0.4),
                                    blurRadius: 30,
                                    spreadRadius: 6,
                                  ),
                                  BoxShadow(
                                    color: AppColors.limeGreen
                                        .withValues(alpha: 0.2),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.emoji_events_rounded,
                                    color: AppColors.corkGold,
                                    size: 58,
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 12,
                                    child: Icon(
                                      Icons.star_rounded,
                                      color: AppColors.limeGreen,
                                      size: 20,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    left: 10,
                                    child: Icon(
                                      Icons.auto_awesome_rounded,
                                      color: AppColors.skyBlue,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        FadeTransition(
                          opacity: _fadeAnim,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.limeGreen
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.limeGreen
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Text(
                                  '🎉 SESSION VICTORY ACHIEVED 🎉',
                                  style: GoogleFonts.jetBrainsMono(
                                    color: AppColors.limeGreen,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'SESSION COMPLETE!',
                                style: GoogleFonts.bebasNeue(
                                  color: AppColors.chalkWhite,
                                  fontSize: 36,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.drillTitle,
                                style: GoogleFonts.inter(
                                  color: AppColors.sageGray,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 2. XP & TIME BURST CARDS
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.courtSurface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.limeGreen.withValues(alpha: 0.4),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.limeGreen.withValues(alpha: 0.12),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                '+${widget.xpEarned}',
                                style: GoogleFonts.bebasNeue(
                                  color: AppColors.limeGreen,
                                  fontSize: 36,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'XP EARNED',
                                style: GoogleFonts.jetBrainsMono(
                                  color: AppColors.sageGray,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.courtSurface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.skyBlue.withValues(alpha: 0.4),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.skyBlue.withValues(alpha: 0.12),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${widget.durationMinutes}m',
                                style: GoogleFonts.bebasNeue(
                                  color: AppColors.skyBlue,
                                  fontSize: 36,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'TIME TRAINED',
                                style: GoogleFonts.jetBrainsMono(
                                  color: AppColors.sageGray,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 3. TECHNIQUE QUALITY RATING
                  Text(
                    'RATE YOUR TECHNIQUE QUALITY TODAY',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.corkGold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.courtSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.sageGray.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        final isSelected = starIndex <= _selectedRating;
                        return IconButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _selectedRating = starIndex;
                            });
                          },
                          icon: Icon(
                            isSelected
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: isSelected
                                ? AppColors.corkGold
                                : AppColors.sageGray.withValues(alpha: 0.3),
                            size: 34,
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. AI COACH DEBRIEF CARD
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.courtSurface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.softViolet.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.psychology_rounded,
                              color: AppColors.softViolet,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AI COACH DEBRIEF',
                              style: GoogleFonts.jetBrainsMono(
                                color: AppColors.softViolet,
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          feedback,
                          style: GoogleFonts.inter(
                            color: AppColors.chalkWhite,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 5. FINISH SESSION BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        widget.onFinish(_selectedRating);
                      },
                      icon: const Icon(Icons.check_circle_rounded),
                      label: Text(
                        'FINISH SESSION & SAVE PROGRESS',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.limeGreen,
                        foregroundColor: AppColors.courtBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
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
  }
}

// CUSTOM PAINTER FOR CONFETTI SPARKLE CELEBRATION
class ConfettiCelebrationPainter extends CustomPainter {
  final double progress;

  ConfettiCelebrationPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final random = math.Random(42); // fixed seed for smooth animation
    final colors = [
      AppColors.corkGold,
      AppColors.limeGreen,
      AppColors.skyBlue,
      AppColors.softViolet,
      AppColors.coral,
    ];

    final centerX = size.width / 2;
    final centerY = 160.0;

    for (int i = 0; i < 40; i++) {
      final angle = (i * (360 / 40)) * (math.pi / 180);
      final speed = 120 + random.nextDouble() * 180;
      final distance = progress * speed;
      final x = centerX + math.cos(angle) * distance;
      final y = centerY + math.sin(angle) * distance + (progress * progress * 40);

      final color = colors[i % colors.length]
          .withValues(alpha: (1.0 - progress).clamp(0.0, 1.0));
      final paint = Paint()..color = color;

      final radius = 3.0 + random.nextDouble() * 3.5;
      if (i % 3 == 0) {
        // Draw star dot
        canvas.drawCircle(Offset(x, y), radius, paint);
      } else {
        // Draw confetti square
        canvas.drawRect(
          Rect.fromCenter(
              center: Offset(x, y), width: radius * 2, height: radius * 1.5),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiCelebrationPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
