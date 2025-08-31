import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileSectionWidget extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  final Function(Map<String, dynamic>) onProfileUpdate;

  const ProfileSectionWidget({
    super.key,
    required this.userProfile,
    required this.onProfileUpdate,
  });

  @override
  State<ProfileSectionWidget> createState() => _ProfileSectionWidgetState();
}

class _ProfileSectionWidgetState extends State<ProfileSectionWidget> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _businessNameController;
  late TextEditingController _websiteController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.userProfile['name'] ?? '');
    _bioController =
        TextEditingController(text: widget.userProfile['bio'] ?? '');
    _businessNameController =
        TextEditingController(text: widget.userProfile['businessName'] ?? '');
    _websiteController =
        TextEditingController(text: widget.userProfile['website'] ?? '');
    _phoneController =
        TextEditingController(text: widget.userProfile['phone'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _businessNameController.dispose();
    _websiteController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    final updatedProfile = {
      ...widget.userProfile,
      'name': _nameController.text,
      'bio': _bioController.text,
      'businessName': _businessNameController.text,
      'website': _websiteController.text,
      'phone': _phoneController.text,
    };
    widget.onProfileUpdate(updatedProfile);
    HapticFeedback.lightImpact();
  }

  void _changeAvatar() {
    HapticFeedback.lightImpact();
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
              'เปลี่ยนรูปโปรไฟล์',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption(
                  icon: 'camera_alt',
                  label: 'ถ่ายรูป',
                  onTap: () {
                    Navigator.pop(context);
                    // Camera functionality would be implemented here
                  },
                ),
                _buildAvatarOption(
                  icon: 'photo_library',
                  label: 'เลือกจากแกลเลอรี่',
                  onTap: () {
                    Navigator.pop(context);
                    // Gallery functionality would be implemented here
                  },
                ),
                _buildAvatarOption(
                  icon: 'delete',
                  label: 'ลบรูป',
                  onTap: () {
                    Navigator.pop(context);
                    // Remove avatar functionality
                  },
                ),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
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
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'ข้อมูลโปรไฟล์',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Avatar Section
          Center(
            child: GestureDetector(
              onTap: _changeAvatar,
              child: Stack(
                children: [
                  Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: widget.userProfile['avatar'] != null
                          ? CustomImageWidget(
                              imageUrl: widget.userProfile['avatar'],
                              width: 25.w,
                              height: 25.w,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: AppTheme
                                  .lightTheme.colorScheme.primaryContainer,
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: 'person',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 10.w,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'edit',
                          color: Colors.white,
                          size: 4.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4.h),

          // Name Field
          Text(
            'ชื่อ',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _nameController,
            onChanged: (_) => _updateProfile(),
            decoration: InputDecoration(
              hintText: 'กรอกชื่อของคุณ',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'person_outline',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Bio Field
          Text(
            'ประวัติย่อ',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _bioController,
            onChanged: (_) => _updateProfile(),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'เขียนประวัติย่อของคุณ',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'description',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Business Name Field
          Text(
            'ชื่อธุรกิจ',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _businessNameController,
            onChanged: (_) => _updateProfile(),
            decoration: InputDecoration(
              hintText: 'ชื่อธุรกิจหรือบริษัท',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'business',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Website Field
          Text(
            'เว็บไซต์',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _websiteController,
            onChanged: (_) => _updateProfile(),
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              hintText: 'https://example.com',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'language',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Phone Field
          Text(
            'เบอร์โทรศัพท์',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _phoneController,
            onChanged: (_) => _updateProfile(),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '08X-XXX-XXXX',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'phone',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
