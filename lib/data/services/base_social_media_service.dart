import 'package:dio/dio.dart';
import '../models/social_media_message.dart';
import '../models/social_media_post.dart';
import '../models/analytics_data.dart';

abstract class BaseSocialMediaService {
  final Dio _dio;
  final String platformName;

  BaseSocialMediaService(this.platformName) : _dio = Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Dio get dio => _dio;

  Future<List<SocialMediaMessage>> getMessages({
    int limit = 50,
    String? cursor,
  });

  Future<List<SocialMediaPost>> getPosts({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
  });

  Future<SocialMediaPost> createPost({
    required String content,
    String? imageUrl,
    DateTime? scheduledTime,
    Map<String, dynamic>? additionalOptions,
  });

  Future<SocialMediaPost> updatePost({
    required String postId,
    String? content,
    String? imageUrl,
    DateTime? scheduledTime,
  });

  Future<bool> deletePost(String postId);

  Future<AnalyticsData> getAnalytics({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? metrics,
  });

  Future<bool> testConnection();

  Map<String, String> getHeaders();
}
