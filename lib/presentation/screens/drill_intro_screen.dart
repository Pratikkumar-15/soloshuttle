import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/drill.dart';
import '../../providers/training_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';
import '../widgets/section_title.dart';
import 'active_drill_session_screen.dart';

class DrillIntroScreen extends StatelessWidget {
  const DrillIntroScreen({
    super.key,
    required this.drill,
  });

  final Drill drill;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Drill Overview',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              drill.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: drill.isFavorite ? AppColors.red : Colors.white,
            ),
            onPressed: () {
              Provider.of<TrainingProvider>(context, listen: false).toggleFavorite(drill.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PREMIUM REDESIGNED DRILL HEADER CARD (TASK 14)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFF111C35),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                        ),
                        child: Text(drill.emoji, style: const TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              drill.title,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                BadgeTag(
                                  label: drill.difficulty,
                                  color: drill.difficulty == 'Advanced'
                                      ? AppColors.red
                                      : drill.difficulty == 'Intermediate'
                                          ? AppColors.cyan
                                          : AppColors.primaryGreen,
                                ),
                                BadgeTag(label: '⏱️ ${drill.duration}', color: AppColors.orange),
                                BadgeTag(label: '+${drill.xpReward} XP', color: AppColors.purple),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // HIGH-CONTRAST OBJECTIVE SECTION INSIDE HEADER
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.track_changes_rounded, color: AppColors.electricGreen, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'DRILL OBJECTIVE',
                              style: GoogleFonts.poppins(
                                color: AppColors.electricGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          drill.objective,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),



            const SizedBox(height: 24),

            // SKILLS IMPROVED
            if (drill.skillsImproved.isNotEmpty) ...[
              const SectionTitle(title: 'Skills Improved'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: drill.skillsImproved.map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.electricGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.electricGreen.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.electricGreen, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          skill,
                          style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // EQUIPMENT REQUIRED
            if (drill.equipmentRequired.isNotEmpty) ...[
              const SectionTitle(title: 'Equipment Required'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: drill.equipmentRequired.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.inventory_2_rounded, color: AppColors.cyan, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          item,
                          style: GoogleFonts.poppins(color: AppColors.cyan, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],

            // STEP-BY-STEP INSTRUCTIONS
            if (drill.instructions.isNotEmpty) ...[
              const SectionTitle(title: 'Step-by-Step Instructions'),
              const SizedBox(height: 10),
              ...drill.instructions.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${entry.key + 1}',
                          style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 24),
            ],

            // COACHING TIPS
            if (drill.coachCue.isNotEmpty || drill.coachingTips.isNotEmpty) ...[
              const SectionTitle(title: 'Coaching Tips'),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.tips_and_updates_rounded, color: AppColors.electricGreen, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          'Pro Coach Guidance',
                          style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (drill.coachCue.isNotEmpty)
                      Text(
                        drill.coachCue,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, height: 1.4),
                      ),
                    ...drill.coachingTips.map((tip) => Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: AppColors.electricGreen, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(tip, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // COMMON MISTAKES
            if (drill.commonMistakes.isNotEmpty) ...[
              const SectionTitle(title: 'Common Mistakes to Avoid'),
              const SizedBox(height: 10),
              ...drill.commonMistakes.map((mistake) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.red, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          mistake,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 24),
            ],

            // SAFETY REMINDERS
            if (drill.safetyReminders.isNotEmpty) ...[
              const SectionTitle(title: 'Safety Reminders'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: drill.safetyReminders.map((reminder) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_outlined, color: AppColors.orange, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            reminder,
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 32),
            ],

            // START DRILL BUTTON
            AppButton(
              text: 'START DRILL SESSION',
              icon: Icons.play_arrow_rounded,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ActiveDrillSessionScreen(drill: drill)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
