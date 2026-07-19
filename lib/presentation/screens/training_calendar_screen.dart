import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/training_provider.dart';
import '../../providers/user_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';
import 'drill_intro_screen.dart';

class TrainingCalendarScreen extends StatelessWidget {
  const TrainingCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trainingProvider = Provider.of<TrainingProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final dailyPlans = trainingProvider.dailyPlans;
    final user = userProvider.user;

    final consecutiveDays = user.currentStreak;
    final isRestRecommended = consecutiveDays >= 4;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Weekly Training Calendar & Periodization', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Periodization Status Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isRestRecommended ? AppColors.orange.withValues(alpha: 0.15) : AppColors.primaryGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isRestRecommended ? AppColors.orange : AppColors.primaryGreen,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isRestRecommended ? Icons.bedtime_rounded : Icons.auto_graph_rounded,
                    color: isRestRecommended ? AppColors.orange : AppColors.electricGreen,
                    size: 32,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isRestRecommended ? 'REST DAY SUGGESTED' : 'PERIODIZATION: DEVELOPMENT PHASE',
                          style: GoogleFonts.poppins(
                            color: isRestRecommended ? AppColors.orange : AppColors.electricGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isRestRecommended
                              ? 'You have trained 4+ consecutive days. Take today light for muscle recovery.'
                              : 'Balanced weekly schedule alternating Technical, Footwork, Reaction & Physical pillars.',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text('7-Day Periodized Workout Schedule', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            ...dailyPlans.map((plan) {
              Color pillarColor;
              switch (plan.pillar) {
                case 'Technical':
                  pillarColor = AppColors.primaryGreen;
                  break;
                case 'Footwork':
                  pillarColor = AppColors.cyan;
                  break;
                case 'Reaction':
                  pillarColor = AppColors.orange;
                  break;
                case 'Physical':
                  pillarColor = AppColors.red;
                  break;
                default:
                  pillarColor = AppColors.purple;
              }

              final isToday = plan.dayName.toLowerCase() == _getTodayDayName().toLowerCase();

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  onTap: () {
                    final drill = trainingProvider.drills.firstWhere((d) => d.id == plan.drillId, orElse: () => trainingProvider.drills.first);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DrillIntroScreen(drill: drill)),
                    );
                  },
                  borderColor: isToday ? pillarColor : Colors.white10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                plan.dayName.toUpperCase(),
                                style: GoogleFonts.poppins(color: isToday ? pillarColor : Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              if (isToday) ...[
                                const SizedBox(width: 8),
                                BadgeTag(label: 'TODAY', color: pillarColor),
                              ],
                            ],
                          ),
                          BadgeTag(label: plan.pillar.toUpperCase(), color: pillarColor),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(plan.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(plan.subtitle, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
                      const SizedBox(height: 8),
                      Text('Coach Focus: "${plan.coachFocus}"', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 11.5, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getTodayDayName() {
    final now = DateTime.now();
    switch (now.weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }
}
