import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/tutorial.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  String _selectedLevel = 'All';

  // EXACTLY THE 7 SPECIFIED TUTORIALS
  static const List<Tutorial> tutorialsList = [
    // 1. CLEAR
    Tutorial(
      id: 'tut_clear',
      title: 'High Overhead Clear',
      description: 'Send the shuttle deep to opponent rear boundary line to reset rally control.',
      category: 'Rear Court',
      level: 'Beginner',
      duration: '5 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Forehand Grip (Basic V-Grip). Shift thumb slightly for backhand clear.',
      technique: [
        'Turn body sideways with non-racket shoulder pointing towards the shuttle.',
        'Draw racket back behind head with elbow high in prep position.',
        'Uncoil hips and shoulder while pushing racket arm upwards toward apex.',
        'Snap wrist forward and follow through down across non-racket hip.',
      ],
      contactPoint: 'High overhead above racket shoulder, slightly in front of head plane.',
      bodyPosition: 'Sideways body angle, non-racket hand pointing up for balance.',
      commonMistakes: [
        'Hitting shuttle behind body shoulder line.',
        'Standing flat-footed facing the net without hip rotation.',
      ],
      coachTip: 'Reach as high as possible at contact for maximum depth.',
    ),

    // 2. SMASH
    Tutorial(
      id: 'tut_smash',
      title: 'Overhead Power Smash',
      description: 'The primary offensive strike hit steeply downward into opponent court.',
      category: 'Rear Court',
      level: 'Intermediate',
      duration: '7 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Relaxed Forehand Grip. Tighten grip tightly at instant of contact.',
      technique: [
        'Position body quickly behind shuttle trajectory with explosive backpedal.',
        'Load weight onto back foot and arch upper torso slightly.',
        'Explode upward into jump while rotating chest and hips forward.',
        'Snap wrist downward sharply at maximum jump height.',
      ],
      contactPoint: 'Peak jump height, well in front of body line.',
      bodyPosition: 'Loaded back leg, chest rotating forward, scissor kick mid-air swap.',
      commonMistakes: [
        'Striking shuttle flat instead of angling downward.',
        'Tensing grip muscles too early before impact.',
      ],
      coachTip: 'Snap your wrist down at the peak of your jump for steep angle.',
    ),

    // 3. DROP
    Tutorial(
      id: 'tut_drop',
      title: 'Overhead Drop Shot',
      description: 'Disguise your stroke as a smash, but drop shuttle softly over net tape.',
      category: 'Rear Court',
      level: 'Intermediate',
      duration: '6 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Forehand V-Grip with relaxed finger pressure.',
      technique: [
        'Use identical smash preparation motion to deceive opponent.',
        'Decelerate racket arm speed just before hitting shuttle.',
        'Slice or slice-slice gently across shuttle cork face.',
        'Follow through smoothly without hard wrist snap.',
      ],
      contactPoint: 'Overhead in front of body, identical to smash position.',
      bodyPosition: 'Sideways setup, upper body relaxed, smooth weight transfer.',
      commonMistakes: [
        'Slow arm preparation giving away the drop shot early.',
        'Hitting shuttle too far behind head plane.',
      ],
      coachTip: 'Make your preparation motion look identical to a smash.',
    ),

    // 4. LIFT
    Tutorial(
      id: 'tut_lift',
      title: 'Underhand Defensive Lift',
      description: 'Send shuttle high and deep to rear court from underhand net position.',
      category: 'Underhand',
      level: 'Beginner',
      duration: '5 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Panhandle or Forehand Grip for forehand lift; Thumb Grip for backhand lift.',
      technique: [
        'Lunge forward toward net with racket leg in front.',
        'Extend racket arm low under shuttle falling line.',
        'Flick wrist and forearm upward sending shuttle high to rear boundary.',
        'Recover back foot to center base immediately.',
      ],
      contactPoint: 'Below net height, out in front of lead knee.',
      bodyPosition: 'Deep lunge with lead knee bent at 90 degrees, torso upright.',
      commonMistakes: [
        'Lifting shuttle flat into opponent smash zone.',
        'Bending waist forward instead of lunging with legs.',
      ],
      coachTip: 'Aim for maximum height to buy time to return to base.',
    ),

    // 5. DRIVE
    Tutorial(
      id: 'tut_drive',
      title: 'Flat Fast Drive',
      description: 'Fast, flat horizontal stroke hit back and forth at chest height.',
      category: 'Mid Court',
      level: 'Intermediate',
      duration: '6 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Shortened Forehand or Thumb Grip for fast recoil.',
      technique: [
        'Adopt wide, low defensive stance at mid-court base.',
        'Keep racket head up at chest level ready for rapid exchanges.',
        'Use short compact wrist snap into shuttle trajectory.',
        'Recoil racket head immediately back to ready position.',
      ],
      contactPoint: 'Chest to shoulder height, out in front of torso.',
      bodyPosition: 'Low stance, knees soft, weight balanced on balls of feet.',
      commonMistakes: [
        'Using full arm swing backswing instead of compact wrist snap.',
        'Dropping racket head below waist level between shots.',
      ],
      coachTip: 'Keep your backswing minimal for maximum exchange speed.',
    ),

    // 6. PUSH
    Tutorial(
      id: 'tut_push',
      title: 'Mid-Court Push Shot',
      description: 'Steer shuttle downwards into open mid-court spaces past net player.',
      category: 'Mid Court',
      level: 'Beginner',
      duration: '5 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Thumb Grip on backhand side; Light Forehand Grip on forehand side.',
      technique: [
        'Step in early to intercept shuttle above net tape level.',
        'Push racket face forward smoothly using thumb or index finger drive.',
        'Keep stroke trajectory flat and downward into open court space.',
      ],
      contactPoint: 'Above net tape height, well extended in front of body.',
      bodyPosition: 'Balanced front step, arm extended, wrist firm.',
      commonMistakes: [
        'Pushing shuttle upward giving opponent easy net kill.',
        'Over-swinging with whole arm.',
      ],
      coachTip: 'Intercept the shuttle high above net tape height.',
    ),

    // 7. NET SHOT
    Tutorial(
      id: 'tut_net',
      title: 'Spinning Net Drop Shot',
      description: 'Tumble shuttle cork spinning just over net tape to force opponent lifts.',
      category: 'Net Play',
      level: 'Advanced',
      duration: '6 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Relaxed Finger-Tip Grip with light thumb support.',
      technique: [
        'Lunge to net tape with extended racket arm and soft fingers.',
        'Brush racket face softly across shuttle cork base at contact.',
        'Allow shuttle to spin cork-over-feather just above tape.',
      ],
      contactPoint: 'Tape level height, high and early in front of net.',
      bodyPosition: 'Extended lunge leg, loose arm, upright chest.',
      commonMistakes: [
        'Tensing fingers or gripping racket handle too hard.',
        'Reaching late below net tape line.',
      ],
      coachTip: 'Use soft fingers—never hit hard at the net.',
    ),
  ];

  List<Tutorial> get _filteredTutorials {
    if (_selectedLevel == 'All') return tutorialsList;
    return tutorialsList.where((t) => t.level == _selectedLevel).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Stroke Learning Library', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Description Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Master 7 Essential Badminton Stroke Techniques',
              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
            ),
          ),

          // Skill Level Choice Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: ['All', 'Beginner', 'Intermediate', 'Advanced'].map((lvl) {
                final isSelected = _selectedLevel == lvl;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    selected: isSelected,
                    label: Text(lvl),
                    labelStyle: GoogleFonts.poppins(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    selectedColor: AppColors.cyan,
                    backgroundColor: AppColors.surfaceLight,
                    onSelected: (_) => setState(() => _selectedLevel = lvl),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // 7 Tutorials List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _filteredTutorials.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final tut = _filteredTutorials[index];
                return AppCard(
                  onTap: () => _showTutorialDetail(context, tut),
                  child: Row(
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.menu_book_rounded, color: AppColors.primaryGreen, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                BadgeTag(label: tut.category, color: AppColors.purple),
                                const SizedBox(width: 8),
                                BadgeTag(label: tut.level, color: AppColors.cyan),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              tut.title,
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tut.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTutorialDetail(BuildContext context, Tutorial tutorial) {
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
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      BadgeTag(label: tutorial.category, color: AppColors.purple),
                      const SizedBox(width: 8),
                      BadgeTag(label: tutorial.level, color: AppColors.cyan),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(tutorial.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(tutorial.description, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13, height: 1.45)),
                  const SizedBox(height: 24),

                  // 1. GRIP
                  _buildSectionHeader('✊ Grip Technique'),
                  const SizedBox(height: 6),
                  _buildInfoBox(tutorial.grip, AppColors.cyan),

                  const SizedBox(height: 18),

                  // 2. TECHNIQUE STEPS
                  _buildSectionHeader('⚡ Technique Execution'),
                  const SizedBox(height: 8),
                  ...tutorial.technique.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.15), shape: BoxShape.circle),
                          child: Text('${entry.key + 1}', style: GoogleFonts.poppins(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(entry.value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, height: 1.4))),
                      ],
                    ),
                  )),

                  const SizedBox(height: 18),

                  // 3. CONTACT POINT
                  _buildSectionHeader('🎯 Contact Point'),
                  const SizedBox(height: 6),
                  _buildInfoBox(tutorial.contactPoint, AppColors.orange),

                  const SizedBox(height: 18),

                  // 4. BODY POSITION
                  _buildSectionHeader('🧘 Body Position & Stance'),
                  const SizedBox(height: 6),
                  _buildInfoBox(tutorial.bodyPosition, AppColors.purple),

                  const SizedBox(height: 18),

                  // 5. COMMON MISTAKES
                  _buildSectionHeader('❌ Common Mistakes to Avoid'),
                  const SizedBox(height: 8),
                  ...tutorial.commonMistakes.map((mistake) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.close_rounded, color: AppColors.red, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(mistake, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13))),
                      ],
                    ),
                  )),

                  const SizedBox(height: 18),

                  // 6. COACHING TIPS
                  _buildSectionHeader('💡 Coaching Tips'),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.tips_and_updates_rounded, color: AppColors.electricGreen, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            tutorial.coachTip,
                            style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoBox(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, height: 1.4),
      ),
    );
  }
}
