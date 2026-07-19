import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'glass_card.dart';

class PauseScreenOverlay extends StatelessWidget {
  const PauseScreenOverlay({
    super.key,
    required this.completedPercentage,
    required this.elapsedFormatted,
    required this.remainingFormatted,
    required this.currentRound,
    required this.roundsLeft,
    required this.onContinue,
    required this.onRestart,
    required this.onExit,
  });

  final double completedPercentage; // 0.0 to 100.0
  final String elapsedFormatted;
  final String remainingFormatted;
  final int currentRound;
  final int roundsLeft;
  final VoidCallback onContinue;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  static const List<String> quotes = [
    'Don\'t lose your momentum.',
    'Finish what you started.',
    'Your future self will thank you.',
  ];

  @override
  Widget build(BuildContext context) {
    final quoteIndex = (currentRound + (completedPercentage.toInt())) % quotes.length;
    final quote = quotes[quoteIndex];

    return Scaffold(
      backgroundColor: AppColors.background.withValues(alpha: 0.96),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Header
              Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.orange.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.orange.withValues(alpha: 0.4)),
                    ),
                    child: const Icon(Icons.pause_rounded, color: AppColors.orange, size: 32),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Workout Paused',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Catch your breath and jump back in.',
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              // Center Statistics & Quote Card
              Column(
                children: [
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    borderColor: Colors.white12,
                    child: Column(
                      children: [
                        // Progress Bar Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SESSION PROGRESS',
                              style: GoogleFonts.poppins(
                                color: AppColors.cyan,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text(
                              '${completedPercentage.toInt()}%',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: completedPercentage / 100.0,
                            minHeight: 8,
                            backgroundColor: Colors.white12,
                            valueColor: const AlwaysStoppedAnimation(AppColors.primaryGreen),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
                        const SizedBox(height: 20),

                        // Stats Grid (2x2)
                        Row(
                          children: [
                            Expanded(child: _statTile('Elapsed Time', elapsedFormatted, Icons.timer_outlined)),
                            Container(height: 36, width: 1, color: Colors.white12),
                            Expanded(child: _statTile('Time Left', remainingFormatted, Icons.hourglass_bottom_rounded)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _statTile('Current Round', 'Round $currentRound', Icons.fitness_center_rounded)),
                            Container(height: 36, width: 1, color: Colors.white12),
                            Expanded(child: _statTile('Rounds Left', '$roundsLeft Left', Icons.flag_rounded)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Motivational Quote Card
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    borderColor: AppColors.cyan.withValues(alpha: 0.3),
                    glowColor: AppColors.cyan.withValues(alpha: 0.1),
                    child: Row(
                      children: [
                        const Icon(Icons.format_quote_rounded, color: AppColors.cyan, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '"$quote"',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Bottom Action Buttons
              Column(
                children: [
                  // Largest Bright Green Continue Practice Button
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withValues(alpha: 0.4),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: onContinue,
                        icon: const Icon(Icons.play_arrow_rounded, size: 28, color: Colors.black),
                        label: Text(
                          'CONTINUE PRACTICE',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      // Restart Training
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onRestart,
                          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                          label: Text(
                            'RESTART',
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
                      const SizedBox(width: 12),

                      // Exit Session
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onExit,
                          icon: const Icon(Icons.close_rounded, color: AppColors.red),
                          label: Text(
                            'EXIT SESSION',
                            style: GoogleFonts.poppins(
                              color: AppColors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.red.withValues(alpha: 0.3)),
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
      ),
    );
  }

  Widget _statTile(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.cyan, size: 16),
            const SizedBox(width: 6),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
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
}
