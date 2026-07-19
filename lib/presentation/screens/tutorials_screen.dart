import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/tutorial.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  String _selectedCategory = 'All'; // 'All', 'Front Court', 'Mid Court', 'Rear Court'
  String _selectedLevel = 'All'; // 'All', 'Beginner', 'Intermediate', 'Advanced'

  static const List<Tutorial> tutorialsList = [
    // === FRONT COURT ===
    Tutorial(
      id: 'tut_net_shot',
      title: 'Spinning Net Drop Shot',
      description: 'Tumble the shuttle cork spinning just over net tape to force opponent lifts.',
      category: 'Front Court',
      level: 'Intermediate',
      duration: '6 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Relaxed Finger-Tip Grip with light thumb support.',
      technique: [
        'Lunge forward toward net tape with extended racket arm and soft fingers.',
        'Brush racket face softly across shuttle cork base at contact.',
        'Allow shuttle to spin cork-over-feather just above net tape height.',
        'Recover front foot to center base immediately.',
      ],
      contactPoint: 'Tape level height, high and early in front of net.',
      bodyPosition: 'Extended lunge leg, loose arm, upright chest.',
      commonMistakes: [
        'Tensing fingers or gripping racket handle too hard.',
        'Reaching late below net tape line.',
      ],
      coachTip: 'Use soft fingers—never hit hard at the net.',
      matchSituations: [
        'When opponent plays a short drop shot that you reach high above net tape.',
        'To force opponent into an upward lift so your partner can smash.',
      ],
      learningObjectives: [
        'Develop delicate finger-tip feel at the net tape.',
        'Master tumbling spin rotation on shuttle cork.',
      ],
      practiceSuggestions: [
        'Practice 30 continuous spinning net drops from hand feeder.',
        'Perform lunge-and-touch shadow net drop reps for 3 sets of 45 seconds.',
      ],
      youtubeUrl: 'https://www.youtube.com/watch?v=1uR10UjX_w0',
      youtubeTitle: 'Badminton Insight - Spinning Net Shot Masterclass',
    ),

    Tutorial(
      id: 'tut_net_lift',
      title: 'Underhand Defensive Net Lift',
      description: 'Send shuttle high and deep to opponent rear boundary line from underhand net position.',
      category: 'Front Court',
      level: 'Beginner',
      duration: '5 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Panhandle or Forehand Grip for forehand lift; Thumb Grip for backhand lift.',
      technique: [
        'Lunge forward toward net with racket leg in front.',
        'Extend racket arm low under falling shuttle trajectory.',
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
      matchSituations: [
        'When under heavy pressure from a tight net shot.',
        'To reset rally pace when out of position at the front court.',
      ],
      learningObjectives: [
        'Generate maximum height clearance to backline.',
        'Maintain body balance on deep low lunges.',
      ],
      practiceSuggestions: [
        'Lift 20 shuttles alternating forehand and backhand net corners to deep backline targets.',
      ],
      youtubeUrl: 'https://www.youtube.com/watch?v=8q5gB-zN_94',
      youtubeTitle: 'Badminton Insight - Perfecting the Net Lift',
    ),

    Tutorial(
      id: 'tut_net_kill',
      title: 'Aggressive Net Kill',
      description: 'Pounce on loose shuttles above net tape height with sharp downward wrist action.',
      category: 'Front Court',
      level: 'Intermediate',
      duration: '6 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Short Forehand V-Grip or Thumb Grip.',
      technique: [
        'Step in early and reach high above net tape level.',
        'Use short compact wrist snap downward into open court space.',
        'Avoid striking net tape with racket frame.',
      ],
      contactPoint: 'Well above net tape height, extended out in front.',
      bodyPosition: 'High balanced stance, racket extended forward.',
      commonMistakes: [
        'Big backswing hitting the net.',
        'Reaching late after shuttle drops below tape level.',
      ],
      coachTip: 'Use a short tap of the wrist—no large arm swing.',
      matchSituations: ['When opponent net shot floats high over net tape.'],
      learningObjectives: ['Develop fast interception reaction at net tape.'],
      practiceSuggestions: ['Practice 20 rapid net kill taps from feeder toss.'],
      youtubeUrl: 'https://www.youtube.com/watch?v=B1AL910jsvA',
      youtubeTitle: 'Badminton Insight - How to Master the Net Kill',
    ),

    Tutorial(
      id: 'tut_hairpin',
      title: 'Hairpin Net Shot',
      description: 'Tight net shot where shuttle travels up and immediately drops vertically down net face.',
      category: 'Front Court',
      level: 'Advanced',
      duration: '7 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Loose Finger-tip V-Grip.',
      technique: [
        'Step under low shuttle near floor.',
        'Lifting racket face vertically upwards with ultra-soft hand touch.',
      ],
      contactPoint: 'Close to net tape, low under falling shuttle.',
      bodyPosition: 'Deep lunging knee, low center of gravity.',
      commonMistakes: ['Hitting shuttle too far forward over net into opponent waiting racket.'],
      coachTip: 'Lift the shuttle vertically so it skims the net tape face.',
      matchSituations: ['Countering tight tumbling net shots near the net base.'],
      learningObjectives: ['Precision touch control under extreme pressure.'],
      practiceSuggestions: ['Shadow hairpin net lift reps for 3 sets.'],
      youtubeUrl: 'https://www.youtube.com/watch?v=b0w9kZ8v3tA',
      youtubeTitle: 'Tobias Wadenka - Hairpin Net Shot Technique',
    ),

    Tutorial(
      id: 'tut_net_push',
      title: 'Mid-Net Push Shot',
      description: 'Steer shuttle smoothly past net player into open mid-court spaces.',
      category: 'Front Court',
      level: 'Beginner',
      duration: '5 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Thumb Grip (Backhand) or Light Forehand Grip.',
      technique: [
        'Intercept shuttle above net tape level.',
        'Push racket face forward smoothly with thumb drive.',
      ],
      contactPoint: 'Above net tape height, extended forward.',
      bodyPosition: 'Balanced front step, firm wrist.',
      commonMistakes: ['Pushing shuttle upwards giving opponent easy kill.'],
      coachTip: 'Keep stroke trajectory flat and downward.',
      matchSituations: ['Catching net player off guard.'],
      learningObjectives: ['Placement control and deception at net.'],
      practiceSuggestions: ['Practice 20 target pushes into mid-court deep corners.'],
      youtubeUrl: 'https://www.youtube.com/watch?v=5V9w3b8k2g0',
      youtubeTitle: 'Badminton Insight - Net Push Mastery',
    ),

    // === MID COURT ===
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
      matchSituations: [
        'Double exchanges in mid-court.',
        'Counter-attacking opponent smash or drive.',
      ],
      learningObjectives: [
        'Master rapid wrist recoil mechanics.',
        'Maintain high racket head readiness.',
      ],
      practiceSuggestions: ['Rally 100 continuous drives against a smooth solid wall.'],
      youtubeUrl: 'https://www.youtube.com/watch?v=wQ3W8_w9z_A',
      youtubeTitle: 'Badminton Insight - Drive Technique Masterclass',
    ),

    Tutorial(
      id: 'tut_mid_push',
      title: 'Mid-Court Placement Push',
      description: 'Push shuttle into open court gaps between front and back court players.',
      category: 'Mid Court',
      level: 'Beginner',
      duration: '5 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Thumb Grip.',
      technique: ['Step into mid-court, push shuttle flat to opponent tramlines.'],
      contactPoint: 'Chest height.',
      bodyPosition: 'Low Athletic Stance.',
      commonMistakes: ['Hitting into net.'],
      coachTip: 'Aim for empty court spaces between opponents.',
      matchSituations: ['Doubles mid-court gap placement.'],
      learningObjectives: ['Court vision and space awareness.'],
      practiceSuggestions: ['Practice 20 placement pushes to sideline targets.'],
      youtubeUrl: 'https://www.youtube.com/watch?v=9_o1_R0xK3U',
      youtubeTitle: 'Badminton Insight - Mid-Court Placement Guide',
    ),

    Tutorial(
      id: 'tut_block',
      title: 'Smash Block & Drive Defense',
      description: 'Absorb smash power and block shuttle softly over net tape.',
      category: 'Mid Court',
      level: 'Intermediate',
      duration: '6 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Thumb Grip for Backhand Smash Defense.',
      technique: [
        'Get low in wide stance, absorb smash energy with soft grip recoil.',
      ],
      contactPoint: 'In front of body waist level.',
      bodyPosition: 'Wide low crouch stance.',
      commonMistakes: ['Swinging at smash instead of blocking.'],
      coachTip: 'Soft hands absorb smash speed.',
      matchSituations: ['Defending against powerful jump smashes.'],
      learningObjectives: ['Smash defense and soft touch counter-attack.'],
      practiceSuggestions: ['Practice 20 smash blocks from feeder smashes.'],
      youtubeUrl: 'https://www.youtube.com/watch?v=uN8_E2o29-0',
      youtubeTitle: 'Badminton Insight - How to Block Smashes',
    ),

    Tutorial(
      id: 'tut_mid_lift',
      title: 'Mid-Court Defensive Lift',
      description: 'Lift fast mid-court drives high to rear boundary under pressure.',
      category: 'Mid Court',
      level: 'Beginner',
      duration: '5 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Thumb Grip.',
      technique: ['Flick wrist upward from mid-court to send shuttle deep.'],
      contactPoint: 'Waist to chest level.',
      bodyPosition: 'Side-stepping mid-court base.',
      commonMistakes: ['Short lifts landing mid-court.'],
      coachTip: 'Commit to full backline depth.',
      matchSituations: ['Under pressure in mid-court drive exchanges.'],
      learningObjectives: ['High defensive clearance depth.'],
      practiceSuggestions: ['Practice 20 mid-court lifts to backline.'],
      youtubeUrl: 'https://www.youtube.com/watch?v=7_E9-w_1m2Q',
      youtubeTitle: 'Tobias Wadenka - Mid Court Defensive Lifts',
    ),

    Tutorial(
      id: 'tut_flat_exchange',
      title: 'Flat Exchange & Counter-Drive',
      description: 'Maintain high speed flat exchanges in fast doubles rallies.',
      category: 'Mid Court',
      level: 'Advanced',
      duration: '7 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Shortened V-Grip / Thumb Swap.',
      technique: ['Rapid grip adjustments mid-rally for flat counter-attacks.'],
      contactPoint: 'Chest level.',
      bodyPosition: 'Dynamic low split-step stance.',
      commonMistakes: ['Dropping racket head between shots.'],
      coachTip: 'Keep racket frame above net tape level.',
      matchSituations: ['Fast-paced doubles drive battles.'],
      learningObjectives: ['Reaction speed and grip transitions.'],
      practiceSuggestions: ['Fast wall drive drills for 3 rounds of 60s.'],
      youtubeUrl: 'https://www.youtube.com/watch?v=2_w8-k_8m0A',
      youtubeTitle: 'Badminton Insight - Flat Exchange Countering',
    ),

    // === REAR COURT ===
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
        'Turn body sideways with non-racket shoulder pointing towards shuttle.',
        'Draw racket back behind head with elbow high in prep position.',
        'Uncoil hips and shoulder while pushing racket arm upwards toward apex.',
        'Snap wrist forward and follow through down across non-racket hip.',
      ],
      contactPoint: 'High overhead above racket shoulder, slightly in front of head plane.',
      bodyPosition: 'Sideways body angle, non-racket hand pointing up for balance.',
      commonMistakes: [
        'Hitting shuttle behind body shoulder line.',
        'Standing flat-footed facing net without hip rotation.',
      ],
      coachTip: 'Reach as high as possible at contact for maximum depth.',
      matchSituations: ['Resetting rally pace when under backcourt pressure.'],
      learningObjectives: ['Master overhead contact point and hip uncoiling.'],
      practiceSuggestions: ['Perform 30 high overhead clear shadows focusing on full arm reach.'],
      youtubeUrl: 'https://www.youtube.com/watch?v=xRv1JLg4NMM',
      youtubeTitle: 'Badminton Insight - High Overhead Clear Tutorial',
    ),

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
      matchSituations: ['Attacking high floating lifts in rear court.'],
      learningObjectives: ['Explosive jump power and steep wrist snap.'],
      practiceSuggestions: ['Practice 20 jump smash and follow-up net sprint repetitions.'],
      youtubeUrl: 'https://www.youtube.com/watch?v=H7kpZ9inc10',
      youtubeTitle: 'Badminton Insight - Master the Power Smash',
    ),

    Tutorial(
      id: 'tut_drop',
      title: 'Overhead Deceptive Drop Shot',
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
      matchSituations: ['Deceiving opponents waiting for a heavy smash.'],
      learningObjectives: ['Stroke disguise and touch deceleration.'],
      practiceSuggestions: ['Practice 20 alternating smash and drop shot shadow reps.'],
      youtubeUrl: 'https://www.youtube.com/watch?v=nELWzvaT0J8',
      youtubeTitle: 'Badminton Insight - Perfecting the Drop Shot',
    ),

    Tutorial(
      id: 'tut_slice_drop',
      title: 'Reverse Slice Drop Shot',
      description: 'Slice shuttle cork face to alter trajectory and deceive opponent movement.',
      category: 'Rear Court',
      level: 'Advanced',
      duration: '7 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Forehand Grip with relaxed thumb.',
      technique: ['Slice racket face diagonally across shuttle cork at contact.'],
      contactPoint: 'High overhead in front of shoulder.',
      bodyPosition: 'Sideways posture.',
      commonMistakes: ['Over-slicing causing shuttle to hit net frame.'],
      coachTip: 'Brush the side of shuttle cork cork-face.',
      matchSituations: ['Creating sharp cross-court drop angles from rear court.'],
      learningObjectives: ['Advanced shuttle spin and trajectory manipulation.'],
      practiceSuggestions: ['Practice 20 reverse slice drop shots.'],
      youtubeUrl: 'https://www.youtube.com/watch?v=8_w9_3Q_2m8',
      youtubeTitle: 'Tobias Wadenka - Reverse Slice Drop Secret',
    ),

    Tutorial(
      id: 'tut_stick_smash',
      title: 'Wrist Snap Stick Smash',
      description: 'Fast steep smash executed with pure wrist snap and minimal arm swing.',
      category: 'Rear Court',
      level: 'Advanced',
      duration: '6 min',
      thumbnailUrl: 'assets/images/icons/tutorials.png',
      grip: 'Relaxed Forehand Grip.',
      technique: ['Quick explosive wrist snap without full arm backswing.'],
      contactPoint: 'High in front of body.',
      bodyPosition: 'Upright athletic stance.',
      commonMistakes: ['Using full shoulder arm swing.'],
      coachTip: 'Rely purely on rapid wrist acceleration.',
      matchSituations: ['Steep attack on mid-court lifts.'],
      learningObjectives: ['Instantaneous wrist snap power.'],
      practiceSuggestions: ['Practice 20 stick smash reps from mid-rear court.'],
      youtubeUrl: 'https://www.youtube.com/watch?v=132cQJ7939g',
      youtubeTitle: 'Badminton Insight - Stick Smash Technique',
    ),
  ];

  List<Tutorial> get _filteredTutorials {
    return tutorialsList.where((t) {
      final matchesCategory = _selectedCategory == 'All' || t.category == _selectedCategory;
      final matchesLevel = _selectedLevel == 'All' || t.level == _selectedLevel;
      return matchesCategory && matchesLevel;
    }).toList();
  }



  Future<void> _launchYouTubeSearch(String title, String channel) async {
    final query = Uri.encodeComponent('$title $channel Badminton Tutorial');
    final searchUri = Uri.parse('https://www.youtube.com/results?search_query=$query');
    try {
      await launchUrl(searchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch YouTube search: $e');
    }
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
          // Header Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Master 15 Essential Badminton Techniques by Court Area',
              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
            ),
          ),

          // Court Area Filter Chips (Front Court, Mid Court, Rear Court)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: ['All', 'Front Court', 'Mid Court', 'Rear Court'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    selected: isSelected,
                    label: Text(cat),
                    labelStyle: GoogleFonts.poppins(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    selectedColor: AppColors.primaryGreen,
                    backgroundColor: AppColors.surface,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),

          // Skill Level Filter Chips (All, Beginner, Intermediate, Advanced)
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

          // Tutorials List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _filteredTutorials.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
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
                        child: const Icon(Icons.ondemand_video_rounded, color: AppColors.primaryGreen, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                BadgeTag(label: tut.category, color: AppColors.purple),
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
          initialChildSize: 0.9,
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

                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      BadgeTag(label: tutorial.category, color: AppColors.purple),
                      BadgeTag(label: tutorial.level, color: AppColors.cyan),
                      BadgeTag(label: tutorial.duration, color: AppColors.orange),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(tutorial.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(tutorial.description, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13, height: 1.45)),
                  const SizedBox(height: 24),

                  // 1. GRIP
                  _buildSectionHeader('✊ Grip Technique'),
                  const SizedBox(height: 6),
                  _buildInfoBox(tutorial.grip, AppColors.cyan),

                  const SizedBox(height: 18),

                  // 2. TECHNIQUE STEPS
                  _buildSectionHeader('⚡ Technique Execution Steps'),
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

                  // 5. MATCH SITUATIONS
                  if (tutorial.matchSituations.isNotEmpty) ...[
                    _buildSectionHeader('🏸 Match Situations'),
                    const SizedBox(height: 8),
                    ...tutorial.matchSituations.map((sit) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.sports_tennis_rounded, color: AppColors.primaryGreen, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(sit, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12))),
                        ],
                      ),
                    )),
                    const SizedBox(height: 18),
                  ],

                  // 6. LEARNING OBJECTIVES
                  if (tutorial.learningObjectives.isNotEmpty) ...[
                    _buildSectionHeader('🎯 Learning Objectives'),
                    const SizedBox(height: 8),
                    ...tutorial.learningObjectives.map((obj) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: AppColors.cyan, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(obj, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12))),
                        ],
                      ),
                    )),
                    const SizedBox(height: 18),
                  ],

                  // 7. PRACTICE SUGGESTIONS
                  if (tutorial.practiceSuggestions.isNotEmpty) ...[
                    _buildSectionHeader('🏋️ Practice Suggestions'),
                    const SizedBox(height: 8),
                    ...tutorial.practiceSuggestions.map((sug) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.fitness_center_rounded, color: AppColors.orange, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(sug, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12))),
                        ],
                      ),
                    )),
                    const SizedBox(height: 18),
                  ],

                  // 8. COMMON MISTAKES
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

                  // 9. COACHING TIPS
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

                  // 10. YOUTUBE VIDEO TUTORIAL LINK (LAST AFTER READING EVERYTHING ABOUT THE SHOT)
                  _buildSectionHeader('📹 Video Coaching Tutorial'),
                  const SizedBox(height: 8),
                  AppCard(
                    backgroundColor: Colors.red.withValues(alpha: 0.15),
                    borderColor: Colors.redAccent,
                    onTap: () => _launchYouTubeSearch(tutorial.title, 'Badminton Insight'),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Watch Video Tutorial on YouTube',
                                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                '${tutorial.title} - Coaching Video',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.open_in_new_rounded, color: Colors.white70, size: 18),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  AppButton(
                    text: 'CLOSE TUTORIAL',
                    type: AppButtonType.outline,
                    onPressed: () => Navigator.pop(context),
                  ),
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
