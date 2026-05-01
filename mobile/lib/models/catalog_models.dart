import 'package:flutter/foundation.dart';

@immutable
class LanguageOption {
  const LanguageOption({
    required this.id,
    required this.nativeName,
    required this.englishName,
    required this.speakersLabel,
    required this.emoji,
  });

  final String id;
  final String nativeName;
  final String englishName;
  final String speakersLabel;
  final String emoji;
}

@immutable
class ReligionOption {
  const ReligionOption({
    required this.id,
    required this.englishLabel,
    required this.nativeLabel,
    required this.note,
  });

  final String id;
  final String englishLabel;
  final String nativeLabel;
  final String note;
}

@immutable
class InterestOption {
  const InterestOption({
    required this.id,
    required this.emoji,
    required this.englishLabel,
    required this.nativeLabel,
    required this.tone,
  });

  final String id;
  final String emoji;
  final String englishLabel;
  final String nativeLabel;
  final String tone;
}

@immutable
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.icon,
    required this.timeAgo,
    required this.title,
    required this.body,
  });

  final String id;
  final String type;
  final String icon;
  final String timeAgo;
  final Map<String, String> title;
  final Map<String, String> body;

  String titleFor(String lang) => title[lang] ?? title['en'] ?? '';
  String bodyFor(String lang) => body[lang] ?? body['en'] ?? '';
}

@immutable
class ExploreCategoryTile {
  const ExploreCategoryTile({
    required this.id,
    required this.emoji,
    required this.nativeTitle,
    required this.englishTitle,
    required this.countLabel,
    required this.mood,
  });

  final String id;
  final String emoji;
  final String nativeTitle;
  final String englishTitle;
  final String countLabel;
  final String mood;
}

@immutable
class OccasionItem {
  const OccasionItem({
    required this.festivalSlug,
    required this.nativeTitle,
    required this.englishTitle,
    required this.dateLabel,
    this.hot = false,
  });

  /// Key for [FestivalLocalizer], e.g. `ugadi`.
  final String festivalSlug;
  final String nativeTitle;
  final String englishTitle;
  final String dateLabel;
  final bool hot;
}
