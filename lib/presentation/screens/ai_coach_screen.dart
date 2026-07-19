import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../providers/training_provider.dart';
import '../../providers/ai_coach_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';
import 'drill_intro_screen.dart';

class AiCoachScreen extends StatelessWidget {
  const AiCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final trainingProvider = Provider.of<TrainingProvider>(context);
    final aiCoach = Provider.of<AiCoachProvider>(context);

    final user = userProvider.user;
    final insight = aiCoach.generateInsight(user, trainingProvider.recentLogs);
    final todaysDrill = trainingProvider.todaysDrill;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology_rounded, color: AppColors.purple, size: 24),
            ),
            const SizedBox(width: 10),
            Text(
              'AI Coach Hub',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coach Greeting Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF261C48), Color(0xFF161C33)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.purple.withValues(alpha: 0.5), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      BadgeTag(label: 'BWF LEVEL 3 CERTIFIED AI COACH', color: AppColors.purple),
                      const Spacer(),
                      const Icon(Icons.verified_rounded, color: AppColors.electricGreen, size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Hello, ${user.name}!',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    insight.briefing,
                    style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13, height: 1.45),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Today's Personalized Recommendation Card
            Text(
              'Today\'s Recommended Session',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            AppCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DrillIntroScreen(drill: todaysDrill)),
                );
              },
              backgroundColor: AppColors.surface,
              borderColor: AppColors.primaryGreen.withValues(alpha: 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(todaysDrill.emoji, style: const TextStyle(fontSize: 24)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BadgeTag(label: todaysDrill.categoryName.toUpperCase(), color: AppColors.primaryGreen),
                            const SizedBox(height: 4),
                            Text(
                              todaysDrill.title,
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.play_circle_fill_rounded, color: AppColors.electricGreen, size: 36),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    todaysDrill.objective,
                    style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Weakness Detection & Strength Recognition Cards
            Text(
              'Coach Insights & Diagnostics',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Weakness Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.orange.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.orange, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WEAKNESS DETECTION',
                          style: GoogleFonts.poppins(color: AppColors.orange, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          insight.weaknessWarning,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.5, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Strength Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.electricGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.electricGreen.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.military_tech_rounded, color: AppColors.electricGreen, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STRENGTH RECOGNITION',
                          style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          insight.strengthBadge,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.5, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Structured Coaching Principle Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_rounded, color: AppColors.orange, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'TODAY\'S COACHING CUE',
                        style: GoogleFonts.poppins(color: AppColors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    insight.focusTip,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, height: 1.45, fontStyle: FontStyle.italic),
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
