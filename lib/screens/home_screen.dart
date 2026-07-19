import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/user_provider.dart';
import '../providers/training_provider.dart';
import '../providers/ai_coach_provider.dart';
import '../presentation/widgets/app_card.dart';
import '../presentation/widgets/gradient_hero_card.dart';
import '../presentation/widgets/badge_tag.dart';
import '../presentation/widgets/section_title.dart';
import '../presentation/screens/drill_intro_screen.dart';
import '../presentation/screens/reaction_training_screen.dart';
import '../presentation/screens/tutorials_screen.dart';
import '../presentation/screens/notifications_screen.dart';
import '../presentation/screens/ai_coach_screen.dart';
import '../presentation/screens/physical_training_screen.dart';
import '../presentation/screens/mental_corner_screen.dart';
import '../presentation/screens/tactical_puzzles_screen.dart';
import '../presentation/screens/mirror_mode_screen.dart';
import '../presentation/screens/training_calendar_screen.dart';
import 'drills_screen.dart';
import 'footwork_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final trainingProvider = Provider.of<TrainingProvider>(context);
    final aiCoach = Provider.of<AiCoachProvider>(context);

    final user = userProvider.user;
    final todaysPlan = trainingProvider.todaysTrainingPlan;
    final todaysDrill = trainingProvider.todaysDrill;
    final insight = aiCoach.generateInsight(user, trainingProvider.recentLogs);
    final dailyGoal = user.dailyGoal;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 42,
                        height: 42,
                        errorBuilder: (ctx, err, stack) => const Icon(Icons.sports_tennis_rounded, color: AppColors.primaryGreen, size: 36),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'SoloShuttle',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.psychology_rounded, color: AppColors.purple, size: 28),
                        tooltip: 'AI Coach Hub',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const AiCoachScreen()));
                        },
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                height: 9,
                                width: 9,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // DYNAMIC COACH GREETING & INSIGHT
              Text(
                'Hello, ${user.name} 👋',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                insight.focusTip,
                style: GoogleFonts.poppins(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 20),

              // SMART DAILY GOAL CARD (PRIORITY 3)
              AppCard(
                backgroundColor: AppColors.surface,
                borderColor: AppColors.primaryGreen.withValues(alpha: 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BadgeTag(label: 'TODAY\'S SMART GOAL', color: AppColors.primaryGreen),
                        Text(
                          '${dailyGoal.completedMinutes}/${dailyGoal.targetMinutes} min',
                          style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dailyGoal.title,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dailyGoal.description,
                      style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: dailyGoal.progress,
                        minHeight: 8,
                        backgroundColor: Colors.white12,
                        color: AppColors.electricGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // DYNAMIC TODAY'S TRAINING CARD
              GradientHeroCard(
                tag: "${todaysPlan.dayName.toUpperCase()}'S DRILL • ${todaysPlan.pillar.toUpperCase()}",
                title: todaysPlan.title,
                subtitle: todaysPlan.subtitle,
                buttonText: 'START TODAY\'S DRILL',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DrillIntroScreen(drill: todaysDrill)),
                  );
                },
              ),

              const SizedBox(height: 28),

              const SectionTitle(title: 'Coaching Modules'),
              const SizedBox(height: 14),

              // MODULES GRID
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  FeatureCard(
                    image: 'assets/images/icons/solo_drills.png',
                    iconFallback: Icons.sports_tennis_rounded,
                    title: 'Solo Drills',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const DrillsScreen()));
                    },
                  ),
                  FeatureCard(
                    image: 'assets/images/icons/footwork.png',
                    iconFallback: Icons.directions_run_rounded,
                    title: 'Footwork',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FootworkScreen()));
                    },
                  ),
                  FeatureCard(
                    image: 'assets/images/icons/voice_coach.png',
                    iconFallback: Icons.bolt_rounded,
                    title: 'Reaction Drill',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ReactionTrainingScreen()));
                    },
                  ),
                  FeatureCard(
                    image: 'assets/images/icons/tutorials.png',
                    iconFallback: Icons.ondemand_video_rounded,
                    title: 'Tutorials',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TutorialsScreen()));
                    },
                  ),
                  FeatureCard(
                    image: 'assets/images/icons/solo_drills.png',
                    iconFallback: Icons.fitness_center_rounded,
                    title: 'Athletic Training',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PhysicalTrainingScreen()));
                    },
                  ),
                  FeatureCard(
                    image: 'assets/images/icons/voice_coach.png',
                    iconFallback: Icons.self_improvement_rounded,
                    title: 'Mental Corner',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MentalCornerScreen()));
                    },
                  ),
                  FeatureCard(
                    image: 'assets/images/icons/tutorials.png',
                    iconFallback: Icons.extension_rounded,
                    title: 'Tactical Puzzles',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TacticalPuzzlesScreen()));
                    },
                  ),
                  FeatureCard(
                    image: 'assets/images/icons/footwork.png',
                    iconFallback: Icons.flip_camera_android_rounded,
                    title: 'Mirror Mode',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MirrorModeScreen()));
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // WEEKLY CALENDAR SHORTCUT CARD
              AppCard(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainingCalendarScreen()));
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.purple.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.calendar_month_rounded, color: AppColors.purple, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Weekly Periodization Calendar', style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                          Text('View your 7-day training plan & rest day recommendations', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11.5)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String image;
  final IconData iconFallback;
  final String title;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.image,
    required this.iconFallback,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 44,
            height: 44,
            fit: BoxFit.contain,
            errorBuilder: (ctx, err, stack) => Icon(iconFallback, size: 36, color: AppColors.primaryGreen),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
