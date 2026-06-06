import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProtoActionPill extends StatelessWidget {
  const ProtoActionPill({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Font metrics matching [ProtoActionPill]; set [color] for the surrounding control (never forces white/black).
  static TextStyle typographyOnly(BuildContext context) {
    final base =
        Theme.of(context).textTheme.titleMedium ??
        Theme.of(context).textTheme.titleLarge ??
        const TextStyle();
    return base.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.1);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.protoSurface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.protoBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.protoInk),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: typographyOnly(
                    context,
                  ).copyWith(color: AppColors.protoInk),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
