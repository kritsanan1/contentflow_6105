import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageCardWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback? onTap;
  final VoidCallback? onReply;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  const MessageCardWidget({
    super.key,
    required this.message,
    this.onTap,
    this.onReply,
    this.onArchive,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = message['isUnread'] as bool? ?? false;
    final platform = message['platform'] as String? ?? '';
    final senderName = message['senderName'] as String? ?? 'Unknown';
    final messageText = message['messageText'] as String? ?? '';
    final timestamp = message['timestamp'] as DateTime? ?? DateTime.now();
    final avatarUrl = message['avatarUrl'] as String? ?? '';

    return Slidable(
      key: ValueKey(message['id']),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              HapticFeedback.lightImpact();
              onReply?.call();
            },
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: Colors.white,
            icon: Icons.reply,
            label: 'ตอบกลับ',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              HapticFeedback.lightImpact();
              onArchive?.call();
            },
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'เก็บถาวร',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (context) {
              HapticFeedback.lightImpact();
              onDelete?.call();
            },
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'ลบ',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: isUnread
              ? Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap?.call();
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvatarSection(theme, avatarUrl, platform),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildMessageContent(
                      theme,
                      senderName,
                      messageText,
                      timestamp,
                      isUnread,
                    ),
                  ),
                  _buildStatusIndicator(theme, isUnread, platform),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(
    ThemeData theme,
    String avatarUrl,
    String platform,
  ) {
    return Stack(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ClipOval(
            child: avatarUrl.isNotEmpty
                ? CustomImageWidget(
                    imageUrl: avatarUrl,
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: theme.colorScheme.primary,
                      size: 6.w,
                    ),
                  ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: _getPlatformColor(platform),
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.cardColor,
                width: 1,
              ),
            ),
            child: CustomIconWidget(
              iconName: _getPlatformIcon(platform),
              color: Colors.white,
              size: 2.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageContent(
    ThemeData theme,
    String senderName,
    String messageText,
    DateTime timestamp,
    bool isUnread,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                senderName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              _formatTimestamp(timestamp),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          messageText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isUnread
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isUnread ? FontWeight.w500 : FontWeight.w400,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(
      ThemeData theme, bool isUnread, String platform) {
    return Column(
      children: [
        if (isUnread)
          Container(
            width: 2.w,
            height: 2.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        SizedBox(height: 1.h),
        CustomIconWidget(
          iconName: 'chevron_right',
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          size: 4.w,
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'เมื่อสักครู่';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} นาทีที่แล้ว';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} ชั่วโมงที่แล้ว';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} วันที่แล้ว';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year + 543}';
    }
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
      case 'youtube':
        return const Color(0xFFFF0000);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
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
      case 'youtube':
        return 'play_arrow';
      default:
        return 'message';
    }
  }
}
