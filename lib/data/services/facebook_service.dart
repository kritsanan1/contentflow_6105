import 'package:dio/dio.dart';
import '../../core/config/api_config.dart';
import '../models/social_media_message.dart';
import '../models/social_media_post.dart';
import '../models/analytics_data.dart';
import 'base_social_media_service.dart';

class FacebookService extends BaseSocialMediaService {
  static const String _baseUrl = 'https://graph.facebook.com/v18.0';

  FacebookService() : super('Facebook');

  @override
  Map<String, String> getHeaders() {
    return {
      'Authorization': 'Bearer ${ApiConfig.facebookAccessToken}',
      'Content-Type': 'application/json',
    };
  }

  @override
  Future<List<SocialMediaMessage>> getMessages({
    int limit = 50,
    String? cursor,
  }) async {
    if (ApiConfig.facebookAccessToken.isEmpty) {
      return _getMockMessages();
    }

    try {
      final response = await dio.get(
        '$_baseUrl/me/conversations',
        queryParameters: {
          'access_token': ApiConfig.facebookAccessToken,
          'limit': limit,
          if (cursor != null) 'after': cursor,
          'fields': 'messages{message,from,created_time},unread_count',
        },
      );

      final data = response.data['data'] as List;
      return data.map((item) {
        final messages = item['messages']['data'] as List;
        if (messages.isEmpty) return null;

        final latestMessage = messages.first;
        return SocialMediaMessage(
          id: latestMessage['id'],
          platform: 'facebook',
          senderName: latestMessage['from']['name'] ?? 'Unknown',
          messageText: latestMessage['message'] ?? '',
          timestamp: DateTime.parse(latestMessage['created_time']),
          isUnread: (item['unread_count'] ?? 0) > 0,
          senderId: latestMessage['from']['id'],
        );
      }).whereType<SocialMediaMessage>().toList();
    } catch (e) {
      print('Error fetching Facebook messages: $e');
      return _getMockMessages();
    }
  }

