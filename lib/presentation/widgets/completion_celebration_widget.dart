import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'glass_card.dart';

class CompletionCelebrationWidget extends StatefulWidget {
  const CompletionCelebrationWidget({
    super.key,
    required this.roundsCompleted,
    required this.totalTimeFormatted,
    required this.estimatedCalories,
    required this.xpEarned,
    required this.consistencyStreak,
    required this.onTrainAgain,
    required this.onShareProgress,
    required this.onBackHome,
  });

  final int roundsCompleted;
  final String totalTimeFormatted;
  final int estimatedCalories;
  final int xpEarned;
  final int consistencyStreak;
  final VoidCallback onTrainAgain;
  final VoidCallback onShareProgress;
  final VoidCallback onBackHome;

  @override
  State<CompletionCelebrationWidget> createState() => _CompletionCelebrationWidgetState();
}

class _CompletionCelebrationWidgetState extends State<CompletionCelebrationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _checkAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Confetti Particle Background
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _ConfettiPainter(progress: _animController.value),
                );
              },
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 12),

                  // Animated Checkmark & Celebration Header
                  Column(
                    children: [
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00FF87), Color(0xFF00CEC9)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.electricGreen.withValues(alpha: 0.5),
                                blurRadius: 28,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: ScaleTransition(
                            scale: _checkAnimation,
                            child: const Icon(
                              Icons.check_rounded,
                              size: 54,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Workout Complete!',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Outstanding session! You\'re leveling up fast.',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  // Statistics Grid
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    borderColor: AppColors.electricGreen.withValues(alpha: 0.3),
                    glowColor: AppColors.electricGreen.withValues(alpha: 0.12),
                    child: Column(
                      children: [
                        Text(
                          'SESSION SUMMARY',
                          style: GoogleFonts.poppins(
                            color: AppColors.electricGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statItem('${widget.roundsCompleted}', 'Rounds', Icons.fitness_center_rounded),
                            _verticalDivider(),
                            _statItem(widget.totalTimeFormatted, 'Total Time', Icons.timer_outlined),
                            _verticalDivider(),
                            _statItem('${widget.estimatedCalories} kcal', 'Est. Calories', Icons.local_fire_department_rounded),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statItem('+${widget.xpEarned} XP', 'XP Earned', Icons.stars_rounded, color: AppColors.cyan),
                            _verticalDivider(),
                            _statItem('${widget.consistencyStreak} Days', 'Streak', Icons.bolt_rounded, color: AppColors.orange),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Buttons (Train Again, Share Progress, Back Home)
                  Column(
                    children: [
                      // Back Home (Primary Green)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryGreen.withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: widget.onBackHome,
                            icon: const Icon(Icons.home_rounded, color: Colors.black),
                            label: Text(
                              'BACK HOME',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: widget.onTrainAgain,
                              icon: const Icon(Icons.replay_rounded, color: Colors.white),
                              label: Text(
                                'TRAIN AGAIN',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: widget.onShareProgress,
                              icon: const Icon(Icons.share_rounded, color: AppColors.cyan),
                              label: Text(
                                'SHARE PROGRESS',
                                style: GoogleFonts.poppins(
                                  color: AppColors.cyan,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: AppColors.cyan.withValues(alpha: 0.4)),
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label, IconData icon, {Color? color}) {
    final c = color ?? Colors.white;
    return Column(
      children: [
        Icon(icon, color: c, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(height: 36, width: 1, color: Colors.white12);
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress});

  final double progress;
  final Random random = Random(42);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final colors = [
      const Color(0xFF00FF87),
      const Color(0xFF00CEC9),
      const Color(0xFFFF9F43),
      const Color(0xFFFF5252),
      const Color(0xFF6C5CE7),
    ];

    for (int i = 0; i < 40; i++) {
      final color = colors[i % colors.length];
      final startX = random.nextDouble() * size.width;
      final speed = 150 + random.nextDouble() * 300;
      final y = (progress * speed + random.nextDouble() * 50) % size.height;
      final radius = 3.0 + random.nextDouble() * 4.0;

      final paint = Paint()
        ..color = color.withValues(alpha: (1.0 - (y / size.height)).clamp(0.2, 0.9));
      canvas.drawCircle(Offset(startX, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}
