// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/content_language.dart';
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
import '../../widgets/status_card.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key, required this.args});

  final FeedRouteArgs args;

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
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
    ref.read(analyticsProvider).log(
      AEvents.feedOpened,
      props: {
        'source': widget.args.categoryFilter == null ? 'unknown' : 'filtered',
        'has_filter': filter != null && filter.isNotEmpty,
        'filter': filter?.toList(),
        'initial_index': widget.args.initialIndex,
      },
    );
  }

  List<KathaCard> _visible(List<KathaCard> full) {
    final f = widget.args.categoryFilter;
    if (f == null || f.isEmpty) return full;
    return full.where((c) => f.contains(c.category)).toList();
  }

  int _startPage(List<KathaCard> full, List<KathaCard> visible) {
    if (visible.isEmpty) return 0;
    final filter = widget.args.categoryFilter;
    if (filter == null || filter.isEmpty) {
      return widget.args.initialIndex.clamp(0, visible.length - 1);
    }
    final fi = widget.args.initialIndex.clamp(0, full.length - 1);
    final targetId = full[fi].id;
    final j = visible.indexWhere((c) => c.id == targetId);
    return j >= 0 ? j : 0;
  }

  void _scheduleControllerIfNeeded(List<KathaCard> full, List<KathaCard> visible) {
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
      await ref.read(userStatsProvider.notifier).incrementSaved();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Saved to gallery' : 'Could not save to gallery'),
      ),
    );
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
      await ref.read(userStatsProvider.notifier).incrementShared();
      await ref.read(analyticsProvider).log(
        AEvents.shareSheetOpened,
        props: {
          'channel': 'whatsapp_status',
          'source': 'feed_quick',
        },
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  void _editCurrent(String lang, KathaCard card) {
    context.push(
      '/edit',
      extra: CardEditorArgs(card: card, contentLanguage: lang, preferStatusPrimaryCta: true),
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
    // Likes are currently not shown in this chrome; keep provider wiring minimal.
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final topInset = MediaQuery.paddingOf(context).top;
    final l10n = AppLocalizations.of(context);

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
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.white)),
          error: (e, _) => Center(
            child: Text(
              '${l10n.errorGeneric}: $e',
              style: const TextStyle(color: AppColors.white),
            ),
          ),
          data: (cards) {
            if (cards.isEmpty) {
              return Center(child: Text(l10n.noCards, style: const TextStyle(color: AppColors.white)));
            }
            final visible = _visible(cards);
            if (visible.isEmpty) {
              return Center(child: Text(l10n.noCards, style: const TextStyle(color: AppColors.white)));
            }

            final ctrl = _controller;
            if (ctrl == null) {
              _scheduleControllerIfNeeded(cards, visible);
              return const Center(child: CircularProgressIndicator(color: AppColors.white));
            }

            final card = visible[_index.clamp(0, visible.length - 1)];
            final headerBottom = topInset + 52;
            final bottomBarH = 86.0 + bottomInset;

            return LayoutBuilder(
              builder: (context, constraints) {
                final h = constraints.maxHeight - headerBottom - bottomBarH;
                final cardHeight = h.clamp(320.0, constraints.maxHeight);

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    /// Card — centered, with optional quick-share on-card button.
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
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                              child: Stack(
                                children: [
                                  Center(
                                    child: StatusCard(
                                      card: c,
                                      contentLanguage: lang,
                                      height: cardHeight,
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 10,
                                    child: Center(
                                      child: Material(
                                        color: Colors.white.withValues(alpha: 0.14),
                                        borderRadius: BorderRadius.circular(999),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(999),
                                          onTap: _sharing ? null : () => _shareCurrentDirect(lang, c),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.share, size: 18, color: Colors.white),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Share to Status',
                                                  style: GoogleFonts.dmSans(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                    letterSpacing: -0.1,
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
                                    child: Icon(Icons.chevron_left, size: 22, color: Colors.white),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      l10n.feedScreenLabel.toUpperCase(),
                                      style: GoogleFonts.dmSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2,
                                        color: Colors.white.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      l10n.feedIndexOf(_index + 1, visible.length),
                                      style: GoogleFonts.dmSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
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
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Search coming soon')),
                                    );
                                  },
                                  customBorder: const CircleBorder(),
                                  child: const SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Icon(Icons.search, size: 20, color: Colors.white),
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

                    /// Bottom: professional action bar (Edit / Save / Share to Status)
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
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _editCurrent(lang, card),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  icon: const Icon(Icons.edit_outlined, size: 18),
                                  label: Text('Edit', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _saveCurrent(lang, card),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  icon: const Icon(Icons.download_outlined, size: 18),
                                  label: Text('Save', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: _sharing ? null : () => _shareCurrentDirect(lang, card),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.protoBrandDeep,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  icon: const Icon(Icons.ios_share, size: 18),
                                  label: Text('Status', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                                ),
                              ),
                            ],
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
                  color: active ? Colors.white : Colors.white.withValues(alpha: 0.32),
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

