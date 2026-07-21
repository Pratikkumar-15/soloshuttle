enum PhaseType {
  explanation,
  work,
  rest,
  coachCue,
  finalChallenge,
}

class DrillPhase {
  final String title;
  final String description;
  final int durationSeconds;
  final PhaseType type;
  final String? coachTip;
  final String? objective;
  final String? instructions;
  final String? coachFocus;
  final String? commonMistake;

  const DrillPhase({
    required this.title,
    required this.description,
    required this.durationSeconds,
    required this.type,
    this.coachTip,
    this.objective,
    this.instructions,
    this.coachFocus,
    this.commonMistake,
  });

  String get formattedDuration {
    if (durationSeconds < 60) {
      return '$durationSeconds sec';
    }
    final mins = durationSeconds ~/ 60;
    final secs = durationSeconds % 60;
    if (secs == 0) {
      return '$mins min';
    }
    return '$mins min $secs sec';
  }

  String get displayObjective => (objective != null && objective!.isNotEmpty) ? objective! : description;
  String get displayInstructions => (instructions != null && instructions!.isNotEmpty) ? instructions! : description;
  String get displayCoachFocus => (coachFocus != null && coachFocus!.isNotEmpty)
      ? coachFocus!
      : (coachTip != null && coachTip!.isNotEmpty)
          ? coachTip!
          : 'Maintain correct balance and smooth movement rhythm.';
  String? get displayCommonMistake => (commonMistake != null && commonMistake!.isNotEmpty) ? commonMistake : null;
}

class Drill {
  final String id;
  final String title;
  final String description;
  final String objective;
  final String duration;
  final int durationSeconds;
  final String difficulty; // 'Beginner', 'Intermediate', 'Advanced'
  final int xpReward;
  final String categoryId;
  final String categoryName;
  final String emoji;
  final List<String> instructions;
  final String coachCue;
  final List<String> commonMistakes;
  final List<String> skillsImproved;
  final List<String> equipmentRequired;
  final List<String> safetyReminders;
  final List<String> coachingTips;
  final List<DrillPhase> phases;
  final bool isFavorite;
  final String recommendedSpace;
  final String energyLevel;
  final String? aiBriefing;
  final List<String> performanceTargets;
  final String? motivationQuote;
  final String progression;
  final String completionCriteria;

  const Drill({
    required this.id,
    required this.title,
    required this.description,
    required this.objective,
    required this.duration,
    required this.durationSeconds,
    required this.difficulty,
    required this.xpReward,
    required this.categoryId,
    required this.categoryName,
    this.emoji = '🏸',
    this.instructions = const [],
    this.coachCue = '',
    this.commonMistakes = const [],
    this.skillsImproved = const [],
    this.equipmentRequired = const [],
    this.safetyReminders = const [],
    this.coachingTips = const [],
    this.phases = const [],
    this.isFavorite = false,
    this.recommendedSpace = 'Standard Half-Court (4m x 4m)',
    this.energyLevel = 'High Intensity',
    this.aiBriefing,
    this.performanceTargets = const [],
    this.motivationQuote,
    this.progression = '',
    this.completionCriteria = '',
  });

  int get totalRoundsCount {
    final activeRounds = phases.where((p) => p.type == PhaseType.work || p.type == PhaseType.finalChallenge || p.type == PhaseType.explanation).length;
    return activeRounds > 0 ? activeRounds : 3;
  }

  String get computedRecommendedSpace {
    if (recommendedSpace.isNotEmpty && recommendedSpace != 'Standard Half-Court (4m x 4m)') {
      return recommendedSpace;
    }
    if (categoryId == 'cat_solo' && id == 'sd_wall') {
      return 'Smooth Wall Space (3m x 3m)';
    }
    return 'Standard Court Space (4m x 4m)';
  }

  String get computedEnergyLevel {
    if (energyLevel.isNotEmpty && energyLevel != 'High Intensity') {
      return energyLevel;
    }
    switch (difficulty) {
      case 'Advanced':
        return '🔥 Maximum Explosive';
      case 'Intermediate':
        return '⚡ High Intensity';
      default:
        return '💪 Moderate Energy';
    }
  }

  String get computedAiBriefing {
    if (aiBriefing != null && aiBriefing!.isNotEmpty) {
      return aiBriefing!;
    }
    final coachHint = coachCue.isNotEmpty ? coachCue : 'Maintain proper balance throughout every round.';
    return 'Today we\'ll focus on $title to execute $objective. $coachHint During later rounds, prioritize explosive speed without sacrificing movement technique.';
  }

  List<String> get computedPerformanceTargets {
    if (performanceTargets.isNotEmpty) {
      return performanceTargets;
    }
    return const [
      'Complete all workout rounds',
      'Maintain correct posture & movement technique',
      'React within 1 second of audio command',
      'Finish with good base recovery balance',
    ];
  }

