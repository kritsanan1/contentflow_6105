import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlatformFilterChipWidget extends StatelessWidget {
  final String platform;
  final bool isSelected;
  final VoidCallback onTap;
  final int messageCount;

  const PlatformFilterChipWidget({
    super.key,
    required this.platform,
    required this.isSelected,
    required this.onTap,
    this.messageCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final platformColor = _getPlatformColor(platform);

    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? platformColor.withValues(alpha: 0.1)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? platformColor
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: platformColor.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: _getPlatformIcon(platform),
                  color: isSelected
                      ? platformColor
                      : theme.colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  _getPlatformDisplayName(platform),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? platformColor
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (messageCount > 0) ...[
                  SizedBox(width: 1.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 1.5.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? platformColor
                          : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      messageCount > 99 ? '99+' : messageCount.toString(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 8.sp,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPlatformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'all':
        return AppTheme.lightTheme.colorScheme.primary;
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
      case 'all':
        return 'inbox';
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

  String _getPlatformDisplayName(String platform) {
    switch (platform.toLowerCase()) {
      case 'all':
        return 'ทั้งหมด';
      case 'facebook':
        return 'Facebook';
      case 'instagram':
        return 'Instagram';
      case 'twitter':
        return 'Twitter';
      case 'linkedin':
        return 'LinkedIn';
      case 'tiktok':
        return 'TikTok';
      case 'youtube':
        return 'YouTube';
      default:
        return platform;
    }
  }
}
