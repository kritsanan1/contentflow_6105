import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SocialLoginWidget extends StatelessWidget {
  final bool isLoading;

  const SocialLoginWidget({
    super.key,
    this.isLoading = false,
  });

  void _handleSocialLogin(BuildContext context, String platform) {
    HapticFeedback.lightImpact();

    // Mock social login implementation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('กำลังเข้าสู่ระบบด้วย $platform...'),
        duration: const Duration(seconds: 2),
      ),
    );

    // Simulate login delay
    Future.delayed(const Duration(seconds: 1), () {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/content-calendar');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'หรือ',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Social Login Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Google Login
            _buildSocialButton(
              context,
              onTap: () => _handleSocialLogin(context, 'Google'),
              icon: 'g_translate',
              label: 'Google',
              backgroundColor: Colors.white,
              borderColor: theme.colorScheme.outline.withValues(alpha: 0.3),
              textColor: theme.colorScheme.onSurface,
            ),

            // Facebook Login
            _buildSocialButton(
              context,
              onTap: () => _handleSocialLogin(context, 'Facebook'),
              icon: 'facebook',
              label: 'Facebook',
              backgroundColor: const Color(0xFF1877F2),
              borderColor: const Color(0xFF1877F2),
              textColor: Colors.white,
            ),

            // LinkedIn Login
            _buildSocialButton(
              context,
              onTap: () => _handleSocialLogin(context, 'LinkedIn'),
              icon: 'business',
              label: 'LinkedIn',
              backgroundColor: const Color(0xFF0A66C2),
              borderColor: const Color(0xFF0A66C2),
              textColor: Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required VoidCallback onTap,
    required String icon,
    required String label,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: OutlinedButton(
          onPressed: isLoading ? null : onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            side: BorderSide(color: borderColor, width: 1),
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: icon,
                color: textColor,
                size: 20,
              ),
              SizedBox(height: 0.5.h),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
