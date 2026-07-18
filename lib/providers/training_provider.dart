import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/drill.dart';
import '../domain/entities/drill_category.dart';
import '../domain/entities/training_log.dart';

class TrainingProvider extends ChangeNotifier {
  List<Drill> _drills = [];
  List<DrillCategory> _categories = [];
  List<TrainingLog> _recentLogs = [];
  bool _dailyChallengeCompleted = false;

  List<Drill> get drills => _drills;
  List<DrillCategory> get categories => _categories;
  List<TrainingLog> get recentLogs => _recentLogs;
  bool get dailyChallengeCompleted => _dailyChallengeCompleted;

  List<Drill> get favoriteDrills => _drills.where((d) => d.isFavorite).toList();

  List<Drill> get footworkDrills => _drills.where((d) => d.categoryId == 'cat_footwork' || d.categoryId == 'cat_shadow').toList();
  List<Drill> get soloDrills => _drills.where((d) => d.categoryId != 'cat_footwork').toList();

  TrainingProvider() {
    _initializeData();
    _loadLogs();
  }

  void _initializeData() {
    _categories = const [
      DrillCategory(
        id: 'cat_footwork',
        emoji: '👣',
        title: 'Footwork Drills',
        subtitle: 'Court Coverage & Recovery',
        drillsCount: '6 Drills',
      ),
      DrillCategory(
        id: 'cat_solo',
        emoji: '🏸',
        title: 'Solo Drills',
        subtitle: 'Stroke & Wall Practice',
        drillsCount: '6 Drills',
      ),
      DrillCategory(
        id: 'cat_reaction',
        emoji: '⚡',
        title: 'Reaction Training',
        subtitle: 'Direction & Color Cues',
        drillsCount: '4 Modes',
      ),
    ];

    _drills = const [
      // === FOOTWORK DRILLS ===
      Drill(
        id: 'fw_front_court',
        title: 'Front Court Footwork',
        description: 'Practice fast forward steps, net lunges, and recovery back to base.',
        objective: 'Reach drop shots early at the net and push back quickly to center base.',
        duration: '10 min',
        durationSeconds: 600,
        difficulty: 'Beginner',
        xpReward: 60,
        categoryId: 'cat_footwork',
        categoryName: 'Footwork',
        emoji: '👣',
        coachCue: 'Keep your center of gravity low and land soft on your front lunge leg.',
        instructions: [
          'Start in center base position with soft knees.',
          'Take quick chasse steps forward to net left or net right.',
          'Execute simulated net drop, then push back off front leg to center.',
        ],
        commonMistakes: ['Standing too tall on recovery.', 'Jumping into lunge.'],
        isFavorite: true,
      ),
      Drill(
        id: 'fw_rear_court',
        title: 'Rear Court Footwork',
        description: 'Master backpedal movement, scissor kicks, and recovery forward.',
        objective: 'Travel rapidly to the backline and return forward without losing balance.',
        duration: '12 min',
        durationSeconds: 720,
        difficulty: 'Intermediate',
        xpReward: 75,
        categoryId: 'cat_footwork',
        categoryName: 'Footwork',
        emoji: '👣',
        coachCue: 'Turn your hips sideways before moving backwards.',
        instructions: [
          'Turn body 90 degrees as shuttle moves back.',
          'Use chasse or running backpedal steps to rear corner.',
          'Execute scissor kick, landing on front leg to propel back to base.',
        ],
        commonMistakes: ['Backpedaling facing forward.', 'Flat-footed landing.'],
      ),
      Drill(
        id: 'fw_four_corner',
        title: 'Four Corner Footwork',
        description: 'Rhythmic movement routine covering all 4 outer court corners.',
        objective: 'Build endurance and smooth footwork transitions across net and rear corners.',
        duration: '15 min',
        durationSeconds: 900,
        difficulty: 'Intermediate',
        xpReward: 90,
        categoryId: 'cat_footwork',
        categoryName: 'Footwork',
        emoji: '👣',
        coachCue: 'Maintain steady pace and touch base center between every corner.',
        instructions: [
          'Move Front Left -> Base -> Front Right -> Base.',
          'Move Rear Right -> Base -> Rear Left -> Base.',
          'Repeat continuously for 3 full sets.',
        ],
        isFavorite: true,
      ),
      Drill(
        id: 'fw_six_corner',
        title: 'Six Corner Footwork',
        description: 'Complete court coverage including front, mid-court drives, and rear corners.',
        objective: 'Develop complete court agility and instinctive 360-degree footwork recovery.',
        duration: '20 min',
        durationSeconds: 1200,
        difficulty: 'Advanced',
        xpReward: 120,
        categoryId: 'cat_footwork',
        categoryName: 'Footwork',
        emoji: '👣',
        coachCue: 'Stay low so your first step in any direction is explosive.',
        instructions: [
          'Cover Net Left, Net Right, Mid Left, Mid Right, Rear Left, Rear Right.',
          'Recover to base center after touching each target corner.',
        ],
        isFavorite: true,
      ),
      Drill(
        id: 'fw_recovery',
        title: 'Recovery Footwork',
        description: 'Focus exclusively on the return step to base after maximum reach lunges.',
        objective: 'Shorten recovery time from deep lunges to prepare for the opponent return.',
        duration: '10 min',
        durationSeconds: 600,
        difficulty: 'Intermediate',
        xpReward: 70,
        categoryId: 'cat_footwork',
        categoryName: 'Footwork',
        emoji: '👣',
        coachCue: 'Push hard off your lead foot immediately after stroke contact.',
        instructions: [
          'Step into maximum reach front lunge.',
          'Push violently back using quad and hip muscles to reach base.',
        ],
      ),
      Drill(
        id: 'fw_split_step',
        title: 'Split Step Practice',
        description: 'Practice pre-hop timing and explosive direction changes.',
        objective: 'Sync your split-step pre-hop with opponent contact for instant reaction.',
        duration: '8 min',
        durationSeconds: 480,
        difficulty: 'Beginner',
        xpReward: 50,
        categoryId: 'cat_footwork',
        categoryName: 'Footwork',
        emoji: '👣',
        coachCue: 'Keep knees soft and feet wider than shoulder width.',
        instructions: [
          'Perform small pre-hop in base position.',
          'React instantly right upon landing.',
        ],
      ),

      // === SOLO DRILLS ===
      Drill(
        id: 'sd_shadow',
        title: 'Shadow Drill Routine',
        description: 'Simulate a full match rally without shuttles focusing on stroke form.',
        objective: 'Combine footwork and stroke mechanics in continuous rally simulation.',
        duration: '15 min',
        durationSeconds: 900,
        difficulty: 'Intermediate',
        xpReward: 85,
        categoryId: 'cat_solo',
        categoryName: 'Solo Drills',
        emoji: '🏸',
        coachCue: 'Visualize the shuttle trajectory on every shadow stroke.',
        instructions: [
          'Simulate serve -> move back -> shadow clear -> move forward -> shadow net drop.',
        ],
        isFavorite: true,
      ),
      Drill(
        id: 'sd_smash',
        title: 'Smash Repetition Drill',
        description: 'High-intensity jump smash motion and explosive recovery.',
        objective: 'Maximize smash steepness, wrist snap power, and quick recovery.',
        duration: '15 min',
        durationSeconds: 900,
        difficulty: 'Advanced',
        xpReward: 100,
        categoryId: 'cat_solo',
        categoryName: 'Solo Drills',
        emoji: '💥',
        coachCue: 'Contact shuttle in front of body at peak jump height.',
        instructions: [
          'Move to rear court, jump, snap wrist down hard, land and sprint to base.',
        ],
        isFavorite: true,
      ),
      Drill(
        id: 'sd_wall',
        title: 'Wall Practice Drives',
        description: 'Rapid drive exchanges off a smooth wall to build wrist reaction.',
        objective: 'Develop lightning-fast wrist recoil and defense reaction speed.',
        duration: '10 min',
        durationSeconds: 600,
        difficulty: 'Intermediate',
        xpReward: 75,
        categoryId: 'cat_solo',
        categoryName: 'Solo Drills',
        emoji: '🧱',
        coachCue: 'Tighten grip on impact and keep backswing minimal.',
        instructions: [
          'Stand 2 meters from wall and rally continuous forehand & backhand flat drives.',
        ],
        isFavorite: true,
      ),
      Drill(
        id: 'sd_serve',
        title: 'Serve Precision Target',
        description: 'Practice low serve skimming tape and high flick serve depth.',
        objective: 'Achieve 90%+ serve placement consistency on the service T-line.',
        duration: '12 min',
        durationSeconds: 720,
        difficulty: 'Beginner',
        xpReward: 60,
        categoryId: 'cat_solo',
        categoryName: 'Solo Drills',
        emoji: '🎯',
        coachCue: 'Push smoothly with thumb without jerky wrist movement.',
        instructions: [
          'Set target marker on T-line. Practice 20 low serves and 10 flick serves.',
        ],
      ),
      Drill(
        id: 'sd_net',
        title: 'Net Play & Tumbling Drop',
        description: 'Fine-tune delicate net touches, spins, and net kills.',
        objective: 'Master tight net tumbling spins that force opponent lifts.',
        duration: '10 min',
        durationSeconds: 600,
        difficulty: 'Advanced',
        xpReward: 80,
        categoryId: 'cat_solo',
        categoryName: 'Solo Drills',
        emoji: '🕸️',
        coachCue: 'Soft hands and loose grip control the net tape.',
        instructions: [
          'Lunge to net tape, slice across shuttle cork face, recover to base.',
        ],
      ),
      Drill(
        id: 'sd_clear',
        title: 'Clear & Lob Practice',
        description: 'Deep high clear strokes to send opponents to back court.',
        objective: 'Generate full court length depth on forehand and backhand clears.',
        duration: '12 min',
        durationSeconds: 720,
        difficulty: 'Intermediate',
        xpReward: 70,
        categoryId: 'cat_solo',
        categoryName: 'Solo Drills',
        emoji: '🏹',
        coachCue: 'Extend arm fully at highest reach point.',
        instructions: [
          'Shadow high overhead clears sending shuttle to backline boundary.',
        ],
      ),
    ];
  }

