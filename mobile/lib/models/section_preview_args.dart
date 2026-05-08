import 'package:flutter/foundation.dart';

@immutable
class SectionPreviewArgs {
  const SectionPreviewArgs({
    required this.title,
    required this.tag,
    required this.initialIndex,
    this.categoryFilter,
  });

  final String title;
  final String tag;
  /// Index in the **full** catalog to pick the first visible card.
  final int initialIndex;
  /// Optional set of categories to show in this preview.
  final Set<String>? categoryFilter;
}

