import 'package:flutter/material.dart';

class GradientProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Duration animationDuration;
  final List<Color> colors;

  const GradientProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.borderRadius = 10,
    this.backgroundColor = const Color(0xFF2E2E2E),
    this.animationDuration = const Duration(milliseconds: 400),
    this.colors = const [Color(0xFF42A5F5), Color(0xFF7E57C2)],
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        color: backgroundColor, // track color
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth * clamped;
            return Stack(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: width),
                  duration: animationDuration,
                  curve: Curves.easeInOut,
                  builder: (context, animatedWidth, child) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: animatedWidth,
                        height: height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: colors,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
