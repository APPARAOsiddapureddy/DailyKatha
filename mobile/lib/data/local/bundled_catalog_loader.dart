import '../../models/katha_card.dart';
import 'asset_cards_catalog.dart';

/// Bundled JSON catalogs exported from `DailyKatha_*_Upload.xlsx` files.
///
/// Regenerate (repo root): `python3 scripts/export_language_catalogs.py`
abstract final class BundledCatalogLoader {
  static const Map<String, String> _assetPathByContentLanguage = {
    'hi': 'assets/data/hindi_cards.json',
    'te': 'assets/data/telugu_cards.json',
    'kn': 'assets/data/kannada_cards.json',
    'ta': 'assets/data/tamil_cards.json',
    'ml': 'assets/data/malayalam_cards.json',
    'en': 'assets/data/english_cards.json',
  };

  /// Cards for [contentLanguage] when a bundled file exists; empty if unknown or missing.
  static Future<List<KathaCard>> loadForContentLanguage(String contentLanguage) {
    final path = _assetPathByContentLanguage[contentLanguage];
    if (path == null) return Future.value(const []);
    return AssetCardsCatalog.load(path);
  }
}
