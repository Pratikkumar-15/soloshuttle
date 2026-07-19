import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/user_provider.dart';
import '../providers/training_provider.dart';
import '../presentation/widgets/app_card.dart';
import '../presentation/widgets/badge_tag.dart';
import '../presentation/widgets/hexagon_radar_chart.dart';
import '../presentation/widgets/streak_heatmap_widget.dart';
import '../presentation/screens/assessment_drills_screen.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final trainingProvider = Provider.of<TrainingProvider>(context);

    final user = userProvider.user;
    final logs = trainingProvider.recentLogs;
    final weeklyGoal = user.weeklyGoal;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Athlete Progress & Analytics',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEVEL & XP BANNER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF132038), Color(0xFF1E3050)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.4), width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BadgeTag(label: 'CURRENT STAGE', color: AppColors.electricGreen),
                          const SizedBox(height: 4),
                          Text(
                            user.calculatedJourneyStage,
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          'Lvl ${user.level}',
                          style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('XP Progress', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
                      Text('${user.currentXp} / ${user.xpNeededForNextLevel} XP', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (user.currentXp / user.xpNeededForNextLevel).clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: Colors.white12,
                      color: AppColors.electricGreen,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 6-SKILL HEXAGON RADAR CHART (PRIORITY 2)
            Center(
              child: AppCard(
                child: Column(
                  children: [
                    BadgeTag(label: '6-PILLAR ATHLETE SKILL RADAR', color: AppColors.electricGreen),
                    const SizedBox(height: 16),
                    HexagonRadarChart(skillRatings: user.skillRatings, size: 260),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // STRONGEST SKILL & FOCUS AREA CARDS
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('STRONGEST SKILL', style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(user.strongestSkill, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('FOCUS AREA', style: GoogleFonts.poppins(color: AppColors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(user.weakestSkill, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // WEEKLY DISCIPLINE SUMMARY CARD (PRIORITY 3)
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BadgeTag(label: 'WEEKLY GOAL SUMMARY', color: AppColors.cyan),
                      Text('${weeklyGoal.completedDays}/${weeklyGoal.targetDays} Days', style: GoogleFonts.poppins(color: AppColors.cyan, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(weeklyGoal.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: weeklyGoal.dayProgress,
                      minHeight: 8,
                      backgroundColor: Colors.white12,
                      color: AppColors.cyan,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // STREAK HEATMAP GRID
            StreakHeatmapWidget(streakHistory: user.streakHistory),

            const SizedBox(height: 24),

            // PERSONAL RECORDS SECTION
            Text('Personal Records', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    child: Column(
                      children: [
                        const Icon(Icons.bolt_rounded, color: AppColors.orange, size: 28),
                        const SizedBox(height: 6),
                        Text('${user.currentStreak} Days', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('BEST STREAK', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppCard(
                    child: Column(
                      children: [
                        const Icon(Icons.fitness_center_rounded, color: AppColors.primaryGreen, size: 28),
                        const SizedBox(height: 6),
                        Text('${user.completedSessions}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('SESSIONS DONE', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ASSESSMENTS SHORTCUT
            AppCard(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AssessmentDrillsScreen()));
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.purple.withValues(alpha: 0.18), shape: BoxShape.circle),
                    child: const Icon(Icons.assignment_rounded, color: AppColors.purple, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Periodic Skill Assessments', style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        Text('Test 6-corner speed, reaction time & drive accuracy', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11.5)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // RECENT TRAINING LOGS
            Text('Recent Training History', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            if (logs.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                child: Center(
                  child: Text('No completed training logs yet. Start a session from the Home screen!', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
                ),
              )
            else
              ...logs.reversed.take(5).map((log) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppCard(
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.electricGreen, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(log.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                              Text('${log.duration} • ${log.category}', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
                            ],
                          ),
                        ),
                        Text('+${log.xpEarned} XP', style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
