import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/voice_coach_service.dart';

class WarmupOverlayScreen extends StatefulWidget {
  final VoidCallback onWarmupComplete;
  final bool allowSkip;

  const WarmupOverlayScreen({
    super.key,
    required this.onWarmupComplete,
    this.allowSkip = false,
  });

  @override
  State<WarmupOverlayScreen> createState() => _WarmupOverlayScreenState();
}

class _WarmupOverlayScreenState extends State<WarmupOverlayScreen> {
  final _voiceCoach = VoiceCoachService();

  @override
  void initState() {
    super.initState();
    _voiceCoach.speak(
        'Warm-up advisory. Please ensure your muscles and joints are properly warmed up before starting.');
  }

  void _onContinuePressed() {
    HapticFeedback.mediumImpact();
    widget.onWarmupComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.courtBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Warning Shield Icon
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: AppColors.corkGold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.corkGold,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.corkGold.withValues(alpha: 0.25),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.corkGold,
                  size: 44,
                ),
              ),

              const SizedBox(height: 24),

              // Title & Eyebrow
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.corkGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.corkGold.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'INJURY PREVENTION ADVISORY',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppColors.corkGold,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Proper Warm-Up Required',
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                  color: AppColors.chalkWhite,
                  fontSize: 32,
                  letterSpacing: 1.0,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'High-intensity badminton training requires active joints and elevated muscle temperature to prevent strain or ligament injury.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.sageGray,
                  fontSize: 13.5,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 24),

              // Checklist Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.courtSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.sageGray.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  children: [
                    _buildCheckItem(
                      'Dynamic Shoulder & Wrist Rotations',
                      'Loosen racket joints for high overhead strokes.',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: Colors.white10, height: 1),
                    ),
                    _buildCheckItem(
                      'Hamstring & Groin Lunges',
                      'Prepare legs for deep court corner reach.',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: Colors.white10, height: 1),
                    ),
                    _buildCheckItem(
                      'Light Ankle Hops & Jogging',
                      'Activate calf tendons for fast split-step response.',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _onContinuePressed,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(
                    'I AM WARMED UP — CONTINUE TO DRILL',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.limeGreen,
                    foregroundColor: AppColors.courtBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.limeGreen,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: AppColors.chalkWhite,
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: GoogleFonts.inter(
                  color: AppColors.sageGray,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
