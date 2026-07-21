import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/training_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';
import '../widgets/gradient_hero_card.dart';
import 'footwork_screen.dart';
import 'drills_screen.dart';
import 'drill_intro_screen.dart';
import 'reaction_training_screen.dart';
import 'tutorials_screen.dart';
import 'mental_corner_screen.dart';
import 'tactical_puzzles_screen.dart';

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
              'Your Training Arsenal',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Choose your focus area and put in the work.',
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
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FootworkScreen()));
              },
            ),

            const SizedBox(height: 14),

            // 2. SOLO DRILLS
            _buildCategoryCard(
              context,
              title: 'Solo Drills',
              subtitle: 'Stroke repetition, serve practice, wall drives & net control',
              badge: 'Crucial',
              badgeColor: AppColors.cyan,
              icon: Icons.sports_tennis_rounded,
              imageAsset: 'assets/images/icons/solo_drills.png',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DrillsScreen()));
              },
            ),

            const SizedBox(height: 14),

            // 3. REACTION TRAINING MODULE
            _buildCategoryCard(
              context,
              title: 'Reaction Training Module',
              subtitle: 'Voice-guided callouts, 3-round system & random direction mode',
              badge: 'Interactive',
              badgeColor: AppColors.orange,
              icon: Icons.bolt_rounded,
              imageAsset: 'assets/images/icons/reaction_drill.png',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ReactionTrainingScreen()));
              },
            ),

            const SizedBox(height: 14),

            // 4. TUTORIALS
            _buildCategoryCard(
              context,
              title: 'Video & Skill Tutorials',
              subtitle: '14-section technique breakdowns, coaching cues & guides',
              badge: 'Library',
              badgeColor: AppColors.electricGreen,
              icon: Icons.ondemand_video_rounded,
              imageAsset: 'assets/images/icons/tutorials.png',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TutorialsScreen()));
              },
            ),

            const SizedBox(height: 14),

            // 5. MENTAL CORNER & PSYCHOLOGY
            _buildCategoryCard(
              context,
              title: 'Mental Corner & Psychology',
              subtitle: 'Pre-match mental prep, self-talk reframing & 2-min focus timer',
              badge: 'Mindset',
              badgeColor: AppColors.purple,
              icon: Icons.self_improvement_rounded,
              imageAsset: 'assets/images/icons/mental_corner.png',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MentalCornerScreen()));
              },
            ),

            const SizedBox(height: 14),

            // 6. TACTICAL IQ PUZZLES
            _buildCategoryCard(
              context,
              title: 'Tactical IQ Puzzles',
              subtitle: 'Court situation diagrams & 4-option shot selection quizzes',
              badge: 'Tactical',
              badgeColor: AppColors.cyan,
              icon: Icons.extension_rounded,
              imageAsset: 'assets/images/icons/tactical_puzzles.png',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TacticalPuzzlesScreen()));
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 68,
            width: 68,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: badgeColor.withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: badgeColor.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: imageAsset != null
                ? Image.asset(
                    imageAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, stack) => Icon(icon, color: badgeColor, size: 34),
                  )
                : Icon(icon, color: badgeColor, size: 34),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BadgeTag(label: badge, color: badgeColor),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: AppColors.chalkWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: AppColors.textMuted,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 18),
        ],
      ),
    );
  }
}
