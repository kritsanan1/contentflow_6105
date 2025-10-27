import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../data/models/social_media_post.dart';
import '../../data/services/social_media_service_factory.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/calendar_grid_widget.dart';
import './widgets/calendar_header_widget.dart';
import './widgets/day_detail_sheet_widget.dart';
import './widgets/platform_filter_widget.dart';
import './widgets/scheduling_bottom_sheet_widget.dart';
import './widgets/week_view_widget.dart';

class ContentCalendar extends StatefulWidget {
  const ContentCalendar({super.key});

  @override
  State<ContentCalendar> createState() => _ContentCalendarState();
}

class _ContentCalendarState extends State<ContentCalendar>
    with TickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isWeekView = false;
  List<String> _selectedPlatforms = ['ทั้งหมด'];
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<SocialMediaPost> _scheduledPosts = [];

  final List<Map<String, dynamic>> _mockScheduledPosts = [
    {
      "id": 1,
      "title": "เปิดตัวผลิตภัณฑ์ใหม่ล่าสุด",
      "content":
          "ร่วมค้นพบนวัตกรรมใหม่ที่จะเปลี่ยนแปลงวิธีการทำงานของคุณ พร้อมฟีเจอร์ที่ล้ำสมัยและการออกแบบที่ใช้งานง่าย",
      "platform": "Facebook",
      "scheduledDate": DateTime.now().add(const Duration(days: 1, hours: 9)),
      "status": "scheduled",
      "imageUrl":
          "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=500&h=300&fit=crop",
      "aiOptimized": true,
    },
    {
      "id": 2,
      "title": "เคล็ดลับการใช้งานแอปพลิเคชัน",
      "content":
          "5 เทคนิคง่ายๆ ที่จะช่วยให้คุณใช้งานแอปได้อย่างมีประสิทธิภาพมากขึ้น",
      "platform": "Instagram",
      "scheduledDate": DateTime.now().add(const Duration(days: 2, hours: 14)),
      "status": "scheduled",
      "imageUrl":
          "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=500&h=300&fit=crop",
      "aiOptimized": false,
    },
    {
      "id": 3,
      "title": "อัปเดตข่าวสารจากทีมพัฒนา",
      "content":
          "ข่าวดีสำหรับผู้ใช้งาน! เรากำลังพัฒนาฟีเจอร์ใหม่ที่น่าตื่นเต้น",
      "platform": "Twitter",
      "scheduledDate": DateTime.now().add(const Duration(days: 3, hours: 16)),
      "status": "draft",
      "imageUrl":
          "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=500&h=300&fit=crop",
      "aiOptimized": true,
    },
    {
      "id": 4,
      "title": "บทความเชิงลึกเกี่ยวกับเทรนด์ใหม่",
      "content":
          "วิเคราะห์เทรนด์เทคโนโลยีที่กำลังมาแรงในปี 2024 และผลกระทบต่อธุรกิจ",
      "platform": "LinkedIn",
      "scheduledDate": DateTime.now().add(const Duration(days: 5, hours: 10)),
      "status": "scheduled",
      "imageUrl":
          "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=500&h=300&fit=crop",
      "aiOptimized": true,
    },
    {
      "id": 5,
      "title": "วิดีโอสั้นแนะนำฟีเจอร์",
      "content": "คลิปสั้นๆ แสดงการใช้งานฟีเจอร์ใหม่ที่น่าสนใจ",
      "platform": "TikTok",
      "scheduledDate": DateTime.now().add(const Duration(days: 7, hours: 19)),
      "status": "scheduled",
      "imageUrl":
          "https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=500&h=300&fit=crop",
      "aiOptimized": false,
    },
    {
      "id": 6,
      "title": "เนื้อหาสำหรับวันหยุดพิเศษ",
      "content": "ส่งความสุขในวันหยุดพิเศษให้กับลูกค้าและผู้ติดตาม",
      "platform": "Facebook",
      "scheduledDate": DateTime.now().add(const Duration(days: 10, hours: 12)),
      "status": "published",
      "imageUrl":
          "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=500&h=300&fit=crop",
      "aiOptimized": true,
    },
  ];

  // Mock data for optimal time slots
  final List<Map<String, dynamic>> _optimalTimeSlots = [
    {
      "time": "09:00",
      "platform": "Facebook",
      "isOptimal": true,
      "expectedEngagement": "สูง (85%)",
    },
    {
      "time": "11:30",
      "platform": "Instagram",
      "isOptimal": true,
      "expectedEngagement": "สูง (78%)",
    },
    {
      "time": "14:00",
      "platform": "LinkedIn",
      "isOptimal": false,
      "expectedEngagement": "ปานกลาง (65%)",
    },
    {
      "time": "16:30",
      "platform": "Twitter",
      "isOptimal": false,
      "expectedEngagement": "ปานกลาง (60%)",
    },
    {
      "time": "19:00",
      "platform": "Instagram",
      "isOptimal": true,
      "expectedEngagement": "สูงมาก (92%)",
    },
    {
      "time": "20:30",
      "platform": "TikTok",
      "isOptimal": true,
      "expectedEngagement": "สูงมาก (88%)",
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final List<SocialMediaPost> allPlatformPosts = [];

      for (final platform in ['facebook', 'instagram']) {
        if (SocialMediaServiceFactory.isPlatformSupported(platform)) {
          try {
            final service = SocialMediaServiceFactory.getService(platform);
            final posts = await service.getPosts(limit: 100);
            allPlatformPosts.addAll(posts);
          } catch (e) {
            print('Error loading posts from $platform: $e');
          }
        }
      }

      allPlatformPosts.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));

      if (mounted) {
        setState(() {
          _scheduledPosts = allPlatformPosts;
        });
      }
    } catch (e) {
      print('Error loading posts: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.contentCalendar(context: context),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: theme.colorScheme.primary,
          child: Column(
            children: [
              // Calendar Header
              CalendarHeaderWidget(
                currentDate: _focusedDay,
                isWeekView: _isWeekView,
                onToggleView: _toggleView,
                onTodayPressed: _goToToday,
                onPreviousMonth: _previousMonth,
                onNextMonth: _nextMonth,
              ),
              // Platform Filter
              PlatformFilterWidget(
                selectedPlatforms: _selectedPlatforms,
                onPlatformToggle: _togglePlatformFilter,
              ),
              SizedBox(height: 2.h),
              // Calendar Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isWeekView
                      ? WeekViewWidget(
                          key: const ValueKey('week_view'),
                          focusedWeek: _focusedDay,
                          posts: _getFilteredPosts(),
                          onPostTap: _handlePostTap,
                          onTimeSlotTap: _handleTimeSlotTap,
                        )
                      : CalendarGridWidget(
                          key: const ValueKey('month_view'),
                          focusedDay: _focusedDay,
                          selectedDay: _selectedDay,
                          posts: _getFilteredPosts(),
                          onDaySelected: _handleDaySelected,
                          onDayLongPressed: _handleDayLongPressed,
                          pageController: _pageController,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewPost,
        icon: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onPrimary,
          size: 20,
        ),
        label: Text(
          'สร้างโพสต์',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      bottomNavigationBar: CustomBottomBar.main(
        context: context,
        currentIndex: BottomNavItem.calendar,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    await _loadPosts();
  }

  void _toggleView() {
    setState(() {
      _isWeekView = !_isWeekView;
    });
  }

  void _goToToday() {
    setState(() {
      _focusedDay = DateTime.now();
      _selectedDay = DateTime.now();
    });
  }

  void _previousMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
    });
  }

  void _togglePlatformFilter(String platform) {
    setState(() {
      if (platform == 'ทั้งหมด') {
        _selectedPlatforms = ['ทั้งหมด'];
      } else {
        _selectedPlatforms.remove('ทั้งหมด');
        if (_selectedPlatforms.contains(platform)) {
          _selectedPlatforms.remove(platform);
          if (_selectedPlatforms.isEmpty) {
            _selectedPlatforms = ['ทั้งหมด'];
          }
        } else {
          _selectedPlatforms.add(platform);
        }
      }
    });
  }

  List<Map<String, dynamic>> _getFilteredPosts() {
    if (_selectedPlatforms.contains('ทั้งหมด')) {
      return _scheduledPosts.map((post) => post.toMap()).toList();
    }
    return _scheduledPosts
        .where((post) => _selectedPlatforms.contains(post.platform))
        .map((post) => post.toMap())
        .toList();
  }

  void _handleDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    final dayPosts = _getPostsForDay(selectedDay);
    _showDayDetailSheet(selectedDay, dayPosts);
  }

  void _handleDayLongPressed(DateTime selectedDay) {
    _showSchedulingBottomSheet(selectedDay);
  }

  void _handleTimeSlotTap(DateTime dateTime) {
    _showSchedulingBottomSheet(dateTime);
  }

  void _handlePostTap(Map<String, dynamic> post) {
    // Navigate to post detail or edit
    Navigator.pushNamed(context, '/post-composer', arguments: post);
  }

  List<Map<String, dynamic>> _getPostsForDay(DateTime day) {
    return _getFilteredPosts().where((post) {
      final postDate = post['scheduledDate'] as DateTime;
      return postDate.year == day.year &&
          postDate.month == day.month &&
          postDate.day == day.day;
    }).toList();
  }

  void _showDayDetailSheet(
      DateTime selectedDate, List<Map<String, dynamic>> dayPosts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DayDetailSheetWidget(
        selectedDate: selectedDate,
        dayPosts: dayPosts,
        onPostTap: _handlePostTap,
        onPostEdit: _handlePostEdit,
        onPostDelete: _handlePostDelete,
        onCreatePost: _createNewPost,
      ),
    );
  }

  void _showSchedulingBottomSheet(DateTime selectedDate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SchedulingBottomSheetWidget(
        selectedDate: selectedDate,
        availableTimeSlots: _optimalTimeSlots,
        onTimeSlotSelected: _handleTimeSlotSelected,
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _handlePostEdit(Map<String, dynamic> post) {
    Navigator.pop(context); // Close bottom sheet
    Navigator.pushNamed(context, '/post-composer', arguments: post);
  }

  void _handlePostDelete(Map<String, dynamic> post) {
    Navigator.pop(context); // Close bottom sheet
    _showDeleteConfirmation(post);
  }

  void _showDeleteConfirmation(Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ลบโพสต์'),
        content: Text('คุณต้องการลบโพสต์ "${post['title']}" หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final postId = post['id'].toString();
                final platform = post['platform'].toString().toLowerCase();

                if (SocialMediaServiceFactory.isPlatformSupported(platform)) {
                  final service = SocialMediaServiceFactory.getService(platform);
                  await service.deletePost(postId);
                }

                setState(() {
                  _scheduledPosts.removeWhere((p) => p.id == postId);
                });

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ลบโพสต์เรียบร้อยแล้ว')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เกิดข้อผิดพลาดในการลบโพสต์: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('ลบ'),
          ),
        ],
      ),
    );
  }

  void _handleTimeSlotSelected(DateTime dateTime, String platform) {
    Navigator.pop(context); // Close bottom sheet
    Navigator.pushNamed(
      context,
      '/post-composer',
      arguments: {
        'scheduledDate': dateTime,
        'platform': platform,
      },
    );
  }

  void _createNewPost() {
    Navigator.pushNamed(context, '/post-composer');
  }
}
