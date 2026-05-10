import 'dart:math';

import '../models/katha_card.dart';

/// Picks a **stable per-day, per-category** card so Explore / Home do not always
/// open the first catalog item (e.g. the same heroes quote every time).
final class DailyCardPicker {
  DailyCardPicker._();

  static int _dayKey() {
    final d = DateTime.now();
    return d.year * 10000 + d.month * 100 + d.day;
  }

  static KathaCard pickForCategory(List<KathaCard> all, String category) {
    final pool = all.where((c) => c.category == category).toList();
    if (pool.isEmpty) {
      return all.isNotEmpty ? all.first : (throw StateError('empty catalog'));
    }
    final seed = _dayKey() * 1000003 + (category.hashCode & 0x3fffffff);
    final r = Random(seed);
    return pool[r.nextInt(pool.length)];
  }

  static KathaCard pickForFestival(List<KathaCard> all) {
    final pool = all
        .where((c) => c.category == 'festival' || c.section == 'festival')
        .toList();
    if (pool.isEmpty) return pickForCategory(all, 'festival');
    final seed = _dayKey() * 911382323 + ('festival'.hashCode & 0x3fffffff);
    final r = Random(seed);
    return pool[r.nextInt(pool.length)];
  }
}
