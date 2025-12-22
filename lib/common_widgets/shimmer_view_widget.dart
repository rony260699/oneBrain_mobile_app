// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class ShimmerViewWidget extends StatelessWidget {
//   final double width, height;
//   final double? borderRadius;
//   final BoxShape? boxShape;

//   const ShimmerViewWidget({super.key, required this.width, required this.height, this.borderRadius, this.boxShape});

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       highlightColor: Colors.grey[100]!,
//       baseColor: Colors.grey[300]!,
//       period: const Duration(seconds: 2),
//       child: Container(
//         height: height,
//         width: width,
//         decoration: boxShape != null
//             ? BoxDecoration(
//                 color: Colors.grey[400]!,
//                 shape: boxShape ?? BoxShape.rectangle,
//               )
//             : BoxDecoration(
//                 color: Colors.grey[400]!,
//                 borderRadius: BorderRadius.circular(borderRadius ?? 0),
//               ),
//       ),
//     );
//   }
// }
