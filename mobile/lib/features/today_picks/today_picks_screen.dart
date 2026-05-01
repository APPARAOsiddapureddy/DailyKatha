import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../theme/app_colors.dart';
import '../../utils/error_handler.dart';

class TodayPicksScreen extends ConsumerStatefulWidget {
  const TodayPicksScreen({super.key});

  @override
  ConsumerState<TodayPicksScreen> createState() => _TodayPicksScreenState();
}

class _TodayPicksScreenState extends ConsumerState<TodayPicksScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _picks = const [];
  int _idx = 0;
  final _controller = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ref.read(feedServiceProvider).getTodaysPicks();
      final raw = (data['picks'] as List?) ?? const [];
      final picks = raw.map((e) => (e as Map).cast<String, dynamic>()).toList();
      if (!mounted) return;
      setState(() {
        _picks = picks;
        _loading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = ErrorHandler.fromDioException(e).userMessage;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        title: const Text("Today's 5", style: TextStyle(color: AppColors.accentGold)),
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh, color: AppColors.accentGold),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accentGold))
          : _error != null
              ? _ErrorState(message: _error!, onRetry: _load)
              : _picks.isEmpty
                  ? const _EmptyState()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: Row(
                            children: [
                              Text('${_idx + 1} / ${_picks.length}', style: const TextStyle(color: AppColors.textSecondaryDark)),
                              const Spacer(),
                              const Text('Refreshes at midnight IST', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: PageView.builder(
                            controller: _controller,
                            scrollDirection: Axis.vertical,
                            onPageChanged: (i) => setState(() => _idx = i),
                            itemCount: _picks.length,
                            itemBuilder: (context, index) => _PickCard(pick: _picks[index]),
                          ),
                        ),
                      ],
                    ),
    );
  }
}

class _PickCard extends StatelessWidget {
  const _PickCard({required this.pick});

  final Map<String, dynamic> pick;

  @override
  Widget build(BuildContext context) {
    final quote = pick['displayQuote']?.toString() ?? '';
    final author = pick['displayAuthor']?.toString() ?? '';
    final category = pick['category']?.toString() ?? '';
    final interest = pick['pickInterest']?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderOnDark),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Pill(text: category.isEmpty ? 'category' : category),
                  if (interest.isNotEmpty) _Pill(text: 'for: $interest'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: Text(
                    quote,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              if (author.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    author,
                    style: const TextStyle(color: AppColors.textSecondaryDark, fontWeight: FontWeight.w700),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _IconAction(icon: Icons.favorite_border, label: 'Like'),
                  const SizedBox(width: 12),
                  _IconAction(icon: Icons.bookmark_border, label: 'Save'),
                  const SizedBox(width: 12),
                  _IconAction(icon: Icons.share_outlined, label: 'Share'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentGold.withAlpha((0.12 * 255).round()),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.accentGold.withAlpha((0.28 * 255).round())),
      ),
      child: Text(text, style: const TextStyle(color: AppColors.accentGold, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderOnDark),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondaryDark),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: AppColors.textSecondaryDark, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          "Today's picks are being prepared.\nPlease try again in a few minutes.",
          style: TextStyle(color: AppColors.textSecondaryDark),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.accentGold, size: 44),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(color: AppColors.textSecondaryDark), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

