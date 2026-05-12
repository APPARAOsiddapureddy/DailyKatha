// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/user_engagement_store.dart';
import '../../data/providers.dart';
import '../../data/user_stats_controller.dart';
import '../../models/card_editor_args.dart';
import '../../models/status_card_photo_layer.dart';
import '../../observability/analytics/analytics.dart';
import '../../observability/analytics/analytics_provider.dart';
import '../../services/card_share_export.dart';
import '../../services/safe_image_picker.dart';
import '../../services/share_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../utils/image_aspect_ratio.dart';
import '../../widgets/status_card.dart';

enum _EditorPane { edit, view }

class CardEditorScreen extends StatefulWidget {
  const CardEditorScreen({
    super.key,
    required this.args,
    required this.shareService,
  });

  final CardEditorArgs args;
  final ShareService shareService;

  @override
  State<CardEditorScreen> createState() => _CardEditorScreenState();
}

class _CardEditorScreenState extends State<CardEditorScreen> {
  final List<StatusCardPhotoLayer> _layers = [];
  int _activeIndex = 0;
  final TextEditingController _captionController = TextEditingController();

  Color _captionColor = const Color(0xFFF5E6C0);

  Offset? _startFocal;
  Offset _startOffset = Offset.zero;
  double _startScale = 1.0;
  double _startRotation = 0.0;
  bool _busy = false;
  _EditorPane _pane = _EditorPane.edit;

