import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ThinkingShimmer extends StatelessWidget {
  const ThinkingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = const Color(0xFF1E2433);
    final highlightColor = const Color(0xFF2A3245);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        period: const Duration(seconds: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [..._buildBars()],
        ),
      ),
    );
  }

  List<Widget> _buildBars() {
    final barWidths = [1.0, 0.75, 0.65, 0.85, 0.55]; // variable widths
    return List.generate(
      barWidths.length,
      (index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: FractionallySizedBox(
          widthFactor: barWidths[index],
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFF2A3245),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
