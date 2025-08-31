import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Navigation item for bottom bar
enum BottomNavItem {
  calendar,
  composer,
  messages,
  settings,
}

/// Custom bottom navigation bar for social media management app
/// Implements gesture-first navigation with contextual actions
class CustomBottomBar extends StatelessWidget {
  final BottomNavItem currentIndex;
  final Function(BottomNavItem) onTap;
  final bool showLabels;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(26),
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                item: BottomNavItem.calendar,
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month,
                label: 'Calendar',
                route: '/content-calendar',
              ),
              _buildNavItem(
                context,
                item: BottomNavItem.composer,
                icon: Icons.edit_outlined,
                activeIcon: Icons.edit,
                label: 'Compose',
                route: '/post-composer',
              ),
              _buildNavItem(
                context,
                item: BottomNavItem.messages,
                icon: Icons.message_outlined,
                activeIcon: Icons.message,
                label: 'Messages',
                route: '/messages-inbox',
              ),
              _buildNavItem(
                context,
                item: BottomNavItem.settings,
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'Settings',
                route: '/account-settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required BottomNavItem item,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
  }) {
    final theme = Theme.of(context);
    final isSelected = currentIndex == item;
    final selectedColor = theme.bottomNavigationBarTheme.selectedItemColor ??
        theme.colorScheme.primary;
    final unselectedColor =
        theme.bottomNavigationBarTheme.unselectedItemColor ??
            theme.colorScheme.onSurface.withAlpha(153);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          if (!isSelected) {
            onTap(item);
            Navigator.pushNamed(context, route);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor.withAlpha(26)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? selectedColor : unselectedColor,
                  size: 24,
                ),
              ),
              if (showLabels) ...[
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: theme.bottomNavigationBarTheme.selectedLabelStyle
                          ?.copyWith(
                        color: isSelected ? selectedColor : unselectedColor,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ) ??
                      TextStyle(
                        color: isSelected ? selectedColor : unselectedColor,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                  child: Text(label),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Factory constructor for main navigation
  factory CustomBottomBar.main({
    Key? key,
    required BuildContext context,
    required BottomNavItem currentIndex,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: (item) {
        // Handle navigation logic here if needed
      },
    );
  }

  /// Get current nav item from route
  static BottomNavItem getNavItemFromRoute(String route) {
    switch (route) {
      case '/content-calendar':
        return BottomNavItem.calendar;
      case '/post-composer':
        return BottomNavItem.composer;
      case '/messages-inbox':
        return BottomNavItem.messages;
      case '/account-settings':
        return BottomNavItem.settings;
      default:
        return BottomNavItem.calendar;
    }
  }

  /// Get route from nav item
  static String getRouteFromNavItem(BottomNavItem item) {
    switch (item) {
      case BottomNavItem.calendar:
        return '/content-calendar';
      case BottomNavItem.composer:
        return '/post-composer';
      case BottomNavItem.messages:
        return '/messages-inbox';
      case BottomNavItem.settings:
        return '/account-settings';
    }
  }
}
