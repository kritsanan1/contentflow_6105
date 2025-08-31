import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _progressAnimation;

  bool _isInitialized = false;
  String _initializationStatus = 'กำลังเริ่มต้น...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Progress animation controller
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    // Progress animation
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _startInitialization() async {
    try {
      // Start progress animation
      _progressAnimationController.forward();

      // Phase 1: Check authentication tokens
      await _updateProgress(0.2, 'กำลังตรวจสอบการเข้าสู่ระบบ...');
      await _simulateAuthCheck();

      // Phase 2: Load user preferences
      await _updateProgress(0.4, 'กำลังโหลดการตั้งค่า...');
      await _simulatePreferencesLoad();

      // Phase 3: Fetch social media configurations
      await _updateProgress(0.6, 'กำลังเชื่อมต่อบัญชีโซเชียลมีเดีย...');
      await _simulateSocialMediaConfig();

      // Phase 4: Prepare cached content
      await _updateProgress(0.8, 'กำลังเตรียมข้อมูลเนื้อหา...');
      await _simulateContentPreparation();

      // Phase 5: Complete initialization
      await _updateProgress(1.0, 'เสร็จสิ้น!');
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isInitialized = true;
      });

      // Navigate based on authentication status
      await _navigateToNextScreen();
    } catch (e) {
      await _handleInitializationError();
    }
  }

  Future<void> _updateProgress(double progress, String status) async {
    setState(() {
      _progress = progress;
      _initializationStatus = status;
    });
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _simulateAuthCheck() async {
    // Simulate checking authentication tokens
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _simulatePreferencesLoad() async {
    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _simulateSocialMediaConfig() async {
    // Simulate fetching social media account configurations
    await Future.delayed(const Duration(milliseconds: 700));
  }

  Future<void> _simulateContentPreparation() async {
    // Simulate preparing cached content data
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _navigateToNextScreen() async {
    // Simulate authentication check
    final bool isAuthenticated = await _checkAuthenticationStatus();

    if (!mounted) return;

    if (isAuthenticated) {
      // Navigate to content calendar (main dashboard)
      Navigator.pushReplacementNamed(context, '/content-calendar');
    } else {
      // Navigate to login screen
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    // Simulate checking stored authentication tokens
    await Future.delayed(const Duration(milliseconds: 200));
    // For demo purposes, return false to show login flow
    return false;
  }

  Future<void> _handleInitializationError() async {
    setState(() {
      _initializationStatus = 'เกิดข้อผิดพลาด กำลังลองใหม่...';
    });

    await Future.delayed(const Duration(seconds: 2));

    // Show retry option after 5 seconds
    if (mounted) {
      _showRetryDialog();
    }
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ไม่สามารถเชื่อมต่อได้',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ตและลองใหม่อีกครั้ง',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _retryInitialization();
              },
              child: const Text('ลองใหม่'),
            ),
          ],
        );
      },
    );
  }

  void _retryInitialization() {
    setState(() {
      _progress = 0.0;
      _initializationStatus = 'กำลังเริ่มต้น...';
      _isInitialized = false;
    });

    // Reset animations
    _progressAnimationController.reset();
    _startInitialization();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: _buildGradientBackground(),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAnimatedLogo(),
                        SizedBox(height: 8.h),
                        _buildAppTitle(),
                        SizedBox(height: 2.h),
                        _buildTagline(),
                        SizedBox(height: 12.h),
                        _buildProgressSection(),
                      ],
                    ),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.gradientStart,
          AppTheme.gradientEnd,
          AppTheme.primaryLight,
        ],
        stops: const [0.0, 0.7, 1.0],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoOpacityAnimation.value,
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'dynamic_feed',
                  color: AppTheme.primaryLight,
                  size: 12.w,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppTitle() {
    return AnimatedBuilder(
      animation: _logoOpacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _logoOpacityAnimation.value,
          child: Text(
            'ContentFlow',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                  letterSpacing: 1.2,
                ),
          ),
        );
      },
    );
  }

  Widget _buildTagline() {
    return AnimatedBuilder(
      animation: _logoOpacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _logoOpacityAnimation.value * 0.8,
          child: Text(
            'จัดการโซเชียลมีเดียด้วย AI',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
          ),
        );
      },
    );
  }

  Widget _buildProgressSection() {
    return Column(
      children: [
        _buildProgressIndicator(),
        SizedBox(height: 3.h),
        _buildStatusText(),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: 60.w,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(3),
      ),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _progress,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusText() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        _initializationStatus,
        key: ValueKey(_initializationStatus),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12.sp,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Column(
        children: [
          Text(
            'เวอร์ชัน 1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 10.sp,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            '© 2024 ContentFlow. สงวนลิขสิทธิ์',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 9.sp,
                ),
          ),
        ],
      ),
    );
  }
}
