import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MediaPickerWidget extends StatefulWidget {
  final List<XFile> selectedMedia;
  final Function(List<XFile>) onMediaChanged;

  const MediaPickerWidget({
    super.key,
    required this.selectedMedia,
    required this.onMediaChanged,
  });

  @override
  State<MediaPickerWidget> createState() => _MediaPickerWidgetState();
}

class _MediaPickerWidgetState extends State<MediaPickerWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        List<XFile> updatedMedia = List.from(widget.selectedMedia);
        updatedMedia.addAll(images);
        widget.onMediaChanged(updatedMedia);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        List<XFile> updatedMedia = List.from(widget.selectedMedia);
        updatedMedia.add(video);
        widget.onMediaChanged(updatedMedia);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        List<XFile> updatedMedia = List.from(widget.selectedMedia);
        updatedMedia.add(photo);
        widget.onMediaChanged(updatedMedia);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _removeMedia(int index) {
    List<XFile> updatedMedia = List.from(widget.selectedMedia);
    updatedMedia.removeAt(index);
    widget.onMediaChanged(updatedMedia);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'สื่อ',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        if (widget.selectedMedia.isNotEmpty) ...[
          SizedBox(
            height: 20.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.selectedMedia.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final media = widget.selectedMedia[index];
                final isVideo = media.path.toLowerCase().contains('.mp4') ||
                    media.path.toLowerCase().contains('.mov') ||
                    media.path.toLowerCase().contains('.avi');

                return Stack(
                  children: [
                    Container(
                      width: 30.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: isVideo
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    color: theme
                                        .colorScheme.surfaceContainerHighest,
                                    child: Center(
                                      child: CustomIconWidget(
                                        iconName: 'play_circle_outline',
                                        color: theme.colorScheme.primary,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                        vertical: 0.5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.black.withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'วิดีโอ',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Image.network(
                                media.path,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: theme
                                        .colorScheme.surfaceContainerHighest,
                                    child: Center(
                                      child: CustomIconWidget(
                                        iconName: 'image',
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                        size: 30,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                    Positioned(
                      top: 1.h,
                      right: 2.w,
                      child: GestureDetector(
                        onTap: () => _removeMedia(index),
                        child: Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: 'close',
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
        ],
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickImages,
                icon: CustomIconWidget(
                  iconName: 'photo_library',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                label: Text('รูปภาพ'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickVideo,
                icon: CustomIconWidget(
                  iconName: 'videocam',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                label: Text('วิดีโอ'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _takePhoto,
                icon: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                label: Text('ถ่ายภาพ'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
