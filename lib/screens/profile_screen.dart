import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/user_provider.dart';
import '../presentation/widgets/app_card.dart';
import '../presentation/widgets/section_title.dart';
import '../presentation/widgets/badge_tag.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/screens/onboarding_screen.dart';
import '../presentation/screens/assessment_drills_screen.dart';
import '../presentation/screens/mental_corner_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<String> journeyStages = [
    'Explorer',
    'Beginner',
    'Developing Player',
    'Intermediate',
    'Advanced',
    'Competitive Player',
    'Elite Athlete',
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    final currentStage = user.calculatedJourneyStage;
    final currentStageIndex = journeyStages.indexOf(currentStage).clamp(0, 6);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Player Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, color: AppColors.primaryGreen, size: 28),
            onPressed: () => _showEditProfileModal(context, userProvider),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Header
            Center(
              child: Column(
                children: [
                  Container(
                    height: 96,
                    width: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryGreen, width: 3),
                      image: DecorationImage(
                        image: AssetImage(user.avatarUrl),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(color: AppColors.primaryGreen.withValues(alpha: 0.3), blurRadius: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.name,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => _showEditProfileModal(context, userProvider),
                        child: const Icon(Icons.edit_rounded, color: AppColors.primaryGreen, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${user.username}',
                    style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  BadgeTag(label: 'Level ${user.level} • $currentStage', color: AppColors.primaryGreen),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 7-STAGE PLAYER JOURNEY CARD
            const SectionTitle(title: '7-Stage Athlete Journey'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Stage ${currentStageIndex + 1} of 7', style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(currentStage, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Journey Stage Progress Stepper
                  Row(
                    children: List.generate(7, (index) {
                      final isReached = index <= currentStageIndex;
                      return Expanded(
                        child: Container(
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: isReached ? AppColors.electricGreen : Colors.white12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Sessions completed: ${user.completedSessions} • Total minutes: ${user.totalMinutes}m',
                    style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // AI COACH DIAGNOSTICS & BADGES
            const SectionTitle(title: 'Coach Diagnostics'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    borderColor: AppColors.primaryGreen.withValues(alpha: 0.4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOP STRENGTH', style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(user.strongestSkill, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppCard(
                    borderColor: AppColors.orange.withValues(alpha: 0.4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AREA TO IMPROVE', style: GoogleFonts.poppins(color: AppColors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(user.weakestSkill, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ATHLETE BIOMETRICS & PREFERENCES
            const SectionTitle(title: 'Athlete Profile Details'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  _buildProfileRow('Playing Level', user.playingLevel),
                  _buildProfileRow('Primary Goal', user.primaryGoal),
                  _buildProfileRow('Dominant Hand', user.dominantHand),
                  _buildProfileRow('Playing Style', user.playingStyle ?? 'Both'),
                  _buildProfileRow('Age', user.age != null ? '${user.age} yrs' : 'Not set'),
                  _buildProfileRow('Gender', user.gender ?? 'Not set'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SHORTCUT BUTTONS
            AppCard(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MentalCornerScreen()));
              },
              child: Row(
                children: [
                  const Icon(Icons.self_improvement_rounded, color: AppColors.cyan, size: 24),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Mental Corner & Psychology', style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
                ],
              ),
            ),

            const SizedBox(height: 12),

            AppCard(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AssessmentDrillsScreen()));
              },
              child: Row(
                children: [
                  const Icon(Icons.assignment_rounded, color: AppColors.purple, size: 24),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Periodic Skill Assessments', style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // RE-ONBOARDING RESET FOR TESTING
            OutlinedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: Text('Reset Onboarding?', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                    content: Text('This will reset your athlete setup and restart the onboarding flow.', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('RESET', style: TextStyle(color: AppColors.red))),
                    ],
                  ),
                );
                if (confirm == true) {
                  await userProvider.resetOnboarding();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                      (route) => false,
                    );
                  }
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.red,
                side: const BorderSide(color: AppColors.red),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('RE-ENTER ONBOARDING SETUP', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13)),
          Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showEditProfileModal(BuildContext context, UserProvider provider) {
    final nameController = TextEditingController(text: provider.user.name);
    String selectedHand = provider.user.dominantHand;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Athlete Profile', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: GoogleFonts.poppins(color: AppColors.textMuted),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white24), borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppColors.primaryGreen), borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: selectedHand,
                dropdownColor: AppColors.surface,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Dominant Racket Hand',
                  labelStyle: GoogleFonts.poppins(color: AppColors.textMuted),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white24), borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'Right-handed', child: Text('Right-handed')),
                  DropdownMenuItem(value: 'Left-handed', child: Text('Left-handed')),
                  DropdownMenuItem(value: 'Ambidextrous', child: Text('Ambidextrous')),
                ],
                onChanged: (val) {
                  if (val != null) selectedHand = val;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty) {
                    provider.updateProfileName(nameController.text.trim());
                  }
                  provider.updateDominantHand(selectedHand);
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('SAVE CHANGES', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}
