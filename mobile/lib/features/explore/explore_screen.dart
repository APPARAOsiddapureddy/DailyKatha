import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content_language.dart';
import '../../data/local/story_pack_catalog.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../models/feed_route_args.dart';
import '../../models/katha_card.dart';
import '../../theme/app_colors.dart';
import '../../utils/daily_card_picker.dart';
import '../../utils/error_handler.dart';
import '../../utils/explore_search_resolver.dart';
import '../../widgets/app_background.dart';
import '../../widgets/story_pack_tile.dart';

/// Mirrors `screens-main.jsx` ExploreScreen — single scroll, no tabs.
/// Catalog text/images come from the API; layout/tokens match the web prototype.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  static void _openPack(
    BuildContext context,
    List<KathaCard> all,
    String packId,
  ) {
    final pick = DailyCardPicker.pickForCategory(all, packId);
    final ix = all.indexWhere((c) => c.id == pick.id);
    context.push(
      '/feed',
      extra: FeedRouteArgs(
        initialIndex: ix >= 0 ? ix : 0,
        categoryFilter: {packId},
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionHolderProvider);
    final lang = effectiveContentLanguage(session);
    final catalog = ref.watch(catalogProvider);

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  e is DioException
                      ? ErrorHandler.fromDioException(e).userMessage
                      : '${AppLocalizations.of(context).errorGeneric}: $e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.protoInk),
                ),
              ),
            ),
            data: (cards) {
              final tt = Theme.of(context).textTheme;
              const featuredPacks = StoryPackCatalog.featuredPacks;
              const allPacks = StoryPackCatalog.packs;
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Browse the story library',
                            style: tt.headlineMedium?.copyWith(fontSize: 30),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Choose a devotional or ancient-history pack and open any card to continue the journey.',
                            style: tt.bodyLarge?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.protoInk3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                    sliver: SliverToBoxAdapter(
                      child: _ExploreSearchField(cards: cards),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverToBoxAdapter(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () =>
                              _openPack(context, cards, featuredPacks.first.id),
                          child: Ink(
                            height: 168,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF463520),
                                  Color(0xFF7E1F0E),
                                  Color(0xFFE89B2C),
                                ],
                                stops: [0.0, 0.6, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF7E1F0E,
                                  ).withValues(alpha: 0.22),
                                  blurRadius: 32,
                                  offset: const Offset(0, 16),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(22),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -20,
                                  right: -20,
                                  child: Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          const Color(0x59FFDD85),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 11,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.18,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: Text(
                                        'Start Mahabharata',
                                        style: tt.labelLarge?.copyWith(
                                          fontSize: 10,
                                          letterSpacing: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '100-day journey',
                                          style: tt.headlineSmall?.copyWith(
                                            fontSize: 28,
                                            height: 1.1,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Open the first card and scroll through the full path at your own pace.',
                                          style: tt.bodyMedium?.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white.withValues(
                                              alpha: 0.78,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _SectionHead(
                      title: 'Featured story packs',
                      sub: 'Five packs first, then the full library below',
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.96,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final pack = featuredPacks[index];
                        return StoryPackTile(
                          pack: pack,
                          contentLanguage: lang,
                          compact: false,
                          onTap: () => _openPack(context, cards, pack.id),
                        );
                      }, childCount: featuredPacks.length),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _SectionHead(
                      title: 'All story packs',
                      sub: 'Tap any pack to open its full card stream',
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.92,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final pack = allPacks[index];
                        return StoryPackTile(
                          pack: pack,
                          contentLanguage: lang,
                          compact: true,
                          onTap: () => _openPack(context, cards, pack.id),
                        );
                      }, childCount: allPacks.length),
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

class _ExploreSearchField extends ConsumerStatefulWidget {
  const _ExploreSearchField({required this.cards});

  final List<KathaCard> cards;

  @override
  ConsumerState<_ExploreSearchField> createState() =>
      _ExploreSearchFieldState();
}

class _ExploreSearchFieldState extends ConsumerState<_ExploreSearchField> {
  late final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final lang = effectiveContentLanguage(ref.read(sessionHolderProvider));
    final id = ExploreSearchResolver.resolve(_controller.text, lang);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    if (id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.exploreSearchNoMatch)));
      return;
    }
    ExploreScreen._openPack(context, widget.cards, id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.protoSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.protoInk.withValues(alpha: 0.04),
              blurRadius: 8,
            ),
          ],
          border: Border.all(color: AppColors.protoBorder),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Icon(Icons.search, size: 20, color: AppColors.protoInk3),
            const SizedBox(width: 6),
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _submit(),
                style: tt.bodyLarge?.copyWith(
                  fontSize: 16,
                  color: AppColors.protoInk,
                ),
                cursorColor: AppColors.protoBrand,
                decoration: InputDecoration(
                  hintText: l10n.exploreSearchHint,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  hintStyle: tt.bodyLarge?.copyWith(
                    fontSize: 16,
                    color: AppColors.protoInk3,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Search',
              onPressed: _submit,
              icon: Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.protoBrand,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHead extends StatelessWidget {
  const _SectionHead({required this.title, required this.sub});

  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: tt.titleLarge?.copyWith(fontSize: 22, height: 1.15),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: tt.bodySmall?.copyWith(
              fontSize: 12,
              letterSpacing: 0.1,
              color: AppColors.protoInk3,
            ),
          ),
        ],
      ),
    );
  }
}
