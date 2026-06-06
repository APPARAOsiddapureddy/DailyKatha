// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content_language.dart';
import '../../data/local/user_engagement_store.dart';
import '../../data/providers.dart';
import '../../data/user_stats_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../models/card_editor_args.dart';
import '../../models/feed_route_args.dart';
import '../../models/katha_card.dart';
import '../../observability/analytics/analytics.dart';
import '../../observability/analytics/analytics_provider.dart';
import '../../services/card_share_export.dart';
import '../../theme/app_colors.dart';
import '../../widgets/proto_action_pill.dart';
import '../../widgets/status_card.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key, required this.args});

  final FeedRouteArgs args;

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

bool _cardIdLooksLikeUuid(String raw) {
  final s = raw.trim();
  return RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  ).hasMatch(s);
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  PageController? _controller;
  int _index = 0;
  final Set<String> _savedIds = {};
  bool _loggedOpen = false;
  bool _sharing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loggedOpen) return;
    _loggedOpen = true;
    final filter = widget.args.categoryFilter;
    ref
        .read(analyticsProvider)
        .log(
          AEvents.feedOpened,
          props: {
            'source': widget.args.categoryFilter == null
                ? 'unknown'
                : 'filtered',
            'has_filter': filter != null && filter.isNotEmpty,
            'filter': filter?.toList(),
            'initial_index': widget.args.initialIndex,
          },
        );
  }

  List<KathaCard> _visible(List<KathaCard> full) {
    final ids = widget.args.cardIds;
    if (ids != null && ids.isNotEmpty) {
      final byId = {for (final c in full) c.id: c};
      return ids.map((id) => byId[id]).whereType<KathaCard>().toList();
    }
    final f = widget.args.categoryFilter;
    if (f == null || f.isEmpty) return full;
    return full.where((c) => f.contains(c.category)).toList();
  }

  int _startPage(List<KathaCard> full, List<KathaCard> visible) {
    if (visible.isEmpty) return 0;
    final ids = widget.args.cardIds;
    if (ids != null && ids.isNotEmpty) {
      return widget.args.initialIndex.clamp(0, visible.length - 1);
    }
    final filter = widget.args.categoryFilter;
    if (filter == null || filter.isEmpty) {
      return widget.args.initialIndex.clamp(0, visible.length - 1);
    }
    final fi = widget.args.initialIndex.clamp(0, full.length - 1);
    final targetId = full[fi].id;
    final j = visible.indexWhere((c) => c.id == targetId);
    return j >= 0 ? j : 0;
  }

  void _scheduleControllerIfNeeded(
    List<KathaCard> full,
    List<KathaCard> visible,
  ) {
    if (_controller != null || visible.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _controller != null) return;
      final freshFull = ref.read(catalogProvider).valueOrNull;
      if (freshFull == null || freshFull.isEmpty) return;
      final vis = _visible(freshFull);
      if (vis.isEmpty) return;
      final start = _startPage(freshFull, vis);
      setState(() {
        _index = start;
        _controller = PageController(initialPage: start);
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _saveCurrent(String lang, KathaCard card) async {
    final bytes = await CardShareExport.renderKathaCardPngBytes(
      context: context,
      card: card,
      contentLanguage: lang,
    );
    final ok = await CardShareExport.savePngBytesToGallery(
      bytes: bytes,
      nameStem: 'daily_katha_${card.id}',
    );
    if (!mounted) return;
    if (ok) setState(() => _savedIds.add(card.id));
    if (ok) {
      await UserEngagementStore.recordSaved(card.id);
      await UserEngagementStore.bumpCategoryAffinity(card.category);
      await ref.read(userStatsProvider.notifier).incrementSaved();
      ref.invalidate(userEngagementProvider);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Saved to gallery' : 'Could not save to gallery'),
      ),
    );
  }

  Future<void> _toggleLike(KathaCard c) async {
    final id = c.id;
    final liked = await UserEngagementStore.toggleLiked(id, c.category);
    await ref.read(analyticsProvider).log(
          AEvents.cardLikeToggled,
          props: {
            'card_id': id,
            'category': c.category,
            'liked': liked,
          },
        );
    if (liked) await _syncLikeToBackend(id);
    ref.invalidate(userEngagementProvider);
    if (mounted) setState(() {});
  }

  Future<void> _syncLikeToBackend(String normalizedId) async {
    if (!_cardIdLooksLikeUuid(normalizedId)) return;
    final session = ref.read(sessionHolderProvider);
    final t = session?.accessToken;
    if (t == null ||
        t.isEmpty ||
        t == 'mock_access' ||
        session?.profile.id == 'demo-user') {
      return;
    }
    try {
      await ref.read(userActionsServiceProvider).like(normalizedId);
    } catch (_) {}
  }

  Future<void> _shareCurrentDirect(String lang, KathaCard card) async {
    if (_sharing || !mounted) return;
    setState(() => _sharing = true);
    try {
      await ref.read(analyticsProvider).log(
            AEvents.shareClicked,
            props: {
              'channel': 'whatsapp_status',
              'source': 'feed_quick',
              'card_id': card.id,
              'category': card.category,
            },
          );
      await CardShareExport.shareKathaCardAsImage(
        context: context,
        card: card,
        contentLanguage: lang,
        shareService: ref.read(shareServiceProvider),
      );
      await UserEngagementStore.recordShared(card.id);
      await UserEngagementStore.bumpCategoryAffinity(card.category);
      await ref.read(userStatsProvider.notifier).incrementShared();
      ref.invalidate(userEngagementProvider);
      await ref.read(analyticsProvider).log(
            AEvents.shareSheetOpened,
            props: {'channel': 'whatsapp_status', 'source': 'feed_quick'},
          );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  static ButtonStyle _feedOutlineStyle(TextTheme tt) =>
      OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide.none,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        minimumSize: const Size(double.infinity, 50),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      );

  void _editCurrent(String lang, KathaCard card) {
    context.push(
      '/edit',
      extra: CardEditorArgs(
        card: card,
        contentLanguage: lang,
        preferStatusPrimaryCta: true,
      ),
    );
  }

  void _seekTo(List<KathaCard> visible, int page) {
    final c = _controller;
    if (c == null || visible.isEmpty) return;
    final i = page.clamp(0, visible.length - 1);
    c.animateToPage(
      i,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionHolderProvider);
    final lang = effectiveContentLanguage(session);
    final catalog = ref.watch(catalogProvider);
    final likedSnap = ref.watch(userEngagementProvider);
    final likedSet = likedSnap.valueOrNull?.likedCardIds.toSet() ?? {};
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final topInset = MediaQuery.paddingOf(context).top;
    final l10n = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.feedScaffold,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.feedScaffold,
        body: catalog.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.white),
          ),
          error: (e, _) => Center(
            child: Text(
              '${l10n.errorGeneric}: $e',
              style: const TextStyle(color: AppColors.white),
            ),
          ),
          data: (cards) {
            if (cards.isEmpty) {
              return Center(
                child: Text(
                  l10n.noCards,
                  style: const TextStyle(color: AppColors.white),
                ),
              );
            }
            final visible = _visible(cards);
            if (visible.isEmpty) {
              return Center(
                child: Text(
                  l10n.noCards,
                  style: const TextStyle(color: AppColors.white),
                ),
              );
            }

            final ctrl = _controller;
            if (ctrl == null) {
              _scheduleControllerIfNeeded(cards, visible);
              return const Center(
                child: CircularProgressIndicator(color: AppColors.white),
              );
            }

            final card = visible[_index.clamp(0, visible.length - 1)];
            final headerBottom = topInset + 52;
            final bottomBarH = 86.0 + bottomInset;

            return LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    /// Card — double-tap to like · share pill on-card.
                    Positioned(
                      left: 28,
                      right: 28,
                      top: headerBottom,
                      bottom: bottomBarH,
                      child: Center(
                        child: PageView.builder(
                          scrollDirection: Axis.vertical,
                          controller: ctrl,
                          itemCount: visible.length,
                          onPageChanged: (i) => setState(() => _index = i),
                          itemBuilder: (context, i) {
                            final c = visible[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 8,
                              ),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onDoubleTap: () => _toggleLike(c),
                                child: SizedBox.expand(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Center(
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            width: CardShareExport
                                                .logicalExportWidth,
                                            height: CardShareExport
                                                .logicalExportHeight,
                                            child: StatusCard(
                                              card: c,
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
                                      Positioned(
                                        left: 24,
                                        right: 24,
                                        bottom: 10,
                                        child: Material(
                                          color: Colors.white.withValues(
                                            alpha: 0.14,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(999),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(999),
                                            onTap: _sharing
                                                ? null
                                                : () => _shareCurrentDirect(
                                                      lang,
                                                      c,
                                                    ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 10,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.share,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text(
                                                      l10n.homeShareToStatus,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          ProtoActionPill.typographyOnly(
                                                        context,
                                                      ).copyWith(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    /// Top chrome: back · Feed / n of m · search
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        bottom: false,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.55),
                                Colors.black.withValues(alpha: 0),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              Material(
                                color: Colors.white.withValues(alpha: 0.14),
                                shape: const CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () => context.pop(),
                                  customBorder: const CircleBorder(),
                                  child: const SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Icon(
                                      Icons.chevron_left,
                                      size: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      l10n.feedScreenLabel.toUpperCase(),
                                      style: tt.labelLarge?.copyWith(
                                        fontSize: 11,
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      l10n.feedIndexOf(
                                        _index + 1,
                                        visible.length,
                                      ),
                                      style: tt.titleMedium?.copyWith(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Material(
                                color: Colors.white.withValues(alpha: 0.14),
                                shape: const CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () => context.go('/explore'),
                                  customBorder: const CircleBorder(),
                                  child: const SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Icon(
                                      Icons.search,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// Left vertical dots
                    Positioned(
                      left: 12,
                      top: headerBottom + 8,
                      bottom: bottomBarH + 8,
                      width: 12,
                      child: Center(
                        child: _FeedPageDots(
                          count: visible.length,
                          index: _index,
                          onTap: (i) => _seekTo(visible, i),
                        ),
                      ),
                    ),

                    /// Bottom: single tray — ♥ · Edit · Save (order per spec).
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SafeArea(
                        top: false,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.72),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.35),
                                border: Border.all(
                                  color:
                                      Colors.white.withValues(alpha: 0.22),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => _toggleLike(card),
                                        child: SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Icon(
                                              likedSet.contains(card.id)
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              size: 24,
                                              color: likedSet
                                                      .contains(card.id)
                                                  ? Colors.redAccent
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1.5,
                                    height: 32,
                                    color: Colors.white.withValues(alpha: 0.18),
                                  ),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          _editCurrent(lang, card),
                                      style: _feedOutlineStyle(tt),
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Edit',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: tt.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.1,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1.5,
                                    height: 32,
                                    color: Colors.white.withValues(alpha: 0.18),
                                  ),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          _saveCurrent(lang, card),
                                      style: _feedOutlineStyle(tt),
                                      icon: const Icon(
                                        Icons.download_outlined,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Save',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: tt.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.1,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _FeedPageDots extends StatelessWidget {
  const _FeedPageDots({
    required this.count,
    required this.index,
    required this.onTap,
  });

  final int count;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(count, (i) {
          final active = i == index;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 4,
                height: active ? 22 : 4,
                decoration: BoxDecoration(
                  color: active
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.32),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
