import '../l10n/genre_localizer.dart';

/// Maps free-text Explore search to a [KathaCard.category] id (e.g. `goodmorning`).
/// Intentionally lightweight: phrase hints + keywords + localized genre names.
final class ExploreSearchResolver {
  ExploreSearchResolver._();

  static const List<String> _categoryOrder = [
    'goodmorning',
    'goodnight',
    'birthday',
    'love',
    'festival',
    'family',
    'motivation',
    'cinema',
    'heroes',
    'poetry',
    'friendship',
    'bhakti',
  ];

  /// Longer phrases first so "good morning" beats "morning".
  static const List<(String, String)> _phraseHints = [
    ('good morning', 'goodmorning'),
    ('goodmorning', 'goodmorning'),
    ('subhodayam', 'goodmorning'),
    ('suprabhat', 'goodmorning'),
    ('good night', 'goodnight'),
    ('goodnight', 'goodnight'),
    ('good evening', 'goodnight'),
    ('happy birthday', 'birthday'),
    ('birth day', 'birthday'),
    ('happy anniversary', 'love'),
    ('film quote', 'cinema'),
    ('movie quote', 'cinema'),
    ('national heroes', 'heroes'),
    ('patriotic', 'heroes'),
    ('friend ship', 'friendship'),
  ];

  /// Single-token hints (normalized word → category).
  static const Map<String, String> _tokenHints = {
    'morning': 'goodmorning',
    'coffee': 'goodmorning',
    'sunrise': 'goodmorning',
    'night': 'goodnight',
    'moon': 'goodnight',
    'sleep': 'goodnight',
    'calm': 'goodnight',
    'birthday': 'birthday',
    'bday': 'birthday',
    'cake': 'birthday',
    'love': 'love',
    'heart': 'love',
    'romance': 'love',
    'festival': 'festival',
    'festive': 'festival',
    'pongal': 'festival',
    'diwali': 'festival',
    'ugadi': 'festival',
    'holi': 'festival',
    'family': 'family',
    'parents': 'family',
    'mom': 'family',
    'dad': 'family',
    'motivation': 'motivation',
    'monday': 'motivation',
    'strength': 'motivation',
    'cinema': 'cinema',
    'movie': 'cinema',
    'film': 'cinema',
    'tollywood': 'cinema',
    'heroes': 'heroes',
    'soldier': 'heroes',
    'army': 'heroes',
    'poetry': 'poetry',
    'poem': 'poetry',
    'shayari': 'poetry',
    'friendship': 'friendship',
    'friends': 'friendship',
    'friend': 'friendship',
    'bhakti': 'bhakti',
    'devotion': 'bhakti',
    'god': 'bhakti',
    'prayer': 'bhakti',
    'temple': 'bhakti',
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
