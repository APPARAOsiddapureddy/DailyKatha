import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content_language.dart';
import '../../data/providers.dart';
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

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        title: Text(args.title),
        backgroundColor: Colors.transparent,
      ),
      body: catalog.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accentGold)),
        error: (e, _) => Center(
          child: Text(
            e.toString(),
            style: const TextStyle(color: AppColors.textPrimaryDark),
          ),
        ),
        data: (all) {
          final visible = _visible(all);
          if (visible.isEmpty) {
            return const Center(
              child: Text('No cards', style: TextStyle(color: AppColors.textPrimaryDark)),
            );
          }

          final start = _startIndex(all, visible);
          final first = visible[start];

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
            children: [
              // One clear “hero” card.
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: StatusCard(
                      card: first,
                      contentLanguage: lang,
                      compact: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _openFeed(context, all.indexOf(first), categoryFilter: args.categoryFilter),
                  child: const Text('Open all'),
                ),
              ),
              const SizedBox(height: 18),
              // Blurred list to reduce “wall of text”; first item remains clear.
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (var i = 0; i < visible.length; i++)
                    MiniCard(
                      card: visible[i],
                      contentLanguage: lang,
                      width: 150,
                      blurred: i != 0,
                      onTap: () => _openFeed(
                        context,
                        all.indexOf(visible[i]),
                        categoryFilter: args.categoryFilter,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

