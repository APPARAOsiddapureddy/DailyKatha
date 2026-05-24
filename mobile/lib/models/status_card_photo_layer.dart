import 'dart:typed_data';

import 'package:flutter/material.dart';

/// One user-placed photo on a [StatusCard] (up to three per card).
@immutable
class StatusCardPhotoLayer {
  const StatusCardPhotoLayer({
    this.bytes,
    this.url,
    this.imageAspectRatio = 1.0,
    this.offset = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.opacity = 1.0,
    this.caption = '',
    this.captionColor,
  }) : assert(bytes != null || url != null, 'Either bytes or url must be provided');

  final Uint8List? bytes;
  final String? url;

  /// Decoded bitmap width ÷ height — frames the layer so rectangles stay rectangular.
  final double imageAspectRatio;

  /// Translation from the card center (logical px).
  final Offset offset;
  final double scale;
  final double rotation;
  final double opacity;
  final String caption;
  final Color? captionColor;

  StatusCardPhotoLayer copyWith({
    Uint8List? bytes,
    String? url,
    double? imageAspectRatio,
    Offset? offset,
    double? scale,
    double? rotation,
    double? opacity,
    String? caption,
    Color? captionColor,
  }) {
    return StatusCardPhotoLayer(
      bytes: bytes ?? this.bytes,
      url: url ?? this.url,
      imageAspectRatio: imageAspectRatio ?? this.imageAspectRatio,
      offset: offset ?? this.offset,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      caption: caption ?? this.caption,
      captionColor: captionColor ?? this.captionColor,
    );
  }
}
