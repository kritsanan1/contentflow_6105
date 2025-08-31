import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PlatformFilterWidget extends StatelessWidget {
  final List<String> selectedPlatforms;
  final Function(String) onPlatformToggle;

  const PlatformFilterWidget({
    super.key,
    required this.selectedPlatforms,
    required this.onPlatformToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final platforms = [
      {
        'name': 'ทั้งหมด',
        'icon': 'select_all',
        'color': theme.colorScheme.primary
      },
      {
        'name': 'Facebook',
        'icon': 'facebook',
        'color': const Color(0xFF1877F2)
      },
      {
        'name': 'Instagram',
        'icon': 'camera_alt',
        'color': const Color(0xFFE4405F)
      },
      {
        'name': 'Twitter',
        'icon': 'alternate_email',
        'color': const Color(0xFF1DA1F2)
      },
      {'name': 'LinkedIn', 'icon': 'work', 'color': const Color(0xFF0A66C2)},
      {
        'name': 'TikTok',
        'icon': 'music_note',
        'color': const Color(0xFF000000)
      },
    ];

    return Container(
      height: 6.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: platforms.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final platform = platforms[index];
          final isSelected = selectedPlatforms.contains(platform['name']);

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onPlatformToggle(platform['name'] as String);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? (platform['color'] as Color).withValues(alpha: 0.1)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? (platform['color'] as Color)
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: platform['icon'] as String,
                    color: isSelected
                        ? (platform['color'] as Color)
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    platform['name'] as String,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? (platform['color'] as Color)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
