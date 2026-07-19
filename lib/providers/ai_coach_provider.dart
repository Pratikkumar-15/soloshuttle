import 'package:flutter/foundation.dart';
import '../domain/entities/user_profile.dart';
import '../domain/entities/training_log.dart';

class AiCoachInsight {
  final String greeting;
  final String briefing;
  final String focusTip;
  final String weaknessWarning;
  final String strengthBadge;
  final String recommendedDrillTitle;
  final String recommendedDrillCategory;

  const AiCoachInsight({
    required this.greeting,
    required this.briefing,
    required this.focusTip,
    required this.weaknessWarning,
    required this.strengthBadge,
    required this.recommendedDrillTitle,
    required this.recommendedDrillCategory,
  });
}

class AiCoachProvider extends ChangeNotifier {
  AiCoachInsight generateInsight(UserProfile user, List<TrainingLog> logs) {
    final name = user.name.isNotEmpty ? user.name : 'Athlete';
    final stage = user.calculatedJourneyStage;

    String greeting = 'Coach Guidance • Level ${user.level} $stage';
    String briefing;
    String focusTip;
    String weaknessWarning;
    String strengthBadge;
    String recTitle;
    String recCategory;

    final recentCount = logs.length;
    if (recentCount == 0) {
      briefing = 'Welcome to SoloShuttle, $name! As your BWF Level 3 AI Coach, my priority is building your footwork foundation before increasing speed or power. Always remember: Quality before quantity.';
      focusTip = 'Keep your racket head up and maintain a relaxed forehand grip during the ready position.';
      weaknessWarning = 'No training logged yet. Start with Front Court Footwork to build early base recovery.';
      strengthBadge = 'Fresh start! Your potential for quick technique mastery is highest today.';
      recTitle = 'Front Court Footwork Mastery';
      recCategory = 'Footwork';
    } else {
      final strongest = user.strongestSkill;
      final weakest = user.weakestSkill;

      briefing = 'Great work completing $recentCount sessions, $name! Your $strongest rating is strong. However, your $weakest score indicates an opportunity for high-yield improvement this week.';
      focusTip = 'Execute the split step just before your opponent strikes the shuttle to accelerate your first step.';
      weaknessWarning = 'Attention: Your $weakest performance score is below target. Practice dedicated drills to restore balance across all 6 pillars.';
      strengthBadge = 'Top Performance: Your $strongest level leads your athlete profile! Keep executing clean repetitions.';
      recTitle = weakest == 'Footwork' ? 'Six Corner Full Court Agility' : 'Wall Practice Drive Exchanges';
      recCategory = weakest == 'Footwork' ? 'Footwork' : 'Solo Drills';
    }

    return AiCoachInsight(
      greeting: greeting,
      briefing: briefing,
      focusTip: focusTip,
      weaknessWarning: weaknessWarning,
      strengthBadge: strengthBadge,
      recommendedDrillTitle: recTitle,
      recommendedDrillCategory: recCategory,
    );
  }

  String generatePostSessionFeedback({
    required String drillTitle,
    required int durationMinutes,
    required int xpEarned,
    required int qualityStars,
  }) {
    if (qualityStars >= 4) {
      return 'Outstanding movement quality on $drillTitle! You maintained a low center of gravity, relaxed grip, and smooth recovery back to base. Earned +$xpEarned XP.';
    } else if (qualityStars == 3) {
      return 'Solid effort on $drillTitle! Your footwork speed was consistent, but make sure to execute the split step earlier to reach the shuttle at maximum height. Earned +$xpEarned XP.';
    } else {
      return 'Good commitment finishing $drillTitle under fatigue! Focus on technique before speed on your next session—relaxed muscles allow faster acceleration. Earned +$xpEarned XP.';
    }
  }

  List<String> getSmartNotificationAlerts(UserProfile user) {
    final alerts = <String>[];
    if (user.currentStreak == 0) {
      alerts.add('👟 Your training streak needs activation today! 10 minutes of footwork is all it takes.');
    } else {
      alerts.add('🔥 Great job maintaining a ${user.currentStreak}-day training streak! Keep up the momentum.');
    }
    alerts.add('📊 Coach Insight: Your ${user.weakestSkill} pillar needs a 15-minute tune up today.');
    alerts.add('🏆 Achievement Alert: You are on path to reach stage "${user.calculatedJourneyStage}".');
    alerts.add('🧘 Recovery Reminder: Remember to complete 5 minutes of static stretching post-training.');
    return alerts;
  }
}
