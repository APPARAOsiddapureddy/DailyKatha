import 'package:flutter/material.dart';

/// Logo row with diya motif.
///
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false, this.color});

  final bool compact;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 18.0 : 22.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('🪔', style: TextStyle(fontSize: size + 4)),
        const SizedBox(width: 10),
        Text(
          'Dailykatha',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: color ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
