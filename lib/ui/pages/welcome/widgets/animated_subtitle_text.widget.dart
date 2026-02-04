import 'package:flutter/material.dart';

class AnimatedSubtitleTextWidget extends StatelessWidget {
  final Animation<double> opacityAnimation;
  final Animation<Offset> slideAnimation;

  const AnimatedSubtitleTextWidget({
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
          'by Quadrilogis',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
