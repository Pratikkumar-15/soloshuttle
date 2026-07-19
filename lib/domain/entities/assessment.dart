class Assessment {
  final String id;
  final DateTime date;
  final String type; // 'Footwork Speed Test', 'Reaction Test', 'Accuracy Test', 'Consistency Test', 'Recovery Test'
  final double score;
  final String unit; // 'sec', 'ms', '%', 'reps'
  final String notes;
  final String ratingLevel; // 'Developing', 'Good', 'Advanced', 'Elite'

  const Assessment({
    required this.id,
    required this.date,
    required this.type,
    required this.score,
    required this.unit,
    required this.notes,
    required this.ratingLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'score': score,
      'unit': unit,
      'notes': notes,
      'ratingLevel': ratingLevel,
    };
  }

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      score: (json['score'] as num).toDouble(),
      unit: json['unit'] as String,
      notes: json['notes'] as String? ?? '',
      ratingLevel: json['ratingLevel'] as String? ?? 'Good',
    );
  }
}
