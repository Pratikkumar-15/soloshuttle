import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SoloShuttle Privacy Policy',
              style: GoogleFonts.bebasNeue(
                color: Colors.white,
                fontSize: 28,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last Updated: July 2026',
              style: GoogleFonts.inter(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Data Collection',
              'SoloShuttle is designed as an offline-first AI coaching application. We do not require you to create an account, and we do not collect, transmit, or store your personal training data on any external servers. All data, including your athlete profile, training logs, and custom settings, are stored locally on your device.',
            ),
            _buildSection(
              '2. Device Permissions',
              'The app may request access to local device storage to save your training progress and preferences. If you deny this permission, the app will function using temporary memory but your progress will be lost upon exiting the app.',
            ),
            _buildSection(
              '3. Third-Party Services',
              'We use Google\'s Flutter framework and the flutter_tts package to provide voice coaching. SoloShuttle itself does not integrate third-party analytics or advertising SDKs. The text-to-speech functionality relies entirely on your device\'s native OS speech synthesis engine.',
            ),
            _buildSection(
              '4. Health and Fitness Data',
              'SoloShuttle tracks your workout durations and calculates XP based on time spent training. This data is kept strictly on-device for your personal motivation and is never shared with third-party health aggregators unless explicitly exported by you.',
            ),
            _buildSection(
              '5. Changes to this Policy',
              'We may update this Privacy Policy from time to time. Any changes will be reflected in future app updates and clearly stated within this screen.',
            ),
            _buildSection(
              '6. Contact',
              'If you have any questions regarding this offline privacy policy or how your local data is managed, please contact the developer directly through the Google Play Store support channels.',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.electricGreen,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
