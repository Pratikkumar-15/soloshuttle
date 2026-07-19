import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme/app_colors.dart';
import '../providers/user_provider.dart';
import '../providers/training_provider.dart';
import '../presentation/widgets/app_card.dart';
import '../presentation/widgets/section_title.dart';
import '../presentation/widgets/stat_card.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final trainingProvider = Provider.of<TrainingProvider>(context);
    final user = userProvider.user;
    final logs = trainingProvider.recentLogs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Progress Analytics Hub', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level & XP Progress Banner
            AppCard(
              backgroundColor: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level ${user.level} Player',
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user.calculatedSkillLevel,
                            style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.orange.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          '${user.currentXp} / ${user.xpNeededForNextLevel} XP',
                          style: GoogleFonts.poppins(color: AppColors.orange, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (user.currentXp / user.xpNeededForNextLevel).clamp(0.0, 1.0),
                      minHeight: 10,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primaryGreen),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Performance Stat Metrics
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.3,
              children: [
                StatCard(
                  icon: Icons.local_fire_department_rounded,
                  value: '${user.currentStreak} Days',
                  title: 'Training Streak',
                  accentColor: AppColors.orange,
                ),
                StatCard(
                  icon: Icons.timer_rounded,
                  value: '${user.totalMinutes ~/ 60} hrs',
                  title: 'Total Training',
                  accentColor: AppColors.cyan,
                ),
                StatCard(
                  icon: Icons.check_circle_rounded,
                  value: '${user.completedSessions}',
                  title: 'Completed Sessions',
                  accentColor: AppColors.primaryGreen,
                ),
                StatCard(
                  icon: Icons.favorite_rounded,
                  value: user.favoriteDrill,
                  title: 'Favorite Drill',
                  accentColor: AppColors.purple,
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Weekly Minutes Bar Chart
            const SectionTitle(title: 'Weekly Active Minutes'),
            const SizedBox(height: 14),
            AppCard(
              child: SizedBox(
                height: 170,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 60,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, _) {
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            if (val.toInt() >= 0 && val.toInt() < days.length) {
                              return Text(days[val.toInt()], style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11));
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    barGroups: [
                      _makeBarGroup(0, 30),
                      _makeBarGroup(1, 45),
                      _makeBarGroup(2, 20),
                      _makeBarGroup(3, 50),
                      _makeBarGroup(4, 35),
                      _makeBarGroup(5, 40),
                      _makeBarGroup(6, 25),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Cumulative XP Trend Line Chart
            const SectionTitle(title: 'XP Progression Trend'),
            const SizedBox(height: 14),
            AppCard(
              child: SizedBox(
                height: 160,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 100),
                          FlSpot(1, 180),
                          FlSpot(2, 240),
                          FlSpot(3, 310),
                          FlSpot(4, 390),
                          FlSpot(5, 450),
                        ],
                        isCurved: true,
                        color: AppColors.electricGreen,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.electricGreen.withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Drill Category Training Distribution
            const SectionTitle(title: 'Skill Focus Distribution'),
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                children: [
                  _buildDistributionBar('Footwork & Shadow', 0.45, AppColors.primaryGreen),
                  const SizedBox(height: 12),
                  _buildDistributionBar('Reaction Drills', 0.25, AppColors.orange),
                  const SizedBox(height: 12),
                  _buildDistributionBar('Strokes & Wall Practice', 0.20, AppColors.cyan),
                  const SizedBox(height: 12),
                  _buildDistributionBar('Serves & Defense', 0.10, AppColors.purple),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Recent Session History Logs (Latest 5 sessions, newest first)
            const SectionTitle(title: 'Recent Sessions'),
            const SizedBox(height: 14),
            Builder(
              builder: (context) {
                final displayLogs = (List.from(logs)
                  ..sort((a, b) => b.date.compareTo(a.date)))
                  .take(5)
                  .toList();

                if (displayLogs.isEmpty) {
                  return Text('No training sessions logged yet.', style: GoogleFonts.poppins(color: AppColors.textMuted));
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayLogs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final log = displayLogs[index];
                    return AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.sports_tennis_rounded, color: AppColors.primaryGreen, size: 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        log.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${log.duration} • ${log.category}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '+${log.xpEarned} XP',
                            style: GoogleFonts.poppins(color: AppColors.electricGreen, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primaryGreen,
          width: 16,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  Widget _buildDistributionBar(String label, double ratio, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            Text('${(ratio * 100).toInt()}%', style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
