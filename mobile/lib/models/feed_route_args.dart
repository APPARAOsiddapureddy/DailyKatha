import 'package:flutter/foundation.dart';

/// Navigation args for [/feed]: optional [categoryFilter] limits vertical scrolling to matching cards.
@immutable
class FeedRouteArgs {
  const FeedRouteArgs({
    this.initialIndex = 0,
    this.categoryFilter,
    this.cardIds,
  });

  /// Index in the **full** catalog ([catalogProvider]) used to pick the starting card when opening the feed.
  final int initialIndex;

  /// When non-null and non-empty, the feed shows only cards whose [KathaCard.category] is in this set.
  final Set<String>? categoryFilter;

  /// When non-null and non-empty, the feed shows **only** these cards, in this order (Library / shares).
  final List<String>? cardIds;
}
