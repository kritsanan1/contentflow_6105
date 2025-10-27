class SocialMediaPost {
  final String id;
  final String title;
  final String content;
  final String platform;
  final DateTime scheduledDate;
  final String status;
  final String? imageUrl;
  final bool aiOptimized;
  final Map<String, dynamic>? platformData;
  final Map<String, dynamic>? analytics;

  SocialMediaPost({
    required this.id,
    required this.title,
    required this.content,
    required this.platform,
    required this.scheduledDate,
    required this.status,
    this.imageUrl,
    this.aiOptimized = false,
    this.platformData,
    this.analytics,
  });

  factory SocialMediaPost.fromJson(Map<String, dynamic> json) {
    return SocialMediaPost(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'] as String)
          : DateTime.now(),
      status: json['status'] as String? ?? 'draft',
      imageUrl: json['imageUrl'] as String?,
      aiOptimized: json['aiOptimized'] as bool? ?? false,
      platformData: json['platformData'] as Map<String, dynamic>?,
      analytics: json['analytics'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'platform': platform,
      'scheduledDate': scheduledDate.toIso8601String(),
      'status': status,
      'imageUrl': imageUrl,
      'aiOptimized': aiOptimized,
      'platformData': platformData,
      'analytics': analytics,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'platform': platform,
      'scheduledDate': scheduledDate,
      'status': status,
      'imageUrl': imageUrl,
      'aiOptimized': aiOptimized,
    };
  }
}
