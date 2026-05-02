import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/content_language.dart';
import '../../data/local/mock_catalog.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/genre_localizer.dart';
import '../../models/user_profile.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_background.dart';
import '../../widgets/mini_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _segment = 'liked';
  bool _notificationsOn = false;

  Future<void> _signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    ref.read(sessionHolderProvider.notifier).clear();
    if (!mounted) return;
    context.go('/login');
  }

  Future<void> _notificationsTap() async {
    final svc = ref.read(notificationServiceProvider);
    final granted = await svc.requestNotificationPermission();
    if (!mounted) return;
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Notifications are off in system settings. Enable there when you want alerts.',
          ),
          action: SnackBarAction(label: 'Settings', onPressed: openAppSettings),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notifications are allowed for this app.')),
      );
    }
  }

  Future<void> _pickLanguage() async {
    final session = ref.read(sessionHolderProvider);
    if (session == null) return;
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surfaceElevatedDark,
      builder: (ctx) {
        return ListView(
          shrinkWrap: true,
          children: [
            for (final opt in MockCatalog.languages)
              ListTile(
                title: Text(opt.nativeName, style: const TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w700)),
                subtitle: Text('${opt.englishName} · ${opt.speakersLabel}', style: const TextStyle(color: AppColors.textSecondaryDark)),
                trailing: session.profile.contentLanguage == opt.id ? const Icon(Icons.check, color: AppColors.accentGold) : null,
                onTap: () => Navigator.pop(ctx, opt.id),
              ),
          ],
        );
      },
    );
    if (picked == null || !mounted) return;
    if (picked == session.profile.contentLanguage) return;
    final updated = session.profile.copyWith(contentLanguage: picked);
    final newSession = await ref.read(authRepositoryProvider).applyProfile(updated);
    ref.read(sessionHolderProvider.notifier).setSession(newSession);
    ref.invalidate(catalogProvider);
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).languageUpdated)),
      );
    });
  }

  String _languageTrailing(UserSession? session) {
    final id = session?.profile.contentLanguage ?? 'en';
    try {
      return MockCatalog.languages.firstWhere((e) => e.id == id).nativeName;
    } catch (_) {
      return id;
    }
  }

  String _languageEnglish(UserSession? session) {
    final id = session?.profile.contentLanguage ?? 'en';
    try {
      return MockCatalog.languages.firstWhere((e) => e.id == id).englishName;
    } catch (_) {
      return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionHolderProvider);
    final lang = effectiveContentLanguage(session);
    final l10n = AppLocalizations.of(context);
    final catalog = ref.watch(catalogProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: AppBackground(
        child: SafeArea(
          child: catalog.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accentGold)),
          error: (e, _) => Center(child: Text('${l10n.errorGeneric}: $e', style: const TextStyle(color: AppColors.textPrimaryDark))),
          data: (cards) {
            final samples = cards.take(6).toList();
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _ProfileHeader(session: session, lang: lang, l10n: l10n)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _Segment(icon: '❤️', label: 'Liked', selected: _segment == 'liked', onTap: () => setState(() => _segment = 'liked')),
                            _Segment(icon: '📥', label: 'Saved', selected: _segment == 'saved', onTap: () => setState(() => _segment = 'saved')),
                            _Segment(icon: '📤', label: 'Shared', selected: _segment == 'shared', onTap: () => setState(() => _segment = 'shared')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_segment == 'shared')
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDark,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.borderOnDark),
                            ),
                            child: Column(
                              children: [
                                const Text('📤', style: TextStyle(fontSize: 32)),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.profileEmptySharedTitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimaryDark),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.profileEmptySharedSubtitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.textSecondaryDark),
                                ),
                              ],
                            ),
                          )
                        else
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            children: [
                              for (final c in samples)
                                MiniCard(
                                  card: c,
                                  contentLanguage: lang,
                                  onTap: () => context.push('/feed', extra: cards.indexOf(c)),
                                ),
                            ],
                          ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.profileSettings.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: AppColors.textTertiaryDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _SettingsTile(
                          icon: Icons.language,
                          title: l10n.profileLanguage,
                          subtitle: _languageEnglish(session),
                          trailing: _languageTrailing(session),
                          onTap: _pickLanguage,
                        ),
                        _SettingsTile(
                          icon: Icons.auto_awesome,
                          title: l10n.profileInterests,
                          subtitle: l10n.onboardingSelectInterests,
                          trailing: l10n.profileInterestCountTrailing(session?.profile.interestIds.length ?? 0),
                        ),
                        _SettingsTile(
                          icon: Icons.download,
                          title: l10n.profileDownloads,
                          subtitle: l10n.profileDownloads,
                          trailing: '${session?.profile.savedCount ?? 32}',
                        ),
                        _SettingsTile(
                          icon: Icons.notifications,
                          title: l10n.profileNotificationsOn,
                          subtitle: l10n.profileNotificationsOn,
                          trailingWidget: Switch(
                            value: _notificationsOn,
                            onChanged: (v) {
                              setState(() => _notificationsOn = v);
                              if (v) _notificationsTap();
                            },
                          ),
                        ),
                        _SettingsTile(
                          icon: Icons.help,
                          title: l10n.profileHelp,
                          subtitle: l10n.profileHelp,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _signOut,
                            child: Text(l10n.profileSignOut),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.profileFooter,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, color: AppColors.textTertiaryDark),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.session, required this.lang, required this.l10n});

  final UserSession? session;
  final String lang;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final name = session?.profile.displayName ?? 'Friend';
    final native = session?.profile.displayNameNative;
    final phone = session?.profile.phoneE164 ?? '';
    final interestChips = session?.profile.interestIds ?? const <String>[];
    final langLabel = _languageTrailingStatic(session);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(bottom: BorderSide(color: AppColors.borderOnDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.accentGold, Color(0xFF8A6A2F)],
                  ),
                ),
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.surfaceElevatedDark,
                  child: Text(
                    name.isNotEmpty ? name[0] : 'U',
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.accentGold),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark)),
                    if (native != null && native.trim().isNotEmpty)
                      Text(native, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondaryDark)),
                    Text(
                      phone.isNotEmpty ? '$phone · Joined Apr 2026' : 'Joined Apr 2026',
                      style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Chip(
                          label: Text(langLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark)),
                          backgroundColor: AppColors.surfaceElevatedDark,
                          side: const BorderSide(color: AppColors.accentGoldBorder),
                        ),
                        for (final id in interestChips)
                          Chip(
                            label: Text(
                              GenreLocalizer.getName(id, lang),
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
                            ),
                            backgroundColor: AppColors.surfaceElevatedDark,
                            side: const BorderSide(color: AppColors.accentGoldBorder),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _Stat(value: '${session?.profile.likedCount ?? 84}', label: l10n.profileLiked),
              const SizedBox(width: 10),
              _Stat(value: '${session?.profile.savedCount ?? 32}', label: l10n.profileSaved),
              const SizedBox(width: 10),
              _Stat(value: '${session?.profile.sharedCount ?? 127}', label: l10n.profileShared),
            ],
          ),
        ],
      ),
    );
  }

  static String _languageTrailingStatic(UserSession? session) {
    final id = session?.profile.contentLanguage ?? 'en';
    try {
      return MockCatalog.languages.firstWhere((e) => e.id == id).nativeName;
    } catch (_) {
      return id;
    }
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderOnDark),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.accentGold)),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark)),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Material(
          color: selected ? AppColors.accentGoldSubtleBg : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: selected ? AppColors.accentGold : AppColors.borderOnDark),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Text(icon),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: selected ? AppColors.textPrimaryDark : AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.trailingWidget,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? trailing;
  final Widget? trailingWidget;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const color = AppColors.accentGold;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.borderOnDark),
        ),
        tileColor: AppColors.surfaceDark,
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimaryDark)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondaryDark)),
        trailing: trailingWidget ??
            (trailing != null
                ? Text(trailing!, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark))
                : (onTap != null ? const Icon(Icons.chevron_right, color: AppColors.textTertiaryDark) : null)),
      ),
    );
  }
}
