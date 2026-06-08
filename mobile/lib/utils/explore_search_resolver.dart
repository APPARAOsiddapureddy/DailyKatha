import '../l10n/genre_localizer.dart';

/// Maps free-text Explore search to a [KathaCard.category] id (e.g. `goodmorning`).
/// Intentionally lightweight: phrase hints + keywords + localized genre names.
final class ExploreSearchResolver {
  ExploreSearchResolver._();

  static const List<String> _categoryOrder = [
    'mahabharata',
    'ramayana',
    'shiv_puran',
    'bhagavad_gita',
    'hanuman',
    'krishna_leela',
    'devi_mahatmya',
    'vedic_wisdom',
    'upanishads',
    'puranas',
    'ancient_history',
    'saints_sages',
  ];

  /// Longer phrases first so "good morning" beats "morning".
  static const List<(String, String)> _phraseHints = [
    ('mahabharata', 'mahabharata'),
    ('maha bharata', 'mahabharata'),
    ('ramayana', 'ramayana'),
    ('ramayanam', 'ramayana'),
    ('shiv puran', 'shiv_puran'),
    ('bhagavad gita', 'bhagavad_gita'),
    ('gita', 'bhagavad_gita'),
    ('hanuman', 'hanuman'),
    ('krishna', 'krishna_leela'),
    ('devi', 'devi_mahatmya'),
    ('vedic', 'vedic_wisdom'),
    ('upanishad', 'upanishads'),
    ('purana', 'puranas'),
    ('ancient history', 'ancient_history'),
    ('saint', 'saints_sages'),
  ];

  /// Single-token hints (normalized word → category).
  static const Map<String, String> _tokenHints = {
    'mahabharata': 'mahabharata',
    'rama': 'ramayana',
    'ramayana': 'ramayana',
    'shiv': 'shiv_puran',
    'puran': 'shiv_puran',
    'gita': 'bhagavad_gita',
    'hanuman': 'hanuman',
    'krishna': 'krishna_leela',
    'devi': 'devi_mahatmya',
    'vedic': 'vedic_wisdom',
    'upanishad': 'upanishads',
    'purana': 'puranas',
    'history': 'ancient_history',
    'ancient': 'ancient_history',
    'saint': 'saints_sages',
    'sage': 'saints_sages',
  };

  static String _norm(String s) {
    var t = s.trim().toLowerCase();
    t = t.replaceAll(RegExp(r'\s+'), ' ');
    return t;
  }

  /// Returns a category id, or `null` if nothing matched.
  static String? resolve(String rawQuery, String contentLanguage) {
    final q = _norm(rawQuery);
    if (q.isEmpty) return null;

    if (_tokenHints.containsKey(q)) return _tokenHints[q];
    for (final id in _categoryOrder) {
      if (q == id) return id;
    }

    for (final (phrase, cat) in _phraseHints) {
      if (q.contains(phrase)) return cat;
    }

    for (final w in q.split(' ')) {
      if (w.isEmpty) continue;
      final hit = _tokenHints[w];
      if (hit != null) return hit;
    }

    for (final id in _categoryOrder) {
      for (final lang in <String>{contentLanguage, 'en', 'te', 'hi'}) {
        final label = GenreLocalizer.getName(id, lang).toLowerCase().trim();
        if (label.length < 2) continue;
        if (q == label || q.contains(label) || label.contains(q)) {
          return id;
        }
      }
    }

    return null;
  }
}
