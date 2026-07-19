import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../providers/user_provider.dart';
import '../presentation/widgets/app_card.dart';
import '../presentation/widgets/app_button.dart';
import '../presentation/widgets/section_title.dart';
import '../presentation/widgets/badge_tag.dart';
import '../presentation/screens/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<Map<String, String>> achievements = [
    {
      'emoji': '🔥',
      'title': '12-Day Streak',
      'description': 'Trained 12 consecutive days without missing a session.',
      'status': 'UNLOCKED',
    },
    {
      'emoji': '⚡',
      'title': 'Speed Demon',
      'description': 'Completed 50 reaction speed callouts under 1.5 seconds.',
      'status': 'UNLOCKED',
    },
    {
      'emoji': '🏆',
      'title': 'Smash Master',
      'description': 'Logged over 100 smash repetitions in solo drills.',
      'status': 'UNLOCKED',
    },
    {
      'emoji': '🎯',
      'title': 'Bullseye',
      'description': 'Achieved 90%+ low serve target accuracy.',
      'status': 'UNLOCKED',
    },
    {
      'emoji': '👑',
      'title': '1000 XP Club',
      'description': 'Earned 1000 total training XP points.',
      'status': 'IN PROGRESS',
    },
    {
      'emoji': '👟',
      'title': 'Footwork Legend',
      'description': 'Completed 50 six-corner shadow footwork routines.',
      'status': 'IN PROGRESS',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final xpProgressRatio = (user.currentXp / user.xpNeededForNextLevel).clamp(0.0, 1.0);
    final xpNeededRemaining = user.xpNeededForNextLevel - user.currentXp;

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
                      image: const DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
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
                  const SizedBox(height: 6),
                  BadgeTag(label: 'Level ${user.level} • ${user.calculatedSkillLevel}', color: AppColors.primaryGreen),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Level & Progress Bar Card
            const SectionTitle(title: 'Level & XP Progress'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Level ${user.level} (${user.calculatedSkillLevel})',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${user.currentXp} / ${user.xpNeededForNextLevel} XP',
                        style: GoogleFonts.poppins(color: AppColors.orange, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: xpProgressRatio,
                      minHeight: 10,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Next Level Progress:',
                        style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
                      ),
                      Text(
                        '$xpNeededRemaining XP to Level ${user.level + 1}',
                        style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile Details & Auto Skill Level Card
            const SectionTitle(title: 'Player Attributes'),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  _buildDetailRow('Automated Skill Rank', user.calculatedSkillLevel, isHighlighted: true),
                  const Divider(color: Colors.white12),
                  _buildDetailRow('Dominant Hand', user.dominantHand),
                  const Divider(color: Colors.white12),
                  _buildDetailRow('Current Level', 'Level ${user.level}'),
                  const Divider(color: Colors.white12),
                  _buildDetailRow('Favorite Drill', user.favoriteDrill),
                  const Divider(color: Colors.white12),
                  _buildDetailRow('Completed Sessions', '${user.completedSessions} Sessions'),
                  const Divider(color: Colors.white12),
                  _buildDetailRow('Total Training Time', '${user.totalMinutes ~/ 60} hrs'),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Auto Calculation Explanation Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: AppColors.cyan, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Skill Rank is calculated automatically from XP, sessions, training minutes, and streaks.',
                      style: GoogleFonts.poppins(color: AppColors.cyan, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Achievements Card & Grid
            SectionTitle(
              title: 'Achievements & Badges',
              actionText: 'View All',
              onActionPressed: () => _showAchievementsModal(context),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: achievements.take(4).map((ach) {
                final isUnlocked = ach['status'] == 'UNLOCKED';
                return AppCard(
                  onTap: () => _showAchievementsModal(context),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  backgroundColor: isUnlocked ? AppColors.surface : AppColors.surfaceLight.withValues(alpha: 0.4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(ach['emoji']!, style: const TextStyle(fontSize: 26)),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          ach['title']!,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ach['status']!,
                        style: GoogleFonts.poppins(
                          color: isUnlocked ? AppColors.electricGreen : AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            AppButton(
              text: 'SETTINGS & PREFERENCES',
              type: AppButtonType.outline,
              icon: Icons.tune_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 14)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: isHighlighted ? AppColors.primaryGreen : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileModal(BuildContext context, UserProvider userProvider) {
    final nameController = TextEditingController(text: userProvider.user.name);
    String selectedHand = userProvider.user.dominantHand;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Edit Player Details', style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Player Name',
                      labelStyle: GoogleFonts.poppins(color: AppColors.textMuted),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white24)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryGreen)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('Dominant Racket Hand', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Right', 'Left'].map((hand) {
                      final isSelected = selectedHand == hand;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            selected: isSelected,
                            label: Text(hand, style: TextStyle(fontSize: 13, color: isSelected ? Colors.black : Colors.white)),
                            selectedColor: AppColors.primaryGreen,
                            backgroundColor: AppColors.surfaceLight,
                            onSelected: (_) => setModalState(() => selectedHand = hand),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'SAVE PROFILE',
                    onPressed: () {
                      if (nameController.text.trim().isNotEmpty) {
                        userProvider.updateProfileName(nameController.text.trim());
                      }
                      userProvider.updateDominantHand(selectedHand);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAchievementsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 16),
                Text('Achievements & Badges', style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...achievements.map((ach) {
                  final isUnlocked = ach['status'] == 'UNLOCKED';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(ach['emoji']!, style: const TextStyle(fontSize: 32)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ach['title']!, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 2),
                                Text(ach['description']!, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
                              ],
                            ),
                          ),
                          BadgeTag(
                            label: ach['status']!,
                            color: isUnlocked ? AppColors.primaryGreen : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }
}
