import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Local notifications (daily reminder) + permission checks.
@immutable
class NotificationService {
  const NotificationService();

  static const _prefEnabled = 'dk_daily_reminder_enabled';
  static const _prefHour = 'dk_daily_reminder_hour';
  static const _prefMinute = 'dk_daily_reminder_minute';
  static const _reminderId = 42001;
  static const _pendingRouteKey = 'dk_pending_route_v1';

  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static bool _didInit = false;

  Future<void> initialize() async {
    if (_didInit) return;
    _didInit = true;
    tz.initializeTimeZones();
    try {
      final tzName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (_) {
      // Scheduling still works using whatever default `timezone` resolved.
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const init = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(
      settings: init,
      onDidReceiveNotificationResponse: (resp) async {
        final route = resp.payload;
        if (route == null || route.trim().isEmpty) return;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_pendingRouteKey, route);
      },
    );
  }

  /// Explicitly request permission for daily reminders (Android 13+ / iOS).
  Future<bool> ensureDailyReminderPermission() async {
    await initialize();
    if (kIsWeb) return false;
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      final ok = await ios?.requestPermissions(alert: true, badge: true, sound: true);
      return ok ?? true;
    }
    return true;
  }

  /// Legacy helper used by Profile snackbars.
  Future<bool> requestNotificationPermission() => ensureDailyReminderPermission();

  Future<bool> get notificationsEnabled async {
    if (Platform.isAndroid) return Permission.notification.isGranted;
    return true;
  }

  Future<DailyReminderPrefs> getDailyReminderPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_prefEnabled) ?? false;
    final h = prefs.getInt(_prefHour) ?? 7;
    final m = prefs.getInt(_prefMinute) ?? 0;
    return DailyReminderPrefs(enabled: enabled, time: TimeOfDay(hour: h, minute: m));
  }

  Future<void> setDailyReminder({required bool enabled, required TimeOfDay time}) async {
    await initialize();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefEnabled, enabled);
    await prefs.setInt(_prefHour, time.hour);
    await prefs.setInt(_prefMinute, time.minute);

    if (!enabled) {
      await _plugin.cancel(id: _reminderId);
      return;
    }

    final android = AndroidNotificationDetails(
      'daily_reminder',
      'Daily reminder',
      channelDescription: 'Daily Katha daily reminder',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const ios = DarwinNotificationDetails();
    final details = NotificationDetails(android: android, iOS: ios);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: _reminderId,
      title: 'Daily Katha',
      body: 'Your daily blessing is ready to share.',
      scheduledDate: scheduled,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '/home?source=reminder',
    );
  }

  /// Returns and clears any route set by notification tap.
  Future<String?> consumePendingRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final route = prefs.getString(_pendingRouteKey);
    if (route == null || route.trim().isEmpty) return null;
    await prefs.remove(_pendingRouteKey);
    return route;
  }
}

@immutable
class DailyReminderPrefs {
  const DailyReminderPrefs({required this.enabled, required this.time});

  final bool enabled;
  final TimeOfDay time;
}
