import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer(
      {super.key, required this.child, this.useMaterial = false});
  final Widget child;
  final bool useMaterial;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Theme.of(context).disabledColor.withAlpha(40),
        ),
      ),
      child: useMaterial
          ? Material(

              borderRadius: BorderRadius.circular(8),
              child: child,
            )
          : child,
    );
  }
}
