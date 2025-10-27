import 'package:dio/dio.dart';
import '../../core/config/api_config.dart';
import '../models/social_media_message.dart';
import '../models/social_media_post.dart';
import '../models/analytics_data.dart';
import 'base_social_media_service.dart';

class InstagramService extends BaseSocialMediaService {
  static const String _baseUrl = 'https://graph.instagram.com';

  InstagramService() : super('Instagram');

  @override
  Map<String, String> getHeaders() {
    return {
      'Authorization': 'Bearer ${ApiConfig.instagramAccessToken}',
      'Content-Type': 'application/json',
    };
  }

  @override
  Future<List<SocialMediaMessage>> getMessages({
    int limit = 50,
    String? cursor,
  }) async {
    if (ApiConfig.instagramAccessToken.isEmpty) {
      return _getMockMessages();
    }

    try {
      final response = await dio.get(
        '$_baseUrl/me/conversations',
        queryParameters: {
          'access_token': ApiConfig.instagramAccessToken,
          'limit': limit,
          if (cursor != null) 'after': cursor,
          'fields': 'messages{text,from,created_time}',
        },
      );

      final data = response.data['data'] as List;
      return data.map((item) {
        final messages = item['messages']?['data'] as List? ?? [];
        if (messages.isEmpty) return null;

        final latestMessage = messages.first;
        return SocialMediaMessage(
          id: latestMessage['id'] ?? '',
          platform: 'instagram',
          senderName: latestMessage['from']?['username'] ?? 'Unknown',
          messageText: latestMessage['text'] ?? '',
          timestamp: DateTime.parse(
              latestMessage['created_time'] ?? DateTime.now().toIso8601String()),
          isUnread: true,
          senderId: latestMessage['from']?['id'],
        );
      }).whereType<SocialMediaMessage>().toList();
    } catch (e) {
      print('Error fetching Instagram messages: $e');
      return _getMockMessages();
    }
  }

