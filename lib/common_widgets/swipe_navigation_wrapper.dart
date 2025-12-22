// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:OneBrain/main.dart';
// import 'package:OneBrain/screens/side_menu/model/ai_list_model.dart';
// import 'package:OneBrain/screens/imagex_screen.dart';
// import 'package:OneBrain/screens/flux_screen.dart';
// import 'package:OneBrain/screens/flux/provider/flux_provider.dart';
// import 'package:OneBrain/common_widgets/global_bottom_navigation.dart';

// class SwipeNavigationWrapper extends StatefulWidget {
//   final Widget chatScreen;
  
//   const SwipeNavigationWrapper({
//     Key? key,
//     required this.chatScreen,
//   }) : super(key: key);

//   @override
//   State<SwipeNavigationWrapper> createState() => SwipeNavigationWrapperState();
// class SwipeNavigationWrapperState extends State<SwipeNavigationWrapper> {
//   late PageController _pageController;
//   int _currentIndex = 0;
//   List<Widget> _screens = [];
//   List<String> _screenModes = [];

//   @override
//   void initState() {
//     super.initState();
//     _buildScreensList();
    
//     // Find current screen index based on currentToolMode
//     _currentIndex = _findCurrentIndex();
//     _pageController = PageController(initialPage: _currentIndex);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _buildScreensList() {
//     _screens.clear();
//     _screenModes.clear();
    
//     // Always add chat as first screen
//     _screens.add(widget.chatScreen);
//     _screenModes.add("chat");
    
//     // Add active AI tools
//     for (AiTool tool in activeAiTools) {
//       Widget toolScreen = _buildToolScreen(tool);
//       _screens.add(toolScreen);
//       _screenModes.add(tool.toolName);
//     }
//   }

//   Widget _buildToolScreen(AiTool tool) {
//     switch (tool.toolName.toLowerCase()) {
//       case 'imagex':
//         return const ImageXScreen();
//       case 'flux':
//         return ChangeNotifierProvider(
//           create: (_) => FluxProvider(),
//           child: const FluxScreen(),
//         );
//       case 'veo3':
//         return _buildComingSoonScreen(tool.toolName);
//       case 'humanizer':
//         return _buildComingSoonScreen(tool.toolName);
//       default:
//         return _buildComingSoonScreen(tool.toolName);
//     }
//   }

//   Widget _buildComingSoonScreen(String toolName) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0E27),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.only(
//             bottom: activeAiTools.isNotEmpty ? 80 : 0, // Add bottom padding when navigation is visible
//           ),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.construction,
//                   size: 80,
//                   color: Colors.orange.withOpacity(0.7),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   '$toolName',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'Coming Soon!',
//                   style: TextStyle(
//                     color: Colors.orange.withOpacity(0.8),
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Swipe left or right to navigate between tools',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.6),
//                     fontSize: 14,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   int _findCurrentIndex() {
//     for (int i = 0; i < _screenModes.length; i++) {
//       if (_screenModes[i] == currentToolMode) {
//         return i;
//       }
//     }
//     return 0; // Default to chat
//   }

//   void _onPageChanged(int index) {
//     setState(() {
//       _currentIndex = index;
//       currentToolMode = _screenModes[index];
      
//       if (currentToolMode == "chat") {
//         currentActiveTool = null;
//       } else {
//         // Find the corresponding tool
//         currentActiveTool = activeAiTools.firstWhere(
//           (tool) => tool.toolName == currentToolMode,
//           orElse: () => activeAiTools.first,
//         );
//       }
//     });
//   }

//   void navigateToIndex(int index) {
//     if (index >= 0 && index < _screens.length) {
//       _pageController.animateToPage(
//         index,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void navigateToMode(String mode) {
//     int index = _screenModes.indexOf(mode);
//     if (index != -1) {
//       navigateToIndex(index);
//     }
//   }

//   void _onToolTap(AiTool tool) {
//     navigateToMode(tool.toolName);
//   }

//   void _onChatTap() {
//     navigateToMode("chat");
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Rebuild screens list if active tools changed
//     if (_screens.length != activeAiTools.length + 1) {
//       _buildScreensList();
      
//       // Adjust current index if needed
//       int newIndex = _findCurrentIndex();
//       if (newIndex != _currentIndex && newIndex < _screens.length) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _pageController.animateToPage(
//             newIndex,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//           );
//         });
//       }
//     }

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Main content with PageView
//           PageView.builder(
//             controller: _pageController,
//             onPageChanged: _onPageChanged,
//             itemCount: _screens.length,
//             itemBuilder: (context, index) {
//               return _screens[index];
//             },
//           ),
          
//           // Bottom navigation overlay
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: GlobalBottomNavigation(
//               onToolTap: _onToolTap,
//               onChatTap: _onChatTap,
//               currentMode: currentToolMode,
//             ),
//           ),
          
//           // Page indicators (optional, for better UX)
//           if (activeAiTools.isNotEmpty && _screens.length > 1)
//             Positioned(
//               bottom: 80, // Above the bottom navigation
//               left: 0,
//               right: 0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(_screens.length, (index) {
//                   return Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 4),
//                     width: 8,
//                     height: 8,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: index == _currentIndex
//                           ? Colors.white
//                           : Colors.white.withOpacity(0.3),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // Extension to access the wrapper's navigation methods
// extension SwipeNavigationExtension on State {
//   SwipeNavigationWrapper? get swipeNavigationWrapper {
//     final wrapper = context.findAncestorWidgetOfExactType<SwipeNavigationWrapper>();
//     return wrapper;
//   }
  
//   SwipeNavigationWrapperState? get swipeNavigationState {
//     final state = context.findAncestorStateOfType<SwipeNavigationWrapperState>();
//     return state;
//   }
// } 