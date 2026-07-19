import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/user_provider.dart';
import '../presentation/widgets/app_card.dart';
import '../presentation/widgets/gradient_hero_card.dart';
import '../presentation/widgets/section_title.dart';
import '../presentation/screens/reaction_training_screen.dart';
import '../presentation/screens/tutorials_screen.dart';
import '../presentation/screens/notifications_screen.dart';
import 'drills_screen.dart';
import 'footwork_screen.dart';
import '../providers/training_provider.dart';
import '../presentation/screens/drill_intro_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final trainingProvider = Provider.of<TrainingProvider>(context);
    final todaysPlan = trainingProvider.todaysTrainingPlan;
    final todaysDrill = trainingProvider.todaysDrill;

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
                        errorBuilder: (_, __, ___) => const Icon(Icons.sports_tennis_rounded, color: AppColors.primaryGreen, size: 36),
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

              const SizedBox(height: 28),

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
                'Ready to train and improve today?',
                style: GoogleFonts.poppins(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 24),

              // DYNAMIC TODAY'S TRAINING CARD
              GradientHeroCard(
                tag: "${todaysPlan.dayName.toUpperCase()}'S TRAINING • ${todaysPlan.pillar.toUpperCase()}",
                title: todaysPlan.title,
                subtitle: todaysPlan.subtitle,
                buttonText: 'START TODAY\'S TRAINING',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DrillIntroScreen(drill: todaysDrill)),
                  );
                },
              ),

              const SizedBox(height: 28),

              const SectionTitle(title: 'Training Modules'),
              const SizedBox(height: 14),

              // FEATURES GRID
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.1,
                children: [
                  FeatureCard(
                    image: 'assets/images/icons/solo_drills.png',
                    iconFallback: Icons.sports_tennis_rounded,
                    title: 'Solo Drills',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DrillsScreen()),
                      );
                    },
                  ),
                  FeatureCard(
                    image: 'assets/images/icons/footwork.png',
                    iconFallback: Icons.directions_run_rounded,
                    title: 'Footwork',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FootworkScreen()),
                      );
                    },
                  ),
                  FeatureCard(
                    image: 'assets/images/icons/voice_coach.png',
                    iconFallback: Icons.bolt_rounded,
                    title: 'Reaction Drill',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ReactionTrainingScreen()),
                      );
                    },
                  ),
                  FeatureCard(
                    image: 'assets/images/icons/tutorials.png',
                    iconFallback: Icons.ondemand_video_rounded,
                    title: 'Tutorials',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TutorialsScreen()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // AI DAILY CHALLENGE BANNER
              AppCard(
                backgroundColor: AppColors.surface,
                borderColor: AppColors.orange.withValues(alpha: 0.4),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DrillsScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.casino_rounded, color: AppColors.orange, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Training Challenge',
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '150 Shadow Footwork Steps • +50 XP Reward',
                            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white60, size: 16),
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
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 54,
            height: 54,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(iconFallback, size: 44, color: AppColors.primaryGreen),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
