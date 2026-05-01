import 'package:flutter/foundation.dart';

@immutable
class OnboardingArgs {
  const OnboardingArgs({
    required this.contentLanguage,
    this.religionId,
  });

  final String contentLanguage;
  final String? religionId;
}
