class TacticalPuzzleOption {
  final int id;
  final String shotName;
  final String description;
  final bool isCorrect;
  final String explanation;

  const TacticalPuzzleOption({
    required this.id,
    required this.shotName,
    required this.description,
    required this.isCorrect,
    required this.explanation,
  });
}

class TacticalPuzzle {
  final String id;
  final String title;
  final String situationDescription;
  final String courtZone; // 'Rear Court', 'Net Zone', 'Midcourt'
  final String opponentPosition;
  final String shuttleHeight;
  final List<TacticalPuzzleOption> options;
  final String coachTip;

  const TacticalPuzzle({
    required this.id,
    required this.title,
    required this.situationDescription,
    required this.courtZone,
    required this.opponentPosition,
    required this.shuttleHeight,
    required this.options,
    required this.coachTip,
  });
}