  String get computedMotivationQuote {
    if (motivationQuote != null && motivationQuote!.isNotEmpty) {
      return motivationQuote!;
    }
    return 'Consistency builds champions. Focus on quality movement rather than speed. Every repetition improves your game.';
  }

  List<String> get effectiveCoachingTips {
    final combined = List<String>.from(coachingTips);
    if (coachCue.isNotEmpty && !combined.contains(coachCue)) {
      combined.insert(0, coachCue);
    }
    if (combined.length < 3) {
      final defaults = [
        'Stay on the balls of your feet with knees flexed.',
        'Keep your racket in the ready position at chest height.',
        'Recover to the center base after every movement.',
        'Focus on smooth movement rhythm before increasing speed.',
      ];
      for (final tip in defaults) {
        if (!combined.contains(tip) && combined.length < 4) {
          combined.add(tip);
        }
      }
    }
    return combined;
  }

  List<String> get effectiveCommonMistakes {
    final combined = List<String>.from(commonMistakes);
    if (combined.length < 3) {
      final defaults = [
        'Crossing your feet unnecessarily during lateral movement.',
        'Leaning too far forward off-balance.',
        'Standing upright immediately after lunging.',
        'Returning slowly to center base.',
      ];
      for (final mistake in defaults) {
        if (!combined.contains(mistake) && combined.length < 4) {
          combined.add(mistake);
        }
      }
    }
    return combined;
  }

  List<String> get effectiveEquipment {
    if (equipmentRequired.isNotEmpty) return equipmentRequired;
    return const ['Badminton Racket', 'Non-marking Court Shoes'];
  }

  List<String> get shortFocusCues {
    final List<String> list = [];
    if (coachCue.isNotEmpty) {
      final parts = coachCue.split(RegExp(r'[\.\!\?]\s*'));
      for (final p in parts) {
        final trimmed = p.trim();
        if (trimmed.isNotEmpty && trimmed.length <= 35) {
          list.add(trimmed.endsWith('.') ? trimmed : '$trimmed.');
        }
      }
    }
    for (final tip in coachingTips) {
      if (list.length >= 2) break;
      final trimmed = tip.trim();
      if (trimmed.isNotEmpty && trimmed.length <= 35 && !list.contains(trimmed)) {
        list.add(trimmed.endsWith('.') ? trimmed : '$trimmed.');
      }
    }
    if (list.isEmpty) {
      list.addAll(const ['Stay low.', 'Explode to the corner.']);
    }
    return list.take(2).toList();
  }

  List<String> get shortMistakesToAvoid {
    final List<String> list = [];
    for (final m in commonMistakes) {
      final trimmed = m.trim();
      if (trimmed.isNotEmpty && trimmed.length <= 35) {
        list.add(trimmed.endsWith('.') ? trimmed : '$trimmed.');
      }
    }
    if (list.isEmpty) {
      list.addAll(const ["Don't cross your feet.", "Don't stand upright."]);
    }
    return list.take(2).toList();
  }

