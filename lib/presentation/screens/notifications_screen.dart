import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/notification_provider.dart';
import '../widgets/app_card.dart';
import '../widgets/badge_tag.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifProvider = Provider.of<NotificationProvider>(context);
    final notifications = notifProvider.notifications;
    final unreadCount = notifProvider.unreadCount;

    return Scaffold(
      backgroundColor: AppColors.courtBackground,
      appBar: AppBar(
        backgroundColor: AppColors.courtBackground,
        elevation: 0,
        title: Text(
          'Notification Center & Reminders',
          style: GoogleFonts.poppins(
            color: AppColors.chalkWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                notifProvider.markAllAsRead();
              },
              child: Text(
                'Mark all read',
                style: GoogleFonts.jetBrainsMono(
                  color: AppColors.limeGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. DAILY SWEET REMINDERS CONTROL CARD
            Text(
              'DAILY TRAINING REMINDERS',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.corkGold,
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Scheduled Morning & Night Alerts',
              style: GoogleFonts.bebasNeue(
                color: AppColors.chalkWhite,
                fontSize: 24,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),

            // Morning Reminder Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.courtSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.corkGold.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.corkGold
                                    .withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.wb_sunny_rounded,
                                color: AppColors.corkGold,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notifProvider.morningPrepTitle,
                                    style: GoogleFonts.inter(
                                      color: AppColors.chalkWhite,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Interactive Time Selector Pill
                                  InkWell(
                                    onTap: () async {
                                      final pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime: notifProvider.morningTime,
                                        builder: (context, child) {
                                          return Theme(
                                            data: ThemeData.dark().copyWith(
                                              colorScheme: const ColorScheme.dark(
                                                primary: AppColors.corkGold,
                                                surface: AppColors.courtSurface,
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (pickedTime != null) {
                                        HapticFeedback.mediumImpact();
                                        notifProvider.setMorningTime(pickedTime);
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.corkGold
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.corkGold
                                              .withValues(alpha: 0.4),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.access_time_rounded,
                                              color: AppColors.corkGold,
                                              size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            notifProvider.formatTimeOfDay(
                                                notifProvider.morningTime),
                                            style: GoogleFonts.jetBrainsMono(
                                              color: AppColors.corkGold,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.edit_rounded,
                                              color: AppColors.corkGold,
                                              size: 11),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: notifProvider.isMorningReminderEnabled,
                        activeThumbColor: AppColors.corkGold,
                        onChanged: (val) {
                          HapticFeedback.lightImpact();
                          notifProvider.toggleMorningReminder(val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.courtBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '"${notifProvider.morningPrepGreeting} Consistency builds elite champions. Step onto the court with focus!"',
                      style: GoogleFonts.inter(
                        color: AppColors.chalkWhite.withValues(alpha: 0.85),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Night Reminder Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.courtSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.skyBlue.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.skyBlue
                                    .withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.nights_stay_rounded,
                                color: AppColors.skyBlue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Night Mental Reset',
                                    style: GoogleFonts.inter(
                                      color: AppColors.chalkWhite,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Interactive Time Selector Pill
                                  InkWell(
                                    onTap: () async {
                                      final pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime: notifProvider.nightTime,
                                        builder: (context, child) {
                                          return Theme(
                                            data: ThemeData.dark().copyWith(
                                              colorScheme: const ColorScheme.dark(
                                                primary: AppColors.skyBlue,
                                                surface: AppColors.courtSurface,
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (pickedTime != null) {
                                        HapticFeedback.mediumImpact();
                                        notifProvider.setNightTime(pickedTime);
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.skyBlue
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.skyBlue
                                              .withValues(alpha: 0.4),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.access_time_rounded,
                                              color: AppColors.skyBlue,
                                              size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            notifProvider.formatTimeOfDay(
                                                notifProvider.nightTime),
                                            style: GoogleFonts.jetBrainsMono(
                                              color: AppColors.skyBlue,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.edit_rounded,
                                              color: AppColors.skyBlue,
                                              size: 11),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: notifProvider.isNightReminderEnabled,
                        activeThumbColor: AppColors.skyBlue,
                        onChanged: (val) {
                          HapticFeedback.lightImpact();
                          notifProvider.toggleNightReminder(val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.courtBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '"Good evening, Athlete! 🌙 Time for your 2-minute Mental Corner reset. Calm your mind, reflect on today\'s court progress, and rest up for tomorrow."',
                      style: GoogleFonts.inter(
                        color: AppColors.chalkWhite.withValues(alpha: 0.85),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 2. INCOMING NOTIFICATION PANEL INBOX
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'INBOX',
                      style: GoogleFonts.jetBrainsMono(
                        color: AppColors.limeGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      BadgeTag(
                        label: '$unreadCount NEW',
                        color: AppColors.coral,
                      ),
                    ],
                  ],
                ),
                if (notifications.isNotEmpty)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.sageGray,
                      size: 20,
                    ),
                    tooltip: 'Clear All Notifications',
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      notifProvider.clearAll();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),

            if (notifications.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: AppColors.courtSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.sageGray.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.notifications_off_outlined,
                      color: AppColors.sageGray,
                      size: 44,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No Active Notifications',
                      style: GoogleFonts.inter(
                        color: AppColors.chalkWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your daily reminders and AI Coach alerts will appear here.',
                      style: GoogleFonts.inter(
                        color: AppColors.sageGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...notifications.map((notif) {
                final isUnread = !notif.isRead;
                final color = _getCategoryColor(notif.category);
                final icon = _getCategoryIcon(notif.category);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    onTap: () {
                      notifProvider.markAsRead(notif.id);
                    },
                    backgroundColor: isUnread
                        ? AppColors.courtSurface
                        : AppColors.courtSurface.withValues(alpha: 0.5),
                    borderColor: isUnread
                        ? color.withValues(alpha: 0.4)
                        : AppColors.sageGray.withValues(alpha: 0.15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      notif.title,
                                      style: GoogleFonts.inter(
                                        color: AppColors.chalkWhite,
                                        fontSize: 14,
                                        fontWeight: isUnread
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (isUnread)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.limeGreen,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif.message,
                                style: GoogleFonts.inter(
                                  color: AppColors.sageGray,
                                  fontSize: 12,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _formatTimestamp(notif.timestamp),
                                style: GoogleFonts.jetBrainsMono(
                                  color: AppColors.sageGray
                                      .withValues(alpha: 0.7),
                                  fontSize: 9.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.sageGray,
                            size: 16,
                          ),
                          onPressed: () {
                            notifProvider.deleteNotification(notif.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'MORNING_REMINDER':
        return AppColors.corkGold;
      case 'NIGHT_REMINDER':
        return AppColors.skyBlue;
      case 'AI_COACH':
        return AppColors.limeGreen;
      case 'ACHIEVEMENT':
        return AppColors.softViolet;
      default:
        return AppColors.limeGreen;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'MORNING_REMINDER':
        return Icons.wb_sunny_rounded;
      case 'NIGHT_REMINDER':
        return Icons.nights_stay_rounded;
      case 'AI_COACH':
        return Icons.psychology_rounded;
      case 'ACHIEVEMENT':
        return Icons.emoji_events_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
  }
}
