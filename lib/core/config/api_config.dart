import 'package:flutter/foundation.dart' show kDebugMode;

class ApiConfig {
  static String get facebookAppId =>
      const String.fromEnvironment('FACEBOOK_APP_ID');

  static String get facebookAppSecret =>
      const String.fromEnvironment('FACEBOOK_APP_SECRET');

  static String get facebookAccessToken =>
      const String.fromEnvironment('FACEBOOK_ACCESS_TOKEN');

  static String get instagramClientId =>
      const String.fromEnvironment('INSTAGRAM_CLIENT_ID');

  static String get instagramClientSecret =>
      const String.fromEnvironment('INSTAGRAM_CLIENT_SECRET');

  static String get instagramAccessToken =>
      const String.fromEnvironment('INSTAGRAM_ACCESS_TOKEN');

  static String get twitterApiKey =>
      const String.fromEnvironment('TWITTER_API_KEY');

  static String get twitterApiSecret =>
      const String.fromEnvironment('TWITTER_API_SECRET');

  static String get twitterAccessToken =>
      const String.fromEnvironment('TWITTER_ACCESS_TOKEN');

  static String get twitterAccessTokenSecret =>
      const String.fromEnvironment('TWITTER_ACCESS_TOKEN_SECRET');

  static String get linkedinClientId =>
      const String.fromEnvironment('LINKEDIN_CLIENT_ID');

  static String get linkedinClientSecret =>
      const String.fromEnvironment('LINKEDIN_CLIENT_SECRET');

  static String get linkedinAccessToken =>
      const String.fromEnvironment('LINKEDIN_ACCESS_TOKEN');

  static String get youtubeApiKey =>
      const String.fromEnvironment('YOUTUBE_API_KEY');

  static String get youtubeClientId =>
      const String.fromEnvironment('YOUTUBE_CLIENT_ID');

  static String get youtubeClientSecret =>
      const String.fromEnvironment('YOUTUBE_CLIENT_SECRET');

  static String get tiktokClientKey =>
      const String.fromEnvironment('TIKTOK_CLIENT_KEY');

  static String get tiktokClientSecret =>
      const String.fromEnvironment('TIKTOK_CLIENT_SECRET');

  static String get tiktokAccessToken =>
      const String.fromEnvironment('TIKTOK_ACCESS_TOKEN');

  static bool get isConfigured {
    return facebookAccessToken.isNotEmpty ||
        instagramAccessToken.isNotEmpty ||
        twitterAccessToken.isNotEmpty ||
        linkedinAccessToken.isNotEmpty ||
        youtubeApiKey.isNotEmpty ||
        tiktokAccessToken.isNotEmpty;
  }

  static Map<String, bool> get platformsConfigured {
    return {
      'Facebook': facebookAccessToken.isNotEmpty,
      'Instagram': instagramAccessToken.isNotEmpty,
      'Twitter': twitterAccessToken.isNotEmpty,
      'LinkedIn': linkedinAccessToken.isNotEmpty,
      'YouTube': youtubeApiKey.isNotEmpty,
      'TikTok': tiktokAccessToken.isNotEmpty,
    };
  }

  static void logConfigStatus() {
    if (kDebugMode) {
      print('=== API Configuration Status ===');
      platformsConfigured.forEach((platform, configured) {
        print('$platform: ${configured ? "✓ Configured" : "✗ Not configured"}');
      });
      print('==============================');
    }
  }
}
