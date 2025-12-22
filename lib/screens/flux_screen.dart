// import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:provider/provider.dart';
// import 'dart:math';
// import '../common_widgets/hexcolor.dart';
// // import '../resources/color.dart';
// // import '../resources/image.dart';
// // import '../resources/strings.dart';
// // import '../main.dart';
// // import '../common_widgets/global_bottom_navigation.dart';

// import '../screens/side_menu/model/ai_list_model.dart';
// import 'imagex/view/imagex_screen.dart';
// import 'flux/provider/flux_provider.dart';
// import 'flux/widgets/flux_header.dart';
// import 'flux/flux_image_generator_page.dart';
// import 'flux/widgets/flux_chat_bar.dart';
// // import 'home/cubit/home_screen_cubit.dart';

// class FluxScreen extends StatefulWidget {
//   final String? conversationId;

//   const FluxScreen({Key? key, this.conversationId}) : super(key: key);

//   @override
//   State<FluxScreen> createState() => _FluxScreenState();
// }

// class _FluxScreenState extends State<FluxScreen> with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late AnimationController _particleController;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: Duration(seconds: 3),
//       vsync: this,
//     )..repeat();

//     _particleController = AnimationController(
//       duration: Duration(seconds: 20),
//       vsync: this,
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _particleController.dispose();
//     super.dispose();
//   }

//   // void _switchToChat() {
//   //   setState(() {
//   //     currentToolMode = "chat";
//   //     currentActiveTool = null;
//   //   });
//   //   Navigator.pop(context);
//   // }

//   // void _switchToTool(AiTool tool) {
//   //   setState(() {
//   //     currentToolMode = tool.toolName;
//   //     currentActiveTool = tool;
//   //   });

//   //   if (tool.toolName.toLowerCase() != 'flux') {
//   //     _navigateToTool(tool);
//   //   }
//   // }

//   void _navigateToTool(AiTool tool) {
//     switch (tool.toolName.toLowerCase()) {
//       case 'imagex':
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => const ImageXScreen(),
//             settings: const RouteSettings(name: '/imagex'),
//           ),
//         );
//         break;
//       case 'veo3':
//         _showComingSoon(tool.toolName);
//         break;
//       case 'humanizer':
//         _showComingSoon(tool.toolName);
//         break;
//       default:
//         _showComingSoon(tool.toolName);
//         break;
//     }
//   }

//   void _showComingSoon(String toolName) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('$toolName is coming soon!'),
//         backgroundColor: Colors.orange,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => FluxProvider(),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         // bottomNavigationBar: activeAiTools.isNotEmpty ? GlobalBottomNavigation(
//         //   currentMode: currentToolMode,
//         //   onChatTap: _switchToChat,
//         //   onToolTap: _switchToTool,
//         // ) : null,
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(
//                   0xFF000000,
//                 ), // Pure black at top for better text visibility
//                 Color(0xFF000000), // Keep black longer for content area
//                 Color(0xFF0A0E24), // Deep dark blue starts lower
//                 Color(0xFF0C1028), // Slightly lighter dark blue at bottom
//               ],
//               stops: [0.0, 0.7, 0.85, 1.0], // Push blue colors towards bottom
//             ),
//           ),
//           child: Stack(
//             children: [
//               // Animated background particles
//               _buildAnimatedBackground(),

//               // Main content
//               SafeArea(
//                 child: Column(
//                   children: [
//                     // Header
//                     FluxHeader(),

//                     // Messages/Content Area
//                     Expanded(
//                       child: Consumer<FluxProvider>(
//                         builder: (context, provider, child) {
//                           if (provider.messages.isEmpty) {
//                             return FluxImageGeneratorPage();
//                           }
//                           return FluxImageGeneratorPage();
//                         },
//                       ),
//                     ),

//                     // Chat Input (matching ImageX structure)
//                     FluxChatBar(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAnimatedBackground() {
//     return AnimatedBuilder(
//       animation: _particleController,
//       builder: (context, child) {
//         return Container(
//           child: Stack(
//             children: [
//               // Floating particles
//               ...List.generate(15, (index) {
//                 final offset = Offset(
//                   (index * 0.15 + _particleController.value * 0.3) % 1.0,
//                   (index * 0.12 + _particleController.value * 0.2) % 1.0,
//                 );

//                 return Positioned(
//                   left: MediaQuery.of(context).size.width * offset.dx,
//                   top: MediaQuery.of(context).size.height * offset.dy,
//                   child: Container(
//                     width: 4 + (index % 3) * 2,
//                     height: 4 + (index % 3) * 2,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           HexColor('#656FE2').withOpacity(0.6),
//                           HexColor('#656FE2').withOpacity(0.0),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),

//               // Glowing orbs
//               ...List.generate(5, (index) {
//                 final angle = _animationController.value * 2 * pi + index * 1.2;
//                 final radius = 100 + index * 20;
//                 final centerX = MediaQuery.of(context).size.width * 0.5;
//                 final centerY = MediaQuery.of(context).size.height * 0.3;

//                 return Positioned(
//                   left: centerX + radius * cos(angle * 0.3),
//                   top: centerY + radius * 0.6 * sin(angle * 0.4),
//                   child: Container(
//                     width: 20 + index * 5,
//                     height: 20 + index * 5,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           HexColor('#4F46E5').withOpacity(0.3),
//                           HexColor('#7C3AED').withOpacity(0.1),
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
