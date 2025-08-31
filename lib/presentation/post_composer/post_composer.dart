import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_options_widget.dart';
import './widgets/ai_assistance_widget.dart';
import './widgets/media_picker_widget.dart';
import './widgets/platform_preview_widget.dart';
import './widgets/platform_selector_widget.dart';
import './widgets/scheduling_widget.dart';

class PostComposer extends StatefulWidget {
  const PostComposer({super.key});

  @override
  State<PostComposer> createState() => _PostComposerState();
}

class _PostComposerState extends State<PostComposer>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFocusNode = FocusNode();

  List<String> _selectedPlatforms = [];
  List<XFile> _selectedMedia = [];
  DateTime? _scheduledDateTime;
  Map<String, dynamic> _advancedOptions = {
    'location': null,
    'audience': 'ทุกคน',
    'autoAdapt': false,
    'allowComments': true,
    'allowSharing': true,
  };

  bool _isDraftSaved = false;
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    _loadDraft();
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _scrollController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isDraftSaved = false;
    });
    _autoSaveDraft();
  }

  void _autoSaveDraft() {
    // Auto-save draft functionality
    Future.delayed(Duration(seconds: 2), () {
      if (!_isDraftSaved && mounted) {
        _saveDraft();
      }
    });
  }

  void _saveDraft() {
    // Save draft to local storage
    setState(() {
      _isDraftSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('บันทึกแบบร่างแล้ว'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _loadDraft() {
    // Load draft from local storage if exists
    // This would typically load from SharedPreferences or local database
  }

  bool _canPost() {
    return _textController.text.trim().isNotEmpty &&
        _selectedPlatforms.isNotEmpty &&
        !_isPosting;
  }

  int _getCharacterLimit() {
    if (_selectedPlatforms.isEmpty) return 280;

    final platformLimits = {
      'Facebook': 63206,
      'Instagram': 2200,
      'Twitter': 280,
      'LinkedIn': 3000,
    };

    int minLimit = platformLimits.values.first;
    for (String platform in _selectedPlatforms) {
      int limit = platformLimits[platform] ?? 280;
      if (limit < minLimit) {
        minLimit = limit;
      }
    }

    return minLimit;
  }

  Color _getCharacterCountColor() {
    final theme = Theme.of(context);
    final currentLength = _textController.text.length;
    final limit = _getCharacterLimit();

    if (currentLength > limit) {
      return theme.colorScheme.error;
    } else if (currentLength > limit * 0.9) {
      return AppTheme.warningLight;
    } else {
      return theme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }

  Future<void> _handlePost() async {
    if (!_canPost()) return;

    setState(() {
      _isPosting = true;
    });

    try {
      // Simulate posting process
      await Future.delayed(Duration(seconds: 2));

      if (_scheduledDateTime != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('กำหนดการโพสต์เรียบร้อยแล้ว'),
            backgroundColor: AppTheme.successLight,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('โพสต์เรียบร้อยแล้ว'),
            backgroundColor: AppTheme.successLight,
          ),
        );
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    } finally {
      setState(() {
        _isPosting = false;
      });
    }
  }

  void _handleCancel() {
    if (_textController.text.trim().isNotEmpty || _selectedMedia.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ยกเลิกการสร้างโพสต์?'),
          content: Text('การเปลี่ยนแปลงที่ยังไม่ได้บันทึกจะหายไป'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('ออก'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveDraft();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('บันทึกแบบร่าง'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: TextButton(
          onPressed: _handleCancel,
          child: Text(
            'ยกเลิก',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ),
        title: Text(
          'สร้างโพสต์',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: ElevatedButton(
              onPressed: _canPost() ? _handlePost : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _canPost()
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.12),
                foregroundColor: _canPost()
                    ? Colors.white
                    : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isPosting
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _scheduledDateTime != null ? 'กำหนดการ' : 'โพสต์',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Input Section
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _textFocusNode.hasFocus
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: _textFocusNode.hasFocus ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _textController,
                          focusNode: _textFocusNode,
                          maxLines: null,
                          minLines: 4,
                          decoration: InputDecoration(
                            hintText: 'เขียนโพสต์ของคุณที่นี่...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(4.w),
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          style: theme.textTheme.bodyMedium,
                          textInputAction: TextInputAction.newline,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_isDraftSaved)
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'check_circle',
                                      color: AppTheme.successLight,
                                      size: 16,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      'บันทึกแล้ว',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: AppTheme.successLight,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                SizedBox(),
                              Text(
                                '${_textController.text.length}/${_getCharacterLimit()}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: _getCharacterCountColor(),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Platform Selector
                  PlatformSelectorWidget(
                    selectedPlatforms: _selectedPlatforms,
                    onPlatformsChanged: (platforms) {
                      setState(() {
                        _selectedPlatforms = platforms;
                      });
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Media Picker
                  MediaPickerWidget(
                    selectedMedia: _selectedMedia,
                    onMediaChanged: (media) {
                      setState(() {
                        _selectedMedia = media;
                      });
                    },
                  ),

                  SizedBox(height: 4.h),

                  // AI Assistance
                  AiAssistanceWidget(
                    currentText: _textController.text,
                    selectedPlatforms: _selectedPlatforms,
                    onSuggestionAccepted: (suggestion) {
                      _textController.text = suggestion;
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Scheduling
                  SchedulingWidget(
                    scheduledDateTime: _scheduledDateTime,
                    onScheduleChanged: (dateTime) {
                      setState(() {
                        _scheduledDateTime = dateTime;
                      });
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Advanced Options
                  AdvancedOptionsWidget(
                    options: _advancedOptions,
                    onOptionsChanged: (options) {
                      setState(() {
                        _advancedOptions = options;
                      });
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Platform Preview
                  if (_selectedPlatforms.isNotEmpty)
                    PlatformPreviewWidget(
                      content: _textController.text,
                      selectedPlatforms: _selectedPlatforms,
                      media: _selectedMedia,
                    ),

                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),

          // Bottom Toolbar
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildToolbarButton(
                    theme,
                    'camera_alt',
                    'กล้อง',
                    () async {
                      final ImagePicker picker = ImagePicker();
                      try {
                        final XFile? photo = await picker.pickImage(
                          source: ImageSource.camera,
                        );
                        if (photo != null) {
                          setState(() {
                            _selectedMedia.add(photo);
                          });
                        }
                      } catch (e) {
                        // Handle error silently
                      }
                    },
                  ),
                  _buildToolbarButton(
                    theme,
                    'photo_library',
                    'คลัง',
                    () async {
                      final ImagePicker picker = ImagePicker();
                      try {
                        final List<XFile> images =
                            await picker.pickMultiImage();
                        if (images.isNotEmpty) {
                          setState(() {
                            _selectedMedia.addAll(images);
                          });
                        }
                      } catch (e) {
                        // Handle error silently
                      }
                    },
                  ),
                  _buildToolbarButton(
                    theme,
                    'template',
                    'เทมเพลต',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('คุณสมบัตินี้จะเปิดใช้งานเร็วๆ นี้'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(
    ThemeData theme,
    String iconName,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
