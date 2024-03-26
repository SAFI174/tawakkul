import 'package:flutter/material.dart';

class AnimatedCircularProgressIndicator extends StatelessWidget {
  const AnimatedCircularProgressIndicator({
    super.key,
    required this.percentage,
    required this.animationDuration,
  });

  final double percentage;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: percentage),
        duration: animationDuration,
        builder: (context, double value, child) => Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: value,
            ),
            Center(
              child: Text(
                "${(value * 100).toInt()}%",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