  @override
  Future<List<SocialMediaPost>> getPosts({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
  }) async {
    if (ApiConfig.facebookAccessToken.isEmpty) {
      return _getMockPosts();
    }

    try {
      final response = await dio.get(
        '$_baseUrl/me/posts',
        queryParameters: {
          'access_token': ApiConfig.facebookAccessToken,
          'limit': limit,
          'fields':
              'id,message,created_time,full_picture,status_type,is_published,scheduled_publish_time',
        },
      );

      final data = response.data['data'] as List;
      return data.map((item) {
        return SocialMediaPost(
          id: item['id'],
          title: _extractTitle(item['message'] ?? ''),
          content: item['message'] ?? '',
          platform: 'Facebook',
          scheduledDate: item['scheduled_publish_time'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  item['scheduled_publish_time'] * 1000)
              : DateTime.parse(item['created_time']),
          status: item['is_published'] ? 'published' : 'scheduled',
          imageUrl: item['full_picture'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching Facebook posts: $e');
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
    if (ApiConfig.facebookAccessToken.isEmpty) {
      throw Exception('Facebook API not configured');
    }

    try {
      final Map<String, dynamic> params = {
        'message': content,
        'access_token': ApiConfig.facebookAccessToken,
      };

      if (scheduledTime != null) {
        params['published'] = false;
        params['scheduled_publish_time'] =
            scheduledTime.millisecondsSinceEpoch ~/ 1000;
      }

      if (imageUrl != null) {
        params['url'] = imageUrl;
      }

      final response = await dio.post(
        '$_baseUrl/me/feed',
        data: params,
      );

      return SocialMediaPost(
        id: response.data['id'],
        title: _extractTitle(content),
        content: content,
        platform: 'Facebook',
        scheduledDate: scheduledTime ?? DateTime.now(),
        status: scheduledTime != null ? 'scheduled' : 'published',
        imageUrl: imageUrl,
      );
    } catch (e) {
      print('Error creating Facebook post: $e');
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
    if (ApiConfig.facebookAccessToken.isEmpty) {
      throw Exception('Facebook API not configured');
    }

    try {
      final Map<String, dynamic> params = {
        'access_token': ApiConfig.facebookAccessToken,
      };

      if (content != null) {
        params['message'] = content;
      }

      await dio.post(
        '$_baseUrl/$postId',
        data: params,
      );

      return SocialMediaPost(
        id: postId,
        title: _extractTitle(content ?? ''),
        content: content ?? '',
        platform: 'Facebook',
        scheduledDate: scheduledTime ?? DateTime.now(),
        status: 'published',
        imageUrl: imageUrl,
      );
    } catch (e) {
      print('Error updating Facebook post: $e');
      rethrow;
    }
  }

  @override
  Future<bool> deletePost(String postId) async {
    if (ApiConfig.facebookAccessToken.isEmpty) {
      throw Exception('Facebook API not configured');
    }

    try {
      await dio.delete(
        '$_baseUrl/$postId',
        queryParameters: {
          'access_token': ApiConfig.facebookAccessToken,
        },
      );
      return true;
    } catch (e) {
      print('Error deleting Facebook post: $e');
      return false;
    }
  }

  @override
  Future<AnalyticsData> getAnalytics({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? metrics,
  }) async {
    if (ApiConfig.facebookAccessToken.isEmpty) {
      return _getMockAnalytics(startDate, endDate);
    }

    try {
      final response = await dio.get(
        '$_baseUrl/me/insights',
        queryParameters: {
          'access_token': ApiConfig.facebookAccessToken,
          'metric':
              metrics?.join(',') ?? 'page_impressions,page_engaged_users',
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
        platform: 'Facebook',
        startDate: startDate,
        endDate: endDate,
        metrics: metricsMap,
        demographics: {},
        topPosts: [],
        engagement: {},
      );
    } catch (e) {
      print('Error fetching Facebook analytics: $e');
      return _getMockAnalytics(startDate, endDate);
    }
  }

  @override
  Future<bool> testConnection() async {
    if (ApiConfig.facebookAccessToken.isEmpty) {
      return false;
    }

    try {
      final response = await dio.get(
        '$_baseUrl/me',
        queryParameters: {
          'access_token': ApiConfig.facebookAccessToken,
          'fields': 'id,name',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Facebook connection test failed: $e');
      return false;
    }
  }

  String _extractTitle(String content) {
    final firstLine = content.split('\n').first;
    return firstLine.length > 50 ? '${firstLine.substring(0, 50)}...' : firstLine;
  }

  List<SocialMediaMessage> _getMockMessages() {
    return [
      SocialMediaMessage(
        id: 'fb_1',
        platform: 'facebook',
        senderName: 'สมชาย ใจดี',
        messageText:
            'สวัสดีครับ ผมสนใจสินค้าของคุณมากครับ สามารถให้รายละเอียดเพิ่มเติมได้ไหมครับ',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isUnread: true,
        avatarUrl:
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      ),
    ];
  }

  List<SocialMediaPost> _getMockPosts() {
    return [
      SocialMediaPost(
        id: 'fb_post_1',
        title: 'เปิดตัวผลิตภัณฑ์ใหม่ล่าสุด',
        content:
            'ร่วมค้นพบนวัตกรรมใหม่ที่จะเปลี่ยนแปลงวิธีการทำงานของคุณ',
        platform: 'Facebook',
        scheduledDate: DateTime.now().add(const Duration(days: 1, hours: 9)),
        status: 'scheduled',
        imageUrl:
            'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=500&h=300&fit=crop',
        aiOptimized: true,
      ),
    ];
  }

  AnalyticsData _getMockAnalytics(DateTime startDate, DateTime endDate) {
    return AnalyticsData(
      platform: 'Facebook',
      startDate: startDate,
      endDate: endDate,
      metrics: {
        'impressions': 12500,
        'reach': 8900,
        'engagement': 1250,
      },
      demographics: {
        'age': {'18-24': 32, '25-34': 45, '35-44': 18, '45+': 5},
        'gender': {'female': 58, 'male': 38, 'other': 4},
      },
      topPosts: [],
      engagement: {
        'likes': 2847,
        'comments': 1243,
        'shares': 567,
      },
    );
  }
}