  @override
  Future<List<SocialMediaPost>> getPosts({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
  }) async {
    if (ApiConfig.instagramAccessToken.isEmpty) {
      return _getMockPosts();
    }

    try {
      final response = await dio.get(
        '$_baseUrl/me/media',
        queryParameters: {
          'access_token': ApiConfig.instagramAccessToken,
          'limit': limit,
          'fields': 'id,caption,media_type,media_url,thumbnail_url,timestamp',
        },
      );

      final data = response.data['data'] as List;
      return data.map((item) {
        final caption = item['caption'] ?? '';
        return SocialMediaPost(
          id: item['id'],
          title: _extractTitle(caption),
          content: caption,
          platform: 'Instagram',
          scheduledDate: DateTime.parse(item['timestamp']),
          status: 'published',
          imageUrl: item['media_url'] ?? item['thumbnail_url'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching Instagram posts: $e');
      return _getMockPosts();
    }
  }

  @override
  Future<SocialMediaPost> createPost({
    required String content,
    String? imageUrl,
    DateTime? scheduledTime,
    Map<String, dynamic>? additionalOptions,
  }) async {
    if (ApiConfig.instagramAccessToken.isEmpty) {
      throw Exception('Instagram API not configured');
    }

    try {
      if (imageUrl == null) {
        throw Exception('Instagram posts require an image');
      }

      final containerResponse = await dio.post(
        '$_baseUrl/me/media',
        data: {
          'image_url': imageUrl,
          'caption': content,
          'access_token': ApiConfig.instagramAccessToken,
        },
      );

      final containerId = containerResponse.data['id'];

      final publishResponse = await dio.post(
        '$_baseUrl/me/media_publish',
        data: {
          'creation_id': containerId,
          'access_token': ApiConfig.instagramAccessToken,
        },
      );

      return SocialMediaPost(
        id: publishResponse.data['id'],
        title: _extractTitle(content),
        content: content,
        platform: 'Instagram',
        scheduledDate: scheduledTime ?? DateTime.now(),
        status: 'published',
        imageUrl: imageUrl,
      );
    } catch (e) {
      print('Error creating Instagram post: $e');
      rethrow;
    }
  }

  @override
  Future<SocialMediaPost> updatePost({
    required String postId,
    String? content,
    String? imageUrl,
    DateTime? scheduledTime,
  }) async {
    throw Exception(
        'Instagram API does not support editing published posts');
  }

  @override
  Future<bool> deletePost(String postId) async {
    if (ApiConfig.instagramAccessToken.isEmpty) {
      throw Exception('Instagram API not configured');
    }

    try {
      await dio.delete(
        '$_baseUrl/$postId',
        queryParameters: {
          'access_token': ApiConfig.instagramAccessToken,
        },
      );
      return true;
    } catch (e) {
      print('Error deleting Instagram post: $e');
      return false;
    }
  }

  @override
  Future<AnalyticsData> getAnalytics({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? metrics,
  }) async {
    if (ApiConfig.instagramAccessToken.isEmpty) {
      return _getMockAnalytics(startDate, endDate);
    }

    try {
      final response = await dio.get(
        '$_baseUrl/me/insights',
        queryParameters: {
          'access_token': ApiConfig.instagramAccessToken,
          'metric': metrics?.join(',') ?? 'impressions,reach,profile_views',
          'period': 'day',
          'since': startDate.millisecondsSinceEpoch ~/ 1000,
          'until': endDate.millisecondsSinceEpoch ~/ 1000,
        },
      );

      final data = response.data['data'] as List;
      final metricsMap = <String, dynamic>{};

      for (var metric in data) {
        metricsMap[metric['name']] = metric['values'];
      }

      return AnalyticsData(
        platform: 'Instagram',
        startDate: startDate,
        endDate: endDate,
        metrics: metricsMap,
        demographics: {},
        topPosts: [],
        engagement: {},
      );
    } catch (e) {
      print('Error fetching Instagram analytics: $e');
      return _getMockAnalytics(startDate, endDate);
    }
  }

  @override
  Future<bool> testConnection() async {
    if (ApiConfig.instagramAccessToken.isEmpty) {
      return false;
    }

    try {
      final response = await dio.get(
        '$_baseUrl/me',
        queryParameters: {
          'access_token': ApiConfig.instagramAccessToken,
          'fields': 'id,username',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Instagram connection test failed: $e');
      return false;
    }
  }

  String _extractTitle(String content) {
    final firstLine = content.split('\n').first;
    return firstLine.length > 50
        ? '${firstLine.substring(0, 50)}...'
        : firstLine;
  }

  List<SocialMediaMessage> _getMockMessages() {
    return [
      SocialMediaMessage(
        id: 'ig_1',
        platform: 'instagram',
        senderName: 'มาลี สวยงาม',
        messageText: 'รูปนี้สวยมากค่ะ ถ่ายที่ไหนคะ? 😍',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isUnread: true,
        avatarUrl:
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      ),
    ];
  }

  List<SocialMediaPost> _getMockPosts() {
    return [
      SocialMediaPost(
        id: 'ig_post_1',
        title: 'เคล็ดลับการใช้งานแอปพลิเคชัน',
        content:
            '5 เทคนิคง่ายๆ ที่จะช่วยให้คุณใช้งานแอปได้อย่างมีประสิทธิภาพมากขึ้น',
        platform: 'Instagram',
        scheduledDate: DateTime.now().add(const Duration(days: 2, hours: 14)),
        status: 'scheduled',
        imageUrl:
            'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=500&h=300&fit=crop',
        aiOptimized: false,
      ),
    ];
  }

  AnalyticsData _getMockAnalytics(DateTime startDate, DateTime endDate) {
    return AnalyticsData(
      platform: 'Instagram',
      startDate: startDate,
      endDate: endDate,
      metrics: {
        'impressions': 15200,
        'reach': 11400,
        'profile_views': 2350,
      },
      demographics: {
        'age': {'18-24': 45, '25-34': 38, '35-44': 12, '45+': 5},
        'gender': {'female': 65, 'male': 32, 'other': 3},
      },
      topPosts: [],
      engagement: {
        'likes': 3245,
        'comments': 892,
        'saves': 567,
      },
    );
  }
}
