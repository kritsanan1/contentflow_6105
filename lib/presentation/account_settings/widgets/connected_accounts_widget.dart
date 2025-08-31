import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConnectedAccountsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> connectedAccounts;
  final Function(String, bool) onAccountToggle;
  final Function(String) onReconnectAccount;
  final VoidCallback onAddAccount;

  const ConnectedAccountsWidget({
    super.key,
    required this.connectedAccounts,
    required this.onAccountToggle,
    required this.onReconnectAccount,
    required this.onAddAccount,
  });

  @override
  State<ConnectedAccountsWidget> createState() =>
      _ConnectedAccountsWidgetState();
}

class _ConnectedAccountsWidgetState extends State<ConnectedAccountsWidget> {
  void _showAccountOptions(Map<String, dynamic> account) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: Color(int.parse(account['color'])),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: account['icon'],
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account['name'],
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    Text(
                      '@${account['username']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('เชื่อมต่อใหม่'),
              onTap: () {
                Navigator.pop(context);
                widget.onReconnectAccount(account['platform']);
                HapticFeedback.lightImpact();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              title: Text('ตั้งค่าบัญชี'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'link_off',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              title: Text(
                'ยกเลิกการเชื่อมต่อ',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDisconnectConfirmation(account);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showDisconnectConfirmation(Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยกเลิกการเชื่อมต่อ'),
        content: Text(
          'คุณต้องการยกเลิกการเชื่อมต่อกับ ${account['name']} หรือไม่?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onAccountToggle(account['platform'], false);
              HapticFeedback.lightImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('ยกเลิกการเชื่อมต่อ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'link',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'บัญชีที่เชื่อมต่อ',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: widget.onAddAccount,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'เพิ่ม',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          widget.connectedAccounts.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'link_off',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 10.w,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'ยังไม่มีบัญชีที่เชื่อมต่อ',
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'เชื่อมต่อบัญชีโซเชียลมีเดียเพื่อเริ่มจัดการเนื้อหา',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: widget.connectedAccounts.map((account) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: Color(int.parse(account['color'])),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: account['icon'],
                                color: Colors.white,
                                size: 6.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account['name'],
                                  style:
                                      AppTheme.lightTheme.textTheme.titleSmall,
                                ),
                                Text(
                                  '@${account['username']}',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                                if (account['status'] == 'expired')
                                  Container(
                                    margin: EdgeInsets.only(top: 0.5.h),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      vertical: 0.5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightTheme.colorScheme
                                          .errorContainer,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'หมดอายุ - ต้องเชื่อมต่อใหม่',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.error,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (account['status'] == 'expired')
                            TextButton(
                              onPressed: () {
                                widget.onReconnectAccount(account['platform']);
                                HapticFeedback.lightImpact();
                              },
                              child: Text('เชื่อมต่อใหม่'),
                            )
                          else
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  value: account['isActive'] ?? false,
                                  onChanged: (value) {
                                    widget.onAccountToggle(
                                        account['platform'], value);
                                    HapticFeedback.lightImpact();
                                  },
                                ),
                                SizedBox(width: 2.w),
                                GestureDetector(
                                  onTap: () => _showAccountOptions(account),
                                  child: Container(
                                    padding: EdgeInsets.all(2.w),
                                    child: CustomIconWidget(
                                      iconName: 'more_vert',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 5.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}