  List<DrillPhase> getPhasesForDifficulty(String targetDifficulty) {
    if (phases.isEmpty) {
      int workSec = 45;
      int restSec = 20;
      int chalSec = 60;
      if (targetDifficulty == 'Beginner') {
        workSec = 30;
        restSec = 30;
        chalSec = 45;
      } else if (targetDifficulty == 'Advanced') {
        workSec = 60;
        restSec = 15;
        chalSec = 90;
      }

      return [
        const DrillPhase(
          title: 'Round 1 — Warm-up Footwork',
          description: 'Move to all corners with controlled speed maintaining balance.',
          durationSeconds: 45,
          type: PhaseType.work,
          objective: 'Build movement rhythm.',
          instructions: 'Execute light steps towards target zones and return softly to center base.',
          coachFocus: 'Maintain balance and posture throughout.',
          commonMistake: 'Standing tall on arrival at base.',
        ),
        DrillPhase(
          title: 'Rest Interval',
          description: 'Catch your breath and prepare for Round 2.',
          durationSeconds: restSec,
          type: PhaseType.rest,
        ),
        DrillPhase(
          title: 'Round 2 — Speed Training',
          description: 'Increase movement speed to every corner.',
          durationSeconds: workSec,
          type: PhaseType.work,
          objective: 'Accelerate first-step explosive drive.',
          instructions: 'Explode to every corner on cue and push back violently.',
          coachFocus: 'Quick recovery push-off lead foot.',
          commonMistake: 'Crossing feet unnecessarily.',
        ),
        DrillPhase(
          title: 'Rest Interval',
          description: 'Deep breathing reset before challenge round.',
          durationSeconds: restSec,
          type: PhaseType.rest,
        ),
        DrillPhase(
          title: 'Round 3 — Match Simulation',
          description: 'Combine speed with technical control.',
          durationSeconds: chalSec,
          type: PhaseType.finalChallenge,
          objective: 'Sustain technical form under fatigue.',
          instructions: 'Move continuously following voice commands.',
          coachFocus: 'Stay balanced while changing direction.',
          commonMistake: 'Leaning forward at the waist.',
        ),
      ];
    }

    return phases.map((phase) {
      if (phase.type == PhaseType.work) {
        int dur = 45;
        if (targetDifficulty == 'Beginner') dur = 30;
        if (targetDifficulty == 'Advanced') dur = 60;
        return DrillPhase(
          title: phase.title,
          description: phase.description,
          durationSeconds: dur,
          type: phase.type,
          coachTip: phase.coachTip,
          objective: phase.objective,
          instructions: phase.instructions,
          coachFocus: phase.coachFocus,
          commonMistake: phase.commonMistake,
        );
      } else if (phase.type == PhaseType.rest) {
        int dur = 20;
        if (targetDifficulty == 'Beginner') dur = 30;
        if (targetDifficulty == 'Advanced') dur = 15;
        return DrillPhase(
          title: phase.title,
          description: phase.description,
          durationSeconds: dur,
          type: phase.type,
          coachTip: phase.coachTip,
          objective: phase.objective,
          instructions: phase.instructions,
          coachFocus: phase.coachFocus,
          commonMistake: phase.commonMistake,
        );
      } else if (phase.type == PhaseType.finalChallenge) {
        int dur = 60;
        if (targetDifficulty == 'Beginner') dur = 45;
        if (targetDifficulty == 'Advanced') dur = 90;
        return DrillPhase(
          title: phase.title,
          description: phase.description,
          durationSeconds: dur,
          type: phase.type,
          coachTip: phase.coachTip,
          objective: phase.objective,
          instructions: phase.instructions,
          coachFocus: phase.coachFocus,
          commonMistake: phase.commonMistake,
        );
      }
      return phase;
    }).toList();
  }

  Drill getAdjustedDrillForDifficulty(String targetDifficulty) {
    final newPhases = getPhasesForDifficulty(targetDifficulty);
    final totalSecs = newPhases.fold<int>(0, (sum, p) => sum + p.durationSeconds);
    final mins = (totalSecs / 60).ceil();

    int xp = xpReward;
    if (targetDifficulty == 'Beginner') {
      xp = (xpReward * 0.8).round();
    } else if (targetDifficulty == 'Advanced') {
      xp = (xpReward * 1.25).round();
    }

    return copyWith(
      difficulty: targetDifficulty,
      phases: newPhases,
      durationSeconds: totalSecs,
      duration: '$mins min',
      xpReward: xp,
      energyLevel: targetDifficulty == 'Advanced'
          ? '🔥 Maximum Explosive'
          : targetDifficulty == 'Intermediate'
              ? '⚡ High Intensity'
              : '💪 Moderate Energy',
    );
  }

  Drill copyWith({
    String? id,
    String? title,
    String? description,
    String? objective,
    String? duration,
    int? durationSeconds,
    String? difficulty,
    int? xpReward,
    String? categoryId,
    String? categoryName,
    String? emoji,
    List<String>? instructions,
    String? coachCue,
    List<String>? commonMistakes,
    List<String>? skillsImproved,
    List<String>? equipmentRequired,
    List<String>? safetyReminders,
    List<String>? coachingTips,
    List<DrillPhase>? phases,
    bool? isFavorite,
    String? recommendedSpace,
    String? energyLevel,
    String? aiBriefing,
    List<String>? performanceTargets,
    String? motivationQuote,
    String? progression,
    String? completionCriteria,
  }) {
    return Drill(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      objective: objective ?? this.objective,
      duration: duration ?? this.duration,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      difficulty: difficulty ?? this.difficulty,
      xpReward: xpReward ?? this.xpReward,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      emoji: emoji ?? this.emoji,
      instructions: instructions ?? this.instructions,
      coachCue: coachCue ?? this.coachCue,
      commonMistakes: commonMistakes ?? this.commonMistakes,
      skillsImproved: skillsImproved ?? this.skillsImproved,
      equipmentRequired: equipmentRequired ?? this.equipmentRequired,
      safetyReminders: safetyReminders ?? this.safetyReminders,
      coachingTips: coachingTips ?? this.coachingTips,
      phases: phases ?? this.phases,
      isFavorite: isFavorite ?? this.isFavorite,
      recommendedSpace: recommendedSpace ?? this.recommendedSpace,
      energyLevel: energyLevel ?? this.energyLevel,
      aiBriefing: aiBriefing ?? this.aiBriefing,
      performanceTargets: performanceTargets ?? this.performanceTargets,
      motivationQuote: motivationQuote ?? this.motivationQuote,
      progression: progression ?? this.progression,
      completionCriteria: completionCriteria ?? this.completionCriteria,
    );
  }
}

