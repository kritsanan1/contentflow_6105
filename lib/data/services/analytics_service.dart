import '../../core/config/api_config.dart';
import '../models/analytics_data.dart';
import 'social_media_service_factory.dart';

class AnalyticsService {
  static Future<Map<String, AnalyticsData>> getAggregatedAnalytics({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? platforms,
  }) async {
    final Map<String, AnalyticsData> analyticsMap = {};
    final targetPlatforms = platforms ?? ['facebook', 'instagram'];

    for (final platform in targetPlatforms) {
      if (SocialMediaServiceFactory.isPlatformSupported(platform)) {
        try {
          final service = SocialMediaServiceFactory.getService(platform);
          final analytics = await service.getAnalytics(
            startDate: startDate,
            endDate: endDate,
          );
          analyticsMap[platform] = analytics;
        } catch (e) {
          print('Error fetching analytics for $platform: $e');
        }
      }
    }

    return analyticsMap;
  }

  static Map<String, dynamic> combineMetrics(
      Map<String, AnalyticsData> analyticsMap) {
    final combined = <String, dynamic>{
      'totalImpressions': 0,
      'totalReach': 0,
      'totalEngagement': 0,
      'totalLikes': 0,
      'totalComments': 0,
      'totalShares': 0,
      'totalSaves': 0,
    };

    for (final analytics in analyticsMap.values) {
      combined['totalImpressions'] =
          (combined['totalImpressions'] as int) +
              (analytics.metrics['impressions'] as int? ?? 0);
      combined['totalReach'] = (combined['totalReach'] as int) +
          (analytics.metrics['reach'] as int? ?? 0);
      combined['totalEngagement'] =
          (combined['totalEngagement'] as int) +
              (analytics.metrics['engagement'] as int? ?? 0);

      if (analytics.engagement.isNotEmpty) {
        combined['totalLikes'] = (combined['totalLikes'] as int) +
            (analytics.engagement['likes'] as int? ?? 0);
        combined['totalComments'] =
            (combined['totalComments'] as int) +
                (analytics.engagement['comments'] as int? ?? 0);
        combined['totalShares'] =
            (combined['totalShares'] as int) +
                (analytics.engagement['shares'] as int? ?? 0);
        combined['totalSaves'] = (combined['totalSaves'] as int) +
            (analytics.engagement['saves'] as int? ?? 0);
      }
    }

    return combined;
  }

  static Map<String, dynamic> combineDemographics(
      Map<String, AnalyticsData> analyticsMap) {
    final Map<String, Map<String, int>> ageDistribution = {};
    final Map<String, int> genderDistribution = {};
    int totalAudience = 0;

    for (final analytics in analyticsMap.values) {
      if (analytics.demographics['age'] != null) {
        final ageData = analytics.demographics['age'] as Map;
        ageData.forEach((key, value) {
          ageDistribution[key] = ageDistribution[key] ?? {};
          ageDistribution[key]![analytics.platform] = value as int;
          totalAudience += value as int;
        });
      }

      if (analytics.demographics['gender'] != null) {
        final genderData = analytics.demographics['gender'] as Map;
        genderData.forEach((key, value) {
          genderDistribution[key] =
              (genderDistribution[key] ?? 0) + (value as int);
        });
      }
    }

    final combinedAge = <String, int>{};
    ageDistribution.forEach((ageGroup, platformData) {
      platformData.forEach((platform, count) {
        combinedAge[ageGroup] = (combinedAge[ageGroup] ?? 0) + count;
      });
    });

    return {
      'age': combinedAge,
      'gender': genderDistribution,
      'totalAudience': totalAudience,
    };
  }
}
