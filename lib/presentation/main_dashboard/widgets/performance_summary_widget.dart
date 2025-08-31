import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


/// Performance summary widget displaying key metrics at a glance
/// Shows weekly comparison and trending indicators
class PerformanceSummaryWidget extends StatelessWidget {
  const PerformanceSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'This Week\'s Performance',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildPerformanceCard(
                context,
                title: 'Total Reach',
                value: '45.2K',
                change: '+18.5%',
                isPositive: true,
                icon: Icons.visibility_outlined,
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildPerformanceCard(
                context,
                title: 'Engagement',
                value: '8.4%',
                change: '+2.1%',
                isPositive: true,
                icon: Icons.favorite_outline,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.w),
        Row(
          children: [
            Expanded(
              child: _buildPerformanceCard(
                context,
                title: 'New Followers',
                value: '287',
                change: '+12.3%',
                isPositive: true,
                icon: Icons.person_add_outlined,
                color: Colors.green,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildPerformanceCard(
                context,
                title: 'Posts Published',
                value: '12',
                change: '-2',
                isPositive: false,
                icon: Icons.edit_outlined,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPerformanceCard(
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color:
                        (isPositive ? Colors.green : Colors.red).withAlpha(26),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        size: 10,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 2),
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
            SizedBox(height: 2.h),
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
            SizedBox(height: 1.h),
            LinearProgressIndicator(
              value: _getProgressValue(title),
              backgroundColor: color.withAlpha(51),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 3,
            ),
          ],
        ),
      ),
    );
  }

  double _getProgressValue(String title) {
    // Mock progress values based on title
    switch (title) {
      case 'Total Reach':
        return 0.72;
      case 'Engagement':
        return 0.84;
      case 'New Followers':
        return 0.65;
      case 'Posts Published':
        return 0.48;
      default:
        return 0.5;
    }
  }
}
