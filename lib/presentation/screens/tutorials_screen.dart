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
    // 1
    Tutorial(
      id: 'tut_grips',
      title: 'Basic Grips: Forehand & Backhand',
      category: 'Grip & Stance',
      duration: '5 min',
      level: 'Beginner',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
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

    // 2
    Tutorial(
      id: 'tut_splitstep',
      title: 'Ready Position & Split Step Timing',
      category: 'Footwork',
      duration: '6 min',
      level: 'Beginner',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
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

    // 3
    Tutorial(
      id: 'tut_chasse',
      title: '6-Corner Court Footwork & Chassé Recovery',
      category: 'Footwork',
      duration: '8 min',
      level: 'Intermediate',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/footwork.png',
      summary: 'Master diagonal chassé steps, lunges, and rapid recovery back to center base.',
      introduction: 'Footwork is the engine of badminton. Efficient court movement saves 40% energy per match.',
      objective: 'Move to all 6 court corners with optimal foot steps while maintaining balanced recovery.',
      matchApplications: 'Crucial for covering rear court clears, net drops, and side smash defenses.',
      grip: 'Dynamic neutral grip switching based on corner.',
      readyPosition: 'Center T-area base position with active pre-hops.',
      footwork: 'Chassé sidestep for rear court; lead-leg lunge for front net corners.',
      bodyPosition: 'Low center of gravity with torso upright during lunges.',
      swingMechanics: 'Synchronized with foot contact step.',
      contactPoint: 'At peak lunge reach or highest jump point.',
      recovery: 'Explosive heel push-off back to center T-area base.',
      commonMistakes: [
        'Crossing feet during rear recovery—causes trips and slow movement.',
        'Landing on lead toe during front net lunge—causes knee strain.',
      ],
      coachingTips: [
        'Always land on the heel of your lead foot during front court lunges.',
        'Use chassé steps (feet never cross) for rapid sideways movement.',
      ],
      practiceProgression: [
        'Beginner: 3-set x 10-reps front net lunge and heel push-back',
        'Intermediate: 6-corner shadow movement drill (45 seconds x 4 sets)',
        'Advanced: Random direction voice callout footwork drill',
        'Match Application: Automatic court coverage with zero wasted steps',
      ],
      progressCheck: 'Achieved when completing a 6-corner shadow set in under 18 seconds with clean balance.',
    ),

    // 4
    Tutorial(
      id: 'tut_scissor_kick',
      title: 'Scissor Kick Footwork & High Contact Power',
      category: 'Footwork',
      duration: '7 min',
      level: 'Intermediate',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/footwork.png',
      summary: 'Airborne leg swap mechanics to gain maximum jump height and instant forward momentum.',
      introduction: 'The scissor kick allows players to hit overhead strokes at maximum height while propelling their body forward.',
      objective: 'Swap legs in mid-air during overhead stroke to land moving forward toward base center.',
      matchApplications: 'Used on overhead smashes, clears, and drops from the rear court.',
      grip: 'Forehand attack grip.',
      readyPosition: 'Side-on body turn with back foot loaded.',
      footwork: 'Explosive jump off back foot, leg swap in mid-air, landing on non-racket leg.',
      bodyPosition: 'Arching torso extending high into air.',
      swingMechanics: 'Rotational hip drive synchronized with mid-air leg swap.',
      contactPoint: 'Peak jump height in front of hitting shoulder.',
      recovery: 'Non-racket leg lands forward to immediately brake and sprint to center.',
      commonMistakes: [
        'Swapping legs after landing—destroys forward momentum.',
        'Jumping straight up without loading back leg.',
      ],
      coachingTips: [
        'Think of pedaling a bicycle once in mid-air.',
        'Land on your front foot to automatically take your first step back to base.',
      ],
      practiceProgression: [
        'Beginner: Stationary scissor kick jump shadow on spot',
        'Intermediate: Rearward move + scissor kick jump smash shadow',
        'Advanced: Multi-shuttle high clear feed with jump scissor kick',
        'Match Application: Dominating overhead attack with rapid forward recovery',
      ],
      progressCheck: 'Achieved when landing on lead foot propels immediate 2-step forward recovery.',
    ),

    // 5
    Tutorial(
      id: 'tut_court_recovery',
      title: 'Central Base T-Area Recovery & Directional Reset',
      category: 'Footwork',
      duration: '6 min',
      level: 'Advanced',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/footwork.png',
      summary: 'Kinetic energy conservation and split-second repositioning back to center T-area.',
      introduction: 'Rally control is won between shots. Returning to center base ensures equal distance to all court corners.',
      objective: 'Reset to center T-area within 0.8 seconds after every stroke.',
      matchApplications: 'Executed after every single stroke in singles rallies.',
      grip: 'Instant return to neutral ready grip.',
      readyPosition: 'Slightly behind center T-line facing opponent.',
      footwork: 'Brake step followed by 2-step recovery chassé.',
      bodyPosition: 'Chest facing forward with knees flexed.',
      swingMechanics: 'N/A - Movement recovery phase.',
      contactPoint: 'N/A',
      recovery: 'Pre-hop split step as opponent reaches shuttle.',
      commonMistakes: [
        'Standing still at the corner to watch your shot.',
        'Over-running past center base.',
      ],
      coachingTips: [
        'Your hit is not finished until your feet return to base T.',
        'Keep your eyes on opponent racket face while recovering.',
      ],
      practiceProgression: [
        'Beginner: Corner hit ➔ sprint to T-area reset (20 reps)',
        'Intermediate: 4-corner random recovery shadow drill',
        'Advanced: Live shuttle placement drill with mandatory T-area touch',
        'Match Application: Effortless center positioning between intense rally exchanges',
      ],
      progressCheck: 'Achieved when reaching base T before opponent makes shuttle contact on 90%+ of shots.',
    ),

    // 6
    Tutorial(
      id: 'tut_clear',
      title: 'High Defensive & Attacking Clear',
      category: 'Overhead Strokes',
      duration: '8 min',
      level: 'Beginner',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
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

    // 7
    Tutorial(
      id: 'tut_backhand_clear',
      title: 'Backhand Overhead Clear & Thumb Leverage',
      category: 'Overhead Strokes',
      duration: '9 min',
      level: 'Advanced',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/tutorials.png',
      summary: 'Escape deep backhand rear court pressure with proper thumb grip and shoulder turn.',
      introduction: 'The backhand clear is considered one of the hardest technical strokes to master.',
      objective: 'Clear shuttle deep to opponent baseline when caught behind on backhand side.',
      matchApplications: 'Used as a vital emergency recovery stroke when caught deep in rear backhand corner.',
      grip: 'Backhand thumb grip placed firmly on wide bevel.',
      readyPosition: 'Complete back turn to net with shoulder facing rear court.',
      footwork: 'Lead leg step across body toward rear backhand corner.',
      bodyPosition: 'Back turned 180 degrees to net with elbow raised high.',
      swingMechanics: 'Elbow extends upward, wrist snaps into pronation with thumb drive acceleration.',
      contactPoint: 'High above non-dominant shoulder line.',
      recovery: 'Scissor turn recovery step back toward center base.',
      commonMistakes: [
        'Swinging with flat elbow—wastes arm power.',
        'No thumb leverage on bevel—causes weak flat return.',
      ],
      coachingTips: [
        'Point your elbow at the incoming shuttle before swinging.',
        'Drive hard with your thumb on impact.',
      ],
      practiceProgression: [
        'Beginner: Stationary backhand wrist flick shadow drills',
        'Intermediate: Multi-shuttle backhand clear feeding (20 reps)',
        'Advanced: Deep backhand clear to straight baseline accuracy',
        'Match Application: Escaping deep backhand pressure with high clears in live points',
      ],
      progressCheck: 'Achieved when backhand clears reach the rear 1.5-meter court zone consistently.',
    ),

    // 8
    Tutorial(
      id: 'tut_around_head',
      title: 'Around-The-Head Forehand Drive & Smash',
      category: 'Overhead Strokes',
      duration: '8 min',
      level: 'Intermediate',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/voice_coach.png',
      summary: 'Attack shuttles on your non-dominant side overhead without switching to backhand.',
      introduction: 'Around-the-head strokes allow aggressive forehand power on shuttles traveling over your backhand shoulder.',
      objective: 'Reach around head with forehand grip to smash or drop aggressively.',
      matchApplications: 'Punish weak clears to your backhand side with full forehand power.',
      grip: 'Forehand attack grip.',
      readyPosition: 'Side-on body rotation with head tilted slightly.',
      footwork: 'Fast backpedal step leaning upper body to non-dominant side.',
      bodyPosition: 'Arching spine sideways to allow racket arm to loop behind head.',
      swingMechanics: 'Forearm loops around back of head, pronating rapidly into impact.',
      contactPoint: 'Above non-dominant shoulder.',
      recovery: 'Explosive push off lead leg back to court center.',
      commonMistakes: [
        'Hitting shuttle late behind shoulder line.',
        'Failing to tilt upper body to clear racket trajectory.',
      ],
      coachingTips: [
        'Tilt your left ear down slightly to create space for your right arm swing.',
        'Maintain forehand attack grip throughout.',
      ],
      practiceProgression: [
        'Beginner: Standing around-the-head swing loop shadow',
        'Intermediate: Multi-shuttle around-the-head drop feeds',
        'Advanced: Jump around-the-head smash down the line',
        'Match Application: Converting backhand high clears into forehand smash winners',
      ],
      progressCheck: 'Achieved when around-the-head smash reaches steep angle with 80%+ max power.',
    ),

    // 9
    Tutorial(
      id: 'tut_smash',
      title: 'Jump & Forehand Power Smash',
      category: 'Overhead Strokes',
      duration: '10 min',
      level: 'Intermediate',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
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

    // 10
    Tutorial(
      id: 'tut_half_smash',
      title: 'Stick Smash & Half Smash Placement',
      category: 'Overhead Strokes',
      duration: '7 min',
      level: 'Intermediate',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/tutorials.png',
      summary: 'Steep downward wrist snap without full arm follow-through for rapid recovery.',
      introduction: 'The stick smash relies on fast wrist snap acceleration rather than heavy body rotation.',
      objective: 'Place steep downward shuttle into open court gaps with zero recovery delay.',
      matchApplications: 'Used in fast doubles rallies or when caught slightly out of position.',
      grip: 'Flexible Forehand grip with index finger trigger.',
      readyPosition: 'Quick upright preparation with minimal backswing.',
      footwork: 'Short adjustment hop.',
      bodyPosition: 'Upright torso with compact shoulder turn.',
      swingMechanics: 'Fast forearm pronation and sharp wrist snap stopping abruptly at hip.',
      contactPoint: 'High overhead in front of body.',
      recovery: 'Instant 1-step forward recovery.',
      commonMistakes: [
        'Using full arm swing—defeats the quick recovery purpose of stick smash.',
        'Hitting too flat over net.',
      ],
      coachingTips: [
        'Snap your wrist like snapping a towel.',
        'Abruptly stop racket follow-through to accelerate racket tip speed.',
      ],
      practiceProgression: [
        'Beginner: Standing wrist stick smash shadow (30 reps)',
        'Intermediate: Stick smash to sideline target placement',
        'Advanced: Stick smash ➔ net kill fast transition',
        'Match Application: Creating attack opportunities with low recovery energy cost',
      ],
      progressCheck: 'Achieved when stick smash lands within 30cm of court sidelines.',
    ),

    // 11
    Tutorial(
      id: 'tut_drop',
      title: 'Precision Fast & Deceptive Drop Shot',
      category: 'Overhead Strokes',
      duration: '7 min',
      level: 'Intermediate',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
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

    // 12
    Tutorial(
      id: 'tut_slice_drop',
      title: 'Crosscourt Slice Drop & Reverse Slice Cut',
      category: 'Overhead Strokes',
      duration: '8 min',
      level: 'Advanced',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/tutorials.png',
      summary: 'Deceptive sliced stroke that changes shuttle trajectory sharply at net.',
      introduction: 'Slice drops brush across shuttle feathers, causing steep deceleration and unexpected direction.',
      objective: 'Execute sharp crosscourt slice drop that land extremely close to net tape.',
      matchApplications: 'Catch opponent flat-footed when expecting a straight clear or down-the-line smash.',
      grip: 'Bevel forehand grip with loose finger control.',
      readyPosition: 'Straight smash shoulder turn disguise.',
      footwork: 'Explosive jump or standing rearward positioning.',
      bodyPosition: 'Full overhead turn disguise.',
      swingMechanics: 'Racket face cuts across shuttle at 45-degree angle from right to left.',
      contactPoint: 'High overhead, slightly to the right of head.',
      recovery: 'Immediate center recovery anticipating front net return.',
      commonMistakes: [
        'Hitting shuttle cork head-on instead of slicing feathers.',
        'Slowing down arm speed and telegraphing the stroke.',
      ],
      coachingTips: [
        'Maintain full racket arm speed; let the slicing angle slow down the shuttle speed.',
        'Brush the side of the shuttle cork.',
      ],
      practiceProgression: [
        'Beginner: Stationary slice contact feeling drill at net',
        'Intermediate: Multi-shuttle crosscourt slice drop target practice',
        'Advanced: Deceptive slice drop & straight smash alternate combination',
        'Match Application: Unlocking easy points against fast-recovering opponents',
      ],
      progressCheck: 'Achieved when slice drop lands inside opponent front service box with sharp angle.',
    ),

    // 13
    Tutorial(
      id: 'tut_block_defense',
      title: 'Smash Defense: Soft Net Block & Fast Counter',
      category: 'Defensive Strokes',
      duration: '7 min',
      level: 'Intermediate',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/voice_coach.png',
      summary: 'Absorb incoming smash velocity and turn defense into immediate net control.',
      introduction: 'A great defense absorbs the opponent smash power and forces them to run 6 meters forward.',
      objective: 'Block incoming smashes softly right over net tape or drive fast into open space.',
      matchApplications: 'Neutralizing heavy smashes in singles and doubles defense.',
      grip: 'Thumb backhand grip held relaxed.',
      readyPosition: 'Low crouching defensive stance with knees bent and racket held low in front.',
      footwork: 'Small wide adjustment steps with low center of gravity.',
      bodyPosition: 'Chest low, eyes tracking shuttle from smasher racket.',
      swingMechanics: 'Minimal swing; absorb power by softening wrist and fingers at impact.',
      contactPoint: 'In front of body below net height.',
      recovery: 'Push forward to net to anticipate opponent forced net lift.',
      commonMistakes: [
        'Swinging hard at heavy smashes—causes shuttle to fly out of bounds.',
        'Standing erect with high center of gravity.',
      ],
      coachingTips: [
        'Relax your grip at impact to absorb shuttle momentum like a soft cushion.',
        'Keep your racket face angled slightly upward.',
      ],
      practiceProgression: [
        'Beginner: Stationary smash absorption drill against feeding partner',
        'Intermediate: Straight smash soft block to net (20 reps)',
        'Advanced: Alternate soft block & fast crossdrive counter',
        'Match Application: Neutralizing opponent smash attack and turning rally into your favor',
      ],
      progressCheck: 'Achieved when soft smash block drops within 20cm of net tape.',
    ),

    // 14
    Tutorial(
      id: 'tut_fast_drive_defense',
      title: 'Drive Defense Counter-Push & Side T-Area Block',
      category: 'Defensive Strokes',
      duration: '8 min',
      level: 'Advanced',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/voice_coach.png',
      summary: 'Counter-punching fast flat drives in high-speed doubles exchanges.',
      introduction: 'Drive defense turns aggressive opponent drives back into attacking pressure for your team.',
      objective: 'Push flat drives back past midcourt opponent into deep open baseline corners.',
      matchApplications: 'Used in fast midcourt doubles drive exchanges.',
      grip: 'Short backhand thumb grip held high on handle.',
      readyPosition: 'Wide crouching stance with racket held out at chest level.',
      footwork: 'Side-to-side quick adjustment steps.',
      bodyPosition: 'Low posture leaning slightly forward.',
      swingMechanics: 'Compact wrist punch without backswing.',
      contactPoint: 'Well in front of chest.',
      recovery: 'Instant racket head reset to chest level.',
      commonMistakes: [
        'Dropping racket head between drives.',
        'Taking long swings under high shuttle speed.',
      ],
      coachingTips: [
        'Use the opponent drive speed against them—just punch firm on impact.',
        'Keep racket head at net height at all times.',
      ],
      practiceProgression: [
        'Beginner: Rapid wall drive counter-punch (100 reps)',
        'Intermediate: Midcourt drive counter-push to corners',
        'Advanced: 2-vs-1 fast drive defense drill',
        'Match Application: Dominating fast midcourt rallies',
      ],
      progressCheck: 'Achieved when counter-drives consistently pass flat within 10cm of net band.',
    ),

    // 15
    Tutorial(
      id: 'tut_drive',
      title: 'Flat Drive & Counter Exchange',
      category: 'Flat Strokes',
      duration: '6 min',
      level: 'Intermediate',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
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

    // 16
    Tutorial(
      id: 'tut_netshot',
      title: 'Spinning & Hairpin Net Shot',
      category: 'Underarm Strokes',
      duration: '7 min',
      level: 'Intermediate',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
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

    // 17
    Tutorial(
      id: 'tut_cross_drop',
      title: 'Deceptive Crosscourt Net Drop & Hairpin Counter',
      category: 'Underarm Strokes',
      duration: '7 min',
      level: 'Advanced',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/tutorials.png',
      summary: 'Hold straight net stance then slice shuttle crosscourt to open corner.',
      introduction: 'Deceptive net play forces opponent to hesitate before committing to forward movement.',
      objective: 'Play a tight crosscourt net drop while holding a straight net drop stance.',
      matchApplications: 'Used in net exchanges when opponent anticipates a straight net return.',
      grip: 'Loose forehand/backhand bevel grip.',
      readyPosition: 'Low lunge with arm extended straight toward net.',
      footwork: 'Deep lead-leg lunge with heel contact.',
      bodyPosition: 'Torso leaning forward over lead knee.',
      swingMechanics: 'Hold racket face straight until last 0.1 second, then brush across cork diagonal.',
      contactPoint: 'Net tape height in front of lead knee.',
      recovery: 'Push off lead heel back to center.',
      commonMistakes: [
        'Turning racket face too early—reveals crosscourt intention.',
        'Hitting shuttle too hard—causes it to land wide out of court.',
      ],
      coachingTips: [
        'Freeze your racket face for a split second before brushing shuttle.',
        'Keep your touch light and delicate.',
      ],
      practiceProgression: [
        'Beginner: Stationary crosscourt net slice drill',
        'Intermediate: Straight net lunge ➔ sudden crosscourt net drop shadow',
        'Advanced: Alternate straight hairpin & deceptive crosscourt net drop',
        'Match Application: Scoring direct net points through opponent deception',
      ],
      progressCheck: 'Achieved when crosscourt net drop lands inside opponent front service box.',
    ),

    // 18
    Tutorial(
      id: 'tut_fast_flick_lift',
      title: 'Attacking Net Lift & Fast Underarm Flick',
      category: 'Underarm Strokes',
      duration: '6 min',
      level: 'Intermediate',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/tutorials.png',
      summary: 'High-velocity underarm wrist snap to push shuttle over opponent frontcourt interceptor.',
      introduction: 'An attacking lift pushes the shuttle trajectory low and fast over the net player into deep rear court.',
      objective: 'Execute fast underarm flick to deep baseline corners when opponent is guarding net.',
      matchApplications: 'Countering aggressive net players in doubles and singles.',
      grip: 'Forehand / Backhand thumb grip.',
      readyPosition: 'Low lunge at net.',
      footwork: 'Explosive front court lunge.',
      bodyPosition: 'Low balance with extended reach.',
      swingMechanics: 'Short backswing followed by rapid forearm supination/pronation wrist snap.',
      contactPoint: 'Below net height near front service line.',
      recovery: 'Push back to defensive base position.',
      commonMistakes: [
        'Lifting shuttle high and slow into opponent smash zone.',
        'Using full arm swing instead of wrist snap.',
      ],
      coachingTips: [
        'Snap your wrist fast to give shuttle flat, fast trajectory over net player.',
        'Aim for the back 1-meter boundary line.',
      ],
      practiceProgression: [
        'Beginner: Underarm wrist flick shadow drills',
        'Intermediate: Fast underarm lift to deep target mats',
        'Advanced: Net drop recovery ➔ fast attacking lift response',
        'Match Application: Pushing aggressive net opponents back to baseline',
      ],
      progressCheck: 'Achieved when attacking lift clears net player reach and lands in rear 1-meter box.',
    ),

    // 19
    Tutorial(
      id: 'tut_push_kill',
      title: 'Net Push & Frontcourt Brush Kill Mechanics',
      category: 'Underarm Strokes',
      duration: '6 min',
      level: 'Advanced',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/tutorials.png',
      summary: 'Intercept loose net returns above net tape level for instant point finish.',
      introduction: 'The net kill is the ultimate execution stroke when opponent lifts or drops pop above net height.',
      objective: 'Whip racket downward or push flat to score direct points at front court.',
      matchApplications: 'Pouncing on high net returns in singles and doubles frontcourt.',
      grip: 'Pan-handle / Bevel forehand grip held high on handle.',
      readyPosition: 'Aggressive forward stance with racket head pre-raised above net level.',
      footwork: 'Explosive single step lunge or jump hop to net tape.',
      bodyPosition: 'Upright chest with arm extended high.',
      swingMechanics: 'Short wrist snap downward or quick sideways wiper motion to avoid hitting net tape.',
      contactPoint: 'Well above net tape level in opponent front court space.',
      recovery: 'Immediate recoil to avoid touching net mesh with racket frame.',
      commonMistakes: [
        'Full arm swing hitting racket into net mesh (net foul).',
        'Reaching late below net tape.',
      ],
      coachingTips: [
        'Use a short windshield wiper wrist snap to avoid net fouls.',
        'Keep racket pre-set high whenever opponent is forced into tight net lunge.',
      ],
      practiceProgression: [
        'Beginner: Stationary net brush wrist technique',
        'Intermediate: Multi-shuttle net kill feeding (20 reps)',
        'Advanced: Hairpin net roll followed by instant net kill anticipation',
        'Match Application: Winning 90%+ of loose frontcourt points instantly',
      ],
      progressCheck: 'Achieved when net kill lands sharply in frontcourt without net contact foul.',
    ),

    // 20
    Tutorial(
      id: 'tut_flick_serve',
      title: 'Low Short Serve & Deceptive Flick Serve',
      category: 'Serve & Return',
      duration: '7 min',
      level: 'Intermediate',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/solo_drills.png',
      summary: 'Low tight serve over net band and deceptive wrist flick serve to opponent rear baseline.',
      introduction: 'Serving initiates every point. A tight short serve deprives opponent of instant attacking returns.',
      objective: 'Deliver short serve passing within 5cm of net tape or flick serve over opponent reach.',
      matchApplications: 'Standard serve delivery in doubles and competitive singles rallies.',
      grip: 'Backhand thumb grip held near top of racket handle.',
      readyPosition: 'Standing close to front service line, lead foot forward, non-racket hand holding shuttle feather tip.',
      footwork: 'Stationary balanced stance with zero foot movement during serve execution.',
      bodyPosition: 'Slight forward lean with racket held below the strict 1.15-meter fixed height limit.',
      swingMechanics: 'Smooth pendulum push for short serve; sudden thumb acceleration for flick serve.',
      contactPoint: 'Contact the shuttle below the strict 1.15-meter fixed height limit.',
      recovery: 'Immediate ready stance expecting net push or drive return.',
      commonMistakes: [
        'Telegraphing flick serve by pulling back racket arm.',
        'Serving too high over net tape giving receiver easy net kill.',
      ],
      coachingTips: [
        'Use identical backswing preparation for both short serve and flick serve.',
        'Push shuttle gently with thumb for short serve.',
      ],
      practiceProgression: [
        'Beginner: 50 low short serves targeting string line 5cm over net',
        'Intermediate: Alternate 3 short serves and 1 deceptive flick serve',
        'Advanced: Target mat serve precision (landing in front 20cm box)',
        'Match Application: Consistently preventing receiver attack on serve delivery',
      ],
      progressCheck: 'Achieved when 9 out of 10 short serves skim within 5cm above net tape.',
    ),

    // 21 (NEW SERVE TUTORIAL 1)
    Tutorial(
      id: 'tut_high_singles_serve',
      title: 'High Deep Singles Serve & Height Arc',
      category: 'Serve & Return',
      duration: '6 min',
      level: 'Beginner',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/solo_drills.png',
      summary: 'High-arching forehand singles serve landing within 30cm of opponent rear baseline.',
      introduction: 'The high singles serve pushes the opponent to the back boundary line, opening up the frontcourt.',
      objective: 'Hit high-altitude forehand underarm serve that drops vertically onto the rear baseline.',
      matchApplications: 'Standard starting serve in singles play to initiate long tactical rallies.',
      grip: 'Relaxed Forehand V-Grip.',
      readyPosition: 'Standing 1 meter behind short service line, non-racket shoulder pointing at net.',
      footwork: 'Weight loaded on back foot, transferring smoothly to front foot on contact.',
      bodyPosition: 'Side-on stance with non-racket hand extending shuttle out.',
      swingMechanics: 'Full underarm pendulum swing with upward forearm pronation and wrist snap.',
      contactPoint: 'Contact the shuttle below the strict 1.15-meter fixed height limit.',
      recovery: 'Immediate scissor step recovery to center base T.',
      commonMistakes: [
        'Serving short into opponent midcourt smash zone.',
        'Lifting shuttle with flat racket face causing out-of-bounds wide serve.',
      ],
      coachingTips: [
        'Aim for maximum height so shuttle drops almost vertically on baseline.',
        'Follow through high over non-dominant shoulder.',
      ],
      practiceProgression: [
        'Beginner: 30 high serves targeting baseline mat',
        'Intermediate: High serve to backhand corner placement',
        'Advanced: Alternate high deep serve and short forehand serve',
        'Match Application: Consistently forcing opponent to clear from deep baseline',
      ],
      progressCheck: 'Achieved when 8 out of 10 high serves land within 30cm of rear baseline.',
    ),

    // 22 (NEW SERVE TUTORIAL 2)
    Tutorial(
      id: 'tut_drive_serve_return',
      title: 'Attacking Drive Serve & Receiver Return Interception',
      category: 'Serve & Return',
      duration: '7 min',
      level: 'Advanced',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      thumbnail: 'assets/images/icons/voice_coach.png',
      summary: 'Fast flat drive serve into opponent non-dominant hip and aggressive receiver return push strategies.',
      introduction: 'The drive serve travels flat and fast to surprise receivers who stand flat-footed.',
      objective: 'Drive shuttle flat at shoulder/hip height forcing a jammed opponent return.',
      matchApplications: 'Surprise tactic in doubles and fast-paced singles exchanges.',
      grip: 'Backhand thumb grip held compact.',
      readyPosition: 'Standing at front service line with flat racket preparation.',
      footwork: 'Stationary feet with quick wrist flick.',
      bodyPosition: 'Compact upright torso with quick forward focus.',
      swingMechanics: 'Sharp thumb push acceleration delivering flat trajectory over net tape.',
      contactPoint: 'Below waist level with legal upward trajectory.',
      recovery: 'Immediate midcourt stance expecting fast drive return.',
      commonMistakes: [
        'Serving too high above net band—gives receiver easy smash return.',
        'Illegal contact above waist level.',
      ],
      coachingTips: [
        'Target opponent non-racket hip or shoulder to jam their wrist.',
        'Follow up immediately with flat drive defense.',
      ],
      practiceProgression: [
        'Beginner: Flat drive serve speed control drill',
        'Intermediate: Target non-dominant hip drive serve (20 reps)',
        'Advanced: Drive serve ➔ midcourt counter-push combination',
        'Match Application: Winning direct serve points when opponent is caught off guard',
      ],
      progressCheck: 'Achieved when drive serve skims within 10cm of net band into hip target.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      'Grip & Stance',
      'Footwork',
      'Overhead Strokes',
      'Defensive Strokes',
      'Flat Strokes',
      'Underarm Strokes',
      'Serve & Return'
    ];

    final filteredTutorials = _selectedCategory == 'All'
        ? _tutorials
        : _tutorials.where((t) => t.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.courtBackground,
      appBar: AppBar(
        backgroundColor: AppColors.courtBackground,
        elevation: 0,
        title: Text(
          'BWF Video & Skill Tutorials',
          style: GoogleFonts.poppins(
            color: AppColors.chalkWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                    label: Text(
                      cat,
                      style: GoogleFonts.poppins(
                        color: isSelected
                            ? AppColors.courtBackground
                            : AppColors.chalkWhite,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.limeGreen,
                    backgroundColor: AppColors.courtSurface,
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
              style: GoogleFonts.bebasNeue(
                color: AppColors.chalkWhite,
                fontSize: 24,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Comprehensive 14-section technical breakdowns covering 22 core strokes, footwork practices & serve techniques.',
              style: GoogleFonts.inter(
                color: AppColors.sageGray,
                fontSize: 12.5,
              ),
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
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          BadgeTag(
                            label: tut.category.toUpperCase(),
                            color: AppColors.skyBlue,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BadgeTag(
                                label: tut.level,
                                color: AppColors.limeGreen,
                              ),
                              const SizedBox(width: 6),
                              BadgeTag(
                                label: tut.duration,
                                color: AppColors.corkGold,
                                icon: Icons.timer_outlined,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        tut.title,
                        style: GoogleFonts.inter(
                          color: AppColors.chalkWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tut.summary,
                        style: GoogleFonts.inter(
                          color: AppColors.sageGray,
                          fontSize: 12.5,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            color: AppColors.limeGreen,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Tap to read full 14-section breakdown ➔',
                              style: GoogleFonts.jetBrainsMono(
                                color: AppColors.limeGreen,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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
      backgroundColor: AppColors.courtSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
                      decoration: BoxDecoration(
                        color: AppColors.sageGray.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      BadgeTag(
                        label: tut.category.toUpperCase(),
                        color: AppColors.skyBlue,
                      ),
                      BadgeTag(
                        label: tut.level,
                        color: AppColors.limeGreen,
                      ),
                      BadgeTag(
                        label: tut.duration,
                        color: AppColors.corkGold,
                        icon: Icons.timer_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tut.title,
                    style: GoogleFonts.bebasNeue(
                      color: AppColors.chalkWhite,
                      fontSize: 26,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildTutSection(
                      '1. INTRODUCTION', tut.introduction, AppColors.limeGreen),
                  _buildTutSection(
                      '2. OBJECTIVE', tut.objective, AppColors.skyBlue),
                  _buildTutSection(
                      '3. WHEN TO USE (MATCH)', tut.matchApplications, AppColors.corkGold),
                  _buildTutSection(
                      '4. GRIP REQUIREMENT', tut.grip, AppColors.softViolet),
                  _buildTutSection(
                      '5. READY POSITION', tut.readyPosition, AppColors.tealSage),
                  _buildTutSection(
                      '6. FOOTWORK INITIATION', tut.footwork, AppColors.limeGreen),
                  _buildTutSection(
                      '7. BODY POSTURE & ROTATION', tut.bodyPosition, AppColors.skyBlue),
                  _buildTutSection(
                      '8. SWING MECHANICS', tut.swingMechanics, AppColors.corkGold),
                  _buildTutSection(
                      '9. CONTACT POINT', tut.contactPoint, AppColors.softViolet),
                  _buildTutSection(
                      '10. RECOVERY TO BASE', tut.recovery, AppColors.tealSage),

                  const SizedBox(height: 12),
                  Text(
                    '11. COMMON MISTAKES & CORRECTIONS',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.coral,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...tut.commonMistakes.map(
                    (m) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              color: AppColors.coral,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              m,
                              style: GoogleFonts.inter(
                                color: AppColors.chalkWhite.withValues(alpha: 0.9),
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    '12. PRACTICAL COACHING TIPS',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.limeGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...tut.coachingTips.map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.limeGreen,
                            size: 15,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              tip,
                              style: GoogleFonts.inter(
                                color: AppColors.chalkWhite,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    '13. PRACTICE PROGRESSION',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.skyBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...tut.practiceProgression.map(
                    (prog) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        prog,
                        style: GoogleFonts.inter(
                          color: AppColors.sageGray,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  _buildTutSection(
                      '14. PROGRESS CHECK & MASTERY', tut.progressCheck, AppColors.softViolet),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.limeGreen,
                        foregroundColor: AppColors.courtBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'CLOSE TUTORIAL',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
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
          Text(
            title,
            style: GoogleFonts.jetBrainsMono(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: GoogleFonts.inter(
              color: AppColors.chalkWhite,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
