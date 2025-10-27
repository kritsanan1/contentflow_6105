class AnalyticsData {
  final String platform;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> metrics;
  final Map<String, dynamic> demographics;
  final List<Map<String, dynamic>> topPosts;
  final Map<String, dynamic> engagement;

  AnalyticsData({
    required this.platform,
    required this.startDate,
    required this.endDate,
    required this.metrics,
    required this.demographics,
    required this.topPosts,
    required this.engagement,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      platform: json['platform'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      metrics: json['metrics'] as Map<String, dynamic>? ?? {},
      demographics: json['demographics'] as Map<String, dynamic>? ?? {},
      topPosts: (json['topPosts'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>() ??
          [],
      engagement: json['engagement'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'metrics': metrics,
      'demographics': demographics,
      'topPosts': topPosts,
      'engagement': engagement,
    };
  }
}
