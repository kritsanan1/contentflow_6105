import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesWidget extends StatefulWidget {
  final Map<String, dynamic> notificationSettings;
  final Function(String, bool) onNotificationToggle;

  const NotificationPreferencesWidget({
    super.key,
    required this.notificationSettings,
    required this.onNotificationToggle,
  });

  @override
  State<NotificationPreferencesWidget> createState() =>
      _NotificationPreferencesWidgetState();
}

class _NotificationPreferencesWidgetState
    extends State<NotificationPreferencesWidget> {
  void _showPlatformNotifications(String platform) {
    final platformSettings = widget.notificationSettings['platforms'][platform]
            as Map<String, dynamic>? ??
        {};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'การแจ้งเตือน $platform',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildPlatformNotificationTile(
                      platform: platform,
                      key: 'comments',
                      title: 'ความคิดเห็นใหม่',
                      subtitle: 'แจ้งเตือนเมื่อมีคนแสดงความคิดเห็น',
                      icon: 'comment',
                      value: platformSettings['comments'] ?? true,
                    ),
                    _buildPlatformNotificationTile(
                      platform: platform,
                      key: 'likes',
                      title: 'การกดไลค์',
                      subtitle: 'แจ้งเตือนเมื่อมีคนกดไลค์โพสต์',
                      icon: 'favorite',
                      value: platformSettings['likes'] ?? true,
                    ),
                    _buildPlatformNotificationTile(
                      platform: platform,
                      key: 'shares',
                      title: 'การแชร์',
                      subtitle: 'แจ้งเตือนเมื่อมีคนแชร์โพสต์',
                      icon: 'share',
                      value: platformSettings['shares'] ?? true,
                    ),
                    _buildPlatformNotificationTile(
                      platform: platform,
                      key: 'mentions',
                      title: 'การกล่าวถึง',
                      subtitle: 'แจ้งเตือนเมื่อมีคนกล่าวถึงคุณ',
                      icon: 'alternate_email',
                      value: platformSettings['mentions'] ?? true,
                    ),
                    _buildPlatformNotificationTile(
                      platform: platform,
                      key: 'messages',
                      title: 'ข้อความส่วนตัว',
                      subtitle: 'แจ้งเตือนข้อความส่วนตัว',
                      icon: 'message',
                      value: platformSettings['messages'] ?? true,
                    ),
                    _buildPlatformNotificationTile(
                      platform: platform,
                      key: 'followers',
                      title: 'ผู้ติดตามใหม่',
                      subtitle: 'แจ้งเตือนเมื่อมีผู้ติดตามใหม่',
                      icon: 'person_add',
                      value: platformSettings['followers'] ?? true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformNotificationTile({
    required String platform,
    required String key,
    required String title,
    required String subtitle,
    required String icon,
    required bool value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall,
                ),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              widget.onNotificationToggle('$platform.$key', newValue);
              HapticFeedback.lightImpact();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile({
    required String key,
    required String title,
    required String subtitle,
    required String icon,
    required bool value,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      ),
                      if (onTap != null) ...[
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: 'chevron_right',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 4.w,
                        ),
                      ],
                    ],
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          if (onTap == null)
            Switch(
              value: value,
              onChanged: (newValue) {
                widget.onNotificationToggle(key, newValue);
                HapticFeedback.lightImpact();
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'การแจ้งเตือน',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // General Notifications
          _buildNotificationTile(
            key: 'pushNotifications',
            title: 'การแจ้งเตือนแบบพุช',
            subtitle: 'รับการแจ้งเตือนบนอุปกรณ์',
            icon: 'notifications_active',
            value: widget.notificationSettings['pushNotifications'] ?? true,
          ),

          _buildNotificationTile(
            key: 'emailNotifications',
            title: 'การแจ้งเตือนทางอีเมล',
            subtitle: 'รับการแจ้งเตือนทางอีเมล',
            icon: 'email',
            value: widget.notificationSettings['emailNotifications'] ?? true,
          ),

          _buildNotificationTile(
            key: 'scheduledPosts',
            title: 'โพสต์ที่กำหนดเวลา',
            subtitle: 'แจ้งเตือนเมื่อโพสต์ถูกเผยแพร่',
            icon: 'schedule',
            value: widget.notificationSettings['scheduledPosts'] ?? true,
          ),

          _buildNotificationTile(
            key: 'analytics',
            title: 'รายงานประจำสัปดาห์',
            subtitle: 'รับสรุปผลงานประจำสัปดาห์',
            icon: 'analytics',
            value: widget.notificationSettings['analytics'] ?? true,
          ),

          // Platform-specific notifications
          Divider(height: 4.h),

          Text(
            'การแจ้งเตือนตามแพลตฟอร์ม',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          _buildNotificationTile(
            key: 'facebook',
            title: 'Facebook',
            subtitle: 'ตั้งค่าการแจ้งเตือนสำหรับ Facebook',
            icon: 'facebook',
            value: true,
            onTap: () => _showPlatformNotifications('Facebook'),
          ),

          _buildNotificationTile(
            key: 'instagram',
            title: 'Instagram',
            subtitle: 'ตั้งค่าการแจ้งเตือนสำหรับ Instagram',
            icon: 'camera_alt',
            value: true,
            onTap: () => _showPlatformNotifications('Instagram'),
          ),

          _buildNotificationTile(
            key: 'twitter',
            title: 'Twitter',
            subtitle: 'ตั้งค่าการแจ้งเตือนสำหรับ Twitter',
            icon: 'alternate_email',
            value: true,
            onTap: () => _showPlatformNotifications('Twitter'),
          ),

          _buildNotificationTile(
            key: 'linkedin',
            title: 'LinkedIn',
            subtitle: 'ตั้งค่าการแจ้งเตือนสำหรับ LinkedIn',
            icon: 'work',
            value: true,
            onTap: () => _showPlatformNotifications('LinkedIn'),
          ),
        ],
      ),
    );
  }
}
