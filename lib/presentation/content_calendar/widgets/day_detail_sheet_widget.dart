import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DayDetailSheetWidget extends StatelessWidget {
  final DateTime selectedDate;
  final List<Map<String, dynamic>> dayPosts;
  final Function(Map<String, dynamic>) onPostTap;
  final Function(Map<String, dynamic>) onPostEdit;
  final Function(Map<String, dynamic>) onPostDelete;
  final VoidCallback onCreatePost;

  const DayDetailSheetWidget({
    super.key,
    required this.selectedDate,
    required this.dayPosts,
    required this.onPostTap,
    required this.onPostEdit,
    required this.onPostDelete,
    required this.onCreatePost,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getFormattedDate(),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${dayPosts.length} โพสต์ที่กำหนดไว้',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onCreatePost();
                  },
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: theme.colorScheme.onPrimary,
                    size: 16,
                  ),
                  label: Text('สร้างโพสต์'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          // Posts list
          Expanded(
            child: dayPosts.isEmpty
                ? _buildEmptyState(context)
                : ListView.separated(
                    padding: EdgeInsets.all(4.w),
                    itemCount: dayPosts.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final post = dayPosts[index];
                      return _buildPostCard(context, post);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'event_note',
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'ไม่มีโพสต์ที่กำหนดไว้',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'แตะปุ่ม "สร้างโพสต์" เพื่อเพิ่มเนื้อหาใหม่',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, Map<String, dynamic> post) {
    final theme = Theme.of(context);
    final scheduledTime = post['scheduledDate'] as DateTime;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onPostTap(post);
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getPlatformColor(post['platform'] as String)
                .withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Platform icon
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _getPlatformColor(post['platform'] as String),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _getPlatformIcon(post['platform'] as String),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['title'] as String,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${scheduledTime.hour.toString().padLeft(2, '0')}:${scheduledTime.minute.toString().padLeft(2, '0')}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: CustomIconWidget(
                    iconName: 'more_vert',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  onSelected: (value) {
                    HapticFeedback.lightImpact();
                    switch (value) {
                      case 'edit':
                        onPostEdit(post);
                        break;
                      case 'delete':
                        onPostDelete(post);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'edit',
                            color: theme.colorScheme.onSurface,
                            size: 16,
                          ),
                          SizedBox(width: 3.w),
                          Text('แก้ไข'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'delete',
                            color: theme.colorScheme.error,
                            size: 16,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'ลบ',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (post['content'] != null &&
                (post['content'] as String).isNotEmpty) ...[
              SizedBox(height: 2.h),
              Text(
                post['content'] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (post['imageUrl'] != null) ...[
              SizedBox(height: 2.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: post['imageUrl'] as String,
                  width: double.infinity,
                  height: 20.h,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            SizedBox(height: 2.h),
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(post['status'] as String)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(post['status'] as String),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(post['status'] as String),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                if (post['aiOptimized'] == true) ...[
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'auto_awesome',
                          color: theme.colorScheme.tertiary,
                          size: 12,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'AI',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getFormattedDate() {
    final months = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม'
    ];

    final buddhistYear = selectedDate.year + 543;
    return '${selectedDate.day} ${months[selectedDate.month - 1]} ${buddhistYear}';
  }

  Color _getPlatformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'tiktok':
        return const Color(0xFF000000);
      default:
        return Colors.grey;
    }
  }

  String _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return 'facebook';
      case 'instagram':
        return 'camera_alt';
      case 'twitter':
        return 'alternate_email';
      case 'linkedin':
        return 'work';
      case 'tiktok':
        return 'music_note';
      default:
        return 'public';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return const Color(0xFF2563EB);
      case 'published':
        return const Color(0xFF059669);
      case 'draft':
        return const Color(0xFFD97706);
      case 'failed':
        return const Color(0xFFDC2626);
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return 'กำหนดเวลาแล้ว';
      case 'published':
        return 'เผยแพร่แล้ว';
      case 'draft':
        return 'ร่าง';
      case 'failed':
        return 'ล้มเหลว';
      default:
        return 'ไม่ทราบสถานะ';
    }
  }
}
