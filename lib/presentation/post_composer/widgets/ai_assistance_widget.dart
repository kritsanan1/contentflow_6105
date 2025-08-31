import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AiAssistanceWidget extends StatefulWidget {
  final String currentText;
  final List<String> selectedPlatforms;
  final Function(String) onSuggestionAccepted;

  const AiAssistanceWidget({
    super.key,
    required this.currentText,
    required this.selectedPlatforms,
    required this.onSuggestionAccepted,
  });

  @override
  State<AiAssistanceWidget> createState() => _AiAssistanceWidgetState();
}

class _AiAssistanceWidgetState extends State<AiAssistanceWidget> {
  bool _isExpanded = false;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _suggestions = [
    {
      'type': 'hashtag',
      'title': 'แฮชแท็กแนะนำ',
      'items': [
        '#ContentCreator',
        '#SocialMedia',
        '#DigitalMarketing',
        '#Thailand',
        '#Inspiration'
      ],
    },
    {
      'type': 'time',
      'title': 'เวลาที่เหมาะสม',
      'items': ['18:00 - 20:00 น.', '12:00 - 14:00 น.', '20:00 - 22:00 น.'],
    },
    {
      'type': 'improvement',
      'title': 'ข้อเสนอแนะ',
      'items': [
        'เพิ่มคำถามเพื่อเพิ่มการมีส่วนร่วม',
        'ใช้อีโมจิเพื่อให้น่าสนใจมากขึ้น',
        'เพิ่มข้อมูลสถิติเพื่อความน่าเชื่อถือ',
      ],
    },
  ];

  void _acceptSuggestion(String suggestion, String type) {
    if (type == 'hashtag') {
      final newText = '${widget.currentText} $suggestion';
      widget.onSuggestionAccepted(newText);
    } else if (type == 'improvement') {
      // For improvements, we'll just show a toast or feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ข้อเสนอแนะ: $suggestion'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'auto_awesome',
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ผู้ช่วย AI',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _isExpanded ? 'แตะเพื่อซ่อน' : 'แตะเพื่อดูข้อเสนอแนะ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: Duration(milliseconds: 200),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _isExpanded ? null : 0,
            child: _isExpanded
                ? Container(
                    padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
                    child: Column(
                      children: _suggestions.map((suggestion) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 3.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                suggestion['title'],
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Wrap(
                                spacing: 2.w,
                                runSpacing: 1.h,
                                children: (suggestion['items'] as List<String>)
                                    .map((item) {
                                  return GestureDetector(
                                    onTap: () => _acceptSuggestion(
                                        item, suggestion['type']),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3.w,
                                        vertical: 1.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surface,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: theme.colorScheme.outline
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (suggestion['type'] == 'hashtag' ||
                                              suggestion['type'] ==
                                                  'improvement') ...[
                                            SizedBox(width: 1.w),
                                            CustomIconWidget(
                                              iconName: 'add',
                                              color: theme.colorScheme.primary,
                                              size: 16,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
