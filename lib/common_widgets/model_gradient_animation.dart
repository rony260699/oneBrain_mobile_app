import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:OneBrain/common_widgets/text_widget.dart';

class ModelGradientAnimation extends StatelessWidget {
  final String modelName;
  final double fontSize;
  final FontWeight fontWeight;

  const ModelGradientAnimation({
    super.key,
    required this.modelName,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
  });

  @override
  Widget build(BuildContext context) {
    return _LoopingShader(
      child: TextWidget(
        text: modelName,
        fontSize: fontSize,
        color: Colors.white,
        fontWeight: fontWeight,
        fontFamily: 'Roboto',
        textAlign: TextAlign.left,
      ),
    );
  }
}

class _LoopingShader extends StatefulWidget {
  final Widget child;

  const _LoopingShader({required this.child});

  @override
  State<_LoopingShader> createState() => _LoopingShaderState();
}

class _LoopingShaderState extends State<_LoopingShader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child, // ✅ cached, not rebuilt every frame
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn, // ✅ only affect child pixels
          shaderCallback: (bounds) {
            final width = bounds.width;
            final gradientWidth = width * 1.5;
            final centerX = width * 0.5;
            final offset = _controller.value * width * 2 - width;

            return ui.Gradient.linear(
              Offset(centerX + offset - gradientWidth * 0.5, 0),
              Offset(centerX + offset + gradientWidth * 0.5, 0),
              const [
                Color(0xFFFFFFFF),
                Color(0xFFE9ECEF),
                Color(0xFFCED4DA),
                Color(0xFF868E96),
                Color(0xFF495057),
                Color(0xFF868E96),
                Color(0xFFCED4DA),
                Color(0xFFE9ECEF),
                Color(0xFFFFFFFF),
              ],
              [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.0],
              TileMode.mirror,
            );
          },
          child: child,
        );
      },
    );
  }
}
