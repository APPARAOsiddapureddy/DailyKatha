import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'katha_card.dart';
import 'status_card_photo_layer.dart';

class CardEditorArgs {
  const CardEditorArgs({
    required this.card,
    required this.contentLanguage,
    this.preferStatusPrimaryCta = false,
    this.initialPhotoLayers,
    this.initialPhotoBytes,
    this.initialPhotoOffset = Offset.zero,
    this.initialPhotoScale = 1.0,
    this.initialPhotoRotation = 0.0,
    this.initialPhotoOpacity = 1.0,
    this.initialCaption = '',
    this.initialCaptionColor = const Color(0xFFF5E6C0),
  });

  final KathaCard card;
  final String contentLanguage;
  final bool preferStatusPrimaryCta;

  /// Offsets are card-center space (see [StatusCard] / export).
  final List<StatusCardPhotoLayer>? initialPhotoLayers;

  /// Legacy single-photo fields — used when [initialPhotoLayers] is null.
  final Uint8List? initialPhotoBytes;
  final Offset initialPhotoOffset;
  final double initialPhotoScale;
  final double initialPhotoRotation;
  final double initialPhotoOpacity;
  final String initialCaption;
  final Color initialCaptionColor;
}
