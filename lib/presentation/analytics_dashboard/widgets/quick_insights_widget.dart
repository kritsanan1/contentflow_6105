import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


/// Quick insights widget displaying actionable analytics insights
/// Shows AI-powered recommendations and trend alerts
class QuickInsightsWidget extends StatelessWidget {
  const QuickInsightsWidget({super.key});

  final List<InsightItem> _insights = const [
    InsightItem(
      type: InsightType.positive,
      title: 'Peak Engagement Time',
      description: 'Your audience is most active at 3-5 PM on weekdays',
      action: 'Schedule more posts during this time',
      icon: Icons.schedule_outlined,
    ),
    InsightItem(
      type: InsightType.warning,
      title: 'Declining Instagram Reach',
      description: 'Your Instagram reach dropped by 15% this week',
      action: 'Try using trending hashtags or reels',
      icon: Icons.trending_down,
    ),
    InsightItem(
      type: InsightType.info,
      title: 'LinkedIn Performing Well',
      description: 'LinkedIn posts have 23% higher engagement than average',
      action: 'Consider posting more professional content',
      icon: Icons.business_center_outlined,
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
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Quick Insights',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _insights.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final insight = _insights[index];
                return _buildInsightItem(context, insight);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(BuildContext context, InsightItem insight) {
    final theme = Theme.of(context);
    final colors = _getInsightColors(insight.type, theme);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.iconBackgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              insight.icon,
              size: 20,
              color: colors.iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(179),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outlined,
                      size: 14,
                      color: colors.actionColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        insight.action,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.actionColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface.withAlpha(128),
            ),
            onPressed: () {
              _showInsightDetails(context, insight);
            },
          ),
        ],
      ),
    );
  }

  InsightColors _getInsightColors(InsightType type, ThemeData theme) {
    switch (type) {
      case InsightType.positive:
        return InsightColors(
          backgroundColor: Colors.green.withAlpha(26),
          borderColor: Colors.green.withAlpha(77),
          iconColor: Colors.green,
          iconBackgroundColor: Colors.green.withAlpha(51),
          actionColor: Colors.green.shade700,
        );
      case InsightType.warning:
        return InsightColors(
          backgroundColor: Colors.orange.withAlpha(26),
          borderColor: Colors.orange.withAlpha(77),
          iconColor: Colors.orange,
          iconBackgroundColor: Colors.orange.withAlpha(51),
          actionColor: Colors.orange.shade700,
        );
      case InsightType.info:
        return InsightColors(
          backgroundColor: theme.colorScheme.primary.withAlpha(26),
          borderColor: theme.colorScheme.primary.withAlpha(77),
          iconColor: theme.colorScheme.primary,
          iconBackgroundColor: theme.colorScheme.primary.withAlpha(51),
          actionColor: theme.colorScheme.primary,
        );
    }
  }

  void _showInsightDetails(BuildContext context, InsightItem insight) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(insight.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(insight.description),
            const SizedBox(height: 16),
            const Text(
              'Recommendation:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(insight.action),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement action based on insight
            },
            child: const Text('Take Action'),
          ),
        ],
      ),
    );
  }
}

/// Insight types for different categories
enum InsightType { positive, warning, info }

/// Data model for insight items
class InsightItem {
  final InsightType type;
  final String title;
  final String description;
  final String action;
  final IconData icon;

  const InsightItem({
    required this.type,
    required this.title,
    required this.description,
    required this.action,
    required this.icon,
  });
}

/// Color scheme for different insight types
class InsightColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color actionColor;

  const InsightColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.actionColor,
  });
}
