import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


/// Top content widget displaying best performing posts and content insights
/// Shows content performance rankings with engagement metrics
class TopContentWidget extends StatelessWidget {
  const TopContentWidget({super.key});

  final List<ContentItem> _topContent = const [
    ContentItem(
      id: '1',
      title: 'Summer Product Launch 🚀',
      platform: 'Instagram',
      platformIcon: Icons.camera_alt_outlined,
      platformColor: Color(0xFFE4405F),
      likes: 2847,
      comments: 156,
      shares: 89,
      engagementRate: 8.4,
      publishedAt: '2 days ago',
      imageUrl:
          'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
    ),
    ContentItem(
      id: '2',
      title: 'Behind the Scenes: Team Meeting',
      platform: 'LinkedIn',
      platformIcon: Icons.business_center_outlined,
      platformColor: Color(0xFF0077B5),
      likes: 543,
      comments: 89,
      shares: 67,
      engagementRate: 12.3,
      publishedAt: '4 days ago',
      imageUrl:
          'https://images.unsplash.com/photo-1556761175-4b46a572b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
    ),
    ContentItem(
      id: '3',
      title: 'Quick Tips for Productivity',
      platform: 'Twitter',
      platformIcon: Icons.alternate_email,
      platformColor: Color(0xFF1DA1F2),
      likes: 1234,
      comments: 78,
      shares: 234,
      engagementRate: 6.7,
      publishedAt: '1 week ago',
      imageUrl:
          'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
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
                  'Top Performing Content',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full content analytics
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _topContent.length,
              separatorBuilder: (context, index) => Divider(height: 3.h),
              itemBuilder: (context, index) {
                final content = _topContent[index];
                return _buildContentItem(context, content, index + 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentItem(
      BuildContext context, ContentItem content, int rank) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        // Navigate to content details
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rank indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _getRankColor(rank),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content image thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                content.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline.withAlpha(51),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      color: theme.colorScheme.onSurface.withAlpha(128),
                      size: 24,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Content details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Platform indicator
                  Row(
                    children: [
                      Icon(
                        content.platformIcon,
                        size: 16,
                        color: content.platformColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        content.platform,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: content.platformColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        content.publishedAt,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Content title
                  Text(
                    content.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Engagement metrics
                  Row(
                    children: [
                      _buildEngagementChip(
                        context,
                        Icons.favorite_outline,
                        content.likes.toString(),
                        Colors.red,
                      ),
                      const SizedBox(width: 8),
                      _buildEngagementChip(
                        context,
                        Icons.comment_outlined,
                        content.comments.toString(),
                        Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      _buildEngagementChip(
                        context,
                        Icons.share_outlined,
                        content.shares.toString(),
                        Colors.green,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(26),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${content.engagementRate.toStringAsFixed(1)}%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementChip(
    BuildContext context,
    IconData icon,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 2),
          Text(
            _formatEngagementNumber(int.parse(value)),
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.orange;
      default:
        return Colors.grey[600]!;
    }
  }

  String _formatEngagementNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

/// Data model for content items
class ContentItem {
  final String id;
  final String title;
  final String platform;
  final IconData platformIcon;
  final Color platformColor;
  final int likes;
  final int comments;
  final int shares;
  final double engagementRate;
  final String publishedAt;
  final String imageUrl;

  const ContentItem({
    required this.id,
    required this.title,
    required this.platform,
    required this.platformIcon,
    required this.platformColor,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.engagementRate,
    required this.publishedAt,
    required this.imageUrl,
  });
}
