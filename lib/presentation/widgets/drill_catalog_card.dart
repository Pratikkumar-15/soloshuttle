import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/drill.dart';
import 'app_card.dart';

/// Premium, responsive Drill Catalog Card with vertical info badge panel and zero text overflow.
class DrillCatalogCard extends StatelessWidget {
  const DrillCatalogCard({
    super.key,
    required this.drill,
    required this.onTap,
  });

  final Drill drill;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color difficultyColor;
    switch (drill.difficulty) {
      case 'Advanced':
        difficultyColor = AppColors.red;
        break;
      case 'Intermediate':
        difficultyColor = AppColors.cyan;
        break;
      default:
        difficultyColor = AppColors.primaryGreen;
    }

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // EMOJI AVATAR
          Container(
            height: 44,
            width: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryGreen.withValues(alpha: 0.35),
              ),
            ),
            child: Text(
              drill.emoji.isNotEmpty ? drill.emoji : '🏸',
              style: const TextStyle(fontSize: 22),
            ),
          ),

          const SizedBox(width: 12),

          // CENTER TEXT SECTION (HIGH PRIORITY EXPANDED SPACE)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  drill.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  drill.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: AppColors.textMuted,
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // COMPACT VERTICAL INFORMATION PANEL (RIGHT-SIDE BADGE)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF131D31),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: difficultyColor.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // DIFFICULTY BADGE (e.g. 🟢 Intermediate)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: difficultyColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      drill.difficulty,
                      style: GoogleFonts.poppins(
                        color: difficultyColor,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                // DURATION BADGE (e.g. ⏱ 15 min)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: AppColors.orange,
                      size: 11,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      drill.duration,
                      style: GoogleFonts.poppins(
                        color: AppColors.orange,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                // NAVIGATION ARROW ICON
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white60,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
