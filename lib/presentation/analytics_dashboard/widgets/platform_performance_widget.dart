import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


/// Platform performance widget showing metrics across different social media platforms
/// Displays performance comparison with visual indicators
class PlatformPerformanceWidget extends StatelessWidget {
  const PlatformPerformanceWidget({super.key});

  final List<PlatformMetric> _platforms = const [
    PlatformMetric(
      name: 'Instagram',
      icon: Icons.camera_alt_outlined,
      color: Color(0xFFE4405F),
      followers: 15400,
      engagement: 8.4,
      posts: 24,
      growth: 5.2,
    ),
    PlatformMetric(
      name: 'Twitter',
      icon: Icons.alternate_email,
      color: Color(0xFF1DA1F2),
      followers: 8900,
      engagement: 6.1,
      posts: 47,
      growth: 2.8,
    ),
    PlatformMetric(
      name: 'Facebook',
      icon: Icons.facebook_outlined,
      color: Color(0xFF4267B2),
      followers: 12300,
      engagement: 4.9,
      posts: 18,
      growth: -1.2,
    ),
    PlatformMetric(
      name: 'LinkedIn',
      icon: Icons.business_center_outlined,
      color: Color(0xFF0077B5),
      followers: 3200,
      engagement: 12.3,
      posts: 12,
      growth: 8.7,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Platform Performance',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _platforms.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final platform = _platforms[index];
                return _buildPlatformItem(context, platform);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformItem(BuildContext context, PlatformMetric platform) {
    final theme = Theme.of(context);
    final isPositiveGrowth = platform.growth > 0;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha(64),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: platform.color.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  platform.icon,
                  color: platform.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      platform.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${_formatNumber(platform.followers)} followers',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isPositiveGrowth ? Colors.green : Colors.red)
                      .withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositiveGrowth
                          ? Icons.trending_up
                          : Icons.trending_down,
                      size: 12,
                      color: isPositiveGrowth ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositiveGrowth ? '+' : ''}${platform.growth.toStringAsFixed(1)}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isPositiveGrowth ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildMetricColumn(
                  context,
                  'Engagement',
                  '${platform.engagement.toStringAsFixed(1)}%',
                ),
              ),
              Expanded(
                child: _buildMetricColumn(
                  context,
                  'Posts',
                  '${platform.posts}',
                ),
              ),
              Expanded(
                child: _buildMetricColumn(
                  context,
                  'Avg. Likes',
                  _formatNumber(
                      (platform.followers * platform.engagement / 100).round()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(
    BuildContext context,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(128),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

/// Data model for platform metrics
class PlatformMetric {
  final String name;
  final IconData icon;
  final Color color;
  final int followers;
  final double engagement;
  final int posts;
  final double growth;

  const PlatformMetric({
    required this.name,
    required this.icon,
    required this.color,
    required this.followers,
    required this.engagement,
    required this.posts,
    required this.growth,
  });
}
