import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ElectronicMasbhaButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const ElectronicMasbhaButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ElectronicMasbhaButtonState createState() => _ElectronicMasbhaButtonState();
}

class _ElectronicMasbhaButtonState extends State<ElectronicMasbhaButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linearToEaseOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
      },
      onTapUp: (_) {
        _animationController.reverse();
      },
      onTap: () {
        widget.onPressed();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(50),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor,
                blurRadius: 5.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              widget.icon,
              color: Colors.white,
              size: 100.h > 100.w
                  ? 100.w > 500
                      ? 30.w
                      : 40.w
                  : 30.h,
            ),
          ),
        ),
      ),
    );
  }
}
