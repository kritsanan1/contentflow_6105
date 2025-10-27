import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/config/api_config.dart';
import '../../data/models/social_media_message.dart';
import '../../data/services/social_media_service_factory.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/bulk_action_bar_widget.dart';
import './widgets/empty_messages_widget.dart';
import './widgets/message_card_widget.dart';
import './widgets/message_search_bar_widget.dart';
import './widgets/platform_filter_chip_widget.dart';

class MessagesInbox extends StatefulWidget {
  const MessagesInbox({super.key});

  @override
  State<MessagesInbox> createState() => _MessagesInboxState();
}

class _MessagesInboxState extends State<MessagesInbox>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedPlatform = 'all';
  String _searchQuery = '';
  bool _isBulkMode = false;
  Set<String> _selectedMessages = {};
  bool _isLoading = false;
  bool _isRefreshing = false;

  List<SocialMediaMessage> _allMessages = [];

  List<SocialMediaMessage> get _filteredMessages {
    List<SocialMediaMessage> filtered = _allMessages;

    // Filter by platform
    if (_selectedPlatform != 'all') {
      filtered = filtered
          .where((message) =>
              message.platform.toLowerCase() == _selectedPlatform.toLowerCase())
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((message) {
        final senderName = message.senderName.toLowerCase();
        final messageText = message.messageText.toLowerCase();
        final platform = message.platform.toLowerCase();
        final query = _searchQuery.toLowerCase();

        return senderName.contains(query) ||
            messageText.contains(query) ||
            platform.contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);

    try {
      final List<SocialMediaMessage> allPlatformMessages = [];

      for (final platform in ['facebook', 'instagram']) {
        if (SocialMediaServiceFactory.isPlatformSupported(platform)) {
          try {
            final service = SocialMediaServiceFactory.getService(platform);
            final messages = await service.getMessages(limit: 50);
            allPlatformMessages.addAll(messages);
          } catch (e) {
            print('Error loading messages from $platform: $e');
          }
        }
      }

      allPlatformMessages
          .sort((a, b) => b.timestamp.compareTo(a.timestamp));

      if (mounted) {
        setState(() {
          _allMessages = allPlatformMessages;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading messages: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _refreshMessages() async {
    setState(() => _isRefreshing = true);

    await _loadMessages();

    if (mounted) {
      setState(() => _isRefreshing = false);
      HapticFeedback.lightImpact();
    }
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
  }

  void _onPlatformFilterChanged(String platform) {
    setState(() => _selectedPlatform = platform);
    HapticFeedback.lightImpact();
  }

  void _toggleBulkMode() {
    setState(() {
      _isBulkMode = !_isBulkMode;
      if (!_isBulkMode) {
        _selectedMessages.clear();
      }
    });
    HapticFeedback.mediumImpact();
  }

  void _toggleMessageSelection(String messageId) {
    setState(() {
      if (_selectedMessages.contains(messageId)) {
        _selectedMessages.remove(messageId);
      } else {
        _selectedMessages.add(messageId);
      }
    });
    HapticFeedback.lightImpact();
  }

  void _selectAllMessages() {
    setState(() {
      _selectedMessages = _filteredMessages.map((m) => m.id).toSet();
    });
    HapticFeedback.lightImpact();
  }

  void _deselectAllMessages() {
    setState(() => _selectedMessages.clear());
    HapticFeedback.lightImpact();
  }

  void _handleBulkMarkAsRead() {
    // Handle bulk mark as read
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'ทำเครื่องหมาย ${_selectedMessages.length} ข้อความว่าอ่านแล้ว'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    setState(() {
      _selectedMessages.clear();
      _isBulkMode = false;
    });
  }

  void _handleBulkArchive() {
    // Handle bulk archive
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เก็บถาวร ${_selectedMessages.length} ข้อความแล้ว'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    setState(() {
      _selectedMessages.clear();
      _isBulkMode = false;
    });
  }

  void _handleBulkDelete() {
    // Handle bulk delete
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content:
            Text('คุณต้องการลบ ${_selectedMessages.length} ข้อความหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selectedMessages.clear();
                _isBulkMode = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ลบข้อความแล้ว'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _isBulkMode
          ? null
          : CustomAppBar.messagesInbox(
              key: const Key('messages_inbox_app_bar'),
              context: context,
            ),
      body: Column(
        children: [
          if (_isBulkMode)
            BulkActionBarWidget(
              selectedCount: _selectedMessages.length,
              onSelectAll: _selectAllMessages,
              onDeselectAll: _deselectAllMessages,
              onMarkAsRead: _handleBulkMarkAsRead,
              onArchive: _handleBulkArchive,
              onDelete: _handleBulkDelete,
              onCancel: () => setState(() {
                _isBulkMode = false;
                _selectedMessages.clear();
              }),
            ),
          if (!_isBulkMode) ...[
            MessageSearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: () => setState(() => _searchQuery = ''),
            ),
            _buildPlatformFilters(theme),
          ],
          Expanded(
            child: _buildMessagesList(theme),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar.main(
        context: context,
        currentIndex: BottomNavItem.messages,
      ),
      floatingActionButton: _filteredMessages.isNotEmpty && !_isBulkMode
          ? FloatingActionButton(
              onPressed: _toggleBulkMode,
              tooltip: 'จัดการหลายรายการ',
              child: CustomIconWidget(
                iconName: 'checklist',
                color: Colors.white,
                size: 6.w,
              ),
            )
          : null,
    );
  }

  Widget _buildPlatformFilters(ThemeData theme) {
    final platforms = [
      'all',
      'facebook',
      'instagram',
      'twitter',
      'linkedin',
      'youtube'
    ];

    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: platforms.length,
        itemBuilder: (context, index) {
          final platform = platforms[index];
          final messageCount = platform == 'all'
              ? _allMessages.length
              : _allMessages
                  .where((m) => m.platform.toLowerCase() == platform.toLowerCase())
                  .length;

          return PlatformFilterChipWidget(
            platform: platform,
            isSelected: _selectedPlatform == platform,
            messageCount: messageCount,
            onTap: () => _onPlatformFilterChanged(platform),
          );
        },
      ),
    );
  }

  Widget _buildMessagesList(ThemeData theme) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }

    if (_filteredMessages.isEmpty) {
      return _searchQuery.isNotEmpty || _selectedPlatform != 'all'
          ? _buildNoResultsWidget(theme)
          : const EmptyMessagesWidget();
    }

    return RefreshIndicator(
      onRefresh: _refreshMessages,
      color: theme.colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _filteredMessages.length,
        itemBuilder: (context, index) {
          final message = _filteredMessages[index];
          final messageId = message.id;
          final isSelected = _selectedMessages.contains(messageId);

          return GestureDetector(
            onLongPress: () {
              if (!_isBulkMode) {
                _toggleBulkMode();
                _toggleMessageSelection(messageId);
              }
            },
            child: Stack(
              children: [
                MessageCardWidget(
                  message: message.toMap(),
                  onTap: () {
                    if (_isBulkMode) {
                      _toggleMessageSelection(messageId);
                    } else {
                      // Navigate to chat interface
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('เปิดการสนทนากับ ${message.senderName}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  onReply: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('ตอบกลับ ${message.senderName}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onArchive: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('เก็บถาวรข้อความจาก ${message.senderName}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onDelete: () {
                    HapticFeedback.mediumImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('ลบข้อความจาก ${message.senderName}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                if (_isBulkMode)
                  Positioned(
                    top: 2.h,
                    right: 6.w,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? CustomIconWidget(
                              iconName: 'check',
                              color: Colors.white,
                              size: 3.w,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoResultsWidget(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 20.w,
            ),
            SizedBox(height: 3.h),
            Text(
              'ไม่พบข้อความ',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'ลองเปลี่ยนคำค้นหาหรือตัวกรองแพลตฟอร์ม',
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedPlatform = 'all';
                });
              },
              child: const Text('ล้างตัวกรอง'),
            ),
          ],
        ),
      ),
    );
  }
}
