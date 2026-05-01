import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.scaffoldDark,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentGold.withValues(alpha: 0.06),
            AppColors.scaffoldDark,
            AppColors.scaffoldDark,
            const Color(0xFF0A121A),
          ],
          stops: const [0.0, 0.35, 0.75, 1.0],
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.7, -0.85),
            radius: 1.1,
            colors: [
              Colors.white.withValues(alpha: 0.05),
              Colors.transparent,
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: child,
      ),
    );
  }
}

