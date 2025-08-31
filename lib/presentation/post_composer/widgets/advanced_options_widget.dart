import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AdvancedOptionsWidget extends StatefulWidget {
  final Map<String, dynamic> options;
  final Function(Map<String, dynamic>) onOptionsChanged;

  const AdvancedOptionsWidget({
    super.key,
    required this.options,
    required this.onOptionsChanged,
  });

  @override
  State<AdvancedOptionsWidget> createState() => _AdvancedOptionsWidgetState();
}

class _AdvancedOptionsWidgetState extends State<AdvancedOptionsWidget> {
  bool _isExpanded = false;

  final List<String> _audienceOptions = [
    'ทุกคน',
    'เพื่อน',
    'เฉพาะฉัน',
    'กลุ่มเฉพาะ',
  ];

  final List<Map<String, dynamic>> _locationSuggestions = [
    {'name': 'กรุงเทพมหานคร', 'country': 'ประเทศไทย'},
    {'name': 'เชียงใหม่', 'country': 'ประเทศไทย'},
    {'name': 'ภูเก็ต', 'country': 'ประเทศไทย'},
    {'name': 'พัทยา', 'country': 'ประเทศไทย'},
  ];

  void _updateOption(String key, dynamic value) {
    Map<String, dynamic> updatedOptions = Map.from(widget.options);
    updatedOptions[key] = value;
    widget.onOptionsChanged(updatedOptions);
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
                      color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'tune',
                      color: theme.colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ตัวเลือกขั้นสูง',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _isExpanded
                              ? 'แตะเพื่อซ่อน'
                              : 'แตะเพื่อดูตัวเลือกเพิ่มเติม',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location Tagging
                        _buildSectionTitle('แท็กสถานที่', 'location_on'),
                        SizedBox(height: 1.h),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'ค้นหาสถานที่...',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: CustomIconWidget(
                                iconName: 'search',
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                size: 20,
                              ),
                            ),
                            suffixIcon: widget.options['location'] != null
                                ? IconButton(
                                    onPressed: () =>
                                        _updateOption('location', null),
                                    icon: CustomIconWidget(
                                      iconName: 'clear',
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                      size: 20,
                                    ),
                                  )
                                : null,
                          ),
                          onChanged: (value) => _updateOption(
                              'location', value.isNotEmpty ? value : null),
                        ),
                        if (widget.options['location'] == null ||
                            (widget.options['location'] as String).isEmpty) ...[
                          SizedBox(height: 1.h),
                          Wrap(
                            spacing: 2.w,
                            runSpacing: 1.h,
                            children: _locationSuggestions.map((location) {
                              return GestureDetector(
                                onTap: () =>
                                    _updateOption('location', location['name']),
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
                                  child: Text(
                                    location['name'],
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        SizedBox(height: 3.h),

                        // Audience Targeting
                        _buildSectionTitle('กลุ่มเป้าหมาย', 'group'),
                        SizedBox(height: 1.h),
                        DropdownButtonFormField<String>(
                          value:
                              widget.options['audience'] ?? _audienceOptions[0],
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                          ),
                          items: _audienceOptions.map((String audience) {
                            return DropdownMenuItem<String>(
                              value: audience,
                              child: Text(audience),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              _updateOption('audience', newValue);
                            }
                          },
                        ),

                        SizedBox(height: 3.h),

                        // Cross-platform Adaptation
                        _buildSectionTitle('ปรับเนื้อหาตามแพลตฟอร์ม', 'sync'),
                        SizedBox(height: 1.h),
                        SwitchListTile(
                          title: Text(
                            'ปรับเนื้อหาอัตโนมัติ',
                            style: theme.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            'ปรับความยาวและรูปแบบให้เหมาะกับแต่ละแพลตฟอร์ม',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                          value: widget.options['autoAdapt'] ?? false,
                          onChanged: (bool value) =>
                              _updateOption('autoAdapt', value),
                          contentPadding: EdgeInsets.zero,
                        ),

                        SizedBox(height: 2.h),

                        // Comments and Sharing
                        _buildSectionTitle('การโต้ตอบ', 'chat'),
                        SizedBox(height: 1.h),
                        SwitchListTile(
                          title: Text(
                            'อนุญาตให้แสดงความคิดเห็น',
                            style: theme.textTheme.bodyMedium,
                          ),
                          value: widget.options['allowComments'] ?? true,
                          onChanged: (bool value) =>
                              _updateOption('allowComments', value),
                          contentPadding: EdgeInsets.zero,
                        ),
                        SwitchListTile(
                          title: Text(
                            'อนุญาตให้แชร์',
                            style: theme.textTheme.bodyMedium,
                          ),
                          value: widget.options['allowSharing'] ?? true,
                          onChanged: (bool value) =>
                              _updateOption('allowSharing', value),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String iconName) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.primary,
          size: 18,
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