  @override
  void initState() {
    super.initState();
    final a = widget.args;
    if (a.initialPhotoLayers != null && a.initialPhotoLayers!.isNotEmpty) {
      _layers.addAll(a.initialPhotoLayers!);
      _activeIndex = 0;
    } else if (a.initialPhotoBytes != null) {
      _layers.add(
        StatusCardPhotoLayer(
          bytes: a.initialPhotoBytes!,
          offset:
              a.initialPhotoOffset +
              Offset(0, CardShareExport.logicalExportHeight * 0.22),
          scale: a.initialPhotoScale,
          rotation: a.initialPhotoRotation,
          opacity: a.initialPhotoOpacity,
          caption: a.initialCaption,
          captionColor: a.initialCaptionColor,
        ),
      );
      _activeIndex = 0;
    }
    _captionController.text = _layers.isEmpty
        ? a.initialCaption
        : _layers[_activeIndex].caption;
    _captionColor = a.initialCaptionColor;
    if (_layers.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _ensureLayerAspectRatios());
    }
  }

  Future<void> _ensureLayerAspectRatios() async {
    if (_layers.isEmpty || !mounted) return;
    final out = <StatusCardPhotoLayer>[];
    for (final layer in _layers) {
      final ar = await decodeImageAspectRatio(layer.bytes);
      out.add(layer.copyWith(imageAspectRatio: ar));
    }
    if (!mounted) return;
    setState(() {
      for (var i = 0; i < out.length; i++) {
        _layers[i] = out[i];
      }
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _syncCaptionIntoActiveLayer() {
    if (_layers.isEmpty) return;
    _layers[_activeIndex] = _layers[_activeIndex].copyWith(
      caption: _captionController.text,
      captionColor: _captionColor,
    );
  }

  void _setActive(int index) {
    if (index < 0 || index >= _layers.length) return;
    setState(() {
      _syncCaptionIntoActiveLayer();
      _activeIndex = index;
      _captionController.text = _layers[_activeIndex].caption;
      _captionColor = _layers[_activeIndex].captionColor ?? _captionColor;
    });
  }

  Future<void> _addPhoto() async {
    if (_layers.length >= 3) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can add up to 3 photos.')),
      );
      return;
    }
    final analytics = ProviderScope.containerOf(
      context,
    ).read(analyticsProvider);
    final x = await SafeImagePicker.pickFromGallery(context);
    if (!mounted) return;
    if (x == null) return;
    final cropped = await SafeImagePicker.cropImage(context, x.path);
    if (!mounted) return;
    try {
      Uint8List bytes;
      if (cropped != null) {
        try {
          bytes = await cropped.readAsBytes();
        } catch (e) {
          debugPrint(
            'CroppedFile.readAsBytes failed ($e). Falling back to original image bytes.',
          );
          bytes = await x.readAsBytes();
        }
      } else {
        bytes = await x.readAsBytes();
      }
      if (!mounted) return;
      final aspectRatio = await decodeImageAspectRatio(bytes);
      if (!mounted) return;
      final idx = _layers.length;
      setState(() {
        _layers.add(
          StatusCardPhotoLayer(
            bytes: bytes,
            imageAspectRatio: aspectRatio,
            offset: Offset(22.0 * idx, 18.0 * idx),
            scale: 1.0,
            rotation: 0.0,
            opacity: 1.0,
            caption: '',
            captionColor: _captionColor,
          ),
        );
        _activeIndex = idx;
        _captionController.clear();
      });
      await analytics.log(
        AEvents.imageSelected,
        props: {
          'source': 'gallery',
          'cropped': cropped != null,
          'bytes_kb': (bytes.length / 1024).round(),
          'layer_index': idx,
          'total_layers': _layers.length,
        },
      );
    } catch (e) {
      if (!mounted) return;
      debugPrint('Failed to load picked/cropped bytes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not load cropped image. Please try again.'),
        ),
      );
    }
  }

  void _removeActivePhoto() {
    if (_layers.isEmpty) return;
    setState(() {
      _layers.removeAt(_activeIndex);
      if (_layers.isEmpty) {
        _activeIndex = 0;
        _captionController.clear();
      } else {
        _activeIndex = _activeIndex.clamp(0, _layers.length - 1);
        _captionController.text = _layers[_activeIndex].caption;
      }
    });
  }

  void _onLayerScaleStart(int index, ScaleStartDetails d) {
    _startFocal = d.focalPoint;
    _startOffset = _layers[index].offset;
    _startScale = _layers[index].scale;
    _startRotation = _layers[index].rotation;
  }

  void _onLayerScaleUpdate(int index, ScaleUpdateDetails d) {
    final startFocal = _startFocal;
    if (startFocal == null) return;
    var nextOffset = _startOffset + (d.focalPoint - startFocal);
    var nextScale = (_startScale * d.scale).clamp(0.6, 3.0);
    var nextRot = _startRotation + d.rotation;

    if (nextOffset.dx.abs() < 8) nextOffset = Offset(0, nextOffset.dy);
    if (nextOffset.dy.abs() < 8) nextOffset = Offset(nextOffset.dx, 0);

    setState(() {
      _layers[index] = _layers[index].copyWith(
        offset: nextOffset,
        scale: nextScale,
        rotation: nextRot,
      );
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
              const Text(
                'Caption color',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryDark,
                ),
              ),
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
    setState(() {
      _captionColor = temp;
      _syncCaptionIntoActiveLayer();
    });
  }

  Future<void> _save() async {
    if (_busy) return;
    _syncCaptionIntoActiveLayer();
    setState(() => _busy = true);
    try {
      final bytes = await CardShareExport.renderKathaCardPngBytes(
        context: context,
        card: widget.args.card,
        contentLanguage: widget.args.contentLanguage,
        photoLayers: _layers.isEmpty
            ? null
            : List<StatusCardPhotoLayer>.from(_layers),
      );
      final ok = await CardShareExport.savePngBytesToGallery(
        bytes: bytes,
        nameStem: 'daily_katha_${widget.args.card.id}',
      );
      if (ok) {
        final c = widget.args.card;
        final freshlyAdded = await UserEngagementStore.recordSaved(c.id);
        await UserEngagementStore.bumpCategoryAffinity(
          c.category,
          delta: freshlyAdded ? 4 : 1,
        );
        final container = ProviderScope.containerOf(context);
        if (freshlyAdded) {
          await container.read(userStatsProvider.notifier).incrementSaved();
        }
        container.invalidate(userEngagementProvider);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? 'Saved to gallery' : 'Could not save to gallery'),
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _status() async {
    if (_busy) return;
    _syncCaptionIntoActiveLayer();
    setState(() => _busy = true);
    final analytics = ProviderScope.containerOf(
      context,
    ).read(analyticsProvider);
    try {
      await analytics.log(
        AEvents.shareClicked,
        props: {
          'channel': 'whatsapp_status',
          'has_photo': _layers.isNotEmpty,
          'photo_count': _layers.length,
          'has_caption': _captionController.text.trim().isNotEmpty,
          'source': widget.args.preferStatusPrimaryCta ? 'feed' : 'editor',
        },
      );
      await CardShareExport.shareKathaCardAsImage(
        context: context,
        card: widget.args.card,
        contentLanguage: widget.args.contentLanguage,
        photoLayers: _layers.isEmpty
            ? null
            : List<StatusCardPhotoLayer>.from(_layers),
        shareService: widget.shareService,
      );
      final c = widget.args.card;
      await UserEngagementStore.recordShared(c.id);
      await UserEngagementStore.bumpCategoryAffinity(c.category);
      final container = ProviderScope.containerOf(context);
      await container.read(userStatsProvider.notifier).incrementShared();
      container.invalidate(userEngagementProvider);
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

  /// Share / save / status actions — reused in Edit and View panes.
  List<Widget> _primaryActionWidgets() {
    if (widget.args.preferStatusPrimaryCta) {
      return [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _busy ? null : _status,
            icon: const Icon(Icons.ios_share, size: 20),
            label: Text(
              'Share to Status',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _busy ? null : _addPhoto,
                icon: const Icon(Icons.add_photo_alternate_outlined, size: 20),
                label: Text(
                  _layers.length >= 3 ? 'Max 3 photos' : 'Add photo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _busy ? null : _save,
                icon: const Icon(Icons.download_outlined, size: 20),
                label: const Text(
                  'Save',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ];
    }
    return [
      Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _busy ? null : _addPhoto,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 20),
              label: Text(
                _layers.length >= 3 ? 'Max 3 photos' : 'Add photo',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.icon(
              onPressed: _busy ? null : _save,
              icon: const Icon(Icons.download_outlined, size: 20),
              label: const Text(
                'Save',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _busy ? null : _status,
              icon: const Icon(Icons.schedule, size: 20),
              label: const Text(
                'Status',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.editorCard(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
            surfaceTintColor: Colors.transparent,
            title: const Text('Edit'),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
                  child: SegmentedButton<_EditorPane>(
                    segments: const [
                      ButtonSegment<_EditorPane>(
                        value: _EditorPane.edit,
                        label: Text('Edit'),
                        icon: Icon(Icons.tune_outlined, size: 18),
                      ),
                      ButtonSegment<_EditorPane>(
                        value: _EditorPane.view,
                        label: Text('View'),
                        icon: Icon(Icons.visibility_outlined, size: 18),
                      ),
                    ],
                    selected: {_pane},
                    onSelectionChanged: (Set<_EditorPane> selection) {
                      if (selection.isEmpty) return;
                      setState(() {
                        _syncCaptionIntoActiveLayer();
                        _pane = selection.first;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    color: _pane == _EditorPane.view
                        ? const Color(0xFF070605)
                        : AppColors.feedScaffold,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: _pane == _EditorPane.view ? 10 : 16,
                        vertical: 6,
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: CardShareExport.logicalExportWidth,
                            height: CardShareExport.logicalExportHeight,
                            child: StatusCard(
                              key: ValueKey(
                                '${widget.args.card.id}_${_layers.map((e) => e.bytes.hashCode).join('_')}',
                              ),
                              card: widget.args.card,
                              contentLanguage: widget.args.contentLanguage,
                              photoLayers: _layers.isEmpty ? null : _layers,
                              width: CardShareExport.logicalExportWidth,
                              height: CardShareExport.logicalExportHeight,
                              compact: false,
                              interactivePhotoLayerIndex:
                                  _pane == _EditorPane.view || _layers.isEmpty
                                  ? null
                                  : _activeIndex,
                              onPhotoLayerScaleStart:
                                  _pane == _EditorPane.view || _busy
                                  ? null
                                  : _onLayerScaleStart,
                              onPhotoLayerScaleUpdate:
                                  _pane == _EditorPane.view || _busy
                                  ? null
                                  : _onLayerScaleUpdate,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_pane == _EditorPane.edit)
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_layers.isNotEmpty) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Photos (${_layers.length}/3) · tap a chip, then drag or pinch the card',
                                style: TextStyle(
                                  color: AppColors.textSecondaryDark.withValues(
                                    alpha: 0.95,
                                  ),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (var i = 0; i < _layers.length; i++)
                                  ChoiceChip(
                                    label: Text('Photo ${i + 1}'),
                                    selected: _activeIndex == i,
                                    onSelected: _busy
                                        ? null
                                        : (_) => _setActive(i),
                                  ),
                                if (_layers.length < 3)
                                  ActionChip(
                                    avatar: const Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 18,
                                    ),
                                    label: const Text('Add'),
                                    onPressed: _busy ? null : _addPhoto,
                                  ),
                                IconButton(
                                  onPressed: _busy ? null : _removeActivePhoto,
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.textPrimaryDark,
                                  ),
                                  tooltip: 'Remove selected photo',
                                ),
                                IconButton(
                                  onPressed: _busy
                                      ? null
                                      : () => setState(() {
                                          _syncCaptionIntoActiveLayer();
                                          _layers[_activeIndex] =
                                              _layers[_activeIndex].copyWith(
                                                offset: Offset.zero,
                                                scale: 1.0,
                                                rotation: 0.0,
                                              );
                                        }),
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: AppColors.textPrimaryDark,
                                  ),
                                  tooltip: 'Reset placement for selected photo',
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              enabled: !_busy,
                              controller: _captionController,
                              style: const TextStyle(
                                color: AppColors.textPrimaryDark,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Caption on selected photo (optional)',
                                suffixIcon: IconButton(
                                  onPressed: _busy ? null : _pickCaptionColor,
                                  icon: const Icon(
                                    Icons.color_lens_outlined,
                                    color: AppColors.accentGold,
                                  ),
                                ),
                              ),
                              onChanged: (v) {
                                if (_layers.isEmpty) return;
                                setState(() {
                                  _layers[_activeIndex] = _layers[_activeIndex]
                                      .copyWith(
                                        caption: v,
                                        captionColor: _captionColor,
                                      );
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                          ] else ...[
                            Text(
                              'Pick a photo, crop it, then place up to three anywhere on the card.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondaryDark.withValues(
                                  alpha: 0.9,
                                ),
                                fontSize: 12.5,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                          ..._primaryActionWidgets(),
                        ],
                      ),
                    ),
                  ),
                if (_pane == _EditorPane.view)
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'This is how your status will look when you share it.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondaryDark.withValues(
                                alpha: 0.95,
                              ),
                              fontSize: 13.5,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: _busy
                                ? null
                                : () =>
                                      setState(() => _pane = _EditorPane.edit),
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            label: const Text('Back to editing'),
                          ),
                          const SizedBox(height: 14),
                          ..._primaryActionWidgets(),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
