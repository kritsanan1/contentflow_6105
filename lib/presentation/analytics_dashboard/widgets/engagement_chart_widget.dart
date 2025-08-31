import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


/// Engagement chart widget displaying engagement trends over time
/// Uses fl_chart to show interactive line chart with engagement data
class EngagementChartWidget extends StatefulWidget {
  const EngagementChartWidget({super.key});

  @override
  State<EngagementChartWidget> createState() => _EngagementChartWidgetState();
}

class _EngagementChartWidgetState extends State<EngagementChartWidget> {
  int _selectedDataSet = 0; // 0: Engagement, 1: Reach, 2: Impressions
  final List<String> _dataTypes = ['Engagement', 'Reach', 'Impressions'];

  // Sample data for demonstration
  final List<FlSpot> _engagementData = [
    const FlSpot(0, 3.2),
    const FlSpot(1, 4.1),
    const FlSpot(2, 2.8),
    const FlSpot(3, 5.3),
    const FlSpot(4, 4.7),
    const FlSpot(5, 6.2),
    const FlSpot(6, 5.8),
  ];

  final List<FlSpot> _reachData = [
    const FlSpot(0, 120),
    const FlSpot(1, 135),
    const FlSpot(2, 98),
    const FlSpot(3, 178),
    const FlSpot(4, 156),
    const FlSpot(5, 189),
    const FlSpot(6, 167),
  ];

  final List<FlSpot> _impressionsData = [
    const FlSpot(0, 245),
    const FlSpot(1, 289),
    const FlSpot(2, 267),
    const FlSpot(3, 312),
    const FlSpot(4, 278),
    const FlSpot(5, 334),
    const FlSpot(6, 298),
  ];

  @override
  Widget build(BuildContext context) {
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
                  'Engagement Trends',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                DropdownButton<int>(
                  value: _selectedDataSet,
                  underline: const SizedBox(),
                  items: _dataTypes.asMap().entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedDataSet = value);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 3.h),
            SizedBox(
              height: 40.h,
              child: LineChart(
                _buildLineChartData(theme),
                duration: const Duration(milliseconds: 250),
              ),
            ),
            SizedBox(height: 2.h),
            _buildChartLegend(context),
          ],
        ),
      ),
    );
  }

  LineChartData _buildLineChartData(ThemeData theme) {
    final Color primaryColor = theme.colorScheme.primary;
    final List<FlSpot> currentData = _getCurrentData();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: theme.colorScheme.outline.withAlpha(64),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style =
                  TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
              Widget text;
              switch (value.toInt()) {
                case 0:
                  text = const Text('Mon', style: style);
                  break;
                case 1:
                  text = const Text('Tue', style: style);
                  break;
                case 2:
                  text = const Text('Wed', style: style);
                  break;
                case 3:
                  text = const Text('Thu', style: style);
                  break;
                case 4:
                  text = const Text('Fri', style: style);
                  break;
                case 5:
                  text = const Text('Sat', style: style);
                  break;
                case 6:
                  text = const Text('Sun', style: style);
                  break;
                default:
                  text = const Text('', style: style);
                  break;
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: text,
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _getLeftTitlesInterval(),
            reservedSize: 40,
            getTitlesWidget: (double value, TitleMeta meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  _formatLeftTitleValue(value),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w400),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha(64),
        ),
      ),
      minX: 0,
      maxX: 6,
      minY: _getMinY(),
      maxY: _getMaxY(),
      lineBarsData: [
        LineChartBarData(
          spots: currentData,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              primaryColor,
              primaryColor.withAlpha(128),
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
              radius: 4,
              color: primaryColor,
              strokeWidth: 2,
              strokeColor: theme.colorScheme.surface,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                primaryColor.withAlpha(51),
                primaryColor.withAlpha(13),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              return LineTooltipItem(
                '${_dataTypes[_selectedDataSet]}\n${_formatTooltipValue(touchedSpot.y)}',
                TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  List<FlSpot> _getCurrentData() {
    switch (_selectedDataSet) {
      case 0:
        return _engagementData;
      case 1:
        return _reachData;
      case 2:
        return _impressionsData;
      default:
        return _engagementData;
    }
  }

  double _getMinY() {
    switch (_selectedDataSet) {
      case 0:
        return 0;
      case 1:
        return 50;
      case 2:
        return 200;
      default:
        return 0;
    }
  }

  double _getMaxY() {
    switch (_selectedDataSet) {
      case 0:
        return 8;
      case 1:
        return 200;
      case 2:
        return 350;
      default:
        return 8;
    }
  }

  double _getLeftTitlesInterval() {
    switch (_selectedDataSet) {
      case 0:
        return 2;
      case 1:
        return 50;
      case 2:
        return 50;
      default:
        return 2;
    }
  }

  String _formatLeftTitleValue(double value) {
    switch (_selectedDataSet) {
      case 0:
        return '${value.toInt()}%';
      case 1:
        return '${(value / 1000).toStringAsFixed(0)}K';
      case 2:
        return '${(value / 1000).toStringAsFixed(0)}K';
      default:
        return '${value.toInt()}%';
    }
  }

  String _formatTooltipValue(double value) {
    switch (_selectedDataSet) {
      case 0:
        return '${value.toStringAsFixed(1)}%';
      case 1:
        return '${(value * 1000).toStringAsFixed(0)}';
      case 2:
        return '${(value * 1000).toStringAsFixed(0)}';
      default:
        return '${value.toStringAsFixed(1)}%';
    }
  }

  Widget _buildChartLegend(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _dataTypes[_selectedDataSet],
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
