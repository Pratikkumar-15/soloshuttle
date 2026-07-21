import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppNotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String category; // MORNING_REMINDER, NIGHT_REMINDER, AI_COACH, ACHIEVEMENT
  bool isRead;

  AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.category,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'category': category,
        'isRead': isRead,
      };

  factory AppNotificationItem.fromJson(Map<String, dynamic> json) =>
      AppNotificationItem(
        id: json['id'],
        title: json['title'],
        message: json['message'],
        timestamp: DateTime.parse(json['timestamp']),
        category: json['category'],
        isRead: json['isRead'] ?? false,
      );
}

class NotificationProvider extends ChangeNotifier {
  List<AppNotificationItem> _notifications = [];
  bool _isMorningReminderEnabled = true;
  bool _isNightReminderEnabled = true;
  TimeOfDay _morningTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _nightTime = const TimeOfDay(hour: 20, minute: 0);

  List<AppNotificationItem> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get isMorningReminderEnabled => _isMorningReminderEnabled;
  bool get isNightReminderEnabled => _isNightReminderEnabled;
  TimeOfDay get morningTime => _morningTime;
  TimeOfDay get nightTime => _nightTime;

  String get morningPrepTitle {
    if (_morningTime.hour >= 17 || _morningTime.hour < 4) {
      return 'Evening Court Prep';
    } else if (_morningTime.hour >= 12) {
      return 'Afternoon Court Prep';
    } else {
      return 'Morning Court Prep';
    }
  }

  String get morningPrepGreeting {
    if (_morningTime.hour >= 17 || _morningTime.hour < 4) {
      return 'Good evening, Champ! Ready for your evening badminton session today?';
    } else if (_morningTime.hour >= 12) {
      return 'Good afternoon, Champ! Ready for your afternoon badminton session today?';
    } else {
      return 'Good morning, Champ! Ready for your morning badminton session today?';
    }
  }

  NotificationProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isMorningReminderEnabled =
          prefs.getBool('isMorningReminderEnabled') ?? true;
      _isNightReminderEnabled =
          prefs.getBool('isNightReminderEnabled') ?? true;

      final mHour = prefs.getInt('morning_hour') ?? 8;
      final mMin = prefs.getInt('morning_minute') ?? 0;
      _morningTime = TimeOfDay(hour: mHour, minute: mMin);

      final nHour = prefs.getInt('night_hour') ?? 20;
      final nMin = prefs.getInt('night_minute') ?? 0;
      _nightTime = TimeOfDay(hour: nHour, minute: nMin);

      final rawList = prefs.getStringList('app_notifications');
      if (rawList != null && rawList.isNotEmpty) {
        _notifications = rawList
            .map((itemStr) =>
                AppNotificationItem.fromJson(jsonDecode(itemStr)))
            .toList();
      } else {
        // Seed initial sweet daily morning & night notifications
        _generateInitialDailyReminders();
      }
    } catch (e) {
      debugPrint('Error loading notification provider: $e');
      _generateInitialDailyReminders();
    }
    notifyListeners();
  }

  void _generateInitialDailyReminders() {
    final now = DateTime.now();
    _notifications = [
      AppNotificationItem(
        id: 'notif_morn_${now.millisecondsSinceEpoch}',
        title: '$morningPrepTitle 🏸',
        message:
            '$morningPrepGreeting Consistency builds elite champions. Step onto the court with focus!',
        timestamp: DateTime(now.year, now.month, now.day, _morningTime.hour, _morningTime.minute),
        category: 'MORNING_REMINDER',
        isRead: false,
      ),
      AppNotificationItem(
        id: 'notif_night_${now.millisecondsSinceEpoch}',
        title: 'Night Mental Reset & Recovery 🌙',
        message:
            'Good evening, Athlete! Time for your 2-minute Mental Corner reset. Calm your mind, reflect on today\'s court progress, and rest up for tomorrow.',
        timestamp: DateTime(now.year, now.month, now.day, _nightTime.hour, _nightTime.minute),
        category: 'NIGHT_REMINDER',
        isRead: false,
      ),
      AppNotificationItem(
        id: 'notif_puzzle_${now.millisecondsSinceEpoch}',
        title: 'Daily 5 Tactical Puzzles Ready 🧩',
        message:
            'Your 5 daily Badminton Tactical IQ Puzzles are unlocked! Test your court decision-making and earn +250 XP.',
        timestamp: DateTime(now.year, now.month, now.day, 9, 30),
        category: 'AI_COACH',
        isRead: false,
      ),
    ];
    _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final strList =
          _notifications.map((n) => jsonEncode(n.toJson())).toList();
      await prefs.setStringList('app_notifications', strList);
      await prefs.setBool(
          'isMorningReminderEnabled', _isMorningReminderEnabled);
      await prefs.setBool('isNightReminderEnabled', _isNightReminderEnabled);
      await prefs.setInt('morning_hour', _morningTime.hour);
      await prefs.setInt('morning_minute', _morningTime.minute);
      await prefs.setInt('night_hour', _nightTime.hour);
      await prefs.setInt('night_minute', _nightTime.minute);
    } catch (e) {
      debugPrint('Error saving notification provider: $e');
    }
  }

  void addNotification({
    required String title,
    required String message,
    required String category,
  }) {
    final newItem = AppNotificationItem(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      timestamp: DateTime.now(),
      category: category,
      isRead: false,
    );
    _notifications.insert(0, newItem);
    _saveToPrefs();
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      _saveToPrefs();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    _saveToPrefs();
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    _saveToPrefs();
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    _saveToPrefs();
    notifyListeners();
  }

  void toggleMorningReminder(bool enabled) {
    _isMorningReminderEnabled = enabled;
    if (enabled) {
      addNotification(
        title: 'Training Reminder Enabled ☀️',
        message:
            'You will receive a sweet reminder every day at ${formatTimeOfDay(_morningTime)} to kickstart your court drills!',
        category: 'MORNING_REMINDER',
      );
    }
    _saveToPrefs();
    notifyListeners();
  }

  void toggleNightReminder(bool enabled) {
    _isNightReminderEnabled = enabled;
    if (enabled) {
      addNotification(
        title: 'Night Recovery Reminder Enabled 🌙',
        message:
            'You will receive a calming reminder every night at ${formatTimeOfDay(_nightTime)} for Mental Corner focus and recovery.',
        category: 'NIGHT_REMINDER',
      );
    }
    _saveToPrefs();
    notifyListeners();
  }

  void setMorningTime(TimeOfDay time) {
    _morningTime = time;
    addNotification(
      title: 'Prep Time Updated ☀️',
      message: 'Your training reminder is now scheduled for ${formatTimeOfDay(time)} daily.',
      category: 'MORNING_REMINDER',
    );
    _saveToPrefs();
    notifyListeners();
  }

  void setNightTime(TimeOfDay time) {
    _nightTime = time;
    addNotification(
      title: 'Night Reset Time Updated 🌙',
      message: 'Your night recovery reminder is now scheduled for ${formatTimeOfDay(time)} daily.',
      category: 'NIGHT_REMINDER',
    );
    _saveToPrefs();
    notifyListeners();
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
