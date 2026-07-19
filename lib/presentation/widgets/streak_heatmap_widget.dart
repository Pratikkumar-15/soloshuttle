import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class StreakHeatmapWidget extends StatelessWidget {
  final List<String> streakHistory; // List of ISO date strings 'YYYY-MM-DD'

  const StreakHeatmapWidget({
    super.key,
    required this.streakHistory,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Generate dates for past 12 weeks (84 days)
    final dates = List.generate(84, (index) {
      return now.subtract(Duration(days: 83 - index));
    });

    final activeDatesSet = streakHistory.map((e) => e.split('T').first).toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Training Consistency Heatmap',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              'Past 12 Weeks',
              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heatmap Grid: 7 rows (Mon-Sun), 12 columns (Weeks)
              SizedBox(
                height: 110,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, // 7 days a week vertically
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    final date = dates[index];
                    final dateStr = date.toIso8601String().substring(0, 10);
                    final isTrained = activeDatesSet.contains(dateStr);
                    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;

                    Color boxColor;
                    if (isTrained) {
                      boxColor = AppColors.primaryGreen;
                    } else if (isToday) {
                      boxColor = AppColors.orange.withValues(alpha: 0.4);
                    } else {
                      boxColor = Colors.white.withValues(alpha: 0.06);
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(4),
                        border: isToday ? Border.all(color: AppColors.orange, width: 1.5) : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Less ', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10)),
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 4),
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 4),
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 4),
                      Text(' More', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10)),
                    ],
                  ),
                  Text(
                    '${activeDatesSet.length} days active',
                    style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
