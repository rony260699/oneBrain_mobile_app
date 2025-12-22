// import 'package:flutter/material.dart';
// import 'package:OneBrain/common_widgets/hexcolor.dart';
// import 'package:OneBrain/screens/side_menu/model/ai_list_model.dart';

// import 'package:OneBrain/main.dart';

// class GlobalBottomNavigation extends StatelessWidget {
//   final Function(AiTool tool) onToolTap;
//   final Function() onChatTap;
//   final String currentMode; // "chat" or tool name

//   const GlobalBottomNavigation({
//     Key? key,
//     required this.onToolTap,
//     required this.onChatTap,
//     required this.currentMode,
//   }) : super(key: key);



//   @override
//   Widget build(BuildContext context) {
//     // Limit to max 3 tools + chat
//     List<AiTool> displayTools = activeAiTools.take(3).toList();
    
//     // Check if keyboard is open
//     final MediaQueryData mediaQuery = MediaQuery.of(context);
//     final double keyboardHeight = mediaQuery.viewInsets.bottom;
//     final bool hasKeyboard = keyboardHeight > 0;

//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFF000000).withOpacity(0.95),
//         border: Border(
//           top: BorderSide(
//             color: HexColor('#656FE2').withOpacity(0.3),
//             width: 1.0,
//           ),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: HexColor('#656FE2').withOpacity(0.2),
//             offset: const Offset(0, -2),
//             blurRadius: 12,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: SafeArea(
//         top: false,
//         // When keyboard is open, don't apply bottom safe area to avoid the gap
//         bottom: !hasKeyboard,
//         child: Container(
//           height: 28, // Ultra minimal height
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//             // Chat button (always first)
//             _buildNavButton(
//               icon: Icons.chat_bubble_outline,
//               label: 'Chat',
//               isActive: currentMode == "chat",
//               onTap: onChatTap,
//             ),
//             // Active AI Tools
//             ...displayTools.map((tool) => _buildNavButton(
//               icon: _getToolIcon(tool),
//               label: tool.toolName,
//               isActive: currentMode == tool.toolName,
//               onTap: () => onToolTap(tool),
//             )).toList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavButton({
//     required IconData icon,
//     required String label,
//     required bool isActive,
//     required VoidCallback onTap,
//   }) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           height: 28, // Match container height exactly
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 color: isActive 
//                   ? HexColor('#656FE2')
//                   : Colors.white.withOpacity(0.8),
//                 size: 14, // Much smaller icon to fit
//               ),
//               SizedBox(height: 1), // Minimal spacing
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: isActive 
//                     ? HexColor('#656FE2')
//                     : Colors.white.withOpacity(0.8),
//                   fontSize: 6, // Very small text
//                   fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
//                   letterSpacing: -0.2,
//                   height: 0.8, // Tight line height
//                 ),
//                 maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   IconData _getToolIcon(AiTool tool) {
//     // Map tool names to appropriate icons
//     switch (tool.toolName.toLowerCase()) {
//       case 'imagex':
//         return Icons.image_outlined;
//       case 'flux':
//         return Icons.auto_fix_high;
//       case 'klingai':
//         return Icons.movie_outlined;
//       case 'veo3':
//         return Icons.videocam_outlined;
//       case 'vgen':
//         return Icons.video_library_outlined;
//       case 'speechai':
//         return Icons.record_voice_over;
//       case 'udioai':
//         return Icons.music_note_outlined;
//       case 'kontext restore':
//         return Icons.restore;
//       case 'runwayml':
//         return Icons.play_circle_outline;
//       case 'humanizer':
//         return Icons.person_outline;
//       default:
//         if (tool.isImageTool) return Icons.image_outlined;
//         if (tool.isVideoTool) return Icons.videocam_outlined;
//         if (tool.isAudioTool) return Icons.music_note_outlined;
//         if (tool.isTextTool) return Icons.text_fields;
//         return Icons.extension_outlined;
//     }
//   }
// } 