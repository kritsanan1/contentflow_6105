import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PlatformPreviewWidget extends StatefulWidget {
  final String content;
  final List<String> selectedPlatforms;
  final List<dynamic> media;

  const PlatformPreviewWidget({
    super.key,
    required this.content,
    required this.selectedPlatforms,
    required this.media,
  });

  @override
  State<PlatformPreviewWidget> createState() => _PlatformPreviewWidgetState();
}

class _PlatformPreviewWidgetState extends State<PlatformPreviewWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.selectedPlatforms.length,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(PlatformPreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedPlatforms.length != widget.selectedPlatforms.length) {
      _tabController.dispose();
      _tabController = TabController(
        length: widget.selectedPlatforms.length,
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildPlatformPreview(String platform) {
    final theme = Theme.of(context);

    switch (platform) {
      case 'Facebook':
        return _buildFacebookPreview(theme);
      case 'Instagram':
        return _buildInstagramPreview(theme);
      case 'Twitter':
        return _buildTwitterPreview(theme);
      case 'LinkedIn':
        return _buildLinkedInPreview(theme);
      default:
        return _buildGenericPreview(theme, platform);
    }
  }

  Widget _buildFacebookPreview(ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Facebook header
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 6.w,
                  backgroundColor: Color(0xFF1877F2),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Page Name',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '2 นาทีที่แล้ว',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'more_horiz',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
              ],
            ),
          ),
          // Content
          if (widget.content.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                widget.content,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            SizedBox(height: 2.h),
          ],
          // Media
          if (widget.media.isNotEmpty) ...[
            Container(
              height: 40.h,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Center(
                child: CustomIconWidget(
                  iconName: 'image',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 40,
                ),
              ),
            ),
          ],
          // Facebook actions
          Container(
            padding: EdgeInsets.all(3.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(theme, 'thumb_up', 'ถูกใจ'),
                _buildActionButton(theme, 'comment', 'แสดงความคิดเห็น'),
                _buildActionButton(theme, 'share', 'แชร์'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstagramPreview(ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instagram header
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFE4405F), Color(0xFFFCAF45)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 5.w,
                      backgroundColor: Colors.white,
                      child: CustomIconWidget(
                        iconName: 'person',
                        color: Color(0xFFE4405F),
                        size: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'your_username',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'สถานที่',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'more_vert',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
              ],
            ),
          ),
          // Media (Instagram is media-first)
          Container(
            height: 80.w,
            width: double.infinity,
            color: theme.colorScheme.surfaceContainerHighest,
            child: widget.media.isNotEmpty
                ? Center(
                    child: CustomIconWidget(
                      iconName: 'image',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 40,
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'add_photo_alternate',
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.3),
                          size: 40,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'เพิ่มรูปภาพหรือวิดีโอ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          // Instagram actions
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'favorite_border',
                      color: theme.colorScheme.onSurface,
                      size: 24,
                    ),
                    SizedBox(width: 4.w),
                    CustomIconWidget(
                      iconName: 'chat_bubble_outline',
                      color: theme.colorScheme.onSurface,
                      size: 24,
                    ),
                    SizedBox(width: 4.w),
                    CustomIconWidget(
                      iconName: 'send',
                      color: theme.colorScheme.onSurface,
                      size: 24,
                    ),
                    Spacer(),
                    CustomIconWidget(
                      iconName: 'bookmark_border',
                      color: theme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ],
                ),
                if (widget.content.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'your_username ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: widget.content,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwitterPreview(ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 6.w,
              backgroundColor: Color(0xFF1DA1F2),
              child: CustomIconWidget(
                iconName: 'person',
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Your Name',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '@username',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '· 2น',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                      Spacer(),
                      CustomIconWidget(
                        iconName: 'more_horiz',
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 16,
                      ),
                    ],
                  ),
                  if (widget.content.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    Text(
                      widget.content.length > 280
                          ? '${widget.content.substring(0, 277)}...'
                          : widget.content,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                  if (widget.media.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Container(
                      height: 30.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'image',
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTwitterAction(theme, 'chat_bubble_outline', '12'),
                      _buildTwitterAction(theme, 'repeat', '5'),
                      _buildTwitterAction(theme, 'favorite_border', '28'),
                      _buildTwitterAction(theme, 'share', ''),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkedInPreview(ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 6.w,
                  backgroundColor: Color(0xFF0A66C2),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Professional Name',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'ตำแหน่งงาน • 2 นาทีที่แล้ว',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'more_horiz',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                ),
              ],
            ),
          ),
          if (widget.content.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                widget.content,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            SizedBox(height: 2.h),
          ],
          if (widget.media.isNotEmpty) ...[
            Container(
              height: 40.h,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Center(
                child: CustomIconWidget(
                  iconName: 'image',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 40,
                ),
              ),
            ),
          ],
          Container(
            padding: EdgeInsets.all(3.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(theme, 'thumb_up', 'ถูกใจ'),
                _buildActionButton(theme, 'comment', 'แสดงความคิดเห็น'),
                _buildActionButton(theme, 'share', 'แชร์'),
                _buildActionButton(theme, 'send', 'ส่ง'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericPreview(ThemeData theme, String platform) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'ตัวอย่างสำหรับ $platform',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          if (widget.content.isNotEmpty)
            Text(
              widget.content,
              style: theme.textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(ThemeData theme, String iconName, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildTwitterAction(ThemeData theme, String iconName, String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          size: 16,
        ),
        if (count.isNotEmpty) ...[
          SizedBox(width: 1.w),
          Text(
            count,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.selectedPlatforms.isEmpty) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: Center(
          child: Column(
            children: [
              CustomIconWidget(
                iconName: 'preview',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                size: 40,
              ),
              SizedBox(height: 2.h),
              Text(
                'เลือกแพลตฟอร์มเพื่อดูตัวอย่าง',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ตัวอย่างโพสต์',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        if (widget.selectedPlatforms.length == 1)
          _buildPlatformPreview(widget.selectedPlatforms.first)
        else
          Column(
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: widget.selectedPlatforms.map((platform) {
                  return Tab(text: platform);
                }).toList(),
              ),
              SizedBox(
                height: 60.h,
                child: TabBarView(
                  controller: _tabController,
                  children: widget.selectedPlatforms.map((platform) {
                    return _buildPlatformPreview(platform);
                  }).toList(),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
