import 'package:flutter/material.dart';

class AnimatedTitleTextWidget extends StatelessWidget {
  final Animation<double> opacityAnimation;
  final Animation<Offset> slideAnimation;

  const AnimatedTitleTextWidget({
    super.key,
    required this.opacityAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: opacityAnimation,
        child: const Text(
          'QuadriPilot',
          style: TextStyle(
            fontSize: 48,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
