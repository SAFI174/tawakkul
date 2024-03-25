import 'package:flutter/material.dart';

class AnimatedLinearProgressIndicator extends StatelessWidget {
  const AnimatedLinearProgressIndicator({
    Key? key,
    required this.percentage,
    this.percentageTextStyle,
    this.labelStyle,
    this.animationDuration,
    this.indicatorColor,
    this.indicatorBackgroundColor,
  }) : super(key: key);

  final double percentage;

  final Duration? animationDuration;
  final TextStyle? percentageTextStyle;
  final TextStyle? labelStyle;
  final Color? indicatorColor;
  final Color? indicatorBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: percentage),
      duration: animationDuration ?? const Duration(milliseconds: 500),
      builder: (context, double value, child) => Column(
        children: [
          LinearProgressIndicator(
            value: value,
            color: indicatorColor,
          ),
        ],
      ),
    );
  }
}
