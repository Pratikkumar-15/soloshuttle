import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'glass_card.dart';
import 'waveform_widget.dart';

class VoiceInstructionCard extends StatelessWidget {
  const VoiceInstructionCard({
    super.key,
    required this.isSpeaking,
    required this.spokenSentence,
  });

  final bool isSpeaking;
  final String spokenSentence;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 20,
      borderColor: isSpeaking ? AppColors.electricGreen.withValues(alpha: 0.4) : Colors.white12,
      glowColor: isSpeaking ? AppColors.electricGreen.withValues(alpha: 0.18) : Colors.transparent,
      child: Row(
        children: [
          // Speaker Icon with pulse glow when speaking
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isSpeaking ? AppColors.electricGreen.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              boxShadow: isSpeaking
                  ? [
                      BoxShadow(
                        color: AppColors.electricGreen.withValues(alpha: 0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              isSpeaking ? Icons.volume_up_rounded : Icons.volume_mute_rounded,
              color: isSpeaking ? AppColors.electricGreen : Colors.white54,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Live Spoken Sentence Text
          Expanded(
            child: Text(
              spokenSentence.isNotEmpty ? spokenSentence : 'Get ready.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Animated Waveform
          WaveformWidget(
            isSpeaking: isSpeaking,
            height: 20,
            barCount: 6,
            activeColor: AppColors.electricGreen,
          ),
        ],
      ),
    );
  }
}
