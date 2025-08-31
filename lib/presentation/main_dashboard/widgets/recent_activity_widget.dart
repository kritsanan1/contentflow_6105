import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


/// Recent activity widget showing latest user actions and system events
/// Displays chronological feed of activities with timestamps
class RecentActivityWidget extends StatelessWidget {
  const RecentActivityWidget({super.key});

  final List<ActivityItem> _activities = const [
    ActivityItem(
      type: ActivityType.post,
      title: 'Post published on Instagram',
      description: 'Summer Product Launch post went live',
      timestamp: '2 hours ago',
      icon: Icons.camera_alt_outlined,
      color: Color(0xFFE4405F),
    ),
    ActivityItem(
      type: ActivityType.engagement,
      title: 'High engagement detected',
      description: 'LinkedIn post received 50+ likes in 1 hour',
      timestamp: '4 hours ago',
      icon: Icons.trending_up_outlined,
      color: Colors.green,
    ),
    ActivityItem(
      type: ActivityType.message,
      title: 'New message received',
      description: 'Customer inquiry about product features',
      timestamp: '6 hours ago',
      icon: Icons.message_outlined,
      color: Colors.blue,
    ),
    ActivityItem(
      type: ActivityType.schedule,
      title: 'Content scheduled',
      description: '3 posts scheduled for tomorrow',
      timestamp: '1 day ago',
      icon: Icons.schedule_outlined,
      color: Colors.orange,
    ),
    ActivityItem(
      type: ActivityType.analytics,
      title: 'Weekly report ready',
      description: 'Performance analytics for last week available',
      timestamp: '2 days ago',
      icon: Icons.analytics_outlined,
      color: Colors.purple,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showAllActivities(context);
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _activities.take(4).length, // Show first 4 items
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return _buildActivityItem(context, activity);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, ActivityItem activity) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _onActivityTap(context, activity),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: activity.color.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                activity.icon,
                color: activity.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          activity.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        activity.timestamp,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(179),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onActivityTap(BuildContext context, ActivityItem activity) {
    switch (activity.type) {
      case ActivityType.post:
        // Navigate to post details or content calendar
        Navigator.pushNamed(context, '/content-calendar');
        break;
      case ActivityType.engagement:
        // Show engagement details or analytics
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Engagement details coming soon')),
        );
        break;
      case ActivityType.message:
        // Navigate to messages
        Navigator.pushNamed(context, '/messages-inbox');
        break;
      case ActivityType.schedule:
        // Navigate to content calendar
        Navigator.pushNamed(context, '/content-calendar');
        break;
      case ActivityType.analytics:
        // Navigate to analytics
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Analytics coming soon')),
        );
        break;
    }
  }

  void _showAllActivities(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withAlpha(128),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Activities',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _activities.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final activity = _activities[index];
                    return _buildActivityItem(context, activity);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Activity types for different categories
enum ActivityType { post, engagement, message, schedule, analytics }

/// Data model for activity items
class ActivityItem {
  final ActivityType type;
  final String title;
  final String description;
  final String timestamp;
  final IconData icon;
  final Color color;

  const ActivityItem({
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.icon,
    required this.color,
  });
}
