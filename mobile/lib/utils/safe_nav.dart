import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Defers navigation until after the current frame so GoRouter / InheritedWidget
/// trees are not torn down mid-build (avoids framework descendant assertions).
void safeGo(BuildContext context, String location, {Object? extra}) {
  if (!context.mounted) return;
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    if (extra != null) {
      context.go(location, extra: extra);
    } else {
      context.go(location);
    }
  });
}

void safePush(BuildContext context, String location, {Object? extra}) {
  if (!context.mounted) return;
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    if (extra != null) {
      context.push(location, extra: extra);
    } else {
      context.push(location);
    }
  });
}
