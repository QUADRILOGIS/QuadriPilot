import 'package:flutter/material.dart';
import 'package:quadri_pilot/constants/app_assets.dart';

class AnimatedLogoWidget extends StatelessWidget {
  final Animation<double> opacityAnimation;
  final Animation<double> scaleAnimation;

  const AnimatedLogoWidget({
    super.key,
    required this.opacityAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(
        opacity: opacityAnimation,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              AppAssets.logo,
              width: 80,
            ),
          ),
        ),
      ),
    );
  }
}
