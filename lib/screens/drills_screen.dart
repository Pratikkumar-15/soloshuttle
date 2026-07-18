import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/training_provider.dart';
import '../providers/user_provider.dart';
import '../domain/entities/drill.dart';
import '../presentation/widgets/app_card.dart';
import '../presentation/widgets/app_button.dart';
import '../presentation/widgets/badge_tag.dart';
import '../presentation/widgets/section_title.dart';
import '../presentation/widgets/stat_card.dart';
import '../presentation/widgets/gradient_hero_card.dart';
import '../presentation/screens/active_drill_session_screen.dart';

class DrillsScreen extends StatelessWidget {
  const DrillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trainingProvider = Provider.of<TrainingProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final soloDrills = trainingProvider.soloDrills;
    final favorites = trainingProvider.favoriteDrills;
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/icons/solo_drills.png',
              width: 28,
              errorBuilder: (_, __, ___) => const Icon(Icons.sports_tennis_rounded, color: AppColors.primaryGreen),
            ),
            const SizedBox(width: 10),
            Text(
              'Solo Drills Catalog',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI RECOMMENDED HERO
            GradientHeroCard(
              tag: '⭐ RECOMMENDED DRILL',
              title: 'Smash Repetition Drill',
              subtitle: '15 min • Explosive Jump Smash & Recovery',
              buttonText: 'START SMASH DRILL NOW',
              onPressed: () {
                final drill = soloDrills.firstWhere(
                  (d) => d.id == 'sd_smash',
                  orElse: () => soloDrills.first,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ActiveDrillSessionScreen(drill: drill)),
                );
              },
            ),

            const SizedBox(height: 32),

            // SOLO DRILLS LIST (Shadow, Smash, Wall, Serve, Net, Clear)
            const SectionTitle(title: 'Solo Drills Catalog'),
            const SizedBox(height: 14),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: soloDrills.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final drill = soloDrills[index];
                return AppCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ActiveDrillSessionScreen(drill: drill)),
                    );
                  },
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Text(drill.emoji, style: const TextStyle(fontSize: 24)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  drill.title,
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                BadgeTag(label: drill.difficulty, color: AppColors.cyan),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              drill.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(drill.duration, style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white60, size: 14),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // FAVORITE DRILLS
            if (favorites.isNotEmpty) ...[
              const SectionTitle(title: 'Favorite Drills'),
              const SizedBox(height: 14),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: favorites.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final drill = favorites[index];
                    return SizedBox(
                      width: 160,
                      child: AppCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ActiveDrillSessionScreen(drill: drill)),
                          );
                        },
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(drill.emoji, style: const TextStyle(fontSize: 26)),
                            const Spacer(),
                            Text(
                              drill.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              drill.duration,
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],

            // DAILY CHALLENGE CARD
            AppCard(
              backgroundColor: AppColors.surface,
              borderColor: trainingProvider.dailyChallengeCompleted ? AppColors.primaryGreen : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.casino_rounded, color: AppColors.orange, size: 26),
                      const SizedBox(width: 10),
                      Text(
                        'Daily Challenge',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '150 Shadow Footwork Steps',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    trainingProvider.dailyChallengeCompleted ? 'Completed! +50 XP Earned' : 'Reward: +50 XP',
                    style: GoogleFonts.poppins(
                      color: trainingProvider.dailyChallengeCompleted ? AppColors.electricGreen : AppColors.primaryGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  AppButton(
                    text: trainingProvider.dailyChallengeCompleted ? 'CHALLENGE COMPLETED' : 'START CHALLENGE',
                    type: trainingProvider.dailyChallengeCompleted ? AppButtonType.outline : AppButtonType.primary,
                    onPressed: trainingProvider.dailyChallengeCompleted
                        ? null
                        : () {
                            trainingProvider.completeDailyChallenge();
                            userProvider.addXp(50);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('🎉 Daily Challenge Completed! +50 XP awarded!')),
                            );
                          },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
