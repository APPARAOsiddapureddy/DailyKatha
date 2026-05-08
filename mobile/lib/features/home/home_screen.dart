import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content_language.dart';
import '../../data/local/mock_catalog.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../models/feed_route_args.dart';
import '../../models/katha_card.dart';
import '../../models/section_preview_args.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_background.dart';
import '../../widgets/mini_card.dart';

String _greetingLine(AppLocalizations l10n, DateTime now, String firstName) {
  final h = now.hour;
  if (h < 5) return l10n.homeGreetingNightEarly(firstName);
  if (h < 11) return l10n.homeGreetingMorning(firstName);
  if (h < 16) return l10n.homeGreetingAfternoon(firstName);
  if (h < 19) return l10n.homeGreetingEvening(firstName);
  return l10n.homeGreetingNight(firstName);
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  int _firstIndexWhere(List<KathaCard> cards, bool Function(KathaCard) test) {
    final i = cards.indexWhere(test);
    return i < 0 ? 0 : i;
  }

  bool _matchesUserInterestRow(KathaCard c, List<String> userInterestIds) {
    if (userInterestIds.isEmpty) {
      return c.section == 'interests' || {'bhakti', 'motivation', 'love'}.contains(c.category);
    }
    return userInterestIds.contains(c.category);
  }

  void _openFeed(
    BuildContext context,
    List<KathaCard> cards,
    int index, {
    Set<String>? categoryFilter,
  }) {
    final clamped = index.clamp(0, cards.length - 1);
    context.push(
      '/feed',
      extra: FeedRouteArgs(initialIndex: clamped, categoryFilter: categoryFilter),
    );
  }

  void _openSectionPreview(
    BuildContext context,
    List<KathaCard> cards,
    int index, {
    required String title,
    required String tag,
    Set<String>? categoryFilter,
  }) {
    final clamped = index.clamp(0, cards.length - 1);
    context.push(
      '/section',
      extra: SectionPreviewArgs(
        title: title,
        tag: tag,
        initialIndex: clamped,
        categoryFilter: categoryFilter,
      ),
    );
  }

  void _showNotifications(BuildContext context, String lang, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surfaceElevatedDark,
      builder: (context) {
        return ListView(
          children: [
            ListTile(
              title: Text(l10n.notificationsTitle, style: TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w700)),
            ),
            for (final n in MockCatalog.notifications)
              ListTile(
                leading: Text(n.icon, style: const TextStyle(fontSize: 22)),
                title: Text(n.titleFor(lang), style: const TextStyle(color: AppColors.textPrimaryDark)),
                subtitle: Text(n.bodyFor(lang), style: TextStyle(color: AppColors.textSecondaryDark)),
                trailing: Text(n.timeAgo, style: TextStyle(fontSize: 12, color: AppColors.textTertiaryDark)),
              ),
          ],
        );
      },
    );
  }

  List<_SectionData> _sectionConfigs(AppLocalizations l10n, List<KathaCard> cards, List<String> userInterestIds) {
    bool morning(KathaCard c) => c.section == 'morning' || c.category == 'goodmorning';
    bool festival(KathaCard c) => c.isFestival || c.section == 'festival';
    bool trending(KathaCard c) => c.section == 'trending';
    bool entertainment(KathaCard c) => {'cinema', 'heroes', 'friendship'}.contains(c.category);

    return [
      _SectionData(
        title: l10n.homeSectionStartTitle,
        tag: l10n.sectionMorning,
        cards: cards.where(morning).toList(),
      ),
      _SectionData(
        title: l10n.homeSectionFestivalTitle,
        tag: l10n.sectionFestival,
        cards: cards.where(festival).toList(),
      ),
      _SectionData(
        title: l10n.homeSectionInterestsTitle,
        tag: l10n.sectionForYou,
        useInterestScopedFeed: true,
        cards: cards.where((c) => _matchesUserInterestRow(c, userInterestIds)).toList(),
      ),
      _SectionData(
        title: l10n.homeSectionTrendingTitle,
        tag: l10n.sectionTrending,
        cards: cards.where(trending).toList(),
      ),
      _SectionData(
        title: l10n.homeSectionCinemaTitle,
        tag: l10n.sectionEntertainment,
        cards: cards.where(entertainment).toList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionHolderProvider);
    final lang = effectiveContentLanguage(session);
    final userInterestIds = session?.profile.interestIds ?? const <String>[];
    final catalog = ref.watch(catalogProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create'),
        backgroundColor: AppColors.accentGold,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Create Card', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: AppBackground(
        child: SafeArea(
          child: catalog.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accentGold)),
          error: (e, _) => Center(
            child: Text(
              '${AppLocalizations.of(context).errorGeneric}: $e',
              style: const TextStyle(color: AppColors.textPrimaryDark),
            ),
          ),
          data: (cards) {
            final l10n = AppLocalizations.of(context);
            final sections = _sectionConfigs(l10n, cards, userInterestIds);
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 12),
                    child: Row(
                      children: [
                        const Text('🪔', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 12),
                        Text(
                          'Dailykatha',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimaryDark,
                              ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => context.go('/explore'),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.surfaceElevatedDark,
                            side: BorderSide(color: AppColors.borderOnDark),
                            padding: const EdgeInsets.all(12),
                          ),
                          icon: const Icon(Icons.search, color: AppColors.textPrimaryDark),
                        ),
                        IconButton(
                          onPressed: () => _showNotifications(context, lang, l10n),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.surfaceElevatedDark,
                            side: BorderSide(color: AppColors.borderOnDark),
                            padding: const EdgeInsets.all(12),
                          ),
                          icon: const Badge(
                            smallSize: 7,
                            backgroundColor: AppColors.accentGold,
                            child: Icon(Icons.notifications_none, color: AppColors.textPrimaryDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _GreetingHero(
                    onProfile: () => context.go('/profile'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _TodayPicksBanner(
                    onTap: () => context.push('/today-picks'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _FestivalBanner(
                    onTap: () => _openFeed(context, cards, _firstIndexWhere(cards, (c) => c.section == 'festival')),
                  ),
                ),
                for (final s in sections)
                  if (s.cards.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _Section(
                        title: s.title,
                        tag: s.tag,
                        lang: lang,
                        cards: s.cards,
                        onViewAll: () => _openSectionPreview(
                          context,
                          cards,
                          cards.indexOf(s.cards.first),
                          title: s.title,
                          tag: s.tag,
                          categoryFilter: s.useInterestScopedFeed && userInterestIds.isNotEmpty
                              ? userInterestIds.toSet()
                              : null,
                        ),
                        onCard: (c) => _openSectionPreview(
                          context,
                          cards,
                          cards.indexOf(c),
                          title: s.title,
                          tag: s.tag,
                          categoryFilter: s.useInterestScopedFeed && userInterestIds.isNotEmpty
                              ? userInterestIds.toSet()
                              : null,
                        ),
                      ),
                    ),
                const SliverToBoxAdapter(child: SizedBox(height: 36)),
              ],
            );
          },
          ),
        ),
      ),
    );
  }
}

