import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


/// Metrics overview widget displaying key performance indicators
/// Shows followers, engagement, reach, and impressions with trends
class MetricsOverviewWidget extends StatelessWidget {
  const MetricsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Metrics',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          mainAxisSpacing: 3.w,
          crossAxisSpacing: 3.w,
          children: [
            _buildMetricCard(
              context,
              title: 'Followers',
              value: '24.8K',
              change: '+5.2%',
              isPositive: true,
              icon: Icons.people_outline,
              color: theme.colorScheme.primary,
            ),
            _buildMetricCard(
              context,
              title: 'Engagement',
              value: '12.4%',
              change: '+2.1%',
              isPositive: true,
              icon: Icons.favorite_outline,
              color: Colors.red,
            ),
            _buildMetricCard(
              context,
              title: 'Reach',
              value: '156K',
              change: '-3.4%',
              isPositive: false,
              icon: Icons.visibility_outlined,
              color: Colors.green,
            ),
            _buildMetricCard(
              context,
              title: 'Impressions',
              value: '289K',
              change: '+8.7%',
              isPositive: true,
              icon: Icons.trending_up_outlined,
              color: Colors.orange,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color:
                        (isPositive ? Colors.green : Colors.red).withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        size: 12,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        change,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(153),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
