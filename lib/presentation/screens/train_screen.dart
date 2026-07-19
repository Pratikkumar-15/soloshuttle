import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/training_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';
import '../widgets/gradient_hero_card.dart';
import '../../screens/footwork_screen.dart';
import '../../screens/drills_screen.dart';
import 'drill_intro_screen.dart';
import 'reaction_training_screen.dart';
import 'tutorials_screen.dart';

class TrainScreen extends StatelessWidget {
  const TrainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trainingProvider = Provider.of<TrainingProvider>(context);
    final todaysPlan = trainingProvider.todaysTrainingPlan;
    final todaysDrill = trainingProvider.todaysDrill;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Training Hub',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Focus Training Hero
            GradientHeroCard(
              tag: '${todaysPlan.dayName.toUpperCase()} • ${todaysPlan.pillar.toUpperCase()}',
              title: todaysPlan.title,
              subtitle: todaysPlan.subtitle,
              buttonText: 'START TODAY\'S DRILL',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DrillIntroScreen(drill: todaysDrill)),
                );
              },
            ),

            const SizedBox(height: 28),

            Text(
              'Training Hierarchy',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Select a training module to begin your practice.',
              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
            ),

            const SizedBox(height: 18),

            // 1. FOOTWORK
            _buildCategoryCard(
              context,
              title: 'Footwork Module',
              subtitle: 'Six-corner shadow movement, recovery steps & split-step timing',
              badge: 'Essential',
              badgeColor: AppColors.primaryGreen,
              icon: Icons.directions_run_rounded,
              imageAsset: 'assets/images/icons/footwork.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FootworkScreen()),
                );
              },
            ),

            const SizedBox(height: 14),

            // 2. SOLO DRILLS
            _buildCategoryCard(
              context,
              title: 'Solo Drills',
              subtitle: 'Stroke repetition, serve practice, wall drives & fitness',
              badge: '30+ Drills',
              badgeColor: AppColors.cyan,
              icon: Icons.sports_tennis_rounded,
              imageAsset: 'assets/images/icons/solo_drills.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DrillsScreen()),
                );
              },
            ),

            const SizedBox(height: 14),

            // 3. REACTION TRAINING MODULE
            _buildCategoryCard(
              context,
              title: 'Reaction Training Module',
              subtitle: 'Voice-guided callouts, 3-round system & random direction, color & number modes',
              badge: 'Interactive',
              badgeColor: AppColors.orange,
              icon: Icons.bolt_rounded,
              imageAsset: 'assets/images/icons/voice_coach.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReactionTrainingScreen()),
                );
              },
            ),

            const SizedBox(height: 14),

            // 5. TUTORIALS
            _buildCategoryCard(
              context,
              title: 'Video & Skill Tutorials',
              subtitle: 'Technique breakdowns, coaching cues & step-by-step guides',
              badge: 'Library',
              badgeColor: AppColors.electricGreen,
              icon: Icons.ondemand_video_rounded,
              imageAsset: 'assets/images/icons/tutorials.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TutorialsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required IconData icon,
    required VoidCallback onTap,
    String? imageAsset,
  }) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            height: 56,
            width: 56,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: imageAsset != null
                ? Image.asset(
                    imageAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(icon, color: badgeColor, size: 28),
                  )
                : Icon(icon, color: badgeColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    BadgeTag(label: badge, color: badgeColor),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
        ],
      ),
    );
  }
}