class _TodayPicksBanner extends StatelessWidget {
  const _TodayPicksBanner({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF1a1208), Color(0xFF2a1e0a)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: AppColors.accentGold.withAlpha((0.28 * 255).round())),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withAlpha((0.15 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentGold.withAlpha((0.25 * 255).round())),
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.accentGold),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's 5 Picks",
                      style: TextStyle(
                        color: AppColors.accentGold,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Fresh picks based on your interests',
                      style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppColors.accentGold, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionData {
  _SectionData({
    required this.title,
    required this.tag,
    required this.cards,
    this.useInterestScopedFeed = false,
  });

  final String title;
  final String tag;
  final List<KathaCard> cards;
  /// When true, tapping into this row opens [/feed] restricted to onboarding interest categories.
  final bool useInterestScopedFeed;
}

class _GreetingHero extends ConsumerWidget {
  const _GreetingHero({required this.onProfile});

  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final session = ref.watch(sessionHolderProvider);
    final name = session?.profile.displayName ?? 'Friend';
    final first = name.split(' ').first;
    final line = _greetingLine(l10n, now, first);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 6, 22, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 26,
                        color: AppColors.textPrimaryDark,
                      ),
                ),
                if ((session?.profile.displayNameNative ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    session!.profile.displayNameNative!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  l10n.homeGreetingSubline,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppColors.textTertiaryDark,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: onProfile,
            style: FilledButton.styleFrom(
              foregroundColor: AppColors.textPrimaryDark,
              backgroundColor: AppColors.surfaceElevatedDark,
              side: const BorderSide(color: AppColors.accentGoldBorder),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(18),
            ),
            child: Text(
              name.isNotEmpty ? name[0] : 'U',
              style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.accentGold),
            ),
          ),
        ],
      ),
    );
  }
}

class _FestivalBanner extends StatelessWidget {
  const _FestivalBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: AppColors.surfaceDark,
              border: Border.all(color: AppColors.accentGoldBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentGold.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✦ ${l10n.festivalBannerKicker.toUpperCase()} ✦',
                  style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentGold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.festivalBannerTitle,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.festivalBannerSubtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.accentGoldSubtleBg,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.accentGoldBorder),
                  ),
                  child: Text(
                    l10n.festivalBannerCta,
                    style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.accentGold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.tag,
    required this.lang,
    required this.cards,
    required this.onViewAll,
    required this.onCard,
  });

  final String title;
  final String tag;
  final String lang;
  final List<KathaCard> cards;
  final VoidCallback onViewAll;
  final void Function(KathaCard c) onCard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tag.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: AppColors.accentGold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textPrimaryDark)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onViewAll,
                  style: TextButton.styleFrom(foregroundColor: AppColors.accentGold),
                  child: Text(l10n.homeViewAll),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                final c = cards[i];
                return MiniCard(
                  card: c,
                  contentLanguage: lang,
                  blurred: i != 0,
                  onTap: () => onCard(c),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 12),
              itemCount: cards.length,
            ),
          ),
        ],
      ),
    );
  }
}
