import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppPreferencesWidget extends StatefulWidget {
  final Map<String, dynamic> appSettings;
  final Function(String, dynamic) onSettingChange;

  const AppPreferencesWidget({
    super.key,
    required this.appSettings,
    required this.onSettingChange,
  });

  @override
  State<AppPreferencesWidget> createState() => _AppPreferencesWidgetState();
}

class _AppPreferencesWidgetState extends State<AppPreferencesWidget> {
  void _showThemeSelector() {
    final currentTheme = widget.appSettings['theme'] ?? 'system';

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              'เลือกธีม',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            _buildThemeOption(
              value: 'light',
              title: 'สว่าง',
              subtitle: 'ใช้ธีมสว่างตลอดเวลา',
              icon: 'light_mode',
              isSelected: currentTheme == 'light',
            ),
            _buildThemeOption(
              value: 'dark',
              title: 'มืด',
              subtitle: 'ใช้ธีมมืดตลอดเวลา',
              icon: 'dark_mode',
              isSelected: currentTheme == 'dark',
            ),
            _buildThemeOption(
              value: 'system',
              title: 'ตามระบบ',
              subtitle: 'เปลี่ยนตามการตั้งค่าระบบ',
              icon: 'settings_brightness',
              isSelected: currentTheme == 'system',
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String value,
    required String title,
    required String subtitle,
    required String icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        widget.onSettingChange('theme', value);
        Navigator.pop(context);
        HapticFeedback.lightImpact();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: isSelected
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    final currentLanguage = widget.appSettings['language'] ?? 'th';

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              'เลือกภาษา',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            _buildLanguageOption(
              value: 'th',
              title: 'ไทย',
              subtitle: 'Thai',
              flag: '🇹🇭',
              isSelected: currentLanguage == 'th',
            ),
            _buildLanguageOption(
              value: 'en',
              title: 'English',
              subtitle: 'English',
              flag: '🇺🇸',
              isSelected: currentLanguage == 'en',
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String value,
    required String title,
    required String subtitle,
    required String flag,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        widget.onSettingChange('language', value);
        Navigator.pop(context);
        HapticFeedback.lightImpact();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  flag,
                  style: TextStyle(fontSize: 6.w),
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
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceTile({
    required String key,
    required String title,
    required String subtitle,
    required String icon,
    bool? value,
    VoidCallback? onTap,
    Widget? trailing,
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
          if (trailing != null)
            trailing
          else if (value != null)
            Switch(
              value: value,
              onChanged: (newValue) {
                widget.onSettingChange(key, newValue);
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
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'การตั้งค่าแอป',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Theme Setting
          _buildPreferenceTile(
            key: 'theme',
            title: 'ธีม',
            subtitle:
                _getThemeDisplayName(widget.appSettings['theme'] ?? 'system'),
            icon: 'palette',
            onTap: _showThemeSelector,
          ),

          // Language Setting
          _buildPreferenceTile(
            key: 'language',
            title: 'ภาษา',
            subtitle:
                _getLanguageDisplayName(widget.appSettings['language'] ?? 'th'),
            icon: 'language',
            onTap: _showLanguageSelector,
          ),

          // Auto-save drafts
          _buildPreferenceTile(
            key: 'autoSaveDrafts',
            title: 'บันทึกร่างอัตโนมัติ',
            subtitle: 'บันทึกโพสต์ที่ยังไม่เสร็จอัตโนมัติ',
            icon: 'save',
            value: widget.appSettings['autoSaveDrafts'] ?? true,
          ),

          // Analytics opt-out
          _buildPreferenceTile(
            key: 'analyticsOptOut',
            title: 'ปิดการวิเคราะห์',
            subtitle: 'ไม่ส่งข้อมูลการใช้งานเพื่อการวิเคราะห์',
            icon: 'analytics',
            value: widget.appSettings['analyticsOptOut'] ?? false,
          ),

          // Crash reporting
          _buildPreferenceTile(
            key: 'crashReporting',
            title: 'รายงานข้อผิดพลาด',
            subtitle: 'ส่งรายงานข้อผิดพลาดเพื่อปรับปรุงแอป',
            icon: 'bug_report',
            value: widget.appSettings['crashReporting'] ?? true,
          ),

          // Beta features
          _buildPreferenceTile(
            key: 'betaFeatures',
            title: 'ฟีเจอร์ทดลอง',
            subtitle: 'เปิดใช้ฟีเจอร์ใหม่ที่อยู่ในช่วงทดลอง',
            icon: 'science',
            value: widget.appSettings['betaFeatures'] ?? false,
          ),

          Divider(height: 4.h),

          // Storage & Cache
          Text(
            'การจัดเก็บข้อมูล',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          _buildPreferenceTile(
            key: 'cacheImages',
            title: 'แคชรูปภาพ',
            subtitle: 'เก็บรูปภาพไว้ในเครื่องเพื่อโหลดเร็วขึ้น',
            icon: 'image',
            value: widget.appSettings['cacheImages'] ?? true,
          ),

          _buildPreferenceTile(
            key: 'clearCache',
            title: 'ล้างแคช',
            subtitle: 'ล้างข้อมูลที่เก็บไว้ชั่วคราว',
            icon: 'clear_all',
            onTap: () {
              HapticFeedback.lightImpact();
              // Clear cache functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('ล้างแคชเรียบร้อยแล้ว'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),

          _buildPreferenceTile(
            key: 'offlineMode',
            title: 'โหมดออฟไลน์',
            subtitle: 'อนุญาตให้ใช้งานแอปแบบออฟไลน์',
            icon: 'offline_bolt',
            value: widget.appSettings['offlineMode'] ?? true,
          ),
        ],
      ),
    );
  }

  String _getThemeDisplayName(String theme) {
    switch (theme) {
      case 'light':
        return 'สว่าง';
      case 'dark':
        return 'มืด';
      case 'system':
        return 'ตามระบบ';
      default:
        return 'ตามระบบ';
    }
  }

  String _getLanguageDisplayName(String language) {
    switch (language) {
      case 'th':
        return 'ไทย';
      case 'en':
        return 'English';
      default:
        return 'ไทย';
    }
  }
}
