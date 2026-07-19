import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../providers/ai_coach_provider.dart';

class SessionReviewScreen extends StatefulWidget {
  final String drillTitle;
  final String category;
  final int xpEarned;
  final int durationMinutes;
  final VoidCallback onFinish;

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

class _SessionReviewScreenState extends State<SessionReviewScreen> {
  int _selectedRating = 5;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final aiCoach = Provider.of<AiCoachProvider>(context, listen: false);

    final feedback = aiCoach.generatePostSessionFeedback(
      drillTitle: widget.drillTitle,
      durationMinutes: widget.durationMinutes,
      xpEarned: widget.xpEarned,
      qualityStars: _selectedRating,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Celebration Badge
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.electricGreen, width: 2),
                      ),
                      child: const Icon(Icons.emoji_events_rounded, color: AppColors.electricGreen, size: 48),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'SESSION COMPLETE!',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.drillTitle,
                      style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // XP & Stats Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '+${widget.xpEarned}',
                            style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'XP EARNED',
                            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${widget.durationMinutes}m',
                            style: GoogleFonts.poppins(color: AppColors.cyan, fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'TIME TRAINED',
                            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Self-Rate Technique Quality (Session Quality Score)
              Text(
                'Rate Your Technique Quality Today',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  final isSelected = starIndex <= _selectedRating;
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedRating = starIndex;
                      });
                    },
                    icon: Icon(
                      isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                      color: isSelected ? AppColors.orange : Colors.white38,
                      size: 36,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // AI Coach Feedback Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.purple.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.psychology_rounded, color: AppColors.purple, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'COACH\'S DEBRIEF',
                          style: GoogleFonts.poppins(color: AppColors.purple, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      feedback,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Cooldown Reminder
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.self_improvement_rounded, color: AppColors.cyan, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '5-Minute Cooldown Prompt',
                            style: GoogleFonts.poppins(color: AppColors.cyan, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Perform static hamstrings & calf stretching to accelerate recovery.',
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              ElevatedButton(
                onPressed: () {
                  userProvider.addXp(widget.xpEarned, category: widget.category);
                  userProvider.updateMinutesTrained(widget.durationMinutes);
                  widget.onFinish();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'FINISH SESSION & SAVE PROGRESS',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
