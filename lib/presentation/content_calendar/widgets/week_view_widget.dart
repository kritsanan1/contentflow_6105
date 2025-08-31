import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';


class WeekViewWidget extends StatelessWidget {
  final DateTime focusedWeek;
  final List<Map<String, dynamic>> posts;
  final Function(Map<String, dynamic>) onPostTap;
  final Function(DateTime) onTimeSlotTap;

  const WeekViewWidget({
    super.key,
    required this.focusedWeek,
    required this.posts,
    required this.onPostTap,
    required this.onTimeSlotTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weekDays = _getWeekDays(focusedWeek);

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
      child: Column(
        children: [
          // Week header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: weekDays.map((day) {
                final isToday = _isToday(day);
                return Expanded(
                  child: Column(
                    children: [
                      Text(
                        _getDayName(day.weekday),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Container(
                        width: 8.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: isToday
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isToday
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                              fontWeight:
                                  isToday ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          // Week timeline
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(24, (hour) {
                  return Container(
                    height: 8.h,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Time label
                        Container(
                          width: 15.w,
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Text(
                            '${hour.toString().padLeft(2, '0')}:00',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Day columns
                        Expanded(
                          child: Row(
                            children: weekDays.map((day) {
                              final dayPosts =
                                  _getPostsForDayAndHour(day, hour);
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    final dateTime = DateTime(
                                        day.year, day.month, day.day, hour);
                                    onTimeSlotTap(dateTime);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(0.5.w),
                                    decoration: BoxDecoration(
                                      color: dayPosts.isNotEmpty
                                          ? theme.colorScheme.primaryContainer
                                              .withValues(alpha: 0.3)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: dayPosts.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: dayPosts.length,
                                            itemBuilder: (context, index) {
                                              final post = dayPosts[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  onPostTap(post);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 0.2.h),
                                                  padding: EdgeInsets.all(1.w),
                                                  decoration: BoxDecoration(
                                                    color: _getPlatformColor(
                                                        post['platform']
                                                            as String),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Text(
                                                    post['title'] as String,
                                                    style: theme
                                                        .textTheme.labelSmall
                                                        ?.copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : null,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> _getWeekDays(DateTime focusedWeek) {
    final startOfWeek =
        focusedWeek.subtract(Duration(days: focusedWeek.weekday % 7));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  String _getDayName(int weekday) {
    const dayNames = ['อา', 'จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส'];
    return dayNames[weekday % 7];
  }

  List<Map<String, dynamic>> _getPostsForDayAndHour(DateTime day, int hour) {
    return posts.where((post) {
      final postDate = post['scheduledDate'] as DateTime;
      return postDate.year == day.year &&
          postDate.month == day.month &&
          postDate.day == day.day &&
          postDate.hour == hour;
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
