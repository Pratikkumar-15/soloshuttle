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
  String _selectedCategory = 'All';

  final List<Tutorial> _tutorials = const [
    Tutorial(
      id: 'tut_grips',
      title: 'Basic Grips: Forehand & Backhand',
      category: 'Grip & Stance',
      duration: '5 min',
      level: 'Beginner',
      videoUrl: '',
      thumbnail: 'assets/images/icons/tutorials.png',
      summary: 'The foundation of all badminton strokes. Master the V-shape grip and thumb leverage.',
      introduction: 'Correct grip alignment determines shuttle control, power generation, and wrist safety.',
      objective: 'Master seamless transitions between forehand V-grip and backhand thumb bevel leverage.',
      matchApplications: 'Used constantly in every rally from serve to net play and rear court smashes.',
      grip: 'Forehand: Bevel 2 V-shape holding racket like a handshake. Backhand: Thumb flat on widest bevel.',
      readyPosition: 'Racket held at chest level with relaxed wrist and neutral grip stance.',
      footwork: 'Small adjustment steps maintaining balance on the balls of your feet.',
      bodyPosition: 'Relaxed shoulders, erect posture with slight forward lean.',
      swingMechanics: 'Short compact wrist recoil with finger snap acceleration on contact.',
      contactPoint: 'In front of body aligned with lead shoulder.',
      recovery: 'Immediately relax grip tension to prepare for next stroke change.',
      commonMistakes: [
        'Death-gripping the handle tightly—prevents wrist snap power.',
        'Index finger extended along spine—causes wrist strain.',
      ],
      coachingTips: [
        'Keep fingers relaxed like holding a bird: loose enough not to crush, firm enough not to drop.',
        'Use thumb push for backhand drive leverage.',
      ],
      practiceProgression: [
        'Beginner: 50 stationary grip switches (Forehand ➔ Backhand)',
        'Intermediate: Wall drive rally with dynamic grip switching',
        'Advanced: Multi-shuttle random stroke grip transitions',
        'Match Application: Execute automatic grip changes under fast drive rallies',
      ],
      progressCheck: 'Mastery achieved when grip changes occur automatically without visual checking.',
    ),
    Tutorial(
      id: 'tut_splitstep',
      title: 'Ready Position & Split Step Timing',
      category: 'Footwork',
      duration: '6 min',
      level: 'Beginner',
      videoUrl: '',
      thumbnail: 'assets/images/icons/footwork.png',
      summary: 'The secret to fast reaction speed. Pre-hop timing just before opponent shuttle impact.',
      introduction: 'The split step unweights your body and stores elastic energy in your calf tendons.',
      objective: 'Time your pre-hop landing exactly as the opponent strikes the shuttle.',
      matchApplications: 'Executed before every single opponent shot during singles and doubles rallies.',
      grip: 'Neutral ready grip held high.',
      readyPosition: 'Feet shoulder-width apart, knees flexed, weight on balls of feet.',
      footwork: 'Small downward bounce landing softly on wide base stance.',
      bodyPosition: 'Chest low, eyes locked on opponent racket contact.',
      swingMechanics: 'N/A - Footwork initiation mechanism.',
      contactPoint: 'N/A',
      recovery: 'Immediate explosive push off opposite leg toward shuttle direction.',
      commonMistakes: [
        'Splitting too late after opponent hits—delays reaction time.',
        'Jumping too high off the court—wastes vertical energy.',
      ],
      coachingTips: [
        'Listen for the opponent shuttle impact sound to sync your split landing.',
        'Stay low to maintain low center of gravity.',
      ],
      practiceProgression: [
        'Beginner: 30 shadow split steps on visual count',
        'Intermediate: Voice coach random direction callout reaction',
        'Advanced: 6-corner shadow movement with mandatory split step',
        'Match Application: Seamless pre-hop execution on every opponent stroke',
      ],
      progressCheck: 'Achieved when first-step reaction speed drops under 250 milliseconds.',
    ),
    Tutorial(
      id: 'tut_clear',
      title: 'High Defensive & Attacking Clear',
      category: 'Overhead Strokes',
      duration: '8 min',
      level: 'Beginner',
      videoUrl: '',
      thumbnail: 'assets/images/icons/solo_drills.png',
      summary: 'Push opponent deep into rear court to gain recovery time or open court space.',
      introduction: 'The clear is the foundation overhead stroke for court depth management.',
      objective: 'Send shuttle high and deep touching within 30cm of opponent rear boundary line.',
      matchApplications: 'Defensive clearance under pressure or offensive clear over opponent head.',
      grip: 'Standard Forehand Grip.',
      readyPosition: 'Side-on body turn, non-racket arm pointing at shuttle.',
      footwork: 'Chassé or backpedal to get behind the shuttle trajectory.',
      bodyPosition: 'Weight loaded on back foot before explosive rotation forward.',
      swingMechanics: 'Elbow leads, forearm pronates into contact, smooth follow-through across hip.',
      contactPoint: 'At highest comfortable point slightly in front of hitting shoulder.',
      recovery: 'Scissor kick step landing and sprinting back to base center.',
      commonMistakes: [
        'Hitting shuttle behind body line—results in flat trajectory.',
        'No hip rotation—relying entirely on arm muscle.',
      ],
      coachingTips: [
        'Reach high like reaching for an apple on a high tree branch.',
        'Snap wrist pronation at top of swing.',
      ],
      practiceProgression: [
        'Beginner: Shadow clear swing with shoulder rotation focus',
        'Intermediate: High clear accuracy to target mats in back 1 meter',
        'Advanced: Clear-to-clear rally endurance drills',
        'Match Application: Hitting deep clears consistently under match fatigue',
      ],
      progressCheck: 'Achieved when 8 out of 10 clears land in the back 1-meter target box.',
    ),
    Tutorial(
      id: 'tut_smash',
      title: 'Jump & Forehand Power Smash',
      category: 'Overhead Strokes',
      duration: '10 min',
      level: 'Intermediate',
      videoUrl: '',
      thumbnail: 'assets/images/icons/voice_coach.png',
      summary: 'Primary attacking weapon. High steep trajectory to finish the rally.',
      introduction: 'The smash converts body rotation and wrist snap into maximum shuttle velocity.',
      objective: 'Drive shuttle downward at steep angle forcing weak returns or direct winners.',
      matchApplications: 'Punish short lifts or weak clears during attacking rally phase.',
      grip: 'Forehand Grip with tight impact squeeze.',
      readyPosition: 'Explosive side-on loading with deep knee flex.',
      footwork: 'Rearward jump or scissor kick jump.',
      bodyPosition: 'Chest arching back, non-racket arm tracking shuttle.',
      swingMechanics: 'Rapid forearm pronation and wrist snap downward.',
      contactPoint: 'At maximum jump height well in front of body.',
      recovery: 'Land softly on non-racket leg and sprint forward for net kill.',
      commonMistakes: [
        'Overhitting with arm muscle instead of relaxed whip mechanics.',
        'Late contact behind head resulting in flat out-of-bounds trajectory.',
      ],
      coachingTips: [
        'Think of a whip snapping at the highest point.',
        'Follow up immediately forward—do not admire your smash.',
      ],
      practiceProgression: [
        'Beginner: Standing smash wrist snap technique',
        'Intermediate: Multi-shuttle smash accuracy down the line',
        'Advanced: Jump smash and net kill combination drill',
        'Match Application: Consistently converting short lifts into points',
      ],
      progressCheck: 'Achieved when smash angle lands steep in front of midcourt service line.',
    ),
    Tutorial(
      id: 'tut_drop',
      title: 'Precision Fast & Deceptive Drop Shot',
      category: 'Overhead Strokes',
      duration: '7 min',
      level: 'Intermediate',
      videoUrl: '',
      thumbnail: 'assets/images/icons/tutorials.png',
      summary: 'Disguise overhead swing to drop shuttle soft right over net tape.',
      introduction: 'The drop shot relies on deception: full smash preparation with soft impact touch.',
      objective: 'Force opponent into deep front court lunge to open rear court space.',
      matchApplications: 'Used after deep clear rallies to break opponent rhythm and create movement.',
      grip: 'Relaxed Forehand Grip.',
      readyPosition: 'Identical to Smash and Clear preparation.',
      footwork: 'Rearward move behind shuttle.',
      bodyPosition: 'Full body turn giving full smash disguise.',
      swingMechanics: 'Fast backswing, sliced or decelerated impact with soft fingers.',
      contactPoint: 'High in front of hitting shoulder.',
      recovery: 'Forward push toward net center.',
      commonMistakes: [
        'Telegraphing drop by slowing backswing early.',
        'Hitting shuttle too high over net tape.',
      ],
      coachingTips: [
        'Same preparation as smash until 1 inch before contact.',
        'Use soft index finger touch at impact.',
      ],
      practiceProgression: [
        'Beginner: Sliced drop contact drill over net',
        'Intermediate: Alternate clear and drop rally practice',
        'Advanced: Random overhead callout (Smash / Drop / Clear)',
        'Match Application: Scoring points through deceptive drop placement',
      ],
      progressCheck: 'Achieved when drop shot passes within 15cm above net tape.',
    ),
    Tutorial(
      id: 'tut_drive',
      title: 'Flat Drive & Counter Exchange',
      category: 'Flat Strokes',
      duration: '6 min',
      level: 'Intermediate',
      videoUrl: '',
      thumbnail: 'assets/images/icons/solo_drills.png',
      summary: 'High-speed flat exchange played around shoulder height in doubles and singles.',
      introduction: 'Drives control rally pace and deny opponent attacking height.',
      objective: 'Drive shuttle flat over net tape targeting opponent body or open space.',
      matchApplications: 'Fast midcourt rallies and counter-attacking opponent smashes.',
      grip: 'Quick switch between Forehand and Backhand thumb grip.',
      readyPosition: 'Low stance, racket held out front at shoulder height.',
      footwork: 'Lateral chassé and quick adjustment steps.',
      bodyPosition: 'Compact body posture with low center of gravity.',
      swingMechanics: 'Short backswing, compact wrist recoil without full arm follow-through.',
      contactPoint: 'In front of body at shoulder height.',
      recovery: 'Immediate racket reset back to chest level.',
      commonMistakes: [
        'Long backswing—causes late contact in fast exchanges.',
        'Hitting shuttle upwards above net tape.',
      ],
      coachingTips: [
        'Keep swing compact like table tennis drives.',
        'Recoil wrist instantly after impact.',
      ],
      practiceProgression: [
        'Beginner: 100 continuous wall drives',
        'Intermediate: Midcourt drive-to-drive rally partner drill',
        'Advanced: Drive exchange with sudden net push variation',
        'Match Application: Dominating fast flat exchanges under match pressure',
      ],
      progressCheck: 'Achieved when completing 50 wall drives without losing rally control.',
    ),
    Tutorial(
      id: 'tut_netshot',
      title: 'Spinning & Hairpin Net Shot',
      category: 'Underarm Strokes',
      duration: '7 min',
      level: 'Intermediate',
      videoUrl: '',
      thumbnail: 'assets/images/icons/footwork.png',
      summary: 'Keep shuttle tight to net tape forcing opponent weak lifts.',
      introduction: 'Net play dictates who controls attacking momentum in badminton.',
      objective: 'Brush shuttle gently so it tumbles tight over net tape into front court.',
      matchApplications: 'Front court exchanges setting up easy net kills.',
      grip: 'Soft Backhand or Forehand grip with finger control.',
      readyPosition: 'Low lunge forward with racket arm extended.',
      footwork: 'Explosive front lunge landing soft on lead heel.',
      bodyPosition: 'Stable low balance with non-hitting arm back for counter-weight.',
      swingMechanics: 'Minimal arm swing, gentle slicing or lifting motion with relaxed fingers.',
      contactPoint: 'At highest possible point near net tape level.',
      recovery: 'Push off front foot back to base center.',
      commonMistakes: [
        'Stiff wrist pushing shuttle too high.',
        'Landing on lead toe causing knee strain and slow recovery.',
      ],
      coachingTips: [
        'Treat shuttle like an eggshell—gentle soft fingers.',
        'Contact shuttle as high as possible above net tape.',
      ],
      practiceProgression: [
        'Beginner: Stationary net roll feeling drill',
        'Intermediate: Net lunge and hairpin net shot shadow',
        'Advanced: Net exchange game (first to 11 points net only)',
        'Match Application: Consistently forcing opponent lifts through net pressure',
      ],
      progressCheck: 'Achieved when net shot tumbles within 10cm of net tape.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Grip & Stance', 'Footwork', 'Overhead Strokes', 'Flat Strokes', 'Underarm Strokes'];

    final filteredTutorials = _selectedCategory == 'All'
        ? _tutorials
        : _tutorials.where((t) => t.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('BWF Video & Skill Tutorials', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Filter Chips
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
                itemBuilder: (ctx, idx) {
                  final cat = categories[idx];
                  final isSelected = cat == _selectedCategory;
                  return ChoiceChip(
                    label: Text(cat, style: GoogleFonts.poppins(color: isSelected ? Colors.black : Colors.white, fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
                    selected: isSelected,
                    selectedColor: AppColors.primaryGreen,
                    backgroundColor: AppColors.surface,
                    onSelected: (val) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Tutorial Library (${filteredTutorials.length})',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Comprehensive 14-section technical breakdowns aligned with BWF Level 3 standards.',
              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
            ),

            const SizedBox(height: 16),

            ...filteredTutorials.map((tut) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AppCard(
                  onTap: () => _showFullTutorialModal(context, tut),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          BadgeTag(label: tut.category.toUpperCase(), color: AppColors.cyan),
                          const Spacer(),
                          BadgeTag(label: tut.level, color: AppColors.electricGreen),
                          const SizedBox(width: 6),
                          BadgeTag(label: tut.duration, color: AppColors.orange, icon: Icons.timer_outlined),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(tut.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(tut.summary, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12.5, height: 1.35)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.menu_book_rounded, color: AppColors.electricGreen, size: 16),
                          const SizedBox(width: 6),
                          Text('Tap to read full 14-section breakdown ➔', style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
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

  void _showFullTutorialModal(BuildContext context, Tutorial tut) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111A2C),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
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
                  BadgeTag(label: tut.category.toUpperCase(), color: AppColors.cyan),
                  const SizedBox(height: 8),
                  Text(tut.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  _buildTutSection('1. INTRODUCTION', tut.introduction, AppColors.electricGreen),
                  _buildTutSection('2. OBJECTIVE', tut.objective, AppColors.cyan),
                  _buildTutSection('3. WHEN TO USE (MATCH)', tut.matchApplications, AppColors.orange),
                  _buildTutSection('4. GRIP REQUIREMENT', tut.grip, AppColors.purple),
                  _buildTutSection('5. READY POSITION', tut.readyPosition, AppColors.primaryGreen),
                  _buildTutSection('6. FOOTWORK INITIATION', tut.footwork, AppColors.electricGreen),
                  _buildTutSection('7. BODY POSTURE & ROTATION', tut.bodyPosition, AppColors.cyan),
                  _buildTutSection('8. SWING MECHANICS', tut.swingMechanics, AppColors.orange),
                  _buildTutSection('9. CONTACT POINT', tut.contactPoint, AppColors.purple),
                  _buildTutSection('10. RECOVERY TO BASE', tut.recovery, AppColors.primaryGreen),

                  const SizedBox(height: 12),
                  Text('11. COMMON MISTAKES & CORRECTIONS', style: GoogleFonts.poppins(color: AppColors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...tut.commonMistakes.map((m) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
                            Expanded(child: Text(m, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12))),
                          ],
                        ),
                      )),

                  const SizedBox(height: 12),
                  Text('12. PRACTICAL COACHING TIPS', style: GoogleFonts.poppins(color: AppColors.electricGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...tut.coachingTips.map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline_rounded, color: AppColors.electricGreen, size: 14),
                            const SizedBox(width: 6),
                            Expanded(child: Text(tip, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12))),
                          ],
                        ),
                      )),

                  const SizedBox(height: 12),
                  Text('13. PRACTICE PROGRESSION', style: GoogleFonts.poppins(color: AppColors.cyan, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...tut.practiceProgression.map((prog) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(prog, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                      )),

                  const SizedBox(height: 12),
                  _buildTutSection('14. PROGRESS CHECK & MASTERY', tut.progressCheck, AppColors.purple),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('CLOSE TUTORIAL', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTutSection(String title, String content, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(color: color, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
          const SizedBox(height: 4),
          Text(content, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.5, height: 1.4)),
        ],
      ),
    );
  }
}
