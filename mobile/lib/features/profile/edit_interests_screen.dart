import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/mock_catalog.dart';
import '../../data/providers.dart';
import '../../l10n/genre_localizer.dart';
import '../../observability/analytics/analytics.dart';
import '../../observability/analytics/analytics_provider.dart';
import '../../theme/app_colors.dart';

Color _interestAccentBg(String id) {
  return switch (id) {
    'bhakti' => const Color(0xFF5B1A1A),
    'love' => const Color(0xFF7A2540),
    'motivation' => const Color(0xFF1B2D44),
    'festival' => const Color(0xFF7E1F0E),
    'goodmorning' => const Color(0xFFC66829),
    'goodnight' => const Color(0xFF1F2848),
    'friendship' => const Color(0xFF2C5F4A),
    'family' => const Color(0xFF5B3220),
    'poetry' => const Color(0xFF3A2548),
    'birthday' => const Color(0xFFA93757),
    'cinema' => const Color(0xFF1B2D44),
    'heroes' => const Color(0xFF2A2566),
    _ => AppColors.protoBrand,
  };
}

class EditInterestsScreen extends ConsumerStatefulWidget {
  const EditInterestsScreen({super.key});

  @override
  ConsumerState<EditInterestsScreen> createState() => _EditInterestsScreenState();
}

class _EditInterestsScreenState extends ConsumerState<EditInterestsScreen> {
  static const int _max = 3;
  late final Set<String> _selected;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final session = ref.read(sessionHolderProvider);
    final ids = session?.profile.interestIds ?? const <String>[];
    _selected = ids.isEmpty
        ? MockCatalog.interests.take(_max).map((e) => e.id).toSet()
        : ids.take(_max).toSet();
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_selected.length < _max) {
        _selected.add(id);
      }
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    final session = ref.read(sessionHolderProvider);
    if (session == null) return;
    final before = List<String>.from(session.profile.interestIds);
    setState(() => _saving = true);
    try {
      final nextProfile = session.profile.copyWith(interestIds: _selected.toList());
      final next = await ref.read(authRepositoryProvider).applyProfile(nextProfile);
      ref.read(sessionHolderProvider.notifier).setSession(next);
      await ref.read(analyticsProvider).log(
        AEvents.interestChanged,
        props: {
          'old_interest_ids': before,
          'new_interest_ids': _selected.toList(),
          'count': _selected.length,
          'source': 'profile',
        },
      );
      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update interests: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionHolderProvider);
    final lang = session?.profile.contentLanguage ?? 'en';
    final tt = Theme.of(context).textTheme;
    const items = MockCatalog.interests;

    return Scaffold(
      backgroundColor: AppColors.protoCream,
      appBar: AppBar(
        backgroundColor: AppColors.protoCream,
        foregroundColor: AppColors.protoInk,
        elevation: 0,
        title: const Text('Interests'),
        actions: [
          TextButton(
            onPressed: _selected.isEmpty || _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
            child: Text(
              'Pick up to $_max. This updates your Home sections automatically.',
              style: tt.bodyMedium?.copyWith(color: AppColors.protoInk3, height: 1.35),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 112,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = _selected.contains(item.id);
                final disabled = !selected && _selected.length >= _max;
                final bg = selected ? _interestAccentBg(item.id) : AppColors.protoSurface;
                final label = GenreLocalizer.getName(item.id, lang);
                return Opacity(
                  opacity: disabled ? 0.45 : 1,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: disabled ? null : () => _toggle(item.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected ? Colors.transparent : AppColors.protoBorder,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: _interestAccentBg(item.id).withValues(alpha: 0.28),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ]
                              : null,
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.emoji, style: const TextStyle(fontSize: 26, height: 1)),
                                const Spacer(),
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                                    color: selected ? Colors.white : AppColors.protoInk,
                                  ),
                                ),
                              ],
                            ),
                            if (selected)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.protoSaffron,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 14,
                                    color: _interestAccentBg(item.id),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

