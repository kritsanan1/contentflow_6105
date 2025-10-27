import 'base_social_media_service.dart';
import 'facebook_service.dart';
import 'instagram_service.dart';

class SocialMediaServiceFactory {
  static final Map<String, BaseSocialMediaService> _services = {};

  static BaseSocialMediaService getService(String platform) {
    final normalizedPlatform = platform.toLowerCase();

    if (!_services.containsKey(normalizedPlatform)) {
      _services[normalizedPlatform] = _createService(normalizedPlatform);
    }

    return _services[normalizedPlatform]!;
  }

  static BaseSocialMediaService _createService(String platform) {
    switch (platform) {
      case 'facebook':
        return FacebookService();
      case 'instagram':
        return InstagramService();
      case 'twitter':
      case 'x':
        throw UnimplementedError('Twitter/X service not yet implemented');
      case 'linkedin':
        throw UnimplementedError('LinkedIn service not yet implemented');
      case 'youtube':
        throw UnimplementedError('YouTube service not yet implemented');
      case 'tiktok':
        throw UnimplementedError('TikTok service not yet implemented');
      default:
        throw Exception('Unknown platform: $platform');
    }
  }

  static List<String> getSupportedPlatforms() {
    return ['facebook', 'instagram'];
  }

  static bool isPlatformSupported(String platform) {
    return getSupportedPlatforms().contains(platform.toLowerCase());
  }

  static Future<Map<String, bool>> testAllConnections() async {
    final results = <String, bool>{};

    for (final platform in getSupportedPlatforms()) {
      try {
        final service = getService(platform);
        results[platform] = await service.testConnection();
      } catch (e) {
        results[platform] = false;
      }
    }

    return results;
  }
}
