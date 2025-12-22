import 'package:flutter/material.dart';

class BounceButton extends StatefulWidget {
  final Widget? child;
  final GestureTapCallback? onTap;

  const BounceButton({super.key, this.child, this.onTap});

  @override
  State<BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<BounceButton> with SingleTickerProviderStateMixin {
  static const clickAnimationDurationMillis = 80;
  double _scaleTransformValue = 1;
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: clickAnimationDurationMillis),
      lowerBound: 0.0,
      upperBound: 0.03,
    )..addListener(() {
        if (mounted) {
          setState(() => _scaleTransformValue = 1 - animationController.value);
        }
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          widget.onTap?.call();
          _shrinkButtonSize();
          _restoreButtonSize();
        },
        onTapDown: (_) => _shrinkButtonSize(),
        onTapCancel: _restoreButtonSize,
        child: Transform.scale(
          scale: _scaleTransformValue,
          child: widget.child,
        ),
      ),
    );
  }

  void _shrinkButtonSize() {
    if (mounted) {
      animationController.forward();
    }
  }

  void _restoreButtonSize() {
    Future.delayed(
      const Duration(milliseconds: clickAnimationDurationMillis),
      () {
        if (mounted) {
          animationController.reverse();
        }
      },
    );
  }
}
