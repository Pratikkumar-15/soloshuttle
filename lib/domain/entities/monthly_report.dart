class MonthlyReport {
  final String id;
  final DateTime month;
  final int totalSessions;
  final int totalMinutes;
  final int xpEarned;
  final String mostTrainedCategory;
  final Map<String, int> sessionsByCategory;

  const MonthlyReport({
    required this.id,
    required this.month,
    required this.totalSessions,
    required this.totalMinutes,
    required this.xpEarned,
    required this.mostTrainedCategory,
    required this.sessionsByCategory,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'month': month.toIso8601String(),
      'totalSessions': totalSessions,
      'totalMinutes': totalMinutes,
      'xpEarned': xpEarned,
      'mostTrainedCategory': mostTrainedCategory,
      'sessionsByCategory': sessionsByCategory,
    };
  }

  factory MonthlyReport.fromJson(Map<String, dynamic> json) {
    return MonthlyReport(
      id: json['id'] as String,
      month: DateTime.parse(json['month'] as String),
      totalSessions: json['totalSessions'] as int,
      totalMinutes: json['totalMinutes'] as int,
      xpEarned: json['xpEarned'] as int,
      mostTrainedCategory: json['mostTrainedCategory'] as String,
      sessionsByCategory: Map<String, int>.from(json['sessionsByCategory'] ?? {}),
    );
  }
}
