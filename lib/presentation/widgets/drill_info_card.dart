import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'glass_card.dart';
import 'drill_movement_graphic.dart';

class DrillInfoCard extends StatelessWidget {
  const DrillInfoCard({
    super.key,
    required this.drillName,
    required this.drillEmoji,
    required this.durationBadge,
    required this.focusCues,
    required this.commonMistake,
    this.mistakesToAvoid,
  });

  final String drillName;
  final String drillEmoji;
  final String durationBadge;
  final List<String> focusCues; // Maximum 2 cues displayed
  final String commonMistake; // Single fallback mistake string
  final List<String>? mistakesToAvoid; // Maximum 2 mistakes displayed

  @override
  Widget build(BuildContext context) {
    final cuesToDisplay = focusCues.isNotEmpty
        ? focusCues.take(2).toList()
        : [
            'Stay low.',
            'Recover quickly.',
          ];

    final mistakesList = (mistakesToAvoid != null && mistakesToAvoid!.isNotEmpty)
        ? mistakesToAvoid!.take(2).toList()
        : [
            commonMistake.isNotEmpty ? commonMistake : "Don't cross your feet.",
          ];

    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 22,
      borderColor: AppColors.cyan.withValues(alpha: 0.25),
      glowColor: AppColors.cyan.withValues(alpha: 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Drill Icon, Name, Duration Badge & Movement Graphic on Right
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cyan.withValues(alpha: 0.4)),
                ),
                child: Text(
                  drillEmoji.isNotEmpty ? drillEmoji : '🏸',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drillName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.orange.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        durationBadge.toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: AppColors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const DrillMovementGraphic(size: 58),
            ],
          ),

          const SizedBox(height: 14),

          // FOCUS CUES (Max 2, Min 1)
          Text(
            'FOCUS CUES',
            style: GoogleFonts.poppins(
              color: AppColors.electricGreen,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          ...cuesToDisplay.map((cue) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.electricGreen, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        cue.replaceAll(RegExp(r'^[•\-\s]+'), ''),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 10),
          Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),
          const SizedBox(height: 10),

          // MISTAKES TO AVOID (Max 2, Min 1)
          Text(
            'MISTAKES TO AVOID',
            style: GoogleFonts.poppins(
              color: AppColors.orange,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          ...mistakesList.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.orange,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        m,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
