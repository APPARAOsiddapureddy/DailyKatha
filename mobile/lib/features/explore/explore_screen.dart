import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/content_language.dart';
import '../../data/local/mock_catalog.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/genre_localizer.dart';
import '../../models/feed_route_args.dart';
import '../../models/katha_card.dart';
import '../../models/section_preview_args.dart';
import '../../theme/app_colors.dart';
import '../../theme/proto_category_palette.dart';
import '../../utils/error_handler.dart';
import '../../widgets/app_background.dart';

/// Mirrors `screens-main.jsx` ExploreScreen — single scroll, no tabs.
/// Catalog text/images come from the API; layout/tokens match the web prototype.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  static void _openInterest(
    BuildContext context,
    List<KathaCard> all,
    String interestId,
    String title,
    String tag,
  ) {
    final idx = all.indexWhere((c) => c.category == interestId);
    context.push(
      '/section',
      extra: SectionPreviewArgs(
        title: title,
        tag: tag,
        initialIndex: idx >= 0 ? idx : 0,
        categoryFilter: {interestId},
      ),
    );
  }

  static void _openFestivalFeatured(BuildContext context, List<KathaCard> all, String lang) {
    final idx = all.indexWhere((c) => c.category == 'festival' || c.section == 'festival');
    context.push(
      '/section',
      extra: SectionPreviewArgs(
        title: GenreLocalizer.getName('festival', lang),
        tag: '',
        initialIndex: idx >= 0 ? idx : 0,
        categoryFilter: {'festival'},
      ),
    );
  }

  static void _openPack(BuildContext context, List<KathaCard> cards, String category) {
    final idx = cards.indexWhere((c) => c.category == category);
    context.push(
      '/feed',
      extra: FeedRouteArgs(
        initialIndex: idx >= 0 ? idx : 0,
        categoryFilter: {category},
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
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.protoBrand)),
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
              final l10n = AppLocalizations.of(context);
              final interests = MockCatalog.interests.take(9).toList();
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.exploreHeadline,
                            style: GoogleFonts.spectral(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.4,
                              color: AppColors.protoInk,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.exploreSubtitle,
                            style: GoogleFonts.dmSans(
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
                      child: SizedBox(
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
                              const SizedBox(width: 14),
                              Icon(Icons.search, size: 20, color: AppColors.protoInk3),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  l10n.exploreSearchHint,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    color: AppColors.protoInk3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverToBoxAdapter(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () => _openFestivalFeatured(context, cards, lang),
                          child: Ink(
                            height: 168,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF7E1F0E),
                                  Color(0xFFB33A20),
                                  Color(0xFFE89B2C),
                                ],
                                stops: [0.0, 0.6, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7E1F0E).withValues(alpha: 0.22),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.18),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        l10n.exploreFestivalLive,
                                        style: GoogleFonts.dmSans(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.exploreFestivalTitle,
                                          style: GoogleFonts.spectral(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.3,
                                            height: 1.1,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          l10n.exploreFestivalBody,
                                          style: GoogleFonts.dmSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white.withValues(alpha: 0.78),
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
                  SliverToBoxAdapter(child: _SectionHead(title: l10n.exploreByInterest, sub: l10n.exploreByInterestSub)),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = interests[index];
                          final bg = ProtoCategoryPalette.bg(item.id);
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _openInterest(
                                context,
                                cards,
                                item.id,
                                GenreLocalizer.getName(item.id, lang),
                                l10n.sectionForYou,
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: bg,
                                  boxShadow: [
                                    BoxShadow(
                                      color: bg.withValues(alpha: 0.25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.emoji, style: const TextStyle(fontSize: 22)),
                                    Text(
                                      GenreLocalizer.getName(item.id, lang),
                                      style: GoogleFonts.dmSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.1,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: interests.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: _SectionHead(title: l10n.exploreCuratedPacks, sub: l10n.exploreCuratedPacksSub)),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _CuratedPackRow(
                          paletteBg: ProtoCategoryPalette.bg('motivation'),
                          title: l10n.explorePack1Title,
                          sub: l10n.explorePack1Sub,
                          onTap: () => _openPack(context, cards, 'motivation'),
                        ),
                        const SizedBox(height: 10),
                        _CuratedPackRow(
                          paletteBg: ProtoCategoryPalette.bg('family'),
                          title: l10n.explorePack2Title,
                          sub: l10n.explorePack2Sub,
                          onTap: () => _openPack(context, cards, 'family'),
                        ),
                        const SizedBox(height: 10),
                        _CuratedPackRow(
                          paletteBg: ProtoCategoryPalette.bg('goodnight'),
                          title: l10n.explorePack3Title,
                          sub: l10n.explorePack3Sub,
                          onTap: () => _openPack(context, cards, 'goodnight'),
                        ),
                      ]),
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

class _SectionHead extends StatelessWidget {
  const _SectionHead({required this.title, required this.sub});

  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.spectral(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
              height: 1.15,
              color: AppColors.protoInk,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.protoInk3, letterSpacing: 0.1),
          ),
        ],
      ),
    );
  }
}

class _CuratedPackRow extends StatelessWidget {
  const _CuratedPackRow({
    required this.paletteBg,
    required this.title,
    required this.sub,
    required this.onTap,
  });

  final Color paletteBg;
  final String title;
  final String sub;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.protoSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.protoBorder),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 76,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: paletteBg,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                          stops: const [0.5, 1],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      left: 7,
                      right: 7,
                      child: Text(
                        'Aa',
                        style: GoogleFonts.spectral(
                          fontSize: 9,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.1,
                        color: AppColors.protoInk,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      sub,
                      style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.protoInk3),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 18, color: AppColors.protoInk4),
            ],
          ),
        ),
      ),
    );
  }
}
