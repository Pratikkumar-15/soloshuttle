import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';
import '../../screens/training_session_screen.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String category; // 'Daily', 'Weekly', 'Coach', 'Achievement', 'Streak'
  final DateTime timestamp;
  final IconData icon;
  final Color accentColor;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.timestamp,
    required this.icon,
    required this.accentColor,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'n1',
      title: 'Protect Your Streak!',
      message: 'Don\'t break your streak! Complete today\'s drill to maintain your 12-day streak.',
      category: 'Streak',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      icon: Icons.local_fire_department_rounded,
      accentColor: AppColors.orange,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Coach Recommendation',
      message: 'Focus on soft knee landing when recovering to base after a jump smash today.',
      category: 'Coach',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      icon: Icons.tips_and_updates_rounded,
      accentColor: AppColors.purple,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Achievement Unlocked! 🏆',
      message: 'You earned the 12-Day Streak Master badge! +100 XP awarded.',
      category: 'Achievement',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      icon: Icons.emoji_events_rounded,
      accentColor: AppColors.electricGreen,
      isRead: true,
    ),
    NotificationItem(
      id: 'n4',
      title: 'Daily Training Alert',
      message: 'Keep your smash form sharp! Time for today\'s 15-minute footwork routine.',
      category: 'Daily',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.alarm_rounded,
      accentColor: AppColors.primaryGreen,
      isRead: true,
    ),
    NotificationItem(
      id: 'n5',
      title: 'Weekly Movement Progress',
      message: 'You are 2 sessions away from completing your 4-session weekly footwork target.',
      category: 'Weekly',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      icon: Icons.bar_chart_rounded,
      accentColor: AppColors.cyan,
      isRead: true,
    ),
  ];

  List<NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 'All') return _notifications;
    return _notifications.where((n) => n.category == _selectedFilter).toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$unreadCount NEW',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark All Read',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: ['All', 'Daily', 'Weekly', 'Coach', 'Achievement', 'Streak'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(filter),
                    labelStyle: GoogleFonts.poppins(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    selectedColor: AppColors.primaryGreen,
                    backgroundColor: AppColors.surface,
                    checkmarkColor: Colors.black,
                    onSelected: (_) => setState(() => _selectedFilter = filter),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Notifications List
          Expanded(
            child: _filteredNotifications.isEmpty
                ? Center(
                    child: Text(
                      'No notifications found.',
                      style: GoogleFonts.poppins(color: AppColors.textMuted),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredNotifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _filteredNotifications[index];
                      return AppCard(
                        backgroundColor: item.isRead
                            ? AppColors.surface
                            : AppColors.surfaceLight,
                        borderColor: item.isRead ? null : item.accentColor.withValues(alpha: 0.5),
                        onTap: () {
                          setState(() => item.isRead = true);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TrainingSessionScreen()),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: item.accentColor.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(item.icon, color: item.accentColor, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      BadgeTag(
                                        label: item.category,
                                        color: item.accentColor,
                                      ),
                                      Text(
                                        _formatTime(item.timestamp),
                                        style: GoogleFonts.poppins(
                                          color: AppColors.textMuted,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.title,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.message,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
