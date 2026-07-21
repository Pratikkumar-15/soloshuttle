import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/training_provider.dart';
import '../widgets/drill_catalog_card.dart';
import '../widgets/gradient_hero_card.dart';
import 'drill_intro_screen.dart';

class FootworkScreen extends StatelessWidget {
  const FootworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trainingProvider = Provider.of<TrainingProvider>(context);
    final footworkDrills = trainingProvider.footworkDrills;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/icons/footwork.png',
              width: 28,
              errorBuilder: (_, _, _) => const Icon(Icons.directions_run_rounded, color: AppColors.primaryGreen),
            ),
            const SizedBox(width: 10),
            Text('Footwork Module', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Move with purpose.',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Build faster recovery, balance, and court coverage.',
              style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 24),

            // Hero Drill
            GradientHeroCard(
              tag: "FEATURED FOOTWORK",
              title: 'Six Corner Footwork',
              subtitle: '20 minutes • Advanced Court Coverage',
              buttonText: 'START SIX-CORNER DRILL',
              onPressed: () {
                final drill = footworkDrills.firstWhere(
                  (d) => d.id == 'fw_six_corner',
                  orElse: () => footworkDrills.first,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DrillIntroScreen(drill: drill)),
                );
              },
            ),

            const SizedBox(height: 32),

            Text(
              'Footwork Drills',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),

            // 6 REAL FOOTWORK DRILLS LIST
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: footworkDrills.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final drill = footworkDrills[index];
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
          ],
        ),
      ),
    );
  }
}
