import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacySectionWidget extends StatefulWidget {
  final Map<String, dynamic> privacySettings;
  final Function(String, bool) onPrivacyToggle;
  final VoidCallback onExportData;
  final VoidCallback onDeleteAccount;

  const PrivacySectionWidget({
    super.key,
    required this.privacySettings,
    required this.onPrivacyToggle,
    required this.onExportData,
    required this.onDeleteAccount,
  });

  @override
  State<PrivacySectionWidget> createState() => _PrivacySectionWidgetState();
}

class _PrivacySectionWidgetState extends State<PrivacySectionWidget> {
  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text('ลบบัญชี'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'การลบบัญชีจะทำให้:',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            SizedBox(height: 2.h),
            _buildDeleteWarningItem('ข้อมูลทั้งหมดถูกลบอย่างถาวร'),
            _buildDeleteWarningItem('โพสต์ที่กำหนดเวลาจะถูกยกเลิก'),
            _buildDeleteWarningItem('การเชื่อมต่อกับโซเชียลมีเดียจะถูกตัด'),
            _buildDeleteWarningItem('ไม่สามารถกู้คืนข้อมูลได้'),
            SizedBox(height: 2.h),
            Text(
              'คุณแน่ใจหรือไม่ที่ต้องการลบบัญชี?',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteConfirmation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('ลบบัญชี'),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation() {
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันการลบบัญชี'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'กรุณาพิมพ์ "ลบบัญชี" เพื่อยืนยัน:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                hintText: 'ลบบัญชี',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              confirmController.dispose();
              Navigator.pop(context);
            },
            child: Text('ยกเลิก'),
          ),
          StatefulBuilder(
            builder: (context, setState) => ElevatedButton(
              onPressed: confirmController.text == 'ลบบัญชี'
                  ? () {
                      confirmController.dispose();
                      Navigator.pop(context);
                      widget.onDeleteAccount();
                      HapticFeedback.heavyImpact();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text('ลบบัญชีถาวร'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteWarningItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.5.h),
            width: 1.w,
            height: 1.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.error,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyTile({
    required String key,
    required String title,
    required String subtitle,
    required String icon,
    bool? value,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: iconColor?.withValues(alpha: 0.1) ??
                  AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: iconColor ?? AppTheme.lightTheme.colorScheme.primary,
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
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: iconColor,
                        ),
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
          if (value != null)
            Switch(
              value: value,
              onChanged: (newValue) {
                widget.onPrivacyToggle(key, newValue);
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
                iconName: 'privacy_tip',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'ความเป็นส่วนตัว',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Privacy Settings
          _buildPrivacyTile(
            key: 'profileVisibility',
            title: 'โปรไฟล์สาธารณะ',
            subtitle: 'อนุญาตให้ผู้อื่นเห็นโปรไฟล์ของคุณ',
            icon: 'visibility',
            value: widget.privacySettings['profileVisibility'] ?? true,
          ),

          _buildPrivacyTile(
            key: 'analyticsSharing',
            title: 'แชร์ข้อมูลการใช้งาน',
            subtitle: 'ช่วยปรับปรุงแอปด้วยข้อมูลการใช้งาน',
            icon: 'analytics',
            value: widget.privacySettings['analyticsSharing'] ?? true,
          ),

          _buildPrivacyTile(
            key: 'marketingEmails',
            title: 'อีเมลการตลาด',
            subtitle: 'รับข้อมูลข่าวสารและโปรโมชั่น',
            icon: 'mail',
            value: widget.privacySettings['marketingEmails'] ?? false,
          ),

          _buildPrivacyTile(
            key: 'dataCollection',
            title: 'การเก็บข้อมูลขั้นสูง',
            subtitle: 'เก็บข้อมูลเพื่อปรับปรุงประสบการณ์',
            icon: 'storage',
            value: widget.privacySettings['dataCollection'] ?? true,
          ),

          Divider(height: 4.h),

          // Data Management
          Text(
            'การจัดการข้อมูล',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          _buildPrivacyTile(
            key: 'exportData',
            title: 'ส่งออกข้อมูล',
            subtitle: 'ดาวน์โหลดข้อมูลทั้งหมดของคุณ',
            icon: 'download',
            onTap: () {
              widget.onExportData();
              HapticFeedback.lightImpact();
            },
          ),

          _buildPrivacyTile(
            key: 'privacyPolicy',
            title: 'นโยบายความเป็นส่วนตัว',
            subtitle: 'อ่านนโยบายความเป็นส่วนตัวของเรา',
            icon: 'policy',
            onTap: () {
              HapticFeedback.lightImpact();
              // Open privacy policy
            },
          ),

          _buildPrivacyTile(
            key: 'termsOfService',
            title: 'ข้อกำหนดการใช้งาน',
            subtitle: 'อ่านข้อกำหนดการใช้งาน',
            icon: 'description',
            onTap: () {
              HapticFeedback.lightImpact();
              // Open terms of service
            },
          ),

          Divider(height: 4.h),

          // Danger Zone
          Text(
            'โซนอันตราย',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
          SizedBox(height: 2.h),

          _buildPrivacyTile(
            key: 'deleteAccount',
            title: 'ลบบัญชี',
            subtitle: 'ลบบัญชีและข้อมูลทั้งหมดอย่างถาวร',
            icon: 'delete_forever',
            iconColor: AppTheme.lightTheme.colorScheme.error,
            onTap: _showDeleteAccountConfirmation,
          ),
        ],
      ),
    );
  }
}
