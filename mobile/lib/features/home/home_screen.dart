import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/app_config.dart';
import '../../core/content_language.dart';
import '../../data/local/mock_catalog.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/genre_localizer.dart';
import '../../models/feed_route_args.dart';
import '../../models/katha_card.dart';
import '../../models/section_preview_args.dart';
import '../../models/user_profile.dart';
import '../../services/card_share_export.dart';
import '../../theme/app_colors.dart';
import '../../utils/error_handler.dart';
import '../../widgets/app_background.dart';
import '../../widgets/mini_card.dart';
import '../../widgets/status_card.dart';

String _firstName(UserSession? session) {
  final raw = session?.profile.displayName;
  if (raw == null || raw.trim().isEmpty) return 'Friend';
  return raw.trim().split(' ').first;
}

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

  KathaCard _heroCard(List<KathaCard> cards, List<String> interestIds) {
    for (final id in interestIds) {
      for (final c in cards) {
        if (c.category == id) return c;
      }
    }
    return cards.first;
  }

  List<String> _interestOrder(List<String> ids) {
    final preferred = MockCatalog.interests.map((e) => e.id).where(ids.contains).toList();
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

  Future<void> _shareHero(BuildContext context, WidgetRef ref, String lang, KathaCard card) async {
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).preparingCard)),
    );
    await CardShareExport.shareKathaCardAsImage(
      context: context,
      card: card,
      contentLanguage: lang,
      shareService: ref.read(shareServiceProvider),
    );
    final demo = ref.read(sessionHolderProvider)?.accessToken == 'mock_access';
    if (!AppConfig.useMockApi && !demo && context.mounted) {
      try {
        await ref.read(userActionsServiceProvider).share(cardId: card.id, channel: 'whatsapp_status');
      } catch (_) {}
    }
  }

  Future<void> _saveHero(BuildContext context, WidgetRef ref, String lang, KathaCard card) async {
    final bytes = await CardShareExport.renderKathaCardPngBytes(
      context: context,
      card: card,
      contentLanguage: lang,
    );
    final ok = await CardShareExport.savePngBytesToGallery(bytes: bytes, nameStem: 'daily_katha_${card.id}');
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Saved to gallery' : 'Could not save to gallery')),
    );
  }

  void _showNotifications(BuildContext context, String lang, AppLocalizations l10n) {
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
                style: const TextStyle(color: AppColors.protoInk, fontWeight: FontWeight.w700),
              ),
            ),
            for (final n in MockCatalog.notifications)
              ListTile(
                leading: Text(n.icon, style: const TextStyle(fontSize: 22)),
                title: Text(n.titleFor(lang), style: const TextStyle(color: AppColors.protoInk)),
                subtitle: Text(n.bodyFor(lang), style: const TextStyle(color: AppColors.protoInk3)),
                trailing: Text(n.timeAgo, style: const TextStyle(fontSize: 12, color: AppColors.protoInk4)),
              ),
          ],
        );
      },
    );
  }

  String _dateLine() => DateFormat('EEEE · d MMM').format(DateTime.now());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionHolderProvider);
    final lang = effectiveContentLanguage(session);
    final userInterestIds = session?.profile.interestIds ?? const <String>[];
    final interests = userInterestIds.isEmpty ? MockCatalog.interests.take(3).map((e) => e.id).toList() : _interestOrder(userInterestIds.toList());
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
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.protoBrand)),
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
              final hero = _heroCard(cards, interests);

              List<KathaCard> byInterest(String id) =>
                  cards.where((c) => c.category == id).toList();

              final trending = cards.where((c) => c.section == 'trending').toList();

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
                                    _firstName(session),
                                  ),
                                  style: tt.headlineSmall?.copyWith(fontSize: 26),
                                ),
                              ],
                            ),
                          ),
                          Material(
                            color: AppColors.protoSurface,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => _showNotifications(context, lang, l10n),
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Icon(Icons.notifications_none, color: AppColors.protoInk, size: 22),
                                    Positioned(
                                      top: 10,
                                      right: 12,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: AppColors.protoBrand,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: AppColors.protoSurface, width: 1.5),
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
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.homeHeroKicker.toUpperCase(),
                              style: tt.labelLarge?.copyWith(letterSpacing: 2, fontSize: 12),
                            ),
                          ),
                          Icon(Icons.local_fire_department_outlined, size: 14, color: AppColors.protoSaffron),
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
                                    onTap: () => _openFeed(context, cards, cards.indexOf(hero)),
                                    child: StatusCard(
                                      card: hero,
                                      contentLanguage: lang,
                                      compact: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                            child: FilledButton.icon(
                              onPressed: () => _shareHero(context, ref, lang, hero),
                              icon: const Icon(Icons.ios_share, size: 20),
                              label: Text(l10n.homeShareToStatus),
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                                  border: Border.all(color: AppColors.protoBorder, width: 1.5),
                                ),
                                child: const Icon(Icons.bookmark_outline, color: AppColors.protoInk),
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
                            onViewAll: () => _openSectionPreview(
                              context,
                              cards,
                              cards.indexOf(byInterest(interest).first),
                              title: GenreLocalizer.getName(interest, lang),
                              tag: l10n.sectionForYou,
                              categoryFilter: {interest},
                            ),
                            onCard: (c) => _openSectionPreview(
                              context,
                              cards,
                              cards.indexOf(c),
                              title: GenreLocalizer.getName(interest, lang),
                              tag: l10n.sectionForYou,
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
                          onViewAll: () => _openSectionPreview(
                            context,
                            cards,
                            cards.indexOf(trending.first),
                            title: l10n.homeSectionTrendingTitle,
                            tag: l10n.sectionTrending,
                          ),
                          onCard: (c) => _openSectionPreview(
                            context,
                            cards,
                            cards.indexOf(c),
                            title: l10n.homeSectionTrendingTitle,
                            tag: l10n.sectionTrending,
                          ),
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
                    Text(
                      title,
                      style: tt.titleLarge?.copyWith(fontSize: 21),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: tt.bodySmall?.copyWith(color: AppColors.protoInk3),
                      )
                    else
                      Text(
                        l10n.homeRailNewToday(count),
                        style: tt.bodySmall?.copyWith(color: AppColors.protoInk3),
                      ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(foregroundColor: AppColors.protoBrand),
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
              return MiniCard(
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
