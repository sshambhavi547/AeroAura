class HydrationEntry {
  final String? id;
  final int amount;
  final String note;
  final String date;
  final DateTime timestamp;

  HydrationEntry({
    this.id,
    required this.amount,
    required this.note,
    required this.date,
    required this.timestamp,
  });

  factory HydrationEntry.fromJson(Map<String, dynamic> json) {
    return HydrationEntry(
      id: json['_id'] as String?,
      amount: (json['amount'] as num).toInt(),
      note: json['note'] as String? ?? '',
      date: json['date'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class DailyAnalytics {
  final String date;
  final int total;
  final int count;

  DailyAnalytics({
    required this.date,
    required this.total,
    required this.count,
  });

  factory DailyAnalytics.fromJson(Map<String, dynamic> json) {
    return DailyAnalytics(
      date: json['date'] as String,
      total: (json['total'] as num).toInt(),
      count: (json['count'] as num).toInt(),
    );
  }
}

class WeeklyData {
  final List<DailyAnalytics> analytics;
  final int totalWeekly;
  final int avgDaily;

  WeeklyData({
    required this.analytics,
    required this.totalWeekly,
    required this.avgDaily,
  });
}