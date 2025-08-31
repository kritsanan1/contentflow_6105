import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarGridWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final List<Map<String, dynamic>> posts;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onDayLongPressed;
  final PageController pageController;

  const CalendarGridWidget({
    super.key,
    required this.focusedDay,
    this.selectedDay,
    required this.posts,
    required this.onDaySelected,
    required this.onDayLongPressed,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar<Map<String, dynamic>>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarFormat: CalendarFormat.month,
        pageJumpingEnabled: true,
        onDaySelected: onDaySelected,
        onDayLongPressed: (selectedDay, focusedDay) {
          HapticFeedback.mediumImpact();
          onDayLongPressed(selectedDay);
        },
        onPageChanged: (focusedDay) {
          // Handle page change if needed
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w500,
          ) ?? const TextStyle(),
          holidayTextStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w500,
          ) ?? const TextStyle(),
          defaultTextStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w400,
          ) ?? const TextStyle(),
          selectedTextStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ) ?? const TextStyle(),
          todayTextStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.w600,
          ) ?? const TextStyle(),
          selectedDecoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: theme.colorScheme.tertiary,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3,
          canMarkersOverflow: true,
          markersOffset: const PositionedOffset(bottom: 4),
          markerSize: 6,
          cellMargin: EdgeInsets.all(1.w),
          cellPadding: EdgeInsets.zero,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronVisible: false,
          rightChevronVisible: false,
          headerPadding: EdgeInsets.zero,
          headerMargin: EdgeInsets.zero,
          titleTextStyle: const TextStyle(fontSize: 0), // Hide default header
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ) ?? const TextStyle(),
          weekendStyle: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.error.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ) ?? const TextStyle(),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return const SizedBox.shrink();

            return Positioned(
              bottom: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: events.take(3).map((event) {
                  final eventMap = event;
                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: _getPlatformColor(eventMap['platform'] as String),
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
            );
          },
          defaultBuilder: (context, day, focusedDay) {
            final events = _getEventsForDay(day);
            return Container(
              margin: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${day.day}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (events.isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: events.take(2).map((event) {
                        final eventMap = event;
                        return Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: _getPlatformColor(
                                eventMap['platform'] as String),
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return posts.where((post) {
      final postDate = post['scheduledDate'] as DateTime;
      return isSameDay(postDate, day);
    }).toList();
  }

  Color _getPlatformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'tiktok':
        return const Color(0xFF000000);
      default:
        return Colors.grey;
    }
  }
}