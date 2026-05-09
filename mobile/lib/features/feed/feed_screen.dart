import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_config.dart';
import '../../core/content_language.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../models/card_editor_args.dart';
import '../../models/feed_route_args.dart';
import '../../models/katha_card.dart';
import '../../services/card_share_export.dart';
import '../../theme/app_colors.dart';
import '../../utils/error_handler.dart';
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
  final Set<String> _savedIds = {};

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
    if (ok) setState(() => _savedIds.add(card.id));
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
            final bottomBarH = 72.0 + bottomInset;

            return LayoutBuilder(
              builder: (context, constraints) {
                final h = constraints.maxHeight - headerBottom - bottomBarH;
                final cardHeight = h.clamp(320.0, constraints.maxHeight);

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    /// Card — inset for left dots + right rail (`screens-feed.jsx`).
                    Positioned(
                      left: 28,
                      right: 72,
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
                              child: StatusCard(
                                card: c,
                                contentLanguage: lang,
                                height: cardHeight,
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

                    /// Right side action rail
                    Positioned(
                      right: 10,
                      top: headerBottom,
                      bottom: bottomBarH,
                      width: 56,
                      child: Center(
                        child: _FeedSideRail(
                          liked: liked.contains(card.id),
                          saved: _savedIds.contains(card.id),
                          onLike: () => _toggleLike(card.id),
                          onSave: () => _saveCurrent(lang, card),
                          onEdit: () => _editCurrent(lang, card),
                          onShare: _sharing ? () {} : () => _shareCurrent(lang, card),
                        ),
                      ),
                    ),

                    /// Bottom: Share to WhatsApp Status + photo (editor)
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
                                child: FilledButton.icon(
                                  onPressed: _sharing ? null : () => _shareCurrent(lang, card),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.protoBrandDeep,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  icon: const Icon(Icons.share, size: 20),
                                  label: Text(
                                    l10n.shareToWhatsAppStatus,
                                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Material(
                                color: Colors.white.withValues(alpha: 0.14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () => _editCurrent(lang, card),
                                  child: const SizedBox(
                                    width: 56,
                                    height: 48,
                                    child: Icon(Icons.photo_outlined, color: Colors.white, size: 22),
                                  ),
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

class _FeedSideRail extends StatelessWidget {
  const _FeedSideRail({
    required this.liked,
    required this.saved,
    required this.onLike,
    required this.onSave,
    required this.onEdit,
    required this.onShare,
  });

  final bool liked;
  final bool saved;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onEdit;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    const gap = 12.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RailAction(
          label: liked ? 'Liked' : 'Like',
          active: liked,
          accent: const Color(0xFFFF5A6E),
          icon: liked ? Icons.favorite : Icons.favorite_border,
          onTap: onLike,
        ),
        const SizedBox(height: gap),
        _RailAction(
          label: saved ? 'Saved' : 'Save',
          active: saved,
          accent: AppColors.protoSaffron,
          icon: saved ? Icons.bookmark : Icons.bookmark_border,
          onTap: onSave,
        ),
        const SizedBox(height: gap),
        _RailAction(
          label: 'Edit',
          active: false,
          accent: Colors.white,
          icon: Icons.edit_outlined,
          onTap: onEdit,
        ),
        const SizedBox(height: gap),
        _RailAction(
          label: 'Share',
          active: false,
          accent: Colors.white,
          icon: Icons.ios_share,
          onTap: onShare,
        ),
      ],
    );
  }
}

class _RailAction extends StatelessWidget {
  const _RailAction({
    required this.label,
    required this.active,
    required this.accent,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color accent;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? Colors.white.withValues(alpha: 0.95) : Colors.white.withValues(alpha: 0.14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
              ),
              child: Icon(icon, size: 20, color: active ? accent : Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
