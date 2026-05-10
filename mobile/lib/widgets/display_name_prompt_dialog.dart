import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/display_name_prompt_store.dart';
import '../data/providers.dart';
import '../l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../theme/app_colors.dart';

Future<void> showDisplayNamePromptIfNeeded(
  BuildContext context,
  WidgetRef ref,
) async {
  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context);
  final session = ref.read(sessionHolderProvider);
  if (session == null) return;

  if (await DisplayNamePromptStore.isCompleted()) return;
  if (!context.mounted) return;
  final controller = TextEditingController();
  final current = session.profile.displayName.trim();
  if (!isPlaceholderDisplayName(current)) {
    controller.text = current;
  }

  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      final tt = Theme.of(ctx).textTheme;
      return AlertDialog(
        backgroundColor: AppColors.protoSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.namePromptTitle,
          style: tt.headlineSmall?.copyWith(fontSize: 22),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.namePromptBody,
              style: tt.bodyLarge?.copyWith(color: AppColors.protoInk3),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              maxLength: 48,
              decoration: InputDecoration(
                hintText: l10n.namePromptHint,
                counterText: '',
                filled: true,
                fillColor: AppColors.protoCream,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.protoBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.protoBrand,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await DisplayNamePromptStore.markCompleted();
            },
            child: Text(l10n.namePromptSkip),
          ),
          FilledButton(
            onPressed: () async {
              final trimmed = controller.text.trim();
              Navigator.of(ctx).pop();
              await DisplayNamePromptStore.markCompleted();
              if (trimmed.isEmpty) return;
              final updated = session.profile.copyWith(displayName: trimmed);
              final next = await ref
                  .read(authRepositoryProvider)
                  .applyProfile(updated);
              ref.read(sessionHolderProvider.notifier).setSession(next);
            },
            child: Text(l10n.namePromptSave),
          ),
        ],
      );
    },
  );

  controller.dispose();
}

/// Opens from Profile — does not interact with one-time onboarding prompt prefs.
Future<void> showDisplayNameEditor(BuildContext context, WidgetRef ref) async {
  final session = ref.read(sessionHolderProvider);
  if (session == null || !context.mounted) return;

  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController(
    text: session.profile.displayName.trim(),
  );

  final saved = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      final tt = Theme.of(ctx).textTheme;
      return AlertDialog(
        backgroundColor: AppColors.protoSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.profileEditNameTitle,
          style: tt.headlineSmall?.copyWith(fontSize: 22),
        ),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          maxLength: 48,
          decoration: InputDecoration(
            hintText: l10n.namePromptHint,
            counterText: '',
            filled: true,
            fillColor: AppColors.protoCream,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.protoBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.protoBrand,
                width: 1.5,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.profileEditNameCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.namePromptSave),
          ),
        ],
      );
    },
  );

  final trimmed = controller.text.trim();
  controller.dispose();
  if (saved != true || trimmed.isEmpty) return;

  final updated = session.profile.copyWith(displayName: trimmed);
  final next = await ref.read(authRepositoryProvider).applyProfile(updated);
  ref.read(sessionHolderProvider.notifier).setSession(next);
}
