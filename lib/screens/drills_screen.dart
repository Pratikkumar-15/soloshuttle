import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/training_provider.dart';
import '../presentation/widgets/app_card.dart';
import '../presentation/widgets/section_title.dart';
import '../presentation/widgets/drill_catalog_card.dart';
import '../presentation/widgets/gradient_hero_card.dart';
import '../presentation/screens/drill_intro_screen.dart';

class DrillsScreen extends StatelessWidget {
  const DrillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trainingProvider = Provider.of<TrainingProvider>(context);
    final soloDrills = trainingProvider.soloDrills;
    final favorites = trainingProvider.favoriteDrills;

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
              errorBuilder: (_, _, _) => const Icon(Icons.sports_tennis_rounded, color: AppColors.primaryGreen),
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
                  MaterialPageRoute(builder: (_) => DrillIntroScreen(drill: drill)),
                );
              },
            ),

            const SizedBox(height: 32),

            // SOLO DRILLS LIST
            const SectionTitle(title: 'Solo Drills Catalog'),
            const SizedBox(height: 14),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: soloDrills.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final drill = soloDrills[index];
                return DrillCatalogCard(
                  drill: drill,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DrillIntroScreen(drill: drill)),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 32),

            // FAVORITE DRILLS (Task 10: Auto-ranked top 3)
            if (favorites.isNotEmpty) ...[
              const SectionTitle(title: 'Top Favourite Drills'),
              const SizedBox(height: 14),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: favorites.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final drill = favorites[index];
                    return SizedBox(
                      width: 160,
                      child: AppCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DrillIntroScreen(drill: drill)),
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
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
