// import 'package:flutter/material.dart';
// import '../models/user_model.dart';
// import '../theme/theme_colors.dart';

// class CurrentSubscriptionCard extends StatelessWidget {
//   final UserModel user;

//   const CurrentSubscriptionCard({
//     super.key,
//     required this.user,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: ThemeColors.cardBackground,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: ThemeColors.borderColor,
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Token Balance - First Line
//           Text(
//             'Token Balance: 80,48,66,043',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
          
//           const SizedBox(height: 8),
          
//           // Plan Expires - Second Line (below token balance)
//           Text(
//             'Plan Expires: Jul 19',
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.7),
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// } 