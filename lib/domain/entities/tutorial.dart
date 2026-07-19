class TutorialSection {
  final String title;
  final String content;

  const TutorialSection({required this.title, required this.content});
}

class Tutorial {
  final String id;
  final String title;
  final String category;
  final String duration;
  final String level; // Beginner, Intermediate, Advanced, Elite
  final String videoUrl;
  final String thumbnail;
  final String summary;
  
  // 14 Required Manual Breakdown Sections
  final String introduction;
  final String objective;
  final String matchApplications;
  final String grip;
  final String readyPosition;
  final String footwork;
  final String bodyPosition;
  final String swingMechanics;
  final String contactPoint;
  final String recovery;
  final List<String> commonMistakes;
  final List<String> coachingTips;
  final List<String> practiceProgression;
  final String progressCheck;

  const Tutorial({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.level,
    required this.videoUrl,
    required this.thumbnail,
    required this.summary,
    required this.introduction,
    required this.objective,
    required this.matchApplications,
    required this.grip,
    required this.readyPosition,
    required this.footwork,
    required this.bodyPosition,
    required this.swingMechanics,
    required this.contactPoint,
    required this.recovery,
    required this.commonMistakes,
    required this.coachingTips,
    required this.practiceProgression,
    required this.progressCheck,
  });
}
