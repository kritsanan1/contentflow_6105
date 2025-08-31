import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';


/// Quick actions widget for common dashboard tasks
/// Provides easy access to frequently used features
class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.8,
          mainAxisSpacing: 3.w,
          crossAxisSpacing: 3.w,
          children: [
            _buildQuickActionCard(
              context,
              title: 'Create Post',
              subtitle: 'Start composing',
              icon: Icons.add_circle_outline,
              color: theme.colorScheme.primary,
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, '/post-composer');
              },
            ),
            _buildQuickActionCard(
              context,
              title: 'Schedule Content',
              subtitle: 'Plan ahead',
              icon: Icons.schedule_outlined,
              color: Colors.green,
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, '/content-calendar');
              },
            ),
            _buildQuickActionCard(
              context,
              title: 'View Analytics',
              subtitle: 'Track performance',
              icon: Icons.analytics_outlined,
              color: Colors.purple,
              onTap: () {
                HapticFeedback.lightImpact();
                // Navigate to analytics when route is added
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Analytics dashboard opened'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            _buildQuickActionCard(
              context,
              title: 'Check Messages',
              subtitle: 'Respond to audience',
              icon: Icons.message_outlined,
              color: Colors.orange,
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, '/messages-inbox');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(128),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withAlpha(128),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
