import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.protoCream,
      appBar: AppBar(
        backgroundColor: AppColors.protoCream,
        foregroundColor: AppColors.protoInk,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications_none, color: AppColors.protoInk),
                  title: const Text('Daily reminder'),
                  subtitle: const Text('Set a time to get a daily notification'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/settings/reminder'),
                ),
                const Divider(height: 1, color: AppColors.protoDivider),
                ListTile(
                  leading: const Icon(Icons.tune, color: AppColors.protoInk),
                  title: const Text('App settings'),
                  subtitle: const Text('Open system settings for permissions'),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: openAppSettings,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.protoSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.protoBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

