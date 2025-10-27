class SocialMediaMessage {
  final String id;
  final String platform;
  final String senderName;
  final String messageText;
  final DateTime timestamp;
  final bool isUnread;
  final String? avatarUrl;
  final String? senderId;
  final Map<String, dynamic>? metadata;

  SocialMediaMessage({
    required this.id,
    required this.platform,
    required this.senderName,
    required this.messageText,
    required this.timestamp,
    required this.isUnread,
    this.avatarUrl,
    this.senderId,
    this.metadata,
  });

  factory SocialMediaMessage.fromJson(Map<String, dynamic> json) {
    return SocialMediaMessage(
      id: json['id'] as String,
      platform: json['platform'] as String,
      senderName: json['senderName'] as String,
      messageText: json['messageText'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isUnread: json['isUnread'] as bool? ?? false,
      avatarUrl: json['avatarUrl'] as String?,
      senderId: json['senderId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform': platform,
      'senderName': senderName,
      'messageText': messageText,
      'timestamp': timestamp.toIso8601String(),
      'isUnread': isUnread,
      'avatarUrl': avatarUrl,
      'senderId': senderId,
      'metadata': metadata,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'platform': platform,
      'senderName': senderName,
      'messageText': messageText,
      'timestamp': timestamp,
      'isUnread': isUnread,
      'avatarUrl': avatarUrl,
      'senderId': senderId,
    };
  }
}
