import '../core/app_config.dart';
import '../models/katha_card.dart';
import '../services/feed_service.dart';
import 'local/bundled_catalog_loader.dart';
import 'local/mock_catalog.dart';

class FeedRepository {
  FeedRepository(this._feedService);

  final FeedService _feedService;

  /// Mock API: loads bundled JSON from `DailyKatha_*_Upload.xlsx` exports when
  /// [contentLanguage] is `hi|te|kn|ta|ml|en`; otherwise [MockCatalog.cards]
  /// or remote feed.
  Future<List<KathaCard>> loadCards({String contentLanguage = 'en'}) async {
    if (AppConfig.useMockApi) {
      final bundled = await BundledCatalogLoader.loadForContentLanguage(contentLanguage);
      if (bundled.isNotEmpty) return bundled;
      return MockCatalog.cards;
    }
    return _feedService.fetchFeed(lang: contentLanguage);
  }
}
