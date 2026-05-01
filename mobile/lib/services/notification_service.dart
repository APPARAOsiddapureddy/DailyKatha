import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Push / system notifications — platform differences abstracted here.
@immutable
class NotificationService {
  const NotificationService();

  /// Android 13+ requires `POST_NOTIFICATIONS` runtime permission.
  /// iOS uses a different flow (user prompt via UNUserNotificationCenter when
  /// registering for remote notifications) — call before FCM setup.
  Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    if (Platform.isIOS) {
      // iOS: permission is tied to UNUserNotificationCenter / push registration.
      // Without FCM plugin, we only document the contract for a future integration.
      return true;
    }
    return true;
  }

  Future<bool> get notificationsEnabled async {
    if (Platform.isAndroid) {
      return Permission.notification.isGranted;
    }
    return true;
  }
}
