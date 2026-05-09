// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/user_stats_controller.dart';
import '../../models/card_editor_args.dart';
import '../../observability/analytics/analytics.dart';
import '../../observability/analytics/analytics_provider.dart';
import '../../services/card_share_export.dart';
import '../../services/safe_image_picker.dart';
import '../../services/share_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/status_card.dart';

class CardEditorScreen extends StatefulWidget {
  const CardEditorScreen({super.key, required this.args, required this.shareService});

  final CardEditorArgs args;
  final ShareService shareService;

  @override
  State<CardEditorScreen> createState() => _CardEditorScreenState();
}

class _CardEditorScreenState extends State<CardEditorScreen> {
  Uint8List? _photo;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  double _rotation = 0.0;
  String _caption = '';
  Color _captionColor = const Color(0xFFF5E6C0);

  Offset? _startFocal;
  Offset _startOffset = Offset.zero;
  double _startScale = 1.0;
  double _startRotation = 0.0;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _photo = widget.args.initialPhotoBytes;
    _offset = widget.args.initialPhotoOffset;
    _scale = widget.args.initialPhotoScale;
    _rotation = widget.args.initialPhotoRotation;
    _caption = widget.args.initialCaption;
    _captionColor = widget.args.initialCaptionColor;
  }

  Future<void> _pickPhoto() async {
    final analytics = ProviderScope.containerOf(context).read(analyticsProvider);
    final x = await SafeImagePicker.pickFromGallery(context);
    if (!mounted) return;
    if (x == null) return;
    final cropped = await SafeImagePicker.cropImage(context, x.path);
    if (!mounted) return;
    try {
      // Some OEMs return a cropped path that isn't readable immediately; validate and fall back.
      Uint8List bytes;
      if (cropped != null) {
        try {
          bytes = await cropped.readAsBytes();
        } catch (e) {
          debugPrint('CroppedFile.readAsBytes failed ($e). Falling back to original image bytes.');
          bytes = await x.readAsBytes();
        }
      } else {
        bytes = await x.readAsBytes();
      }
      if (!mounted) return;
      // RCA: when users change photo, previous transform (offset/scale/rotation) can
      // push the new image out of frame so it looks like it didn't update.
      // Reset transforms on every new image.
      setState(() {
        _photo = bytes;
        _offset = Offset.zero;
        _scale = 1.0;
        _rotation = 0.0;
      });
      await analytics.log(
        AEvents.imageSelected,
        props: {
          'source': 'gallery',
          'cropped': cropped != null,
          'bytes_kb': (bytes.length / 1024).round(),
        },
      );
    } catch (e) {
      if (!mounted) return;
      debugPrint('Failed to load picked/cropped bytes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load cropped image. Please try again.')),
      );
    }
  }

  void _onScaleStart(ScaleStartDetails d) {
    _startFocal = d.focalPoint;
    _startOffset = _offset;
    _startScale = _scale;
    _startRotation = _rotation;
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    final startFocal = _startFocal;
    if (startFocal == null) return;
    var nextOffset = _startOffset + (d.focalPoint - startFocal);
    var nextScale = (_startScale * d.scale).clamp(0.6, 3.0);
    var nextRot = _startRotation + d.rotation;

    // snap-to-center helpers (soft)
    if (nextOffset.dx.abs() < 8) nextOffset = Offset(0, nextOffset.dy);
    if (nextOffset.dy.abs() < 8) nextOffset = Offset(nextOffset.dx, 0);

    setState(() {
      _offset = nextOffset;
      _scale = nextScale;
      _rotation = nextRot;
    });
  }

  Future<void> _pickCaptionColor() async {
    Color temp = _captionColor;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surfaceElevatedDark,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Caption color', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark)),
              const SizedBox(height: 10),
              ColorPicker(
                pickerColor: temp,
                onColorChanged: (c) => temp = c,
                enableAlpha: false,
                displayThumbColor: true,
                portraitOnly: true,
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
    if (!mounted) return;
    setState(() => _captionColor = temp);
  }

  Future<void> _save() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final bytes = await CardShareExport.renderKathaCardPngBytes(
        context: context,
        card: widget.args.card,
        contentLanguage: widget.args.contentLanguage,
        insertedPhotoBytes: _photo,
        insertedPhotoOffset: _offset,
        insertedPhotoScale: _scale,
        insertedPhotoRotation: _rotation,
        insertedPhotoOpacity: 1.0,
        caption: _caption,
        captionColor: _captionColor,
      );
      final ok = await CardShareExport.savePngBytesToGallery(
        bytes: bytes,
        nameStem: 'daily_katha_${widget.args.card.id}',
      );
      if (ok) {
        await ProviderScope.containerOf(context).read(userStatsProvider.notifier).incrementSaved();
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? 'Saved to gallery' : 'Could not save to gallery')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _status() async {
    if (_busy) return;
    setState(() => _busy = true);
    final analytics = ProviderScope.containerOf(context).read(analyticsProvider);
    try {
      await analytics.log(
        AEvents.shareClicked,
        props: {
          'channel': 'whatsapp_status',
          'has_photo': _photo != null,
          'has_caption': _caption.trim().isNotEmpty,
          'source': widget.args.preferStatusPrimaryCta ? 'feed' : 'editor',
        },
      );
      await CardShareExport.shareKathaCardAsImage(
        context: context,
        card: widget.args.card,
        contentLanguage: widget.args.contentLanguage,
        insertedPhotoBytes: _photo,
        insertedPhotoOffset: _offset,
        insertedPhotoScale: _scale,
        insertedPhotoRotation: _rotation,
        insertedPhotoOpacity: 1.0,
        caption: _caption,
        captionColor: _captionColor,
        shareService: widget.shareService,
      );
      await ProviderScope.containerOf(context).read(userStatsProvider.notifier).incrementShared();
      await analytics.log(
        AEvents.shareSheetOpened,
        props: {
          'channel': 'whatsapp_status',
          'source': widget.args.preferStatusPrimaryCta ? 'feed' : 'editor',
        },
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.feedScaffold,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
      backgroundColor: AppColors.feedScaffold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Edit'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onScaleStart: _photo == null ? null : _onScaleStart,
                    onScaleUpdate: _photo == null ? null : _onScaleUpdate,
                    child: StatusCard(
                      key: ValueKey('${widget.args.card.id}_${_photo?.hashCode ?? 0}'),
                      card: widget.args.card,
                      contentLanguage: widget.args.contentLanguage,
                      insertedPhotoBytes: _photo,
                      insertedPhotoOffset: _offset,
                      insertedPhotoScale: _scale,
                      insertedPhotoRotation: _rotation,
                      insertedPhotoOpacity: 1.0,
                      caption: _caption,
                      captionColor: _captionColor,
                      onPhotoTap: _busy ? null : _pickPhoto,
                      height: 560,
                      compact: false,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_photo != null) ...[
                      Row(
                        children: [
                          IconButton(
                            onPressed: _busy
                                ? null
                                : () => setState(() {
                                      _offset = Offset.zero;
                                      _scale = 1.0;
                                      _rotation = 0.0;
                                    }),
                            icon: const Icon(Icons.refresh, color: AppColors.textPrimaryDark),
                            tooltip: 'Reset photo placement',
                          ),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: Text(
                              'Adjust your photo',
                              style: TextStyle(color: AppColors.textSecondaryDark, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              enabled: !_busy,
                              style: const TextStyle(color: AppColors.textPrimaryDark),
                              decoration: InputDecoration(
                                hintText: 'Caption (optional)',
                                suffixIcon: IconButton(
                                  onPressed: _busy ? null : _pickCaptionColor,
                                  icon: const Icon(Icons.color_lens_outlined, color: AppColors.accentGold),
                                ),
                              ),
                              onChanged: (v) => setState(() => _caption = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _busy ? null : _pickPhoto,
                            icon: const Icon(Icons.photo_library_outlined),
                            label: Text(_photo == null ? 'Add photo' : 'Change photo'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: widget.args.preferStatusPrimaryCta
                              ? OutlinedButton.icon(
                                  onPressed: _busy ? null : _save,
                                  icon: const Icon(Icons.download_outlined),
                                  label: const Text('Save'),
                                )
                              : FilledButton.icon(
                                  onPressed: _busy ? null : _save,
                                  icon: const Icon(Icons.download_outlined),
                                  label: const Text('Save'),
                                ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: widget.args.preferStatusPrimaryCta
                              ? FilledButton.icon(
                                  onPressed: _busy ? null : _status,
                                  icon: const Icon(Icons.ios_share),
                                  label: const Text('Share to Status'),
                                )
                              : OutlinedButton.icon(
                                  onPressed: _busy ? null : _status,
                                  icon: const Icon(Icons.schedule),
                                  label: const Text('Status'),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

