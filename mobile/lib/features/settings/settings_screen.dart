import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/compliance_links.dart';
import '../../data/providers.dart';
import '../../theme/app_colors.dart';
import '../../utils/safe_nav.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _openExternal(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    await _openExternal(context, Uri.parse(ComplianceLinks.privacyPolicyUrl));
  }

  Future<void> _openTerms(BuildContext context) async {
    await _openExternal(context, Uri.parse(ComplianceLinks.termsOfServiceUrl));
  }

  Future<void> _emailSupport(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: ComplianceLinks.supportEmail,
      queryParameters: {'subject': 'Daily Katha support'},
    );
    await _openExternal(context, uri);
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete account?'),
          content: const Text(
            'This will permanently delete your account, preferences, and saved app data on this device. '
            'You will need to sign up again if you want to use Daily Katha later.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      ref.read(sessionHolderProvider.notifier).clear();
      if (!context.mounted) return;
      safeGo(context, '/login');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not delete account: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  leading: const Icon(
                    Icons.notifications_none,
                    color: AppColors.protoInk,
                  ),
                  title: const Text('Daily reminder'),
                  subtitle: const Text(
                    'Set a time to get a daily notification',
                  ),
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
          const SizedBox(height: 16),
          _Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.privacy_tip_outlined,
                    color: AppColors.protoInk,
                  ),
                  title: const Text('Privacy policy'),
                  subtitle: const Text(
                    'How Daily Katha handles phone and profile data',
                  ),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => _openPrivacyPolicy(context),
                ),
                const Divider(height: 1, color: AppColors.protoDivider),
                ListTile(
                  leading: const Icon(
                    Icons.description_outlined,
                    color: AppColors.protoInk,
                  ),
                  title: const Text('Terms of service'),
                  subtitle: const Text('Usage rules and content terms'),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => _openTerms(context),
                ),
                const Divider(height: 1, color: AppColors.protoDivider),
                ListTile(
                  leading: const Icon(
                    Icons.help_outline,
                    color: AppColors.protoInk,
                  ),
                  title: const Text('Support'),
                  subtitle: Text(ComplianceLinks.supportEmail),
                  trailing: const Icon(Icons.email_outlined, size: 18),
                  onTap: () => _emailSupport(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    'Delete account',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text(
                    'Permanently remove your Daily Katha account',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _deleteAccount(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _DisclosureCard(),
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

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.protoSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.protoBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.protoInk3,
            height: 1.4,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Permissions & data',
                style: TextStyle(
                  color: AppColors.protoInk,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '• Notifications: daily reminder alerts and system notifications you enable.',
              ),
              SizedBox(height: 6),
              Text(
                '• Photos / media: save cards to the gallery and pick images for edits.',
              ),
              SizedBox(height: 6),
              Text(
                '• Camera: optional when creating cards with your own photos.',
              ),
              SizedBox(height: 6),
              Text(
                '• Network: fetch login, content, reminders, and updates from the server.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
