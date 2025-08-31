import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/performance_summary_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/upcoming_schedule_widget.dart';

/// Dashboard screen serves as central command center for social media management
/// Provides comprehensive overview and quick access to platform features through bottom tab navigation
class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  bool _isLoading = true;
  bool _hasUnreadNotifications = true;
  bool _isRefreshing = false;

  // Sample data for connected accounts status
  final List<Map<String, dynamic>> _connectedAccounts = [
    {'platform': 'Instagram', 'status': 'active', 'health': true},
    {'platform': 'Twitter', 'status': 'active', 'health': true},
    {'platform': 'Facebook', 'status': 'expired', 'health': false},
    {'platform': 'LinkedIn', 'status': 'active', 'health': true},
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    // Simulate API calls for real-time data sync from connected social accounts
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _onNotificationsTap() {
    HapticFeedback.lightImpact();
    setState(() => _hasUnreadNotifications = false);
    // Navigate to notifications screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('การแจ้งเตือนถูกเปิด (Notifications opened)'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onSearchTap() {
    HapticFeedback.lightImpact();
    showSearch(
      context: context,
      delegate: _DashboardSearchDelegate(),
    );
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    setState(() => _isRefreshing = true);

    // Simulate pull-to-refresh functionality syncing real-time data
    await _loadDashboardData();

    setState(() => _isRefreshing = false);
  }

  void _navigateToAnalyticsDashboard() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/analytics-dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        showBackButton: false,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 24),
                onPressed: _onNotificationsTap,
              ),
              if (_hasUnreadNotifications)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.search, size: 24),
            onPressed: _onSearchTap,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dashboard Header with Thai timestamp formatting
                    const DashboardHeaderWidget(),
                    SizedBox(height: 3.h),

                    // Performance metrics in card format with trend indicators
                    const PerformanceSummaryWidget(),
                    SizedBox(height: 3.h),

                    // Quick action tiles with floating card design
                    const QuickActionsWidget(),
                    SizedBox(height: 3.h),

                    // Analytics preview section with drill-down navigation
                    _buildAnalyticsPreview(context),
                    SizedBox(height: 3.h),

                    // Recent activity feed with platform-specific icons
                    const RecentActivityWidget(),
                    SizedBox(height: 3.h),

                    // Connected accounts status bar
                    _buildConnectedAccountsStatus(context),
                    SizedBox(height: 3.h),

                    // Upcoming Schedule Preview
                    const UpcomingScheduleWidget(),

                    // Add bottom padding for better scrolling
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: BottomNavItem.calendar, // Home tab active
        onTap: (item) {
          if (item != BottomNavItem.calendar) {
            Navigator.pushNamed(
              context,
              CustomBottomBar.getRouteFromNavItem(item),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pushNamed(context, '/post-composer');
        },
        tooltip: 'Create Post',
        child: const Icon(Icons.add, size: 24),
      ),
    );
  }

  Widget _buildAnalyticsPreview(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Analytics Preview',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  onPressed: _navigateToAnalyticsDashboard,
                  icon: const Icon(Icons.analytics_outlined, size: 16),
                  label: const Text('View Full'),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                    child: _buildAnalyticsMetric(
                        'Reach', '45.2K', '+18%', Colors.blue)),
                SizedBox(width: 3.w),
                Expanded(
                    child: _buildAnalyticsMetric(
                        'Impressions', '89.1K', '+12%', Colors.green)),
                SizedBox(width: 3.w),
                Expanded(
                    child: _buildAnalyticsMetric(
                        'Engagement', '8.4%', '+5%', Colors.orange)),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.trending_up,
                      color: theme.colorScheme.primary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Performance up 12% this week',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsMetric(
      String label, String value, String change, Color color) {
    final theme = Theme.of(context);
    final isPositive = change.startsWith('+');

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(128),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: (isPositive ? Colors.green : Colors.red).withAlpha(26),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            change,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedAccountsStatus(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connected Accounts',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _connectedAccounts
                  .map((account) => _buildAccountChip(
                        context,
                        account['platform'],
                        account['health'],
                        account['status'],
                      ))
                  .toList(),
            ),
            if (_connectedAccounts
                .any((account) => account['status'] == 'expired')) ...[
              SizedBox(height: 1.h),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_outlined,
                        color: theme.colorScheme.error, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Some accounts need reconnection',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/account-settings'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 32),
                      ),
                      child: const Text('Fix'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccountChip(
      BuildContext context, String platform, bool health, String status) {
    final theme = Theme.of(context);
    final color = health ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(64)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getPlatformIcon(platform), size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            platform,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Icons.camera_alt_outlined;
      case 'twitter':
        return Icons.alternate_email;
      case 'facebook':
        return Icons.facebook;
      case 'linkedin':
        return Icons.business;
      default:
        return Icons.public;
    }
  }
}

/// Custom search delegate for dashboard search functionality with Thai support
class _DashboardSearchDelegate extends SearchDelegate<String> {
  final List<String> _searchOptions = [
    'Analytics',
    'Create Post',
    'Schedule Content',
    'Messages',
    'Account Settings',
    'Content Calendar',
    'Performance Report',
    'Instagram',
    'Twitter',
    'Facebook',
    'LinkedIn',
  ];

  @override
  String get searchFieldLabel => 'ค้นหาใน Dashboard...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final filteredOptions = _searchOptions
        .where((option) => option.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (filteredOptions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              'ไม่พบผลลัพธ์',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'ลองค้นหาคำอื่น',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(153),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredOptions.length,
      itemBuilder: (context, index) {
        final option = filteredOptions[index];
        return ListTile(
          leading: _getIconForOption(option),
          title: Text(option),
          onTap: () {
            close(context, option);
            _navigateToOption(context, option);
          },
        );
      },
    );
  }

  Icon _getIconForOption(String option) {
    switch (option.toLowerCase()) {
      case 'analytics':
        return const Icon(Icons.analytics_outlined);
      case 'create post':
        return const Icon(Icons.edit_outlined);
      case 'schedule content':
        return const Icon(Icons.schedule_outlined);
      case 'messages':
        return const Icon(Icons.message_outlined);
      case 'account settings':
        return const Icon(Icons.settings_outlined);
      case 'content calendar':
        return const Icon(Icons.calendar_month_outlined);
      default:
        return const Icon(Icons.search_outlined);
    }
  }

  void _navigateToOption(BuildContext context, String option) {
    switch (option.toLowerCase()) {
      case 'analytics':
        Navigator.pushNamed(context, '/analytics-dashboard');
        break;
      case 'create post':
        Navigator.pushNamed(context, '/post-composer');
        break;
      case 'messages':
        Navigator.pushNamed(context, '/messages-inbox');
        break;
      case 'account settings':
        Navigator.pushNamed(context, '/account-settings');
        break;
      case 'content calendar':
        Navigator.pushNamed(context, '/content-calendar');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigate to $option')),
        );
    }
  }
}
