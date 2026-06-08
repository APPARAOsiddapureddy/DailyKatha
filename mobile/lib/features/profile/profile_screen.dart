import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/mock_catalog.dart';
import '../../data/local/user_engagement_store.dart';
import '../../data/providers.dart';
import '../../data/user_stats_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/genre_localizer.dart';
import '../../models/feed_route_args.dart';
import '../../models/user_profile.dart';
import '../../services/user_display_name.dart';
import '../../theme/app_colors.dart';
import '../../utils/safe_nav.dart';
import '../../widgets/app_background.dart';
import '../../widgets/display_name_prompt_dialog.dart';

/// Mirrors `screens-main.jsx` `ProfileScreen` — cream shell, streak hero, stats, grouped rows.
/// Not driven by backend layout APIs; profile fields come from session / catalog like the prototype’s static copy.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    ref.read(sessionHolderProvider.notifier).clear();
    if (!mounted) return;
    safeGo(context, '/login');
  }

  Future<void> _editDisplayName() async {
    await showDisplayNameEditor(context, ref);
  }

  Future<void> _pickLanguage() async {
    final session = ref.read(sessionHolderProvider);
    if (session == null) return;
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.protoSurface,
      builder: (ctx) {
        return ListView(
          shrinkWrap: true,
          children: [
            for (final opt in MockCatalog.languages)
              ListTile(
                title: Text(
                  opt.nativeName,
                  style: const TextStyle(
                    color: AppColors.protoInk,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  '${opt.englishName} · ${opt.speakersLabel}',
                  style: const TextStyle(color: AppColors.protoInk3),
                ),
                trailing: session.profile.contentLanguage == opt.id
                    ? const Icon(Icons.check, color: AppColors.protoBrand)
                    : null,
                onTap: () => Navigator.pop(ctx, opt.id),
              ),
          ],
        );
      },
    );
    if (picked == null || !mounted) return;
    if (picked == session.profile.contentLanguage) return;
    final updated = session.profile.copyWith(contentLanguage: picked);
    final newSession = await ref
        .read(authRepositoryProvider)
        .applyProfile(updated);
    ref.read(sessionHolderProvider.notifier).setSession(newSession);
    ref.invalidate(catalogProvider);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).languageUpdated)),
    );
  }

  Future<void> _openSavedCards(BuildContext context, WidgetRef ref) async {
    final snap = await UserEngagementStore.load();
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);
    if (snap.savedCardIds.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.profileDialogNoSavedTitle),
          content: Text(l10n.profileDialogNoSavedBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.profileEditNameCancel),
            ),
          ],
        ),
      );
      return;
    }
    context.push(
      '/feed',
      extra: FeedRouteArgs(initialIndex: 0, cardIds: snap.savedCardIds),
    );
  }

  Future<void> _openMyEdits(BuildContext context, WidgetRef ref) async {
    final created = await ref.read(userCreatedCardsProvider.future);
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);
    if (created.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.profileDialogNoEditsTitle),
          content: Text(l10n.profileDialogNoEditsBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.profileEditNameCancel),
            ),
          ],
        ),
      );
      return;
    }
    context.push(
      '/feed',
      extra: FeedRouteArgs(
        initialIndex: 0,
        cardIds: created.map((c) => c.id).toList(),
      ),
    );
  }

  Future<void> _openMyShares(BuildContext context) async {
    final snap = await UserEngagementStore.load();
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);
    if (snap.sharedCardIds.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.profileDialogNoSharesTitle),
          content: Text(l10n.profileDialogNoSharesBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.profileEditNameCancel),
            ),
          ],
        ),
      );
      return;
    }
    context.push(
      '/feed',
      extra: FeedRouteArgs(initialIndex: 0, cardIds: snap.sharedCardIds),
    );
  }

  String _nativeLanguage(UserSession? session) {
    final id = session?.profile.contentLanguage ?? 'en';
    try {
      return MockCatalog.languages.firstWhere((e) => e.id == id).nativeName;
    } catch (_) {
      return id;
    }
  }

  String _storyPackLabel(UserSession? session) {
    final ids = session?.profile.interestIds ?? const <String>[];
    if (ids.isEmpty) {
      return 'Mahabharata · Ramayanam · Shiv Puranam';
    }
    final lang = session?.profile.contentLanguage ?? 'en';
    final labels = ids
        .take(3)
        .map((id) => GenreLocalizer.getName(id, lang))
        .toList();
    if (labels.isEmpty) return 'Story packs';
    if (ids.length > 3) {
      return '${labels.join(' · ')} · +${ids.length - 3} more';
    }
    return labels.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionHolderProvider);
    final l10n = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final stats = ref.watch(userStatsProvider).valueOrNull;

    final profile = session?.profile;
    final resolvedName = profile == null
        ? l10n.profileYourName
        : () {
            final t = profile.displayName.trim();
            if (t.isEmpty || isPlaceholderDisplayName(t)) {
              return l10n.profileYourName;
            }
            return t;
          }();

    final saved = stats?.savedCount ?? (session?.profile.savedCount ?? 0);
    final edits = session?.profile.likedCount ?? 0;
    final shared = stats?.sharedCount ?? (session?.profile.sharedCount ?? 0);

    return Scaffold(
      backgroundColor: AppColors.protoCream,
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    l10n.navProfile,
                    style: tt.headlineMedium?.copyWith(fontSize: 30),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                sliver: SliverToBoxAdapter(
                  child: Material(
                    color: AppColors.protoSurface,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: _editDisplayName,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.protoBorder),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.protoBrand.withValues(
                                alpha: 0.15,
                              ),
                              child: profile == null
                                  ? Icon(
                                      Icons.person,
                                      color: AppColors.protoBrand.withValues(
                                        alpha: 0.8,
                                      ),
                                    )
                                  : Text(
                                      UserDisplayName.avatarInitial(profile),
                                      style: tt.titleMedium?.copyWith(
                                        color: AppColors.protoBrand,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    resolvedName,
                                    style: tt.titleLarge?.copyWith(
                                      fontSize: 20,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.profileYourNameSub,
                                    style: tt.bodySmall?.copyWith(
                                      color: AppColors.protoInk3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: AppColors.protoInk3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1A1410), Color(0xFF3A2A1F)],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE89B2C), Color(0xFFB33A20)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFE89B2C,
                                ).withValues(alpha: 0.45),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_fire_department,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '5 days',
                                style: tt.headlineSmall?.copyWith(
                                  fontSize: 28,
                                  height: 1,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.profileStreakSub,
                                style: tt.bodyMedium?.copyWith(
                                  fontSize: 13,
                                  height: 1.3,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatTile(n: saved, label: l10n.profileSaved),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatTile(
                          n: edits,
                          label: l10n.profileStatEdits,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatTile(n: shared, label: l10n.profileShared),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: _SectionLabel(text: l10n.profileSectionLibrary),
                ),
              ),
              SliverToBoxAdapter(
                child: _ProfileRow(
                  icon: Icons.favorite,
                  iconBg: const Color(0xFFFFE4DC),
                  iconColor: AppColors.protoBrand,
                  title: l10n.profileRowSavedCards,
                  sub: l10n.profileRowSavedSub(saved),
                  onTap: () => _openSavedCards(context, ref),
                ),
              ),
              SliverToBoxAdapter(
                child: _ProfileRow(
                  icon: Icons.ios_share,
                  iconBg: const Color(0xFFE8F4FF),
                  iconColor: AppColors.protoInk2,
                  title: l10n.profileRowMyShares,
                  sub: l10n.profileRowMySharesSub(shared),
                  onTap: () => _openMyShares(context),
                ),
              ),
              SliverToBoxAdapter(
                child: _ProfileRow(
                  icon: Icons.edit_outlined,
                  iconBg: const Color(0xFFFFF1D9),
                  iconColor: AppColors.protoSaffron,
                  title: l10n.profileRowMyEdits,
                  sub: l10n.profileRowMyEditsSub(edits),
                  onTap: () => _openMyEdits(context, ref),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 18),
                sliver: SliverToBoxAdapter(
                  child: _SectionLabel(text: l10n.profileSectionPreferences),
                ),
              ),
              SliverToBoxAdapter(
                child: _ProfileRow(
                  icon: Icons.translate,
                  iconBg: const Color(0xFFEAE3D2),
                  iconColor: AppColors.protoInk2,
                  title: l10n.profileLanguage,
                  sub: _nativeLanguage(session),
                  onTap: _pickLanguage,
                ),
              ),
              SliverToBoxAdapter(
                child: _ProfileRow(
                  icon: Icons.auto_awesome,
                  iconBg: const Color(0xFFEAE3D2),
                  iconColor: AppColors.protoInk2,
                  title: 'Story packs',
                  sub: _storyPackLabel(session),
                  onTap: () => context.push('/profile/story-packs'),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 18),
                sliver: SliverToBoxAdapter(
                  child: _SectionLabel(text: l10n.profileSectionAbout),
                ),
              ),
              SliverToBoxAdapter(
                child: _ProfileRow(
                  icon: Icons.notifications_none,
                  iconBg: const Color(0xFFEAE3D2),
                  iconColor: AppColors.protoInk2,
                  title: l10n.profileRowDailyReminder,
                  sub: l10n.profileRowReminderSub,
                  onTap: () => context.push('/settings/reminder'),
                ),
              ),
              SliverToBoxAdapter(
                child: _ProfileRow(
                  icon: Icons.settings_outlined,
                  iconBg: const Color(0xFFEAE3D2),
                  iconColor: AppColors.protoInk2,
                  title: l10n.profileRowSettingsOnly,
                  sub: null,
                  onTap: () => context.push('/settings'),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: OutlinedButton(
                    onPressed: _signOut,
                    child: Text(l10n.profileSignOut),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                  child: Text(
                    l10n.profileFooter,
                    textAlign: TextAlign.center,
                    style: tt.bodySmall?.copyWith(
                      fontSize: 11,
                      color: AppColors.protoInk4,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: tt.labelLarge?.copyWith(
          fontSize: 11,
          letterSpacing: 2,
          color: AppColors.protoInk3,
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.n, required this.label});

  final int n;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.protoSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.protoBorder),
      ),
      child: Column(
        children: [
          Text('$n', style: tt.titleLarge?.copyWith(fontSize: 24, height: 1)),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: tt.bodySmall?.copyWith(
              fontSize: 11,
              letterSpacing: 0.3,
              color: AppColors.protoInk3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.sub,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? sub;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Material(
        color: AppColors.protoSurface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.protoBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: iconBg,
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: tt.titleMedium?.copyWith(fontSize: 16),
                      ),
                      if (sub != null && sub!.isNotEmpty)
                        Text(
                          sub!,
                          style: tt.bodySmall?.copyWith(
                            color: AppColors.protoInk3,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 18, color: AppColors.protoInk4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
