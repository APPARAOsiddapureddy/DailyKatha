import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content_language.dart';
import '../../data/local/mock_catalog.dart';
import '../../data/local/user_created_cards_store.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../models/card_editor_args.dart';
import '../../models/katha_card.dart';
import '../../observability/analytics/analytics.dart';
import '../../observability/analytics/analytics_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/status_card.dart';

class CreateCardScreen extends ConsumerStatefulWidget {
  const CreateCardScreen({super.key});

  @override
  ConsumerState<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends ConsumerState<CreateCardScreen> {
  final _text = TextEditingController();
  String _genre = 'motivation';
  bool _saving = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  KathaCard _draft(String lang) {
    final input = _text.text.trim();
    // "Convert to English" (offline v1): store the user input as English, and also as the current UI language.
    // When you later enable translation API, replace this mapping.
    final quote = <String, String>{
      'en': input,
      if (lang != 'en') lang: input,
    };

    return KathaCard(
      id: 'user_${DateTime.now().microsecondsSinceEpoch}',
      section: 'user',
      category: _genre,
      mood: 'warm',
      quote: quote,
      author: const {'en': 'You'},
    );
  }

  Future<void> _save() async {
    if (_saving) return;
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final session = ref.read(sessionHolderProvider);
    final lang = effectiveContentLanguage(session);
    final input = _text.text.trim();
    if (input.length < 3) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please write at least 3 characters.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final card = _draft(lang);
      await UserCreatedCardsStore.add(card);
      await ref.read(analyticsProvider).log(
        AEvents.cardCreated,
        props: {
          'source': 'home_create',
          'category': _genre,
          'text_len': input.length,
        },
      );
      ref.invalidate(userCreatedCardsProvider);
      ref.invalidate(catalogProvider);
      if (!mounted) return;
      // Open editor so user can add photo/caption and share as Status.
      router.push('/edit', extra: CardEditorArgs(card: card, contentLanguage: lang, preferStatusPrimaryCta: true));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionHolderProvider);
    final lang = effectiveContentLanguage(session);
    final card = _draft(lang);

    return Scaffold(
      backgroundColor: AppColors.protoCream,
      appBar: AppBar(
        title: const Text('Create Card'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l10n.onboardingInterestsTitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.protoInk)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _genre,
              items: MockCatalog.interests
                  .map(
                    (g) => DropdownMenuItem(
                      value: g.id,
                      child: Text('${g.emoji} ${g.englishLabel}'),
                    ),
                  )
                  .toList(growable: false),
              onChanged: _saving ? null : (v) => setState(() => _genre = v ?? _genre),
              decoration: const InputDecoration(labelText: 'Genre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _text,
              enabled: !_saving,
              minLines: 3,
              maxLines: 6,
              style: const TextStyle(color: AppColors.protoInk),
              decoration: const InputDecoration(
                labelText: 'Your text',
                hintText: 'Write your quote / wish…',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 360,
                child: StatusCard(
                  card: card,
                  contentLanguage: lang,
                  compact: false,
                  height: 560,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'Creating…' : 'Create & Edit'),
            ),
          ],
        ),
      ),
    );
  }
}

