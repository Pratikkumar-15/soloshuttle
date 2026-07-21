import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../providers/training_provider.dart';
import '../widgets/hexagon_radar_chart.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  void _onChipTap(StatChipData chip) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.courtSurface,
        duration: const Duration(seconds: 2),
        content: Text(
          '${chip.name} rating: ${chip.score}/100 — Tap to view drills',
          style: GoogleFonts.inter(color: AppColors.chalkWhite, fontSize: 13),
        ),
      ),
    );
  }

  void _onCoachNoteTap() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.courtSurface,
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.corkGold, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Complete more training sessions & assessments to level up your skill radar!',
                style: GoogleFonts.inter(color: AppColors.chalkWhite, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final trainingProvider = Provider.of<TrainingProvider>(context);
    final user = userProvider.user;

    final Map<String, int> skillRatings = user.skillRatings;

    final chipsData = [
      StatChipData('Technical', skillRatings['Technical'] ?? 0, AppColors.skyBlue),
      StatChipData('Footwork', skillRatings['Footwork'] ?? 0, AppColors.limeGreen),
      StatChipData('Tactical', skillRatings['Tactical'] ?? 0, AppColors.softViolet),
      StatChipData('Physical', skillRatings['Physical'] ?? 0, AppColors.coral),
      StatChipData('Mental', skillRatings['Mental'] ?? 0, AppColors.corkGold),
      StatChipData('Consistency', skillRatings['Consistency'] ?? 0, AppColors.tealSage),
    ];

    // Find lowest rating for coach note
    String lowestPillar = 'Footwork';
    int lowestScore = 100;
    skillRatings.forEach((key, val) {
      if (val < lowestScore) {
        lowestScore = val;
        lowestPillar = key;
      }
    });

    final xpProgress = (user.currentXp / (user.xpNeededForNextLevel > 0 ? user.xpNeededForNextLevel : 500)).clamp(0.0, 1.0);
    final xpRemaining = (user.xpNeededForNextLevel - user.currentXp).clamp(0, 10000);

    return Scaffold(
      backgroundColor: AppColors.courtBackground,
      body: Stack(
        children: [
          // Background Court Line Texture
          Positioned.fill(
            child: CustomPaint(
              painter: CourtLineTexturePainter(),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'COURT FORM',
                                style: GoogleFonts.jetBrainsMono(
                                  color: AppColors.corkGold,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3.0,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.corkGold,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Progress',
                            style: GoogleFonts.bebasNeue(
                              color: AppColors.chalkWhite,
                              fontSize: 48,
                              height: 1.0,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${user.name} • Season 01 • ${DateTime.now().year}',
                            style: GoogleFonts.inter(
                              color: AppColors.sageGray,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2. RANK CARD WITH HAPTICS & SHIMMER
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.courtSurface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.limeGreen.withValues(alpha: 0.18),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: RankCardCrosshatchPainter(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.corkGold
                                                .withValues(alpha: 0.15),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: AppColors.corkGold
                                                  .withValues(alpha: 0.4),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            'CURRENT RANK',
                                            style: GoogleFonts.jetBrainsMono(
                                              color: AppColors.corkGold,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          user.calculatedJourneyStage,
                                          style: GoogleFonts.bebasNeue(
                                            color: AppColors.chalkWhite,
                                            fontSize: 32,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Right side: Circular shuttlecock badge
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.heavyImpact();
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 58,
                                            height: 58,
                                            decoration: BoxDecoration(
                                              color: AppColors.courtBackground,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.corkGold,
                                                width: 1.5,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.corkGold
                                                      .withValues(alpha: 0.25),
                                                  blurRadius: 12,
                                                  spreadRadius: 2,
                                                )
                                              ],
                                            ),
                                            child: Center(
                                              child: CustomPaint(
                                                size: const Size(28, 28),
                                                painter:
                                                    ShuttlecockIconPainter(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'LVL ${user.level.toString().padLeft(2, '0')}',
                                            style: GoogleFonts.jetBrainsMono(
                                              color: AppColors.corkGold,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // XP Progress Bar
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'SEASON XP',
                                      style: GoogleFonts.jetBrainsMono(
                                        color: AppColors.sageGray,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    Text(
                                      '${user.currentXp} / ${user.xpNeededForNextLevel}',
                                      style: GoogleFonts.jetBrainsMono(
                                        color: AppColors.chalkWhite,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    height: 8,
                                    width: double.infinity,
                                    color: AppColors.courtBackground,
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0.0, end: xpProgress),
                                      duration: const Duration(milliseconds: 1200),
                                      curve: Curves.easeOutCubic,
                                      builder: (context, value, child) {
                                        return FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: value,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppColors.tealSage,
                                                  AppColors.limeGreen
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$xpRemaining XP to next rank',
                                  style: GoogleFonts.inter(
                                    color: AppColors.sageGray,
                                    fontSize: 11.5,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. SKILL RADAR CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 22, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.courtSurface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.limeGreen.withValues(alpha: 0.18),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'SIX-PILLAR RATING',
                          style: GoogleFonts.jetBrainsMono(
                            color: AppColors.corkGold,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Skill Radar',
                          style: GoogleFonts.bebasNeue(
                            color: AppColors.chalkWhite,
                            fontSize: 28,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Based on ${trainingProvider.recentLogs.length} logged sessions',
                          style: GoogleFonts.inter(
                            color: AppColors.sageGray,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 20),
                        HexagonRadarChart(
                          skillRatings: skillRatings,
                          size: 260,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. STAT CHIPS 2-COLUMN GRID WITH HAPTIC TOUCH
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: chipsData.length,
                    itemBuilder: (context, index) {
                      final chip = chipsData[index];
                      return GestureDetector(
                        onTap: () => _onChipTap(chip),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.courtSurface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: chip.color.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: chip.color,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: chip.color
                                                  .withValues(alpha: 0.6),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        chip.name.toUpperCase(),
                                        style: GoogleFonts.jetBrainsMono(
                                          color: AppColors.sageGray,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TweenAnimationBuilder<int>(
                                    tween: IntTween(begin: 0, end: chip.score),
                                    duration: const Duration(milliseconds: 800),
                                    builder: (context, value, child) {
                                      return Text(
                                        '$value',
                                        style: GoogleFonts.bebasNeue(
                                          color: AppColors.chalkWhite,
                                          fontSize: 18,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: Container(
                                  height: 4,
                                  width: double.infinity,
                                  color: AppColors.courtBackground,
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: chip.score > 0 ? chip.score / 100 : 0.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: chip.color,
                                        boxShadow: [
                                          BoxShadow(
                                            color: chip.color
                                                .withValues(alpha: 0.5),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // 5. INSIGHT CALLOUT CARD WITH SPARKLE ICON & TAP ACTION
                  GestureDetector(
                    onTap: _onCoachNoteTap,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.courtSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.corkGold,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.corkGold.withValues(alpha: 0.15),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.corkGold.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: AppColors.corkGold,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  color: AppColors.chalkWhite,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Coach\'s note — ',
                                    style: GoogleFonts.inter(
                                      color: AppColors.corkGold,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: lowestScore == 0
                                        ? 'Start your first workout session to activate your skill radar and level up!'
                                        : '$lowestPillar is currently your focus area ($lowestScore/100). Complete $lowestPillar drills to raise your overall court form.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatChipData {
  final String name;
  final int score;
  final Color color;

  StatChipData(this.name, this.score, this.color);
}

class CourtLineTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.sageGray.withValues(alpha: 0.04)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RankCardCrosshatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.sageGray.withValues(alpha: 0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const spacing = 24.0;
    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
          Offset(x, 0), Offset(x + size.height, size.height), paint);
      canvas.drawLine(
          Offset(x, size.height), Offset(x + size.height, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ShuttlecockIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()
      ..color = AppColors.corkGold
      ..style = PaintingStyle.fill;

    final featherPaint = Paint()
      ..color = AppColors.chalkWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawLine(
        Offset(center.dx, center.dy + 2), Offset(center.dx, center.dy - 10), featherPaint);
    canvas.drawLine(
        Offset(center.dx - 3, center.dy + 3), Offset(center.dx - 8, center.dy - 8), featherPaint);
    canvas.drawLine(
        Offset(center.dx + 3, center.dy + 3), Offset(center.dx + 8, center.dy - 8), featherPaint);

    final bandPath = Path()
      ..moveTo(center.dx - 7, center.dy - 4)
      ..quadraticBezierTo(center.dx, center.dy - 2, center.dx + 7, center.dy - 4);
    canvas.drawPath(
        bandPath,
        Paint()
          ..color = AppColors.corkGold.withValues(alpha: 0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0);

    final corkRect = Rect.fromCircle(
        center: Offset(center.dx, center.dy + 6), radius: 5.0);
    canvas.drawArc(corkRect, 0, 3.14159, true, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
