import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/providers.dart';
import '../../observability/analytics/analytics.dart';
import '../../observability/analytics/analytics_provider.dart';
import '../../theme/app_colors.dart';

class DailyReminderScreen extends ConsumerStatefulWidget {
  const DailyReminderScreen({super.key});

  @override
  ConsumerState<DailyReminderScreen> createState() => _DailyReminderScreenState();
}

class _DailyReminderScreenState extends ConsumerState<DailyReminderScreen> {
  bool _loading = true;
  bool _enabled = false;
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 0);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final svc = ref.read(notificationServiceProvider);
    final prefs = await svc.getDailyReminderPrefs();
    if (!mounted) return;
    setState(() {
      _enabled = prefs.enabled;
      _time = prefs.time;
      _loading = false;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked == null || !mounted) return;
    setState(() => _time = picked);
  }

  Future<void> _apply() async {
    final svc = ref.read(notificationServiceProvider);
    setState(() => _loading = true);
    try {
      if (_enabled) {
        final granted = await svc.ensureDailyReminderPermission();
        if (!granted) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Notifications are off. Enable them in system settings.'),
              action: SnackBarAction(label: 'Settings', onPressed: openAppSettings),
            ),
          );
          setState(() {
            _enabled = false;
            _loading = false;
          });
          await svc.setDailyReminder(enabled: false, time: _time);
          return;
        }
      }

      await svc.setDailyReminder(enabled: _enabled, time: _time);
      await ref.read(analyticsProvider).log(
        AEvents.reminderEnabled,
        props: {
          'enabled': _enabled,
          'time_h': _time.hour,
          'time_m': _time.minute,
        },
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_enabled ? 'Daily reminder set for ${_time.format(context)}' : 'Daily reminder off')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update reminder: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.protoCream,
      appBar: AppBar(
        backgroundColor: AppColors.protoCream,
        foregroundColor: AppColors.protoInk,
        elevation: 0,
        title: const Text('Daily reminder'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _apply,
            child: _loading
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.protoSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.protoBorder),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: _enabled,
                        onChanged: (v) => setState(() => _enabled = v),
                        title: const Text('Enable daily reminder'),
                        subtitle: const Text('We’ll send a gentle nudge once a day'),
                      ),
                      const Divider(height: 1, color: AppColors.protoDivider),
                      ListTile(
                        enabled: _enabled,
                        leading: const Icon(Icons.schedule, color: AppColors.protoInk),
                        title: const Text('Time'),
                        subtitle: Text(_time.format(context)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _enabled ? _pickTime : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tip: if notifications are blocked by the OS, enable them in system settings.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.protoInk3),
                ),
              ],
            ),
    );
  }
}

