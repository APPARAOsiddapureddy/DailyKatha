import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content_language.dart';
import '../../data/local/mock_catalog.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/festival_localizer.dart';
import '../../l10n/genre_localizer.dart';
import '../../l10n/mood_localizer.dart';
import '../../theme/app_colors.dart';
import '../../utils/error_handler.dart';
import '../../widgets/app_background.dart';
import '../../widgets/mini_card.dart';

String _exploreChipLabel(String key, String lang) {
  final f = FestivalLocalizer.getName(key, lang);
  if (f != key) return f;
  return GenreLocalizer.getName(key, lang);
}

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  int _chip = 0;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionHolderProvider);
    final lang = effectiveContentLanguage(session);
    final catalog = ref.watch(catalogProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: AppBackground(
        child: SafeArea(
          child: catalog.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accentGold)),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                e is DioException
                    ? ErrorHandler.fromDioException(e).userMessage
                    : '${AppLocalizations.of(context).errorGeneric}: $e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textPrimaryDark),
              ),
            ),
          ),
          data: (cards) {
            final l10n = AppLocalizations.of(context);
            final trending = cards.where((c) => c.section == 'trending').take(5).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
                  child: TabBar(
                    controller: _tabs,
                    indicatorColor: AppColors.accentGold,
                    indicatorWeight: 2.5,
                    labelColor: AppColors.accentGold,
                    unselectedLabelColor: AppColors.textTertiaryDark,
                    dividerColor: AppColors.borderOnDark,
                    tabs: [
                      Tab(text: l10n.exploreTabDiscover),
                      Tab(text: l10n.exploreTabBrowse),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabs,
                    children: [
                      ListView(
                        padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                        children: [
                          Text(
                            l10n.exploreHeadline,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimaryDark,
                                ),
                          ),
                          Text(
                            l10n.exploreSubtitle,
                            style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.textSecondaryDark),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _search,
                            style: const TextStyle(color: AppColors.textPrimaryDark),
                            decoration: InputDecoration(
                              hintText: l10n.exploreSearchHint,
                              hintStyle: TextStyle(color: AppColors.textTertiaryDark),
                              prefixIcon: const Icon(Icons.search, color: AppColors.accentGold),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(l10n.exploreJumpIn.toUpperCase(), style: _overline),
                          Text(
                            l10n.exploreWhatToShare,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textPrimaryDark),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 52,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _IntentChip(
                                  emoji: '☀️',
                                  genreId: 'goodmorning',
                                  lang: lang,
                                  selected: _chip == 0,
                                  onTap: () {
                                    setState(() => _chip = 0);
                                    context.push('/feed', extra: 0);
                                  },
                                ),
                                _IntentChip(
                                  emoji: '❤️',
                                  genreId: 'love',
                                  lang: lang,
                                  selected: _chip == 1,
                                  onTap: () {
                                    setState(() => _chip = 1);
                                    context.push('/feed', extra: 0);
                                  },
                                ),
                                _IntentChip(
                                  emoji: '🔥',
                                  genreId: 'motivation',
                                  lang: lang,
                                  selected: _chip == 2,
                                  onTap: () {
                                    setState(() => _chip = 2);
                                    context.push('/feed', extra: 0);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 26),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.exploreTrendingLine.toUpperCase(), style: _overline),
                                  Text(
                                    l10n.exploreWeekHit,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textPrimaryDark),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () => context.push('/feed', extra: 0),
                                style: TextButton.styleFrom(foregroundColor: AppColors.accentGold),
                                child: Text(l10n.exploreSeeAll),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 220,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: trending.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 12),
                              itemBuilder: (context, i) => MiniCard(
                                card: trending[i],
                                contentLanguage: lang,
                                onTap: () => context.push('/feed', extra: cards.indexOf(trending[i])),
                              ),
                            ),
                          ),
                          const SizedBox(height: 26),
                          Text(l10n.explorePopularSearches, style: _overline),
                          Text(
                            l10n.exploreYouMightLike,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textPrimaryDark),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final t in MockCatalog.trendingExploreTags)
                                ActionChip(
                                  label: Text(
                                    '# ${_exploreChipLabel(t, lang)}',
                                    style: const TextStyle(color: AppColors.textPrimaryDark),
                                  ),
                                  onPressed: () {},
                                  side: const BorderSide(color: AppColors.borderOnDark),
                                ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          Text(l10n.exploreUpcomingLine.toUpperCase(), style: _overline),
                          Text(
                            l10n.exploreFestivalCalendar,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textPrimaryDark),
                          ),
                          const SizedBox(height: 14),
                          for (final o in MockCatalog.occasions)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(color: o.hot ? AppColors.accentGoldBorder : AppColors.borderOnDark),
                                ),
                                tileColor: o.hot ? AppColors.surfaceElevatedDark : AppColors.surfaceDark,
                                textColor: AppColors.textPrimaryDark,
                                iconColor: AppColors.accentGold,
                                leading: const Text('🪔', style: TextStyle(fontSize: 22)),
                                title: Text(
                                  FestivalLocalizer.getName(o.festivalSlug, lang),
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                                subtitle: Text(o.englishTitle, style: const TextStyle(color: AppColors.textSecondaryDark)),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentGoldSubtleBg,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: AppColors.accentGoldBorder),
                                  ),
                                  child: Text(
                                    o.dateLabel == 'Today' ? l10n.dateToday : o.dateLabel,
                                    style: const TextStyle(
                                      color: AppColors.accentGold,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                onTap: () => context.push('/feed', extra: 0),
                              ),
                            ),
                        ],
                      ),
                      ListView(
                        padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                        children: [
                          Text(l10n.exploreCategoriesLine.toUpperCase(), style: _overline),
                          Text(
                            l10n.exploreBrowseAll,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textPrimaryDark),
                          ),
                          const SizedBox(height: 14),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.15,
                            children: [
                              for (final c in MockCatalog.exploreCategories)
                                _CategoryTile(
                                  emoji: c.emoji,
                                  genreId: c.id,
                                  lang: lang,
                                  count: c.countLabel,
                                  moodId: c.mood,
                                  onTap: () => context.push('/feed', extra: 0),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
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

const _overline = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w800,
  letterSpacing: 1.5,
  color: AppColors.accentGold,
);

class _IntentChip extends StatelessWidget {
  const _IntentChip({
    required this.emoji,
    required this.genreId,
    required this.lang,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String genreId;
  final String lang;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = GenreLocalizer.getName(genreId, lang);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Material(
        color: selected ? AppColors.accentGoldSubtleBg : AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: selected ? AppColors.accentGold : AppColors.borderOnDark),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(primary, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimaryDark)),
                    if (lang != 'en')
                      Text(
                        GenreLocalizer.getName(genreId, 'en'),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondaryDark),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.emoji,
    required this.genreId,
    required this.lang,
    required this.count,
    required this.moodId,
    required this.onTap,
  });

  final String emoji;
  final String genreId;
  final String lang;
  final String count;
  final String moodId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = GenreLocalizer.getName(genreId, lang);
    final mood = MoodLocalizer.getName(moodId, lang);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.surfaceDark,
            border: Border.all(color: AppColors.accentGoldBorder),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryDark,
                ),
              ),
              Text(
                '$mood · $count',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
