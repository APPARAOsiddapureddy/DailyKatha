import 'package:flutter/foundation.dart';

/// Shareable quote card (`FEED_CARDS` in prototype).
@immutable
class KathaCard {
  const KathaCard({
    required this.id,
    required this.section,
    required this.category,
    required this.mood,
    required this.quote,
    required this.author,
    this.isFestival = false,
    this.festivalTag,
  });

  final String id;
  final String section;
  final String category;
  final String mood;
  final bool isFestival;
  final String? festivalTag;
  final Map<String, String> quote;
  final Map<String, String> author;

  String quoteFor(String lang) => quote[lang] ?? quote['en'] ?? '';
  String authorFor(String lang) => author[lang] ?? author['en'] ?? '';

  /// Secondary line under main quote: English echo unless UI language is English, then Telugu.
  String secondaryQuoteFor(String contentLanguage) {
    if (contentLanguage == 'en') {
      return quote['te'] ?? quote['hi'] ?? quote['en'] ?? '';
    }
    return quote['en'] ?? '';
  }

  factory KathaCard.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    return KathaCard(
      id: id == null ? '' : id.toString(),
      section: json['section'] as String? ?? 'trending',
      category: json['category'] as String? ?? 'goodmorning',
      mood: json['mood'] as String? ?? 'warm',
      isFestival: json['isFestival'] as bool? ?? false,
      festivalTag: json['festival'] as String?,
      quote: _stringMap(json['quote']),
      author: _stringMap(json['author']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'section': section,
        'category': category,
        'mood': mood,
        'isFestival': isFestival,
        if (festivalTag != null) 'festival': festivalTag,
        'quote': quote,
        'author': author,
      };

  static Map<String, String> _stringMap(Object? value) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return const {};
  }
}
