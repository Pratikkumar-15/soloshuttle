import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../providers/training_provider.dart';
import '../../providers/ai_coach_provider.dart';
import '../../providers/notification_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/gradient_hero_card.dart';
import '../widgets/badge_tag.dart';
import '../widgets/section_title.dart';
import 'drill_intro_screen.dart';
import 'reaction_training_screen.dart';
import 'tutorials_screen.dart';
import 'notifications_screen.dart';
import 'ai_coach_screen.dart';
import 'mental_corner_screen.dart';
import 'tactical_puzzles_screen.dart';
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
                      Consumer<NotificationProvider>(
                        builder: (context, notifProvider, _) {
                          final unread = notifProvider.unreadCount;
                          return InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const NotificationsScreen()),
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
                                if (unread > 0)
                                  Positioned(
                                    right: 2,
                                    top: 2,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.coral,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '$unread',
                                        style: GoogleFonts.jetBrainsMono(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
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

              // SMART DAILY GOAL CARD
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

              // MODULES GRID (Badminton Features Only)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
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
                    image: 'assets/images/icons/reaction_drill.png',
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
                    image: 'assets/images/icons/mental_corner.png',
                    iconFallback: Icons.self_improvement_rounded,
                    title: 'Mental Corner',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MentalCornerScreen()));
                    },
                  ),
                  FeatureCard(
                    image: 'assets/images/icons/tactical_puzzles.png',
                    iconFallback: Icons.extension_rounded,
                    title: 'Tactical Puzzles',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TacticalPuzzlesScreen()));
                    },
                  ),
                ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 68,
            width: 68,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.limeGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.limeGreen.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, stack) => Icon(iconFallback, size: 44, color: AppColors.limeGreen),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: GoogleFonts.poppins(
                  color: AppColors.chalkWhite,
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
