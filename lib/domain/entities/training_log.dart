class TrainingLog {
  final String id;
  final String title;
  final String duration;
  final int xpEarned;
  final DateTime date;
  final String category;

  const TrainingLog({
    required this.id,
    required this.title,
    required this.duration,
    required this.xpEarned,
    required this.date,
    this.category = 'Footwork',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'xpEarned': xpEarned,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  factory TrainingLog.fromJson(Map<String, dynamic> json) {
    return TrainingLog(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: json['duration'] as String,
      xpEarned: json['xpEarned'] as int,
      date: DateTime.parse(json['date'] as String),
      category: (json['category'] as String?) ?? 'Footwork',
    );
  }
}
