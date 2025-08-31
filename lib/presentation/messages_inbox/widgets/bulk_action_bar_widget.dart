import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BulkActionBarWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;
  final VoidCallback onMarkAsRead;
  final VoidCallback onArchive;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const BulkActionBarWidget({
    super.key,
    required this.selectedCount,
    required this.onSelectAll,
    required this.onDeselectAll,
    required this.onMarkAsRead,
    required this.onArchive,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildCancelButton(theme),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildSelectedCount(theme),
            ),
            _buildActionButtons(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onCancel();
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: CustomIconWidget(
            iconName: 'close',
            color: theme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCount(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$selectedCount รายการที่เลือก',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onSelectAll();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'เลือกทั้งหมด',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              ' • ',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onDeselectAll();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'ยกเลิกทั้งหมด',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        _buildActionButton(
          theme,
          icon: 'mark_email_read',
          onTap: onMarkAsRead,
          tooltip: 'ทำเครื่องหมายว่าอ่านแล้ว',
        ),
        SizedBox(width: 2.w),
        _buildActionButton(
          theme,
          icon: 'archive',
          onTap: onArchive,
          tooltip: 'เก็บถาวร',
        ),
        SizedBox(width: 2.w),
        _buildActionButton(
          theme,
          icon: 'delete',
          onTap: onDelete,
          tooltip: 'ลบ',
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    ThemeData theme, {
    required String icon,
    required VoidCallback onTap,
    required String tooltip,
    bool isDestructive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isDestructive
                  ? theme.colorScheme.error.withValues(alpha: 0.1)
                  : theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: isDestructive
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
              size: 5.w,
            ),
          ),
        ),
      ),
    );
  }
}
