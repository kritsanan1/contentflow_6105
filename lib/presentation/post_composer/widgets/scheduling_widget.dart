import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SchedulingWidget extends StatefulWidget {
  final DateTime? scheduledDateTime;
  final Function(DateTime?) onScheduleChanged;

  const SchedulingWidget({
    super.key,
    required this.scheduledDateTime,
    required this.onScheduleChanged,
  });

  @override
  State<SchedulingWidget> createState() => _SchedulingWidgetState();
}

class _SchedulingWidgetState extends State<SchedulingWidget> {
  bool _isScheduled = false;
  DateTime? _selectedDateTime;

  final List<Map<String, dynamic>> _recommendedTimes = [
    {
      'time': '12:00',
      'label': 'เที่ยง',
      'description': 'เหมาะสำหรับข่าวสารและข้อมูล',
    },
    {
      'time': '18:00',
      'label': 'เย็น',
      'description': 'เวลาที่มีการมีส่วนร่วมสูงสุด',
    },
    {
      'time': '20:00',
      'label': 'ค่ำ',
      'description': 'เหมาะสำหรับเนื้อหาบันเทิง',
    },
  ];

  @override
  void initState() {
    super.initState();
    _isScheduled = widget.scheduledDateTime != null;
    _selectedDateTime = widget.scheduledDateTime;
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now().add(Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      locale: Locale('th', 'TH'),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _selectedDateTime ?? DateTime.now().add(Duration(hours: 1)),
        ),
      );

      if (pickedTime != null) {
        final DateTime newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _selectedDateTime = newDateTime;
        });
        widget.onScheduleChanged(newDateTime);
      }
    }
  }

  void _selectRecommendedTime(String time) {
    final now = DateTime.now();
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    DateTime recommendedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has passed today, schedule for tomorrow
    if (recommendedDateTime.isBefore(now)) {
      recommendedDateTime = recommendedDateTime.add(Duration(days: 1));
    }

    setState(() {
      _selectedDateTime = recommendedDateTime;
    });
    widget.onScheduleChanged(recommendedDateTime);
  }

  void _toggleScheduling(bool value) {
    setState(() {
      _isScheduled = value;
      if (!value) {
        _selectedDateTime = null;
        widget.onScheduleChanged(null);
      }
    });
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม'
    ];

    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year + 543} เวลา ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} น.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'กำหนดเวลาโพสต์',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Switch(
              value: _isScheduled,
              onChanged: _toggleScheduling,
            ),
          ],
        ),
        if (_isScheduled) ...[
          SizedBox(height: 2.h),
          if (_selectedDateTime != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'กำหนดการโพสต์',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _formatDateTime(_selectedDateTime!),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
          ],
          OutlinedButton.icon(
            onPressed: _selectDate,
            icon: CustomIconWidget(
              iconName: 'calendar_today',
              color: theme.colorScheme.primary,
              size: 20,
            ),
            label: Text(_selectedDateTime == null
                ? 'เลือกวันและเวลา'
                : 'เปลี่ยนวันและเวลา'),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 6.h),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'เวลาที่แนะนำ',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Column(
            children: _recommendedTimes.map((timeSlot) {
              return Container(
                margin: EdgeInsets.only(bottom: 1.h),
                child: ListTile(
                  onTap: () => _selectRecommendedTime(timeSlot['time']),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  leading: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CustomIconWidget(
                      iconName: 'access_time',
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '${timeSlot['time']} น. (${timeSlot['label']})',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    timeSlot['description'],
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 16,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
