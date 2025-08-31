import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Tab item configuration
class TabItem {
  final String label;
  final IconData? icon;
  final Widget? customWidget;
  final VoidCallback? onTap;

  const TabItem({
    required this.label,
    this.icon,
    this.customWidget,
    this.onTap,
  });
}

/// Custom tab bar widget for social media management app
/// Implements progressive disclosure and contextual navigation
class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<TabItem> tabs;
  final int initialIndex;
  final Function(int)? onTabChanged;
  final bool isScrollable;
  final TabAlignment tabAlignment;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final double indicatorWeight;
  final EdgeInsetsGeometry? labelPadding;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.isScrollable = false,
    this.tabAlignment = TabAlignment.center,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorWeight = 2.0,
    this.labelPadding,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// Factory constructor for content calendar tabs
  factory CustomTabBar.contentCalendar({
    Key? key,
    int initialIndex = 0,
    Function(int)? onTabChanged,
  }) {
    return CustomTabBar(
      key: key,
      initialIndex: initialIndex,
      onTabChanged: onTabChanged,
      isScrollable: true,
      tabs: const [
        TabItem(
          label: 'Today',
          icon: Icons.today_outlined,
        ),
        TabItem(
          label: 'This Week',
          icon: Icons.view_week_outlined,
        ),
        TabItem(
          label: 'This Month',
          icon: Icons.calendar_view_month_outlined,
        ),
        TabItem(
          label: 'Scheduled',
          icon: Icons.schedule_outlined,
        ),
        TabItem(
          label: 'Published',
          icon: Icons.published_with_changes_outlined,
        ),
      ],
    );
  }

  /// Factory constructor for post composer tabs
  factory CustomTabBar.postComposer({
    Key? key,
    int initialIndex = 0,
    Function(int)? onTabChanged,
  }) {
    return CustomTabBar(
      key: key,
      initialIndex: initialIndex,
      onTabChanged: onTabChanged,
      tabs: const [
        TabItem(
          label: 'Compose',
          icon: Icons.edit_outlined,
        ),
        TabItem(
          label: 'Media',
          icon: Icons.photo_library_outlined,
        ),
        TabItem(
          label: 'Schedule',
          icon: Icons.schedule_outlined,
        ),
        TabItem(
          label: 'Preview',
          icon: Icons.preview_outlined,
        ),
      ],
    );
  }

  /// Factory constructor for messages inbox tabs
  factory CustomTabBar.messagesInbox({
    Key? key,
    int initialIndex = 0,
    Function(int)? onTabChanged,
  }) {
    return CustomTabBar(
      key: key,
      initialIndex: initialIndex,
      onTabChanged: onTabChanged,
      isScrollable: true,
      tabs: const [
        TabItem(
          label: 'All',
          icon: Icons.inbox_outlined,
        ),
        TabItem(
          label: 'Unread',
          icon: Icons.mark_email_unread_outlined,
        ),
        TabItem(
          label: 'Comments',
          icon: Icons.comment_outlined,
        ),
        TabItem(
          label: 'Mentions',
          icon: Icons.alternate_email_outlined,
        ),
        TabItem(
          label: 'Direct',
          icon: Icons.message_outlined,
        ),
      ],
    );
  }

  /// Factory constructor for account settings tabs
  factory CustomTabBar.accountSettings({
    Key? key,
    int initialIndex = 0,
    Function(int)? onTabChanged,
  }) {
    return CustomTabBar(
      key: key,
      initialIndex: initialIndex,
      onTabChanged: onTabChanged,
      tabs: const [
        TabItem(
          label: 'Profile',
          icon: Icons.person_outline,
        ),
        TabItem(
          label: 'Accounts',
          icon: Icons.account_circle_outlined,
        ),
        TabItem(
          label: 'Notifications',
          icon: Icons.notifications_outlined,
        ),
        TabItem(
          label: 'Privacy',
          icon: Icons.privacy_tip_outlined,
        ),
      ],
    );
  }
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      HapticFeedback.lightImpact();
      widget.onTabChanged?.call(_tabController.index);
      widget.tabs[_tabController.index].onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withAlpha(51),
            width: 1.0,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: widget.tabs.map((tab) => _buildTab(context, tab)).toList(),
        isScrollable: widget.isScrollable,
        tabAlignment: widget.tabAlignment,
        indicatorColor: widget.indicatorColor ?? theme.colorScheme.primary,
        labelColor: widget.labelColor ?? theme.tabBarTheme.labelColor,
        unselectedLabelColor: widget.unselectedLabelColor ??
            theme.tabBarTheme.unselectedLabelColor,
        indicatorWeight: widget.indicatorWeight,
        labelPadding:
            widget.labelPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        labelStyle: theme.tabBarTheme.labelStyle?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: theme.tabBarTheme.unselectedLabelStyle?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  Widget _buildTab(BuildContext context, TabItem tab) {
    if (tab.customWidget != null) {
      return Tab(child: tab.customWidget);
    }

    if (tab.icon != null) {
      return Tab(
        icon: Icon(tab.icon, size: 20),
        text: tab.label,
        iconMargin: const EdgeInsets.only(bottom: 4),
      );
    }

    return Tab(text: tab.label);
  }
}

/// Tab view widget to work with CustomTabBar
class CustomTabView extends StatelessWidget {
  final TabController? controller;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const CustomTabView({
    super.key,
    this.controller,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        controller: controller,
        children: children.map((child) {
          return Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          );
        }).toList(),
      ),
    );
  }
}
