import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/engagement_chart_widget.dart';
import './widgets/metrics_overview_widget.dart';
import './widgets/platform_performance_widget.dart';
import './widgets/quick_insights_widget.dart';
import './widgets/top_content_widget.dart';

/// Analytics Dashboard provides comprehensive social media performance insights
/// Features tabbed interface with Overview, Performance, Audience, and Content tabs
class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPeriod = 0; // 0: 7 Days, 1: 30 Days, 2: 3 Months
  bool _isLoading = true;
  String _selectedDateRange = '7 Days';
  String _comparisonPeriod = 'Previous Week';

  final List<Map<String, String>> _periods = [
    {'label': '7 Days', 'comparison': 'Previous Week'},
    {'label': '30 Days', 'comparison': 'Previous Month'},
    {'label': '3 Months', 'comparison': 'Previous 3 Months'},
  ];

  final List<String> _platformFilters = [
    'All',
    'Instagram',
    'Twitter',
    'Facebook',
    'LinkedIn'
  ];
  String _selectedPlatform = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Updated to 4 tabs
    _loadAnalyticsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() => _isLoading = true);

    // Simulate API call for analytics data
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _onPeriodChanged(int index) {
    setState(() {
      _selectedPeriod = index;
      _selectedDateRange = _periods[index]['label']!;
      _comparisonPeriod = _periods[index]['comparison']!;
    });
    _loadAnalyticsData();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterModal(),
    );
  }

  Future<void> _onRefresh() async {
    await _loadAnalyticsData();
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('รายงาน PDF กำลังส่งออก... (PDF report generating...)'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Analytics Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: _showFilterModal,
          ),
          PopupMenuButton<int>(
            icon: Icon(
              Icons.date_range_outlined,
              color: theme.colorScheme.onSurface,
            ),
            initialValue: _selectedPeriod,
            onSelected: _onPeriodChanged,
            itemBuilder: (context) => _periods
                .asMap()
                .entries
                .map((entry) => PopupMenuItem(
                      value: entry.key,
                      child: Row(
                        children: [
                          if (entry.key == _selectedPeriod)
                            Icon(
                              Icons.check,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                          if (entry.key == _selectedPeriod)
                            const SizedBox(width: 12),
                          Text(entry.value['label']!),
                        ],
                      ),
                    ))
                .toList(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'export':
                  _exportReport();
                  break;
                case 'refresh':
                  _onRefresh();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Export PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Refresh'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: Column(
                children: [
                  // Date range and comparison info bar
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    color: theme.colorScheme.surfaceContainer.withAlpha(128),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16,
                            color: theme.colorScheme.onSurface.withAlpha(153)),
                        const SizedBox(width: 8),
                        Text(
                          '$_selectedDateRange vs $_comparisonPeriod',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                        const Spacer(),
                        if (_selectedPlatform != 'All') ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha(26),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _selectedPlatform,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Tab bar with native platform patterns
                  Container(
                    color: theme.scaffoldBackgroundColor,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: false,
                      tabs: const [
                        Tab(
                            text: 'Overview',
                            icon: Icon(Icons.analytics_outlined, size: 18)),
                        Tab(
                            text: 'Performance',
                            icon: Icon(Icons.trending_up_outlined, size: 18)),
                        Tab(
                            text: 'Audience',
                            icon: Icon(Icons.people_outline, size: 18)),
                        Tab(
                            text: 'Content',
                            icon: Icon(Icons.content_copy_outlined, size: 18)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOverviewTab(),
                        _buildPerformanceTab(),
                        _buildAudienceTab(),
                        _buildContentTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: BottomNavItem
            .calendar, // Analytics would be part of dashboard navigation
        onTap: (item) {
          if (item != BottomNavItem.calendar) {
            Navigator.pushNamed(
              context,
              CustomBottomBar.getRouteFromNavItem(item),
            );
          }
        },
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key metrics summary with customizable date range
          const MetricsOverviewWidget(),
          SizedBox(height: 3.h),

          // Quick Insights powered by AI
          const QuickInsightsWidget(),
          SizedBox(height: 3.h),

          // Interactive line charts with pinch-to-zoom
          const EngagementChartWidget(),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform-specific performance breakdown
          const PlatformPerformanceWidget(),
          SizedBox(height: 3.h),

          // Engagement metrics breakdown
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Engagement Breakdown',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 2.h),
                  _buildEngagementMetric('Likes', '2,847', '+12%', Colors.red),
                  _buildEngagementMetric(
                      'Comments', '1,243', '+8%', Colors.blue),
                  _buildEngagementMetric('Shares', '567', '+15%', Colors.green),
                  _buildEngagementMetric('Saves', '892', '+22%', Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudienceTab() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Audience demographics with donut charts
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Audience Demographics',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Age demographics
                  _buildDemographicSection('Age Distribution', [
                    {'label': '18-24', 'value': '32%', 'color': Colors.blue},
                    {'label': '25-34', 'value': '45%', 'color': Colors.green},
                    {'label': '35-44', 'value': '18%', 'color': Colors.orange},
                    {'label': '45+', 'value': '5%', 'color': Colors.red},
                  ]),
                  SizedBox(height: 3.h),

                  // Gender demographics
                  _buildDemographicSection('Gender Distribution', [
                    {'label': 'Female', 'value': '58%', 'color': Colors.pink},
                    {'label': 'Male', 'value': '38%', 'color': Colors.blue},
                    {'label': 'Other', 'value': '4%', 'color': Colors.purple},
                  ]),
                  SizedBox(height: 3.h),

                  // Location data
                  _buildDemographicSection('Top Locations', [
                    {
                      'label': 'Bangkok',
                      'value': '35%',
                      'color': Colors.indigo
                    },
                    {
                      'label': 'Chiang Mai',
                      'value': '12%',
                      'color': Colors.teal
                    },
                    {'label': 'Phuket', 'value': '8%', 'color': Colors.amber},
                    {'label': 'Others', 'value': '45%', 'color': Colors.grey},
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top performing content with optimal posting time recommendations
          const TopContentWidget(),
          SizedBox(height: 3.h),

          // AI-powered posting recommendations
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'AI Insights & Recommendations',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildInsightItem(
                    'Optimal Posting Time',
                    'Best performance at 10:00 AM and 3:00 PM on weekdays',
                    Icons.schedule_outlined,
                    Colors.blue,
                  ),
                  _buildInsightItem(
                    'Content Type',
                    'Video posts get 45% more engagement than images',
                    Icons.video_library_outlined,
                    Colors.green,
                  ),
                  _buildInsightItem(
                    'Hashtag Strategy',
                    'Use 5-8 hashtags for optimal reach on Instagram',
                    Icons.tag_outlined,
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementMetric(
      String label, String value, String change, Color color) {
    final theme = Theme.of(context);
    final isPositive = change.startsWith('+');

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
      ),
    );
  }

  Widget _buildDemographicSection(
      String title, List<Map<String, dynamic>> data) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...data.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: item['color'],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item['label'])),
                  Text(
                    item['value'],
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildInsightItem(
      String title, String description, IconData icon, Color color) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(153),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterModal() {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) {
          return Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                // Title
                Text(
                  'Filter Analytics',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),

                // Platform filter
                Text(
                  'Platform',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 8,
                  children: _platformFilters
                      .map((platform) => FilterChip(
                            label: Text(platform),
                            selected: _selectedPlatform == platform,
                            onSelected: (selected) {
                              setState(() => _selectedPlatform = platform);
                              Navigator.pop(context);
                              _loadAnalyticsData();
                            },
                          ))
                      .toList(),
                ),
                SizedBox(height: 3.h),

                // Metric customization section
                Text(
                  'Metrics',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                const Text('Select which metrics to display in your dashboard'),
                SizedBox(height: 4.h),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _loadAnalyticsData();
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
