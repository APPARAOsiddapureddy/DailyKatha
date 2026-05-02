import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Push / system notifications — platform differences abstracted here.
@immutable
class NotificationService {
  const NotificationService();

  /// Does **not** call [Permission.notification.request] so Android 13+ never shows the system
  /// permission sheet during QA; users can enable alerts from system Settings when push is wired.
  Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      return Permission.notification.isGranted;
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
