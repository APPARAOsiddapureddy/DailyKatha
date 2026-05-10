import 'package:flutter/material.dart';

/// Bottom action row (Like, Status, Save, Edit) — compact touch targets.
class FeedActionBar extends StatelessWidget {
  const FeedActionBar({
    super.key,
    required this.liked,
    required this.onLike,
    required this.onShare,
    required this.onDownload,
    required this.onEdit,
  });

  final bool liked;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final VoidCallback onDownload;
  final VoidCallback onEdit;

  static const double _btn = 52;
  static const double _gap = 10;

  @override
  Widget build(BuildContext context) {
    final base = Colors.white.withValues(alpha: 0.07);
    final border = Colors.white.withValues(alpha: 0.08);
    final icon = Colors.white.withValues(alpha: 0.55);
    final label = Colors.white.withValues(alpha: 0.35);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        _ActBtn(
          label: 'Like',
          icon: Icon(
            Icons.favorite_border,
            size: 20,
            color: liked ? const Color(0xFFD45064) : icon,
          ),
          iconLiked: const Icon(
            Icons.favorite,
            size: 20,
            color: Color(0xFFD45064),
          ),
          liked: liked,
          base: base,
          border: border,
          labelColor: liked ? const Color(0xFFCC5A6E) : label,
          onTap: onLike,
        ),
        SizedBox(width: _gap),
        _ActBtn(
          label: 'Edit',
          icon: Icon(Icons.schedule, size: 20, color: icon),
          base: base,
          border: border,
          labelColor: label,
          onTap: onShare,
        ),
        SizedBox(width: _gap),
        _ActBtn(
          label: 'Save',
          icon: Icon(Icons.download_outlined, size: 20, color: icon),
          base: base,
          border: border,
          labelColor: label,
          onTap: onDownload,
        ),
        SizedBox(width: _gap),
        _ActBtn(
          label: 'Share',
          icon: Icon(Icons.ios_share, size: 20, color: icon),
          base: base,
          border: border,
          labelColor: label,
          onTap: onEdit,
        ),
      ],
    );
  }
}

class _ActBtn extends StatelessWidget {
  const _ActBtn({
    required this.label,
    required this.icon,
    required this.base,
    required this.border,
    required this.labelColor,
    required this.onTap,
    this.liked = false,
    this.iconLiked,
  });

  final String label;
  final Widget icon;
  final Widget? iconLiked;
  final bool liked;
  final Color base;
  final Color border;
  final Color labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fill = liked ? const Color(0xFFD45064).withValues(alpha: 0.15) : base;
    final side = liked
        ? const Color(0xFFD45064).withValues(alpha: 0.3)
        : border;

    return Material(
      color: fill,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: side),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white.withValues(alpha: 0.08),
        highlightColor: Colors.white.withValues(alpha: 0.04),
        child: SizedBox(
          width: FeedActionBar._btn,
          height: FeedActionBar._btn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              liked && iconLiked != null ? iconLiked! : icon,
              const SizedBox(height: 3),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                  color: labelColor,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
