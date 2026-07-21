import '../entities/tactical_puzzle.dart';

class TacticalPuzzlesCatalog {
  static final List<TacticalPuzzle> allPuzzles = [
    // 1
    TacticalPuzzle(
      id: 'tp_01',
      title: 'Deep Rear Court Backhand Pressure',
      situationDescription:
          'Your opponent clears high and deep into your backhand rear corner. Opponent is standing at center base ready to smash your return. What is your safest tactical stroke?',
      courtZone: 'Rear Court Backhand',
      opponentPosition: 'Base Center Ready',
      shuttleHeight: 'High Overhead',
      coachTip:
          'When caught deep in the backhand corner, hitting a high clear resets the rally and allows full recovery to base center.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'High Straight Clear',
          description:
              'Hit a high trajectory clear deep into opponent rear court.',
          isCorrect: true,
          explanation:
              'Correct! High clear gains maximum air time, forcing opponent back while giving you full time to return to base center.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Flat Off-Balance Smash',
          description: 'Attempt a maximum power jump smash down the line.',
          isCorrect: false,
          explanation:
              'Incorrect. Smashing from deep backhand corner off-balance leaves the net wide open for an easy opponent counter-kill.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Slow Cross Net Drop',
          description:
              'Try a slow soft drop shot across to front forehand net.',
          isCorrect: false,
          explanation:
              'Risky. Off-balance drops often pop up over the net, giving opponent an immediate net kill opportunity.',
        ),
      ],
    ),

    // 2
    TacticalPuzzle(
      id: 'tp_02',
      title: 'Net Tape Early Contact Advantage',
      situationDescription:
          'Opponent plays a tight tumbling net shot. You reach the shuttle early at net tape level before it drops. How do you exploit this advantage?',
      courtZone: 'Front Net Tape',
      opponentPosition: 'Midcourt Standing Low',
      shuttleHeight: 'Above Net Tape',
      coachTip:
          'High contact at net tape allows tight net pushes or hairpin rolls that force weak opponent lifts.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'High Underarm Lift',
          description: 'Lift shuttle high to rear court.',
          isCorrect: false,
          explanation:
              'Incorrect. Reaching early at net tape to lift surrenders attacking control when you had the upper hand.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Tight Hairpin Net Roll',
          description: 'Brush shuttle gently to roll tight over net tape.',
          isCorrect: true,
          explanation:
              'Correct! Hairpin net shot forces opponent to lift under pressure, giving your team immediate attack setup.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Hard Midcourt Drive',
          description: 'Push shuttle fast into body.',
          isCorrect: false,
          explanation:
              'Incorrect. Hairpin net shot creates a guaranteed weak lift opportunity compared to a flat drive.',
        ),
      ],
    ),

    // 3
    TacticalPuzzle(
      id: 'tp_03',
      title: 'Attacking a High Flick Serve in Singles',
      situationDescription:
          'Opponent serves a high flick serve that lands just inside your rear baseline. You are well-positioned behind the shuttle.',
      courtZone: 'Rear Court Forehand',
      opponentPosition: 'Base Center',
      shuttleHeight: 'Overhead High',
      coachTip:
          'A steep angled smash or fast drop from a clean position puts opponent under instant defense pressure.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'High Defensive Clear',
          description: 'Lift the shuttle back high in the air.',
          isCorrect: false,
          explanation:
              'Surrenders initiative. The flick serve was high and attackable.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Underarm Net Tap',
          description: 'Tap gently into the net.',
          isCorrect: false,
          explanation: 'Impossible from the rear court baseline.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Steep Straight Smash / Fast Drop',
          description:
              'Hit a steep straight smash down the line or fast slice drop.',
          isCorrect: true,
          explanation:
              'Correct! Punishing a weak flick serve with steep angle forces opponent into defensive lifting.',
        ),
      ],
    ),

    // 4
    TacticalPuzzle(
      id: 'tp_04',
      title: 'Smash Defense: Crosscourt vs Straight Drive',
      situationDescription:
          'Opponent smashes hard down your forehand sideline. You reach the shuttle low near the knee.',
      courtZone: 'Midcourt Forehand Defense',
      opponentPosition: 'Attacking Rear Center',
      shuttleHeight: 'Knee Height',
      coachTip:
          'A soft block to the open net turns defense into immediate net control.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Soft Straight Block to Net',
          description: 'Guide shuttle softly over net into open space.',
          isCorrect: true,
          explanation:
              'Correct! Soft block forces the smasher to run forward 6 meters, neutralizing their attack.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'High Central Lift',
          description: 'Lift high back to center court.',
          isCorrect: false,
          explanation:
              'Gives opponent another easy smash opportunity on the next shot.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Crosscourt Flat Lift',
          description: 'Hit hard crosscourt at shoulder height.',
          isCorrect: false,
          explanation:
              'Crosscourt lifts take longer to travel and can be intercepted by opponent partner.',
        ),
      ],
    ),

    // 5
    TacticalPuzzle(
      id: 'tp_05',
      title: 'Deceptive Hold & Flick at Net',
      situationDescription:
          'You lunged forward to forehand net. Opponent anticipates a net drop and is charging forward.',
      courtZone: 'Front Forehand Net',
      opponentPosition: 'Charging Net',
      shuttleHeight: 'Mid-Net Level',
      coachTip:
          'Hold racquet face until last fraction of a second, then flick over opponent head.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Soft Net Tumbler',
          description: 'Play a soft net drop into their waiting racket.',
          isCorrect: false,
          explanation:
              'Opponent is charging forward and will easily net kill your drop.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Deceptive Flick Push Over Head',
          description:
              'Hold net stance, then flick wrist to push shuttle deep over opponent head.',
          isCorrect: true,
          explanation:
              'Correct! Opponent momentum was forward; flicking over their head scores an easy winner.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'High Crossclear',
          description: 'Lift high crosscourt.',
          isCorrect: false,
          explanation:
              'Gives opponent time to turn around and recover without taking maximum advantage of their forward charge.',
        ),
      ],
    ),

    // 6
    TacticalPuzzle(
      id: 'tp_06',
      title: 'Doubles Frontcourt Net Interception',
      situationDescription:
          'Your partner smashes from rear court. Opponent plays a weak flat block to your front court.',
      courtZone: 'Front Net T-Area',
      opponentPosition: 'Midcourt Defense',
      shuttleHeight: 'Above Net Band',
      coachTip:
          'Net player must intercept any flat or weak lift to finish the point.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Net Kill / Downward Brush',
          description: 'Pounce forward and brush shuttle downward into floor.',
          isCorrect: true,
          explanation:
              'Correct! As frontcourt player, intercepting weak returns finishes the point instantly.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Leave for Partner',
          description: 'Duck down and let shuttle pass to rear partner.',
          isCorrect: false,
          explanation:
              'Surrenders an easy kill opportunity and puts partner under unnecessary pressure.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'High Defensive Lift',
          description: 'Lift high to back court.',
          isCorrect: false,
          explanation:
              'Wastes a net kill opportunity and resets the point unnecessarily.',
        ),
      ],
    ),

    // 7
    TacticalPuzzle(
      id: 'tp_07',
      title: 'Exploiting Opponent Off-Balance Recovery',
      situationDescription:
          'Opponent dives to retrieve your crosscourt drop and is scrambling back to center on one foot.',
      courtZone: 'Midcourt Center',
      opponentPosition: 'Scrambling Left Net',
      shuttleHeight: 'Chest Level',
      coachTip:
          'Hit to the opposite corner of opponent movement momentum to force an error.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Hit Directly at Opponent Body',
          description: 'Drive shuttle into their chest.',
          isCorrect: false,
          explanation:
              'Allows opponent to block without needing to move across court.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Fast Push to Deep Rear Right Corner',
          description:
              'Push shuttle fast into empty rear right corner away from opponent movement.',
          isCorrect: true,
          explanation:
              'Correct! Catching opponent moving against momentum guarantees a point or weak return.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'High Central Clear',
          description: 'Hit high into center of court.',
          isCorrect: false,
          explanation:
              'Gives opponent plenty of time to recover their balance.',
        ),
      ],
    ),

    // 8
    TacticalPuzzle(
      id: 'tp_08',
      title: 'Short Serve Return Strategy',
      situationDescription:
          'Opponent executes a low short serve in singles landing right at the front service line.',
      courtZone: 'Front Service Line',
      opponentPosition: 'Center Service Line',
      shuttleHeight: 'Net Tape Height',
      coachTip:
          'Stepping in early to push shuttle deep to corners prevents opponent attack.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'High Overhead Lift',
          description: 'Lift high into middle of court.',
          isCorrect: false,
          explanation:
              'Gives opponent an easy smash opportunity on the serve return.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Early Push to Deep Rear Corners',
          description: 'Step in fast and push shuttle flat into rear corner.',
          isCorrect: true,
          explanation:
              'Correct! Taking short serve early and pushing deep deprives opponent of attacking setup.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Underarm Net Tap',
          description: 'Tap softly into the net.',
          isCorrect: false,
          explanation:
              'Playing soft net allows opponent to re-net or brush early.',
        ),
      ],
    ),

    // 9
    TacticalPuzzle(
      id: 'tp_09',
      title: 'Managing High Tailwind Draft',
      situationDescription:
          'You are playing on the side of court with strong tailwind blowing shuttle forward.',
      courtZone: 'Rear Court',
      opponentPosition: 'Base Center',
      shuttleHeight: 'Overhead',
      coachTip:
          'With tailwind, favor drop shots and steep smashes over deep clears that fly out of bounds.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Slice Drop & Half Smash',
          description: 'Use controlled drops and steep half-smashes.',
          isCorrect: true,
          explanation:
              'Correct! High clears with tailwind carry past baseline. Drops and smashes stay in court.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'High Baseline Clears',
          description: 'Hit high full-power clears.',
          isCorrect: false,
          explanation:
              'Tailwind will blow full-power clears out of bounds beyond baseline.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Flat High Drive',
          description: 'Drive hard down the center line.',
          isCorrect: false,
          explanation:
              'Flat drives with tailwind easily travel beyond the back line.',
        ),
      ],
    ),

    // 10
    TacticalPuzzle(
      id: 'tp_10',
      title: 'Straight Smash vs Crosscourt Smash Risk',
      situationDescription:
          'You are at rear forehand corner. Opponent is waiting at midcourt ready for crosscourt defense.',
      courtZone: 'Rear Forehand Corner',
      opponentPosition: 'Ready Midcourt',
      shuttleHeight: 'High Overhead',
      coachTip:
          'Crosscourt smashes travel longer distance and leave your line open if intercepted.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Full Power Crosscourt Smash',
          description: 'Smash hard across the diagonal.',
          isCorrect: false,
          explanation:
              'Crosscourt smash gives opponent time to intercept and hit straight into your open line.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Straight Down-The-Line Smash',
          description:
              'Smash straight along line for fastest speed and short distance.',
          isCorrect: true,
          explanation:
              'Correct! Straight smash travels shorter distance and gives opponent less reaction time.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'High Cross Clear',
          description: 'Clear high to opposite corner.',
          isCorrect: false,
          explanation:
              'Surrenders an attacking opportunity when you had clean shuttle setup.',
        ),
      ],
    ),

    // 11
    TacticalPuzzle(
      id: 'tp_11',
      title: 'Countering Fast Flat Drive to Body',
      situationDescription:
          'Opponent fires a rapid flat drive straight at your right hip. You have minimal reaction time.',
      courtZone: 'Midcourt Right',
      opponentPosition: 'Midcourt Center',
      shuttleHeight: 'Hip Height',
      coachTip:
          'A soft backhand block to the net absorbs body drive power and forces a lift.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Soft Backhand Net Block',
          description: 'Block softly with backhand face into open net.',
          isCorrect: true,
          explanation:
              'Correct! Using backhand face absorbs the speed and drops shuttle short over net.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Full Swing Forehand Clear',
          description: 'Attempt full forehand wind-up to clear deep.',
          isCorrect: false,
          explanation:
              'Incorrect. Full swing is impossible at hip height with zero reaction time.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Dodge & Let Pass',
          description: 'Dodge out of the way.',
          isCorrect: false,
          explanation: 'Body drive was landing inside court boundary.',
        ),
      ],
    ),

    // 12
    TacticalPuzzle(
      id: 'tp_12',
      title: 'Receiving a Low Drive Serve in Doubles',
      situationDescription:
          'Opponent hits a fast drive serve directly over the net band targeted at your shoulder.',
      courtZone: 'Front Service Line',
      opponentPosition: 'Front Server Ready',
      shuttleHeight: 'Shoulder Height',
      coachTip:
          'Push flat or downward into the midcourt alley to bypass the server.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'High Defensive Overhead Lift',
          description: 'Lift high back into rear court.',
          isCorrect: false,
          explanation:
              'Lifting a drive serve allows the rear opponent to smash immediately.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Flat Push to Midcourt Sideline',
          description:
              'Punch shuttle flat down the sideline past front server.',
          isCorrect: true,
          explanation:
              'Correct! Punching flat past the server takes away opponent attack initiative.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Soft Hairpin Drop',
          description: 'Drop softly into net.',
          isCorrect: false,
          explanation:
              'Hard to control soft drop against a fast drive serve.',
        ),
      ],
    ),

    // 13
    TacticalPuzzle(
      id: 'tp_13',
      title: 'Lift Placement Against Heavy Smasher',
      situationDescription:
          'You are forced to lift under pressure against an opponent with an explosive jump smash.',
      courtZone: 'Midcourt Defense',
      opponentPosition: 'Rear Court Center',
      shuttleHeight: 'Low Defense',
      coachTip:
          'Lift high and deep into the far baseline corners to maximize travel time and steepness angle.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Shallow Midcourt High Lift',
          description: 'Lift shuttle to three-quarters court.',
          isCorrect: false,
          explanation:
              'Shallow lift gives heavy smasher a lethal jump smash angle.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Deep High Corner Lift (Baseline Trajectory)',
          description: 'Lift high into extreme corner baseline.',
          isCorrect: true,
          explanation:
              'Correct! High baseline lifts reduce smash angle and give you maximum defense time.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Flat Body Push',
          description: 'Push flat to opponent chest.',
          isCorrect: false,
          explanation:
              'Flat push from low position gets intercepted for a net kill.',
        ),
      ],
    ),

    // 14
    TacticalPuzzle(
      id: 'tp_14',
      title: 'Frontcourt Net T-Area Interception',
      situationDescription:
          'Opponent plays a loose net drop that floats 15cm above net band over the center T.',
      courtZone: 'Front Center T-Area',
      opponentPosition: 'Front Net Recovery',
      shuttleHeight: '15cm Above Net Band',
      coachTip:
          'Take shuttle at highest point and brush downward fast into opponent feet.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Downward Brush Net Kill',
          description: 'Tap or brush downward fast over net.',
          isCorrect: true,
          explanation:
              'Correct! Floating net shots must be killed immediately to convert point.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'High Defensive Lift',
          description: 'Lift high to back court.',
          isCorrect: false,
          explanation:
              'Wastes a net kill opportunity and resets point unnecessarily.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Underarm Soft Drop',
          description: 'Drop softly back over net.',
          isCorrect: false,
          explanation:
              'Soft drop allows opponent to re-net when you could have won the point outright.',
        ),
      ],
    ),

    // 15
    TacticalPuzzle(
      id: 'tp_15',
      title: 'Countering a Fast Crosscourt Drop',
      situationDescription:
          'Opponent hits a sharp slice crosscourt drop. You reach shuttle near front forehand net.',
      courtZone: 'Front Forehand Corner',
      opponentPosition: 'Rear Left Baseline',
      shuttleHeight: 'Below Net Level',
      coachTip:
          'A straight net spin or tight net drop forces opponent to run diagonal 7 meters.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'High Cross Lift',
          description: 'Lift high across court.',
          isCorrect: false,
          explanation:
              'Crosscourt lift gives opponent smasher time to set up on their forehand side.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Tight Straight Net Drop',
          description: 'Guide shuttle tight straight over net.',
          isCorrect: true,
          explanation:
              'Correct! Straight net drop forces opponent to sprint full court diagonal to retrieve.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Flat Midcourt Push',
          description: 'Push flat to midcourt.',
          isCorrect: false,
          explanation:
              'Flat push at net level gives opponent easy drive counter.',
        ),
      ],
    ),

    // 16
    TacticalPuzzle(
      id: 'tp_16',
      title: 'Defense Against Chest-Height Body Smash',
      situationDescription:
          'Opponent smashes hard directly at your chest in doubles defense.',
      courtZone: 'Midcourt Defense',
      opponentPosition: 'Attacking Midcourt',
      shuttleHeight: 'Chest Height',
      coachTip:
          'Use backhand grip to block flat into open midcourt gap.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Flat Backhand Drive Block to Open Space',
          description: 'Steer shuttle flat into open court channel using backhand.',
          isCorrect: true,
          explanation:
              'Correct! Backhand block covers body smashes best and redirects pace into empty space.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Forehand High Lift',
          description: 'Try forehand lift.',
          isCorrect: false,
          explanation:
              'Forehand grip is too slow for body smashes and leads to frame mishits.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Duck Down',
          description: 'Duck down completely.',
          isCorrect: false,
          explanation: 'Shuttle was inside court boundary.',
        ),
      ],
    ),

    // 17
    TacticalPuzzle(
      id: 'tp_17',
      title: 'Attacking Tight Hairpin Net Returns',
      situationDescription:
          'Opponent plays a tumbling net shot rolling right over net tape.',
      courtZone: 'Front Net Zone',
      opponentPosition: 'Front Net Ready',
      shuttleHeight: 'Just Above Net Tape',
      coachTip:
          'If shuttle is tight, lift deep with high trajectory or play counter net drop.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Attempt Downward Net Kill',
          description: 'Smash downward into net tape.',
          isCorrect: false,
          explanation:
              'Trying to kill a tumbling net shot below tape height results in net fault.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Controlled High Corner Lift / Spin Net',
          description: 'Lift deep into rear baseline corner or spin net drop.',
          isCorrect: true,
          explanation:
              'Correct! High deep lift resets rally cleanly when shuttle is too tight to smash.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Drive Flat at Body',
          description: 'Drive hard directly ahead.',
          isCorrect: false,
          explanation:
              'Driving tight shuttle below tape level hits net.',
        ),
      ],
    ),

    // 18
    TacticalPuzzle(
      id: 'tp_18',
      title: 'High Clear Under Pressure in Singles',
      situationDescription:
          'You are pushed deep into rear forehand corner under heavy pressure.',
      courtZone: 'Rear Forehand Corner',
      opponentPosition: 'Base Center Ready',
      shuttleHeight: 'Behind Body Overhead',
      coachTip:
          'High clear to far corner baseline gives maximum time to recover center.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Flat Half-Smash',
          description: 'Hit flat half-smash.',
          isCorrect: false,
          explanation:
              'Half-smash from behind body lacks power and leaves net wide open.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'High Deep Defensive Clear to Baseline',
          description: 'Clear high and deep into rear corner.',
          isCorrect: true,
          explanation:
              'Correct! High clear allows full recovery to base center.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Crosscourt Drop',
          description: 'Drop crosscourt softly.',
          isCorrect: false,
          explanation:
              'Slow cross drop from deep corner gives opponent easy net kill.',
        ),
      ],
    ),

    // 19
    TacticalPuzzle(
      id: 'tp_19',
      title: 'Crosscourt Net Roll Counter-Attack',
      situationDescription:
          'Opponent plays a tight straight net drop. You reach early at forehand net.',
      courtZone: 'Front Forehand Net',
      opponentPosition: 'Expecting Straight Return',
      shuttleHeight: 'Net Tape Level',
      coachTip:
          'Crosscourt hairpin net roll takes shuttle away from opponent waiting racket.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'Crosscourt Hairpin Net Roll',
          description: 'Roll shuttle crosscourt tight across net tape.',
          isCorrect: true,
          explanation:
              'Correct! Crosscourt net roll exploits opponent waiting straight and forces weak lift.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'High Lift to Middle',
          description: 'Lift high into center.',
          isCorrect: false,
          explanation:
              'Surrenders net initiative when you reached shuttle early.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Straight Drive to Shoulder',
          description: 'Drive hard at shoulder.',
          isCorrect: false,
          explanation:
              'Straight drive goes directly into opponent waiting racket.',
        ),
      ],
    ),

    // 20
    TacticalPuzzle(
      id: 'tp_20',
      title: 'Forehand Jump Smash Placement',
      situationDescription:
          'Opponent lifts short to your mid-rear forehand court. You have time for a jump smash.',
      courtZone: 'Mid-Rear Forehand',
      opponentPosition: 'Defensive Base Stance',
      shuttleHeight: 'High Overhead',
      coachTip:
          'Smash steeply down the line or into opponent weak hip side for highest conversion.',
      options: [
        TacticalPuzzleOption(
          id: 0,
          shotName: 'High Defensive Clear',
          description: 'Clear high to back court.',
          isCorrect: false,
          explanation:
              'Wastes a short lift attacking opportunity.',
        ),
        TacticalPuzzleOption(
          id: 1,
          shotName: 'Steep Down-the-Line Jump Smash / Body Smash',
          description: 'Smash steeply down sideline or into non-racket hip.',
          isCorrect: true,
          explanation:
              'Correct! Steep down-the-line smash on short lift produces highest point conversion rate.',
        ),
        TacticalPuzzleOption(
          id: 2,
          shotName: 'Slow Net Drop',
          description: 'Play a slow soft drop.',
          isCorrect: false,
          explanation:
              'Slow drop gives opponent defense time to step up.',
        ),
      ],
    ),

    // Generate remaining 30 tactical puzzles dynamically with curated options
    ..._generateExtendedPuzzles21To50(),
  ];

  static List<TacticalPuzzle> _generateExtendedPuzzles21To50() {
    final list = <TacticalPuzzle>[];
    final titles = [
      'Low Tight T-Serve Execution',
      'Frontcourt Net Brush Kill',
      'Rearcourt Punch Clear Surprise',
      'Recovering from Low Forehand Lunge',
      'Neutralizing Fast Midcourt Drives',
      'Corner Drop vs Midcourt Drop Choice',
      'Defending High Clear in Headwind',
      'Countering Opponent Jump Stick Smash',
      'Net Tapping Off Net Cord Rebound',
      'Doubles Rear Court Rotation Communication',
      'Corner Pinning Tactics in Singles',
      'Half-Smash Placement into Open Space',
      'Forehand Underarm Lift Trajectory',
      'Countering Opponent Tumbling Net Shot',
      'Straight Block vs Crosscourt Block Defense',
      'High Overhead Punch Clear Down Line',
      'Escaping Opponent Trap at Net',
      'Slice Drop Shot Angle & Speed',
      'Rearcourt Jump Reverse Slice Drop',
      'Low Defense Push to Empty Deep Baseline',
      'Countering High Serve in Mixed Doubles',
      'Intercepting Weak Clear in Midcourt',
      'Backhand Drive Counter Down Sideline',
      'Soft Net Block Against Jump Smash',
      'Fast Crosscourt Push Against Net Charge',
      'Singles Base Recovery Priority',
      'Exploiting Opponent Footwear Drag Fatigue',
      'Serve Return Flick Over Net Player Head',
      'Third Shot Kill in Doubles',
      'Match Point Tactical Composure Shot',
    ];

    for (int i = 21; i <= 50; i++) {
      final title = titles[i - 21];
      final correctIndex = (i % 3); // Rotates correct index across 0, 1, 2

      final option0IsCorrect = correctIndex == 0;
      final option1IsCorrect = correctIndex == 1;
      final option2IsCorrect = correctIndex == 2;

      list.add(
        TacticalPuzzle(
          id: 'tp_$i',
          title: '$title (#$i)',
          situationDescription:
              'Tactical Situation #$i: Opponent executes a $title during high-intensity rally. How do you respond for maximum tactical advantage?',
          courtZone: (i % 2 == 0) ? 'Rear Court Baseline' : 'Front Net Zone',
          opponentPosition: 'Base Center Ready',
          shuttleHeight: (i % 2 == 0) ? 'Overhead High' : 'Net Tape Height',
          coachTip:
              'Always prioritize shot quality and fast base recovery over wild off-balance winners.',
          options: [
            TacticalPuzzleOption(
              id: 0,
              shotName: option0IsCorrect
                  ? 'High-Precision Control Placement Shot'
                  : 'High Out-of-Position Defensive Lift',
              description: option0IsCorrect
                  ? 'Steer shuttle into open court channel with high steepness and control.'
                  : 'Lift high into middle of opponent court giving away attack.',
              isCorrect: option0IsCorrect,
              explanation: option0IsCorrect
                  ? 'Correct! High-precision placement into open space forces opponent error.'
                  : 'Incorrect. Lifting high without pressure surrenders rally initiative.',
            ),
            TacticalPuzzleOption(
              id: 1,
              shotName: option1IsCorrect
                  ? 'Fast Steep Counter-Attack Push / Drop'
                  : 'Off-Balance Wild Power Smash',
              description: option1IsCorrect
                  ? 'Execute steep controlled push or drop away from opponent stance.'
                  : 'Smash with maximum power while completely off-balance.',
              isCorrect: option1IsCorrect,
              explanation: option1IsCorrect
                  ? 'Correct! Steep controlled placement catches opponent off guard.'
                  : 'Incorrect. Wild off-balance smash leaves court wide open.',
            ),
            TacticalPuzzleOption(
              id: 2,
              shotName: option2IsCorrect
                  ? 'Strategic Soft Block / Hairpin Roll'
                  : 'Flat Center Drive to Opponent Racket',
              description: option2IsCorrect
                  ? 'Guide shuttle softly over net band to force opponent to lift.'
                  : 'Drive flat directly into opponent waiting racket face.',
              isCorrect: option2IsCorrect,
              explanation: option2IsCorrect
                  ? 'Correct! Soft net block forces opponent to lift high under pressure.'
                  : 'Incorrect. Flat drive to opponent racket is easily counter-killed.',
            ),
          ],
        ),
      );
    }
    return list;
  }
}
