import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/story_pack_catalog.dart';
import '../../data/providers.dart';
import '../../theme/app_colors.dart';

class AdminGenerateScreen extends ConsumerStatefulWidget {
  const AdminGenerateScreen({super.key});

  @override
  ConsumerState<AdminGenerateScreen> createState() =>
      _AdminGenerateScreenState();
}

class _AdminGenerateScreenState extends ConsumerState<AdminGenerateScreen> {
  final List<String> _allInterests = StoryPackCatalog.packs
      .map((e) => e.id)
      .toList(growable: false);

  final Set<String> _selected = {};
  int _cardsRequested = 20;
  bool _loading = false;
  String? _result;

  Future<void> _generate() async {
    if (_selected.isEmpty) return;
    setState(() {
      _loading = true;
      _result = null;
    });
    try {
      for (final interest in _selected) {
        final resp = await ref
            .read(adminServiceProvider)
            .generateCards(
              interestIds: [interest],
              cardsRequested: _cardsRequested,
            );
        _result = 'Queued: ${resp['jobId'] ?? ''}';
        if (mounted) setState(() {});
        await Future<void>.delayed(const Duration(milliseconds: 700));
      }
    } catch (e) {
      setState(() => _result = 'Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        title: const Text(
          'Generate story cards',
          style: TextStyle(color: AppColors.accentGold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Select story packs',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allInterests.map((id) {
              final selected = _selected.contains(id);
              final pack = StoryPackCatalog.packs.firstWhere((e) => e.id == id);
              return InkWell(
                onTap: _loading
                    ? null
                    : () => setState(() {
                        if (selected) {
                          _selected.remove(id);
                        } else {
                          _selected.add(id);
                        }
                      }),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.accentGold.withAlpha((0.18 * 255).round())
                        : AppColors.surfaceElevatedDark,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: selected
                          ? AppColors.accentGold
                          : AppColors.borderOnDark,
                    ),
                  ),
                  child: Text(
                    pack.englishTitle,
                    style: TextStyle(
                      color: selected
                          ? AppColors.accentGold
                          : AppColors.textSecondaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          const Text(
            'Cards per story pack',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          Slider(
            value: _cardsRequested.toDouble(),
            min: 5,
            max: 40,
            divisions: 7,
            label: '$_cardsRequested',
            activeColor: AppColors.accentGold,
            onChanged: _loading
                ? null
                : (v) => setState(() => _cardsRequested = v.toInt()),
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: _loading || _selected.isEmpty ? null : _generate,
            child: Text(
              _loading ? 'Queuing…' : 'Generate for ${_selected.length} packs',
            ),
          ),
          if (_result != null) ...[
            const SizedBox(height: 12),
            Text(
              _result!,
              style: const TextStyle(color: AppColors.textSecondaryDark),
            ),
          ],
        ],
      ),
    );
  }
}
