import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/content_calendar/content_calendar.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/account_settings/account_settings.dart';
import '../presentation/messages_inbox/messages_inbox.dart';
import '../presentation/post_composer/post_composer.dart';
import '../presentation/analytics_dashboard/analytics_dashboard.dart';
import '../presentation/main_dashboard/main_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String mainDashboard = '/main-dashboard';
  static const String dashboard = '/dashboard';
  static const String analyticsDashboard = '/analytics-dashboard';
  static const String contentCalendar = '/content-calendar';
  static const String login = '/login-screen';
  static const String accountSettings = '/account-settings';
  static const String messagesInbox = '/messages-inbox';
  static const String postComposer = '/post-composer';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const MainDashboard(),
    splash: (context) => const SplashScreen(),
    mainDashboard: (context) => const MainDashboard(),
    dashboard: (context) => const MainDashboard(),
    analyticsDashboard: (context) => const AnalyticsDashboard(),
    contentCalendar: (context) => const ContentCalendar(),
    login: (context) => const LoginScreen(),
    accountSettings: (context) => const AccountSettings(),
    messagesInbox: (context) => const MessagesInbox(),
    postComposer: (context) => const PostComposer(),
    // TODO: Add your other routes here
  };
}
