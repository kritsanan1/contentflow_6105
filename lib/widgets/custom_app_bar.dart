import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar widget for social media management app
/// Implements contextual actions and professional minimalism design
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? theme.appBarTheme.foregroundColor,
        ),
      ),
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: onBackPressed ??
                      () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                )
              : null),
      actions: actions,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation,
      shadowColor: theme.colorScheme.shadow,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      bottom: bottom,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  /// Factory constructor for home screen app bar
  factory CustomAppBar.home({
    Key? key,
    required BuildContext context,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Social Hub',
      showBackButton: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 24),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Navigate to notifications
          },
        ),
        IconButton(
          icon: const Icon(Icons.search, size: 24),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Open search
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Factory constructor for content calendar app bar
  factory CustomAppBar.contentCalendar({
    Key? key,
    required BuildContext context,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Content Calendar',
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list, size: 24),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Show filter options
          },
        ),
        IconButton(
          icon: const Icon(Icons.calendar_view_month, size: 24),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Toggle calendar view
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Factory constructor for post composer app bar
  factory CustomAppBar.postComposer({
    Key? key,
    required BuildContext context,
    VoidCallback? onSave,
    VoidCallback? onSchedule,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Create Post',
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            onSave?.call();
          },
          child: const Text('Save'),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16, left: 8),
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onSchedule?.call();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: const Size(0, 36),
            ),
            child: const Text('Schedule'),
          ),
        ),
      ],
    );
  }

  /// Factory constructor for messages inbox app bar
  factory CustomAppBar.messagesInbox({
    Key? key,
    required BuildContext context,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Messages',
      actions: [
        IconButton(
          icon: const Icon(Icons.mark_email_read_outlined, size: 24),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Mark all as read
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, size: 24),
          onSelected: (value) {
            HapticFeedback.lightImpact();
            switch (value) {
              case 'filter':
                // Show filter options
                break;
              case 'settings':
                Navigator.pushNamed(context, '/account-settings');
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'filter',
              child: Row(
                children: [
                  Icon(Icons.filter_alt_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('Filter Messages'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('Settings'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Factory constructor for account settings app bar
  factory CustomAppBar.accountSettings({
    Key? key,
    required BuildContext context,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Account Settings',
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline, size: 24),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Show help
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
