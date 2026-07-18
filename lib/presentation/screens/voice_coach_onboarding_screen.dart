import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/voice_coach_provider.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';

class VoiceCoachOnboardingScreen extends StatelessWidget {
  const VoiceCoachOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Voice Coach Guide', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: AppColors.voiceCoachGradient,
              ),
              child: Column(
                children: [
                  const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Training Setup Guide',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Follow these 4 quick safety & setup tips before starting hands-free voice coaching.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 1. Phone Placement
            _buildTipCard(
              icon: Icons.phone_android_rounded,
              title: '1. Phone Placement',
              description: 'Place your phone securely on a bench, tripod, or chair at court side at eye level where you can hear callouts clearly.',
              accentColor: AppColors.cyan,
            ),

            const SizedBox(height: 12),

            // 2. Safety
            _buildTipCard(
              icon: Icons.warning_amber_rounded,
              title: '2. Safety First',
              description: 'Clear all loose shuttlecocks, extra rackets, bags, and water bottles from your movement area to prevent slipping.',
              accentColor: AppColors.orange,
            ),

            const SizedBox(height: 12),

            // 3. Training Distance
            _buildTipCard(
              icon: Icons.straighten_rounded,
              title: '3. Training Distance',
              description: 'Maintain a 2 to 3-meter radius around your base center position so you can perform explosive lunges and footwork safely.',
              accentColor: AppColors.primaryGreen,
            ),

            const SizedBox(height: 12),

            // 4. Speaker Usage
            _buildTipCard(
              icon: Icons.volume_up_rounded,
              title: '4. Speaker Usage & Volume',
              description: 'Turn your device media volume up to 100%, or connect Bluetooth wireless earbuds for maximum voice clarity.',
              accentColor: AppColors.purple,
            ),

            const SizedBox(height: 32),

            AppButton(
              text: 'GOT IT! START VOICE COACH',
              icon: Icons.play_arrow_rounded,
              onPressed: () async {
                final provider = Provider.of<VoiceCoachProvider>(context, listen: false);
                await provider.completeOnboarding();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
    required Color accentColor,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
