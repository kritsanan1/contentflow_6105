import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PlatformSelectorWidget extends StatefulWidget {
  final List<String> selectedPlatforms;
  final Function(List<String>) onPlatformsChanged;

  const PlatformSelectorWidget({
    super.key,
    required this.selectedPlatforms,
    required this.onPlatformsChanged,
  });

  @override
  State<PlatformSelectorWidget> createState() => _PlatformSelectorWidgetState();
}

class _PlatformSelectorWidgetState extends State<PlatformSelectorWidget> {
  final List<Map<String, dynamic>> platforms = [
    {
      'name': 'Facebook',
      'icon': 'facebook',
      'color': Color(0xFF1877F2),
      'limit': 63206,
    },
    {
      'name': 'Instagram',
      'icon': 'camera_alt',
      'color': Color(0xFFE4405F),
      'limit': 2200,
    },
    {
      'name': 'Twitter',
      'icon': 'alternate_email',
      'color': Color(0xFF1DA1F2),
      'limit': 280,
    },
    {
      'name': 'LinkedIn',
      'icon': 'business',
      'color': Color(0xFF0A66C2),
      'limit': 3000,
    },
  ];

  void _togglePlatform(String platformName) {
    List<String> updatedPlatforms = List.from(widget.selectedPlatforms);

    if (updatedPlatforms.contains(platformName)) {
      updatedPlatforms.remove(platformName);
    } else {
      updatedPlatforms.add(platformName);
    }

    widget.onPlatformsChanged(updatedPlatforms);
  }

  int _getCharacterLimit() {
    if (widget.selectedPlatforms.isEmpty) return 280;

    int minLimit = platforms
        .where(
            (platform) => widget.selectedPlatforms.contains(platform['name']))
        .map((platform) => platform['limit'] as int)
        .reduce((a, b) => a < b ? a : b);

    return minLimit;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'เลือกแพลตฟอร์ม',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 3.w,
          runSpacing: 1.h,
          children: platforms.map((platform) {
            final isSelected =
                widget.selectedPlatforms.contains(platform['name']);

            return GestureDetector(
              onTap: () => _togglePlatform(platform['name']),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (platform['color'] as Color).withValues(alpha: 0.1)
                      : theme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? platform['color'] as Color
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: platform['icon'],
                      color: isSelected
                          ? platform['color'] as Color
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      platform['name'],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? platform['color'] as Color
                            : theme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.selectedPlatforms.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'ขีดจำกัดตัวอักษร: ${_getCharacterLimit().toString()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
