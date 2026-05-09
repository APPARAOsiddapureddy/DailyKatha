import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content_language.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../models/feed_route_args.dart';
import '../../models/katha_card.dart';
import '../../models/section_preview_args.dart';
import '../../theme/app_colors.dart';
import '../../widgets/mini_card.dart';
import '../../widgets/status_card.dart';

class SectionPreviewScreen extends ConsumerWidget {
  const SectionPreviewScreen({super.key, required this.args});

  final SectionPreviewArgs args;

  List<KathaCard> _visible(List<KathaCard> all) {
    final f = args.categoryFilter;
    if (f == null || f.isEmpty) return all;
    return all.where((c) => f.contains(c.category)).toList();
  }

  int _startIndex(List<KathaCard> all, List<KathaCard> visible) {
    if (visible.isEmpty) return 0;
    final f = args.categoryFilter;
    if (f == null || f.isEmpty) return args.initialIndex.clamp(0, visible.length - 1);
    final fi = args.initialIndex.clamp(0, all.length - 1);
    final targetId = all[fi].id;
    final j = visible.indexWhere((c) => c.id == targetId);
    return j >= 0 ? j : 0;
  }

  void _openFeed(BuildContext context, int index, {required Set<String>? categoryFilter}) {
    context.push(
      '/feed',
      extra: FeedRouteArgs(initialIndex: index, categoryFilter: categoryFilter),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionHolderProvider);
    final lang = effectiveContentLanguage(session);
    final catalog = ref.watch(catalogProvider);
    final l10n = AppLocalizations.of(context);
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.protoCream,
      appBar: AppBar(
        backgroundColor: AppColors.protoCream,
        foregroundColor: AppColors.protoInk,
        elevation: 0,
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: AppColors.protoInk.withValues(alpha: 0.06),
          ),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
        title: Text(args.title, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      ),
      body: catalog.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.protoBrand)),
        error: (e, _) => Center(
          child: Text(
            e.toString(),
            style: const TextStyle(color: AppColors.protoInk),
          ),
        ),
        data: (all) {
          final visible = _visible(all);
          if (visible.isEmpty) {
            return Center(
              child: Text(l10n.noCards, style: const TextStyle(color: AppColors.protoInk)),
            );
          }

          final start = _startIndex(all, visible);
          final first = visible[start];
          final rest = [
            for (var i = 0; i < visible.length; i++)
              if (i != start) visible[i],
          ];

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 96),
            children: [
              Text(
                l10n.sectionPreviewSubline,
                style: tt.bodyMedium?.copyWith(color: AppColors.protoInk3),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, _) {
                  final screenW = MediaQuery.sizeOf(context).width;
                  final heroW = (screenW * 0.78).clamp(280.0, 420.0);
                  return Center(
                    child: SizedBox(
                      width: heroW,
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: Material(
                          color: Colors.transparent,
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () => _openFeed(context, all.indexOf(first), categoryFilter: args.categoryFilter),
                            child: StatusCard(
                              card: first,
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
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _openFeed(context, all.indexOf(first), categoryFilter: args.categoryFilter),
                icon: const Icon(Icons.arrow_forward, size: 20),
                label: Text(l10n.sectionOpenAll(visible.length)),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              if (rest.isNotEmpty) ...[
                const SizedBox(height: 28),
                Text(
                  l10n.sectionAlsoToday,
                  style: tt.titleLarge?.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.homeRailNewToday(rest.length),
                  style: tt.bodySmall?.copyWith(color: AppColors.protoInk3),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final c in rest)
                      MiniCard(
                        card: c,
                        contentLanguage: lang,
                        width: 150,
                        blurred: true,
                        onTap: () => _openFeed(
                          context,
                          all.indexOf(c),
                          categoryFilter: args.categoryFilter,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
