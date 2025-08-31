import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_preferences_widget.dart';
import './widgets/connected_accounts_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/privacy_section_widget.dart';
import './widgets/profile_section_widget.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  bool _hasUnsavedChanges = false;

  // Mock user profile data
  final Map<String, dynamic> _userProfile = {
    "name": "สมชาย ใจดี",
    "bio":
        "นักการตลาดดิจิทัลที่หลงใหลในการสร้างเนื้อหาที่น่าสนใจ ชอบแชร์เทคนิคและประสบการณ์ในการทำ Social Media Marketing",
    "businessName": "Creative Digital Agency",
    "website": "https://creativedigital.co.th",
    "phone": "089-123-4567",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
  };

  // Mock connected accounts data
  final List<Map<String, dynamic>> _connectedAccounts = [
    {
      "platform": "facebook",
      "name": "Facebook",
      "username": "creativedigital.th",
      "icon": "facebook",
      "color": "0xFF1877F2",
      "isActive": true,
      "status": "connected",
    },
    {
      "platform": "instagram",
      "name": "Instagram",
      "username": "creativedigital_th",
      "icon": "camera_alt",
      "color": "0xFFE4405F",
      "isActive": true,
      "status": "connected",
    },
    {
      "platform": "twitter",
      "name": "Twitter",
      "username": "creativedigital_th",
      "icon": "alternate_email",
      "color": "0xFF1DA1F2",
      "isActive": false,
      "status": "expired",
    },
    {
      "platform": "linkedin",
      "name": "LinkedIn",
      "username": "creative-digital-agency",
      "icon": "work",
      "color": "0xFF0A66C2",
      "isActive": true,
      "status": "connected",
    },
  ];

  // Mock notification settings
  final Map<String, dynamic> _notificationSettings = {
    "pushNotifications": true,
    "emailNotifications": true,
    "scheduledPosts": true,
    "analytics": false,
    "platforms": {
      "Facebook": {
        "comments": true,
        "likes": true,
        "shares": false,
        "mentions": true,
        "messages": true,
        "followers": false,
      },
      "Instagram": {
        "comments": true,
        "likes": false,
        "shares": true,
        "mentions": true,
        "messages": true,
        "followers": true,
      },
      "Twitter": {
        "comments": true,
        "likes": false,
        "shares": true,
        "mentions": true,
        "messages": false,
        "followers": true,
      },
      "LinkedIn": {
        "comments": true,
        "likes": true,
        "shares": true,
        "mentions": true,
        "messages": true,
        "followers": false,
      },
    },
  };

  // Mock privacy settings
  final Map<String, dynamic> _privacySettings = {
    "profileVisibility": true,
    "analyticsSharing": true,
    "marketingEmails": false,
    "dataCollection": true,
  };

  // Mock app settings
  final Map<String, dynamic> _appSettings = {
    "theme": "system",
    "language": "th",
    "autoSaveDrafts": true,
    "analyticsOptOut": false,
    "crashReporting": true,
    "betaFeatures": false,
    "cacheImages": true,
    "offlineMode": true,
  };

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  void _onProfileUpdate(Map<String, dynamic> updatedProfile) {
    setState(() {
      _userProfile.addAll(updatedProfile);
      _hasUnsavedChanges = true;
    });
  }

  void _onAccountToggle(String platform, bool isActive) {
    setState(() {
      final accountIndex = _connectedAccounts
          .indexWhere((account) => account['platform'] == platform);
      if (accountIndex != -1) {
        _connectedAccounts[accountIndex]['isActive'] = isActive;
        _hasUnsavedChanges = true;
      }
    });
  }

  void _onReconnectAccount(String platform) {
    setState(() {
      final accountIndex = _connectedAccounts
          .indexWhere((account) => account['platform'] == platform);
      if (accountIndex != -1) {
        _connectedAccounts[accountIndex]['status'] = 'connected';
        _connectedAccounts[accountIndex]['isActive'] = true;
        _hasUnsavedChanges = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เชื่อมต่อ $platform สำเร็จแล้ว'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onAddAccount() {
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
              'เชื่อมต่อบัญชีใหม่',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            _buildAddAccountOption('TikTok', 'video_library', '0xFF000000'),
            _buildAddAccountOption(
                'YouTube', 'play_circle_filled', '0xFFFF0000'),
            _buildAddAccountOption('Pinterest', 'push_pin', '0xFFBD081C'),
            _buildAddAccountOption('Telegram', 'send', '0xFF0088CC'),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAccountOption(String name, String icon, String color) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        leading: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: Color(int.parse(color)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 6.w,
            ),
          ),
        ),
        title: Text(name),
        subtitle: Text('เชื่อมต่อบัญชี $name'),
        trailing: CustomIconWidget(
          iconName: 'add_circle_outline',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 6.w,
        ),
        onTap: () {
          Navigator.pop(context);
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('กำลังเชื่อมต่อ $name...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _onNotificationToggle(String key, bool value) {
    setState(() {
      if (key.contains('.')) {
        final parts = key.split('.');
        final platform = parts[0];
        final setting = parts[1];
        _notificationSettings['platforms'][platform][setting] = value;
      } else {
        _notificationSettings[key] = value;
      }
      _hasUnsavedChanges = true;
    });
  }

  void _onPrivacyToggle(String key, bool value) {
    setState(() {
      _privacySettings[key] = value;
      _hasUnsavedChanges = true;
    });
  }

  void _onExportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'download',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text('ส่งออกข้อมูล'),
          ],
        ),
        content: Text(
          'เราจะส่งไฟล์ข้อมูลทั้งหมดของคุณไปยังอีเมลที่ลงทะเบียนไว้ภายใน 24 ชั่วโมง',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('กำลังเตรียมข้อมูลสำหรับส่งออก...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('ส่งออก'),
          ),
        ],
      ),
    );
  }

  void _onDeleteAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บัญชีถูกลบเรียบร้อยแล้ว'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate to login screen after account deletion
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login-screen',
        (route) => false,
      );
    });
  }

  void _onSettingChange(String key, dynamic value) {
    setState(() {
      _appSettings[key] = value;
      _hasUnsavedChanges = true;
    });
  }

  void _saveChanges() {
    setState(() {
      _hasUnsavedChanges = false;
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text('บันทึกการตั้งค่าเรียบร้อยแล้ว'),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _cancelChanges() {
    if (_hasUnsavedChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ยกเลิกการเปลี่ยนแปลง'),
          content: Text(
              'คุณมีการเปลี่ยนแปลงที่ยังไม่ได้บันทึก ต้องการยกเลิกหรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('อยู่ต่อ'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text('ยกเลิก'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'ตั้งค่าบัญชี',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 5.w,
          ),
          onPressed: _cancelChanges,
        ),
        actions: [
          if (_hasUnsavedChanges) ...[
            TextButton(
              onPressed: _cancelChanges,
              child: Text(
                'ยกเลิก',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 4.w, left: 2.w),
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  minimumSize: Size(0, 5.h),
                ),
                child: Text('บันทึก'),
              ),
            ),
          ] else ...[
            IconButton(
              icon: CustomIconWidget(
                iconName: 'help_outline',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ช่วยเหลือและคำถามที่พบบ่อย'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ],
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 2.h),

            // Profile Section
            ProfileSectionWidget(
              userProfile: _userProfile,
              onProfileUpdate: _onProfileUpdate,
            ),

            // Connected Accounts Section
            ConnectedAccountsWidget(
              connectedAccounts: _connectedAccounts,
              onAccountToggle: _onAccountToggle,
              onReconnectAccount: _onReconnectAccount,
              onAddAccount: _onAddAccount,
            ),

            // Notification Preferences Section
            NotificationPreferencesWidget(
              notificationSettings: _notificationSettings,
              onNotificationToggle: _onNotificationToggle,
            ),

            // Privacy Section
            PrivacySectionWidget(
              privacySettings: _privacySettings,
              onPrivacyToggle: _onPrivacyToggle,
              onExportData: _onExportData,
              onDeleteAccount: _onDeleteAccount,
            ),

            // App Preferences Section
            AppPreferencesWidget(
              appSettings: _appSettings,
              onSettingChange: _onSettingChange,
            ),

            SizedBox(height: 4.h),

            // App Version Info
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Contentflow',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'เวอร์ชัน 1.2.0 (Build 120)',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '© 2024 Creative Digital Agency',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
