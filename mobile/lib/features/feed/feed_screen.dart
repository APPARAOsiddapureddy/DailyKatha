import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_config.dart';
import '../../core/content_language.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/genre_localizer.dart';
import '../../models/card_editor_args.dart';
import '../../models/feed_route_args.dart';
import '../../models/katha_card.dart';
import '../../services/card_share_export.dart';
import '../../theme/app_colors.dart';
import '../../theme/status_luxe_palette.dart';
import '../../utils/error_handler.dart';
import '../../widgets/action_rail.dart';
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
  bool _sharing = false;

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

  Future<void> _toggleLike(String id) async {
    final wasLiked = ref.read(likedIdsProvider).contains(id);
    ref.read(likedIdsProvider.notifier).toggle(id);
    final demo = ref.read(sessionHolderProvider)?.accessToken == 'mock_access';
    if (!AppConfig.useMockApi && !demo) {
      final actions = ref.read(userActionsServiceProvider);
      try {
        if (wasLiked) {
          await actions.unlike(id);
        } else {
          await actions.like(id);
        }
      } catch (e) {
        if (!mounted) return;
        ref.read(likedIdsProvider.notifier).toggle(id); // rollback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandler.userMessage(context, e))),
        );
      }
    }
  }

  Future<void> _shareCurrent(
    String lang,
    KathaCard card,
  ) async {
    if (_sharing || !mounted) return;
    setState(() => _sharing = true);
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).preparingCard),
        duration: const Duration(seconds: 2),
      ),
    );
    try {
      await CardShareExport.shareKathaCardAsImage(
        context: context,
        card: card,
        contentLanguage: lang,
        shareService: ref.read(shareServiceProvider),
      );
      final demo = ref.read(sessionHolderProvider)?.accessToken == 'mock_access';
      if (!AppConfig.useMockApi && !demo) {
        try {
          await ref.read(userActionsServiceProvider).share(cardId: card.id, channel: 'whatsapp_status');
        } catch (_) {}
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Saved to gallery' : 'Could not save to gallery'),
      ),
    );
  }

  void _editCurrent(String lang, KathaCard card) {
    context.push(
      '/edit',
      extra: CardEditorArgs(card: card, contentLanguage: lang),
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
    final liked = ref.watch(likedIdsProvider);
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.feedScaffold,
      body: catalog.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.white)),
        error: (e, _) => Center(
          child: Text(
            '${AppLocalizations.of(context).errorGeneric}: $e',
            style: const TextStyle(color: AppColors.white),
          ),
        ),
        data: (cards) {
          final l10n = AppLocalizations.of(context);
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
          final luxe = StatusLuxePalette.forCategory(card.category);
          final genreLabel = GenreLocalizer.getName(card.category, lang);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Leave breathing room so the top header never overlaps the card.
                    final cardHeight = (constraints.maxHeight - 140).clamp(420.0, constraints.maxHeight);
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        PageView.builder(
                          scrollDirection: Axis.vertical,
                          controller: ctrl,
                          itemCount: visible.length,
                          onPageChanged: (i) => setState(() => _index = i),
                          itemBuilder: (context, i) {
                            final c = visible[i];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(18, 36, 18, 14),
                              child: Center(
                                child: StatusCard(
                                  card: c,
                                  contentLanguage: lang,
                                  height: cardHeight,
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: SafeArea(
                            bottom: false,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.feedScaffold.withValues(alpha: 0.94),
                                    AppColors.feedScaffold.withValues(alpha: 0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _FeedProgressStrip(
                                    index: _index,
                                    total: visible.length,
                                    onSeek: (p) => _seekTo(visible, p),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Material(
                                          color: Colors.white.withValues(alpha: 0.08),
                                          shape: const CircleBorder(),
                                          clipBehavior: Clip.antiAlias,
                                          child: InkWell(
                                            onTap: () => context.pop(),
                                            customBorder: const CircleBorder(),
                                            child: const SizedBox(
                                              width: 34,
                                              height: 34,
                                              child: Icon(Icons.arrow_back, size: 18, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'DAILY KATHA',
                                                style: GoogleFonts.dmSans(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 2.2,
                                                  color: Colors.white.withValues(alpha: 0.5),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text.rich(
                                                TextSpan(
                                                  style: GoogleFonts.dmSans(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white.withValues(alpha: 0.28),
                                                    height: 1.35,
                                                  ),
                                                  children: [
                                                    TextSpan(text: '${AppLocalizations.of(context).scrollHint} · '),
                                                    TextSpan(
                                                      text: genreLabel,
                                                      style: GoogleFonts.dmSans(
                                                        fontWeight: FontWeight.w500,
                                                        color: luxe.accent,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
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
                      ],
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 4, 12, 8 + bottomPad),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FeedActionBar(
                        liked: liked.contains(card.id),
                        onLike: () => _toggleLike(card.id),
                        // UX: "Edit" first, then share as Status from inside editor.
                        onShare: () => _editCurrent(lang, card),
                        onDownload: () => _saveCurrent(lang, card),
                        onEdit: _sharing ? () {} : () => _shareCurrent(lang, card),
                      ),
                      const SizedBox(height: 10),
                      // Intentionally minimal: avoid instructional chrome while viewing the card.
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Story-style progress: one segment per card when [total] ≤ 48, else a single filled track.
class _FeedProgressStrip extends StatelessWidget {
  const _FeedProgressStrip({
    required this.index,
    required this.total,
    required this.onSeek,
  });

  final int index;
  final int total;
  final ValueChanged<int> onSeek;

  static const int _maxSeg = 48;

  @override
  Widget build(BuildContext context) {
    if (total <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
      child: SizedBox(
        height: 2,
        child: total <= _maxSeg
            ? Row(
                children: List.generate(total, (i) {
                  final done = i < index;
                  final here = i == index;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.5),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onSeek(i),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ColoredBox(color: Colors.white.withValues(alpha: 0.18)),
                              if (done || here) const ColoredBox(color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(color: Colors.white.withValues(alpha: 0.18)),
                    FractionallySizedBox(
                      widthFactor: (index + 1) / total,
                      alignment: Alignment.centerLeft,
                      child: const ColoredBox(color: Colors.white),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
