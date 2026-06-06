import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.phoneE164,
    this.displayName = 'Friend',
    this.displayNameNative,
    this.contentLanguage = 'en',
    this.religionId,
    this.interestIds = const [],
    this.isAdmin = false,
    this.onboardingComplete = false,
    this.likedCount = 0,
    this.savedCount = 0,
    this.sharedCount = 0,
    this.joinedAt,
  });

  final String id;
  final String phoneE164;
  final String displayName;
  final String? displayNameNative;
  final String contentLanguage;
  final String? religionId;
  final List<String> interestIds;
  final bool isAdmin;
  final bool onboardingComplete;
  final int likedCount;
  final int savedCount;
  final int sharedCount;
  final DateTime? joinedAt;

  UserProfile copyWith({
    String? id,
    String? phoneE164,
    String? displayName,
    String? displayNameNative,
    String? contentLanguage,
    String? religionId,
    List<String>? interestIds,
    bool? isAdmin,
    bool? onboardingComplete,
    int? likedCount,
    int? savedCount,
    int? sharedCount,
    DateTime? joinedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      phoneE164: phoneE164 ?? this.phoneE164,
      displayName: displayName ?? this.displayName,
      displayNameNative: displayNameNative ?? this.displayNameNative,
      contentLanguage: contentLanguage ?? this.contentLanguage,
      religionId: religionId ?? this.religionId,
      interestIds: interestIds ?? this.interestIds,
      isAdmin: isAdmin ?? this.isAdmin,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      likedCount: likedCount ?? this.likedCount,
      savedCount: savedCount ?? this.savedCount,
      sharedCount: sharedCount ?? this.sharedCount,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final interests = json['interests'];
    if (json['content_language'] != null ||
        (json['name'] != null && json['displayName'] == null) ||
        (interests is List && interests.isNotEmpty && interests.first is Map)) {
      return UserProfile.fromBackendJson(json);
    }
    return UserProfile(
      id: json['id']?.toString() ?? 'me',
      phoneE164: json['phone'] as String? ?? json['phoneE164'] as String? ?? '',
      displayName: json['displayName'] as String? ?? 'Friend',
      displayNameNative: json['displayNameNative'] as String?,
      contentLanguage: json['contentLanguage'] as String? ?? json['uiLanguage'] as String? ?? 'en',
      religionId: json['religionId'] as String?,
      interestIds: (json['interestIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      isAdmin: json['isAdmin'] as bool? ?? json['is_admin'] as bool? ?? false,
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      likedCount: json['likedCount'] as int? ?? 0,
      savedCount: json['savedCount'] as int? ?? 0,
      sharedCount: json['sharedCount'] as int? ?? 0,
      joinedAt: json['joinedAt'] != null ? DateTime.tryParse(json['joinedAt'].toString()) : null,
    );
  }

  /// Backend has no explicit flag; treat onboarding as done once religion + interests exist.
  static bool inferOnboardingComplete(Map<String, dynamic> json, List<String> interestIds) {
    if (json['onboardingComplete'] == true) return true;
    final religionId = (json['religionId'] ?? json['religion_id'])?.toString();
    return religionId != null && religionId.isNotEmpty && interestIds.isNotEmpty;
  }

  /// REST `/v1/users/me` and auth verify `user` object.
  factory UserProfile.fromBackendJson(Map<String, dynamic> json) {
    final rawPhone = json['phone']?.toString() ?? '';
    final phoneE164 = rawPhone.startsWith('+')
        ? rawPhone
        : (rawPhone.length == 10 ? '+91$rawPhone' : rawPhone);

    final interests = json['interests'] as List<dynamic>? ?? const [];
    final ids = <String>[];
    for (final e in interests) {
      if (e is Map) {
        final id = e['interestId'] ?? e['interest_id'];
        if (id != null) ids.add(id.toString());
      } else if (e != null) {
        ids.add(e.toString());
      }
    }

    return UserProfile(
      id: json['id']?.toString() ?? '',
      phoneE164: phoneE164,
      displayName: (json['name'] ?? json['displayName'])?.toString() ?? 'Friend',
      displayNameNative: json['displayNameNative'] as String?,
      contentLanguage:
          (json['contentLanguage'] ?? json['content_language'])?.toString() ?? 'en',
      religionId: (json['religionId'] ?? json['religion_id'])?.toString(),
      interestIds: ids,
      isAdmin: (json['isAdmin'] as bool?) ?? (json['is_admin'] as bool?) ?? false,
      onboardingComplete: inferOnboardingComplete(json, ids),
      likedCount: (json['likedCount'] as num?)?.toInt() ?? 0,
      savedCount: (json['savedCount'] as num?)?.toInt() ?? 0,
      sharedCount: (json['sharedCount'] as num?)?.toInt() ?? 0,
      joinedAt: json['joinedAt'] != null
          ? DateTime.tryParse(json['joinedAt'].toString())
          : (json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null),
    );
  }

  Map<String, dynamic> toBackendUpdateBody() {
    return {
      'name': displayName,
      'contentLanguage': contentLanguage,
      'religionId': religionId,
    };
  }
}

bool isPlaceholderDisplayName(String raw) {
  final s = raw.trim().toLowerCase();
  if (s.isEmpty) return true;
  const placeholders = {'friend', 'demo user', 'ravi kumar'};
  return placeholders.contains(s);
}

@immutable
class UserSession {
  const UserSession({
    required this.accessToken,
    required this.refreshToken,
    required this.profile,
  });

  final String accessToken;
  final String refreshToken;
  final UserProfile profile;
}
