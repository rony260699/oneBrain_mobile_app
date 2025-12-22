import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  final double dotRadius;
  final double spacing;
  final Color color;

  DottedLinePainter({
    required this.dotRadius,
    required this.spacing,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double totalWidth = size.width;
    final double dotDiameter = 2 * dotRadius;
    final double totalSpacing = dotDiameter + spacing;
    final int dotCount = (totalWidth / totalSpacing).floor();

    for (int i = 0; i < dotCount; i++) {
      final double dx = i * totalSpacing + dotRadius;
      canvas.drawCircle(Offset(dx, size.height / 2), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DottedLine extends StatelessWidget {
  final double width;
  final double dotRadius;
  final double spacing;
  final Color color;

  const DottedLine({
    super.key,
    required this.width,
    required this.dotRadius,
    required this.spacing,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, dotRadius * 2),
      painter: DottedLinePainter(
        dotRadius: dotRadius,
        spacing: spacing,
        color: color,
      ),
    );
  }
}

class VerticalDottedLinePainter extends CustomPainter {
  final double dotRadius;
  final double spacing;
  final Color color;

  VerticalDottedLinePainter({
    required this.dotRadius,
    required this.spacing,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double totalHeight = size.height;
    final double dotDiameter = 2 * dotRadius;
    final double totalSpacing = dotDiameter + spacing;
    final int dotCount = (totalHeight / totalSpacing).floor();

    for (int i = 0; i < dotCount; i++) {
      final double dy = i * totalSpacing + dotRadius;
      canvas.drawCircle(Offset(size.width / 2, dy), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class VerticalDottedLine extends StatelessWidget {
  final double height;
  final double dotRadius;
  final double spacing;
  final Color color;

  const VerticalDottedLine({
    super.key,
    required this.height,
    required this.dotRadius,
    required this.spacing,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(dotRadius * 2, height),
      painter: VerticalDottedLinePainter(
        dotRadius: dotRadius,
        spacing: spacing,
        color: color,
      ),
    );
  }
}