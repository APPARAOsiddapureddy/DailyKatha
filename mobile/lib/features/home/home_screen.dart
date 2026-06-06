// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/content_language.dart';
import '../../data/local/mock_catalog.dart';
import '../../data/local/user_engagement_store.dart';
import '../../data/providers.dart';
import '../../data/user_stats_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/genre_localizer.dart';
import '../../models/card_editor_args.dart';
import '../../models/feed_route_args.dart';
import '../../models/katha_card.dart';
import '../../models/user_profile.dart';
import '../../services/card_share_export.dart';
import '../../services/user_display_name.dart';
import '../../theme/app_colors.dart';
import '../../utils/daily_card_picker.dart';
import '../../utils/error_handler.dart';
import '../../widgets/app_background.dart';
import '../../widgets/display_name_prompt_dialog.dart';
import '../../widgets/proto_action_pill.dart';
import '../../widgets/status_card.dart';
import '../../widgets/status_rail_thumbnail.dart';

String _greetingFirstName(UserSession? session) {
  if (session == null) return 'Friend';
  return UserDisplayName.firstWord(session.profile);
}

String _greetingLine(AppLocalizations l10n, DateTime now, String firstName) {
  final h = now.hour;
  if (h < 5) return l10n.homeGreetingNightEarly(firstName);
  if (h < 11) return l10n.homeGreetingMorning(firstName);
  if (h < 16) return l10n.homeGreetingAfternoon(firstName);
  if (h < 19) return l10n.homeGreetingEvening(firstName);
  return l10n.homeGreetingNight(firstName);
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _scheduledNamePrompt = false;
  /// Which of [picks] (0…2) is the front card in the overlapping “today” deck.
  int _todayFeaturedIndex = 0;

  void _maybePromptName(List<KathaCard> cards) {
    if (_scheduledNamePrompt || cards.isEmpty) return;
    _scheduledNamePrompt = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await showDisplayNamePromptIfNeeded(context, ref);
    });
  }

  List<KathaCard> _todayPicksFor(
    List<KathaCard> catalog,
    List<String> interests,
    Map<String, int> affinity,
  ) {
    if (catalog.isEmpty) return const [];
    final sorted = List<String>.from(interests.take(3));
    sorted.sort((a, b) => (affinity[b] ?? 0).compareTo(affinity[a] ?? 0));
    if (sorted.isEmpty) {
      return MockCatalog.interests
          .take(3)
          .map((e) => DailyCardPicker.pickForCategory(catalog, e.id))
          .toList();
    }
    return sorted
        .take(3)
        .map((id) => DailyCardPicker.pickForCategory(catalog, id))
        .toList();
  }

  int _indexInCatalog(KathaCard card, List<KathaCard> catalog) {
    final i = catalog.indexWhere((c) => c.id == card.id);
    return i >= 0 ? i : 0;
  }

  List<String> _interestOrder(List<String> ids) {
    final preferred = MockCatalog.interests
        .map((e) => e.id)
        .where(ids.contains)
        .toList();
    for (final id in ids) {
      if (!preferred.contains(id)) preferred.add(id);
    }
    return preferred;
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
      extra: FeedRouteArgs(
        initialIndex: clamped,
        categoryFilter: categoryFilter,
      ),
    );
  }

  void _editHero(BuildContext context, String lang, KathaCard card) {
    context.push(
      '/edit',
      extra: CardEditorArgs(
        card: card,
        contentLanguage: lang,
        preferStatusPrimaryCta: true,
      ),
    );
  }

  Future<void> _saveHero(
    BuildContext context,
    WidgetRef ref,
    String lang,
    KathaCard card,
  ) async {
    final bytes = await CardShareExport.renderKathaCardPngBytes(
      context: context,
      card: card,
      contentLanguage: lang,
    );
    final ok = await CardShareExport.savePngBytesToGallery(
      bytes: bytes,
      nameStem: 'daily_katha_${card.id}',
    );
    if (!context.mounted) return;
    if (ok) {
      final freshlyAdded = await UserEngagementStore.recordSaved(card.id);
      await UserEngagementStore.bumpCategoryAffinity(
        card.category,
        delta: freshlyAdded ? 4 : 1,
      );
      if (freshlyAdded) {
        await ref.read(userStatsProvider.notifier).incrementSaved();
      }
    }
    ref.invalidate(userEngagementProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Saved to gallery' : 'Could not save to gallery'),
      ),
    );
  }

  void _showNotifications(
    BuildContext context,
    String lang,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.protoSurface,
      builder: (context) {
        return ListView(
          children: [
            ListTile(
              title: Text(
                l10n.notificationsTitle,
                style: const TextStyle(
                  color: AppColors.protoInk,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            for (final n in MockCatalog.notifications)
              ListTile(
                leading: Text(n.icon, style: const TextStyle(fontSize: 22)),
                title: Text(
                  n.titleFor(lang),
                  style: const TextStyle(color: AppColors.protoInk),
                ),
                subtitle: Text(
                  n.bodyFor(lang),
                  style: const TextStyle(color: AppColors.protoInk3),
                ),
                trailing: Text(
                  n.timeAgo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.protoInk4,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  String _dateLine() => DateFormat('EEEE · d MMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<KathaCard>>>(catalogProvider, (previous, next) {
      next.whenData(_maybePromptName);
    });

    final session = ref.watch(sessionHolderProvider);
    final lang = effectiveContentLanguage(session);
    final userInterestIds = session?.profile.interestIds ?? const <String>[];
    final interests = userInterestIds.isEmpty
        ? MockCatalog.interests.take(3).map((e) => e.id).toList()
        : _interestOrder(userInterestIds.toList());
    final catalog = ref.watch(catalogProvider);
    final l10n = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.protoCream,
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: catalog.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.protoBrand),
            ),
            error: (e, _) => Center(
              child: Text(
                '${l10n.errorGeneric}: ${ErrorHandler.userMessage(context, e)}',
                style: tt.bodyMedium?.copyWith(color: AppColors.protoInk),
                textAlign: TextAlign.center,
              ),
            ),
            data: (cards) {
              if (cards.isEmpty) {
                return Center(child: Text(l10n.noCards));
              }
              final affinity =
                  ref.watch(userEngagementProvider).valueOrNull?.categoryAffinity ??
                  {};
              final picks = _todayPicksFor(cards, interests, affinity);
              final featuredIdx = picks.isEmpty
                  ? 0
                  : (_todayFeaturedIndex < picks.length
                        ? _todayFeaturedIndex
                        : 0);
              final hero =
                  picks.isNotEmpty ? picks[featuredIdx] : cards.first;

              List<KathaCard> byInterest(String id) =>
                  cards.where((c) => c.category == id).toList();

              final trending = cards
                  .where((c) => c.section == 'trending')
                  .toList();

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _dateLine().toUpperCase(),
                                  style: tt.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5,
                                    color: AppColors.protoInk3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _greetingLine(
                                    l10n,
                                    now,
                                    _greetingFirstName(session),
                                  ),
                                  style: tt.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                          Material(
                            color: AppColors.protoSurface,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () =>
                                  _showNotifications(context, lang, l10n),
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Icon(
                                      Icons.notifications_none,
                                      color: AppColors.protoInk,
                                      size: 22,
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 12,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: AppColors.protoBrand,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.protoSurface,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Row(
                        children: [
                          ProtoActionPill(
                            icon: Icons.add,
                            label: 'Create Card',
                            onTap: () => context.push('/create'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.homeHeroKicker.toUpperCase(),
                              style: tt.labelLarge?.copyWith(
                                letterSpacing: 2,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.local_fire_department_outlined,
                            size: 14,
                            color: AppColors.protoSaffron,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '5-day streak',
                            style: tt.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.protoInk3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: LayoutBuilder(
                        builder: (context, _) {
                          final screenW = MediaQuery.sizeOf(context).width;
                          final heroW = (screenW * 0.64).clamp(260.0, 360.0);
                          if (picks.length <= 1) {
                            return Center(
                              child: SizedBox(
                                width: heroW,
                                child: AspectRatio(
                                  aspectRatio: 9 / 16,
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: () => _openFeed(
                                        context,
                                        cards,
                                        _indexInCatalog(hero, cards),
                                        categoryFilter: {hero.category},
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: CardShareExport
                                              .logicalExportWidth,
                                          height: CardShareExport
                                              .logicalExportHeight,
                                          child: StatusCard(
                                            card: hero,
                                            contentLanguage: lang,
                                            compact: false,
                                            width: CardShareExport
                                                .logicalExportWidth,
                                            height: CardShareExport
                                                .logicalExportHeight,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: _TodayOverlappingDeck(
                                  picks: picks,
                                  featuredIdx: featuredIdx,
                                  lang: lang,
                                  heroW: heroW,
                                  onPromote: (i) => setState(
                                    () => _todayFeaturedIndex = i,
                                  ),
                                  onOpenFeatured: () => _openFeed(
                                    context,
                                    cards,
                                    _indexInCatalog(hero, cards),
                                    categoryFilter: {hero.category},
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  l10n.homeTodayPickHint,
                                  textAlign: TextAlign.center,
                                  style: tt.bodySmall?.copyWith(
                                    color: AppColors.protoInk3,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _editHero(context, lang, hero),
                              icon: const Icon(
                                Icons.ios_share,
                                size: 20,
                                color: AppColors.protoInk,
                              ),
                              label: Text(
                                l10n.homeShareToStatus,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: ProtoActionPill.typographyOnly(
                                  context,
                                ).copyWith(color: AppColors.protoInk),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.protoSurface,
                                foregroundColor: AppColors.protoInk,
                                minimumSize: const Size(double.infinity, 48),
                                side: const BorderSide(
                                  color: AppColors.protoBorder,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Material(
                            color: AppColors.protoSurface,
                            borderRadius: BorderRadius.circular(14),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => _saveHero(context, ref, lang, hero),
                              child: Container(
                                width: 56,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.protoBorder,
                                    width: 1.5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.bookmark_outline,
                                  color: AppColors.protoInk,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  for (final interest in interests)
                    if (byInterest(interest).isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 10),
                          child: _InterestRail(
                            title: GenreLocalizer.getName(interest, lang),
                            count: byInterest(interest).length,
                            lang: lang,
                            cards: byInterest(interest),
                            onViewAll: () {
                              final pick =
                                  DailyCardPicker.pickForCategory(cards, interest);
                              _openFeed(
                                context,
                                cards,
                                cards.indexWhere((c) => c.id == pick.id),
                                categoryFilter: {interest},
                              );
                            },
                            onCard: (c) => _openFeed(
                              context,
                              cards,
                              cards.indexOf(c),
                              categoryFilter: {interest},
                            ),
                          ),
                        ),
                      ),
                  if (trending.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 10),
                        child: _InterestRail(
                          title: l10n.homeSectionTrendingTitle,
                          count: trending.length,
                          lang: lang,
                          cards: trending,
                          subtitle: l10n.exploreWeekHit,
                          onViewAll: () => _openFeed(
                            context,
                            cards,
                            cards.indexOf(trending.first),
                          ),
                          onCard: (c) =>
                              _openFeed(context, cards, cards.indexOf(c)),
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Three daily picks arranged like a hand of cards: center = featured; left/right wings peek
/// clearly so two back cards stay obvious. Tap left/right to swap with center; tap center to open.
class _TodayOverlappingDeck extends StatelessWidget {
  const _TodayOverlappingDeck({
    required this.picks,
    required this.featuredIdx,
    required this.lang,
    required this.heroW,
    required this.onPromote,
    required this.onOpenFeatured,
  });

  final List<KathaCard> picks;
  final int featuredIdx;
  final String lang;
  final double heroW;
  final ValueChanged<int> onPromote;
  final VoidCallback onOpenFeatured;

  static const double _aspectHOverW = 16 / 9;
  /// Side cards scaled down vs [heroW] so shoulders read as “playing card” wings.
  static const double _sideScale = 0.74;

  static const Duration _swapDuration = Duration(milliseconds: 280);

  @override
  Widget build(BuildContext context) {
    final n = picks.length;
    assert(n >= 2);
    final baseH = heroW * _aspectHOverW;

    /// Sorted non-featured pick indices → left slot gets the lower catalogue index, right the higher,
    /// so swapping center with a wing moves the former center into that wing logically.
    final othersSorted = <int>[
      for (var i = 0; i < n; i++)
        if (i != featuredIdx) i,
    ]..sort();

    final leftIdx =
        othersSorted.isEmpty ? null : othersSorted.first;
    final rightIdx =
        othersSorted.length >= 2 ? othersSorted[1] : null;

    final laneW = heroW *
        (n >= 3
            ? 1.74
            : 1.28); // widen when fan has two wings so nothing clips

    /// Horizontal inset of each wing card’s center from deck middle (readable fan).
    final wingDx = heroW * 0.38;
    /// Slight tuck under the center card so overlaps feel intentional.
    final wingDy = baseH * 0.035;
    /// Card corner radius scales with wing size so clips stay proportional.
    final sideRadius =
        (16.0 * _sideScale).clamp(11.0, 18.0);

    return SizedBox(
      width: laneW,
      height: baseH + wingDy + 12,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (leftIdx != null)
            _fanSide(
              picks: picks,
              cardIndex: leftIdx,
              lang: lang,
              heroW: heroW,
              baseH: baseH,
              dx: -wingDx,
              dy: wingDy,
              rotation: -0.11,
              borderRadius: sideRadius,
              onTap: () => onPromote(leftIdx),
            ),
          if (rightIdx != null)
            _fanSide(
              picks: picks,
              cardIndex: rightIdx,
              lang: lang,
              heroW: heroW,
              baseH: baseH,
              dx: wingDx,
              dy: wingDy,
              rotation: 0.11,
              borderRadius: sideRadius,
              onTap: () => onPromote(rightIdx),
            ),
          _fanCenter(
            picks: picks,
            featuredIdx: featuredIdx,
            lang: lang,
            heroW: heroW,
            baseH: baseH,
            onOpenFeatured: onOpenFeatured,
          ),
        ],
      ),
    );
  }

  Widget _fanSide({
    required List<KathaCard> picks,
    required int cardIndex,
    required String lang,
    required double heroW,
    required double baseH,
    required double dx,
    required double dy,
    required double rotation,
    required double borderRadius,
    required VoidCallback onTap,
  }) {
    final card = picks[cardIndex];
    final w = heroW * _sideScale;
    final h = baseH * _sideScale;

    return Transform.translate(
      offset: Offset(dx, dy),
      child: Transform.rotate(
        angle: rotation,
        child: AnimatedSwitcher(
          duration: _swapDuration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.92, end: 1).animate(
                CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          ),
          child: KeyedSubtree(
            key: ValueKey<String>('side-$cardIndex-${card.id}'),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(borderRadius),
              clipBehavior: Clip.antiAlias,
              elevation: 2,
              shadowColor: Colors.black26,
              child: InkWell(
                onTap: onTap,
                child: SizedBox(
                  width: w,
                  height: h,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: CardShareExport.logicalExportWidth,
                      height: CardShareExport.logicalExportHeight,
                      child: StatusCard(
                        card: card,
                        contentLanguage: lang,
                        compact: true,
                        width: CardShareExport.logicalExportWidth,
                        height: CardShareExport.logicalExportHeight,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fanCenter({
    required List<KathaCard> picks,
    required int featuredIdx,
    required String lang,
    required double heroW,
    required double baseH,
    required VoidCallback onOpenFeatured,
  }) {
    final card = picks[featuredIdx];

    return Transform.translate(
      offset: const Offset(0, -6),
      child: AnimatedSwitcher(
        duration: _swapDuration,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey<String>('center-$featuredIdx-${card.id}'),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            elevation: 10,
            shadowColor: Colors.black38,
            child: InkWell(
              onTap: onOpenFeatured,
              child: SizedBox(
                width: heroW,
                height: baseH,
                child: FittedBox(
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: CardShareExport.logicalExportWidth,
                    height: CardShareExport.logicalExportHeight,
                    child: StatusCard(
                      card: card,
                      contentLanguage: lang,
                      compact: false,
                      width: CardShareExport.logicalExportWidth,
                      height: CardShareExport.logicalExportHeight,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InterestRail extends StatelessWidget {
  const _InterestRail({
    required this.title,
    required this.count,
    required this.lang,
    required this.cards,
    required this.onViewAll,
    required this.onCard,
    this.subtitle,
  });

  final String title;
  final int count;
  final String lang;
  final List<KathaCard> cards;
  final VoidCallback onViewAll;
  final void Function(KathaCard c) onCard;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: tt.titleLarge?.copyWith(fontSize: 21)),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.protoInk3,
                        ),
                      )
                    else
                      Text(
                        l10n.homeRailNewToday(count),
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.protoInk3,
                        ),
                      ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.protoBrand,
                ),
                child: Text(l10n.homeViewAll),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              final c = cards[i];
              return StatusRailThumbnail(
                card: c,
                contentLanguage: lang,
                blurred: i != 0,
                onTap: () => onCard(c),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemCount: cards.length,
          ),
        ),
      ],
    );
  }
}