  Future<void> _loadLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logsString = prefs.getString('training_logs');
      if (logsString != null) {
        final List<dynamic> jsonList = jsonDecode(logsString);
        _recentLogs = jsonList.map((j) => TrainingLog.fromJson(j)).toList();
      } else {
        _recentLogs = [
          TrainingLog(
            id: 'log1',
            title: 'Six Corner Footwork',
            duration: '20 min',
            xpEarned: 120,
            date: DateTime.now().subtract(const Duration(hours: 4)),
            category: 'Footwork',
          ),
          TrainingLog(
            id: 'log2',
            title: 'Smash Repetition Drill',
            duration: '15 min',
            xpEarned: 100,
            date: DateTime.now().subtract(const Duration(days: 1)),
            category: 'Solo Drills',
          ),
        ];
      }
    } catch (e) {
      debugPrint('Failed to load training logs: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> logCompletedTraining({
    required String title,
    required String duration,
    required int xpEarned,
    String category = 'Footwork',
  }) async {
    final newLog = TrainingLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      duration: duration,
      xpEarned: xpEarned,
      date: DateTime.now(),
      category: category,
    );

    _recentLogs.insert(0, newLog);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _recentLogs.map((l) => l.toJson()).toList();
      await prefs.setString('training_logs', jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Failed to save log: $e');
    }
  }

  void toggleFavorite(String drillId) {
    final index = _drills.indexWhere((d) => d.id == drillId);
    if (index != -1) {
      final current = _drills[index];
      _drills[index] = current.copyWith(isFavorite: !current.isFavorite);
      notifyListeners();
    }
  }

  void completeDailyChallenge() {
    _dailyChallengeCompleted = true;
    notifyListeners();
  }
}
