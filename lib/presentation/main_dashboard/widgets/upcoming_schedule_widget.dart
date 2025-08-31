import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


/// Upcoming schedule widget showing next scheduled posts
/// Displays preview of content pipeline with platform indicators
class UpcomingScheduleWidget extends StatelessWidget {
  const UpcomingScheduleWidget({super.key});

  final List<ScheduledPost> _scheduledPosts = const [
    ScheduledPost(
      id: '1',
      title: 'Product Feature Highlight',
      platform: 'Instagram',
      platformIcon: Icons.camera_alt_outlined,
      platformColor: Color(0xFFE4405F),
      scheduledTime: 'Today, 3:00 PM',
      status: ScheduleStatus.ready,
      imageUrl:
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
    ),
    ScheduledPost(
      id: '2',
      title: 'Industry News Update',
      platform: 'LinkedIn',
      platformIcon: Icons.business_center_outlined,
      platformColor: Color(0xFF0077B5),
      scheduledTime: 'Tomorrow, 9:00 AM',
      status: ScheduleStatus.pending,
      imageUrl:
          'https://images.unsplash.com/photo-1504384764586-bb4cdc1707b0?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
    ),
    ScheduledPost(
      id: '3',
      title: 'Quick Tip Tuesday',
      platform: 'Twitter',
      platformIcon: Icons.alternate_email,
      platformColor: Color(0xFF1DA1F2),
      scheduledTime: 'Tomorrow, 11:30 AM',
      status: ScheduleStatus.draft,
      imageUrl:
          'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
    ),
    ScheduledPost(
      id: '4',
      title: 'Weekend Motivation',
      platform: 'Facebook',
      platformIcon: Icons.facebook_outlined,
      platformColor: Color(0xFF4267B2),
      scheduledTime: 'Friday, 5:00 PM',
      status: ScheduleStatus.ready,
      imageUrl:
          'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
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
                  'Upcoming Posts',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/content-calendar');
                  },
                  child: const Text('View Calendar'),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _scheduledPosts.take(3).length, // Show first 3 items
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final post = _scheduledPosts[index];
                return _buildScheduledPostItem(context, post);
              },
            ),
            if (_scheduledPosts.length > 3) ...[
              SizedBox(height: 2.h),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/content-calendar');
                  },
                  child: Text(
                    '+${_scheduledPosts.length - 3} more scheduled posts',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScheduledPostItem(BuildContext context, ScheduledPost post) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _onPostTap(context, post),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withAlpha(64),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Post thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                post.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline.withAlpha(51),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      color: theme.colorScheme.onSurface.withAlpha(128),
                      size: 20,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Post details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Platform and status
                  Row(
                    children: [
                      Icon(
                        post.platformIcon,
                        size: 16,
                        color: post.platformColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        post.platform,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: post.platformColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      _buildStatusBadge(context, post.status),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Post title
                  Text(
                    post.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Scheduled time
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 14,
                        color: theme.colorScheme.onSurface.withAlpha(128),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        post.scheduledTime,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action button
            IconButton(
              onPressed: () => _showPostOptions(context, post),
              icon: Icon(
                Icons.more_vert,
                size: 20,
                color: theme.colorScheme.onSurface.withAlpha(128),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, ScheduleStatus status) {
    final theme = Theme.of(context);
    final colors = _getStatusColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.displayName,
        style: theme.textTheme.labelSmall?.copyWith(
          color: colors.textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  StatusColors _getStatusColors(ScheduleStatus status) {
    switch (status) {
      case ScheduleStatus.ready:
        return const StatusColors(
          backgroundColor: Color(0xFF4CAF50),
          textColor: Colors.white,
        );
      case ScheduleStatus.pending:
        return const StatusColors(
          backgroundColor: Color(0xFFFF9800),
          textColor: Colors.white,
        );
      case ScheduleStatus.draft:
        return const StatusColors(
          backgroundColor: Color(0xFF9E9E9E),
          textColor: Colors.white,
        );
    }
  }

  void _onPostTap(BuildContext context, ScheduledPost post) {
    Navigator.pushNamed(
      context,
      '/post-composer',
      arguments: post.id,
    );
  }

  void _showPostOptions(BuildContext context, ScheduledPost post) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Post'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/post-composer',
                  arguments: post.id,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule_outlined),
              title: const Text('Reschedule'),
              onTap: () {
                Navigator.pop(context);
                // Show date/time picker
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete'),
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, post);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ScheduledPost post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: Text('Are you sure you want to delete "${post.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted "${post.title}"'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      // Implement undo functionality
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Schedule status enum
enum ScheduleStatus { ready, pending, draft }

extension ScheduleStatusExtension on ScheduleStatus {
  String get displayName {
    switch (this) {
      case ScheduleStatus.ready:
        return 'Ready';
      case ScheduleStatus.pending:
        return 'Pending';
      case ScheduleStatus.draft:
        return 'Draft';
    }
  }
}

/// Data model for scheduled posts
class ScheduledPost {
  final String id;
  final String title;
  final String platform;
  final IconData platformIcon;
  final Color platformColor;
  final String scheduledTime;
  final ScheduleStatus status;
  final String imageUrl;

  const ScheduledPost({
    required this.id,
    required this.title,
    required this.platform,
    required this.platformIcon,
    required this.platformColor,
    required this.scheduledTime,
    required this.status,
    required this.imageUrl,
  });
}

/// Color scheme for different status types
class StatusColors {
  final Color backgroundColor;
  final Color textColor;

  const StatusColors({
    required this.backgroundColor,
    required this.textColor,
  });
}
