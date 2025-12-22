// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gradient_borders/box_borders/gradient_box_border.dart';
// import '../../../base/base_stateful_state.dart';
// import '../../../common_widgets/common_widgets.dart';
// import '../../../resources/color.dart';
// import '../../../resources/image.dart';
// import '../../side_menu/model/ai_list_model.dart';
// import '../../../main.dart';

// class AiToolListView extends StatefulWidget {
//   final List<AiTool> tools;
//   final Function(AiTool)? onToolTap;
//   final Function(AiTool, bool)? onToolToggle;

//   const AiToolListView({
//     Key? key,
//     required this.tools,
//     this.onToolTap,
//     this.onToolToggle,
//   }) : super(key: key);

//   @override
//   State<AiToolListView> createState() => _AiToolListViewState();
// }

// class _AiToolListViewState extends State<AiToolListView> {
//   List<AiTool> filteredTools = [];
//   String searchQuery = "";
//   String selectedCategory = "All";

//   @override
//   void initState() {
//     super.initState();
//     filteredTools = widget.tools;
//   }

//   @override
//   void didUpdateWidget(AiToolListView oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.tools != widget.tools) {
//       _filterTools();
//     }
//   }

//   void _filterTools() {
//     setState(() {
//       filteredTools =
//           widget.tools.where((tool) {
//             bool matchesSearch =
//                 searchQuery.isEmpty ||
//                 tool.toolName.toLowerCase().contains(
//                   searchQuery.toLowerCase(),
//                 ) ||
//                 tool.description.toLowerCase().contains(
//                   searchQuery.toLowerCase(),
//                 ) ||
//                 tool.capabilities.any(
//                   (capability) => capability.toLowerCase().contains(
//                     searchQuery.toLowerCase(),
//                   ),
//                 );

//             bool matchesCategory =
//                 selectedCategory == "All" ||
//                 tool.capabilities.contains(selectedCategory.toLowerCase()) ||
//                 tool.category == selectedCategory;

//             return matchesSearch && matchesCategory;
//           }).toList();
//     });
//   }

//   void _onSearchChanged(String query) {
//     searchQuery = query;
//     _filterTools();
//   }

//   void _onCategoryChanged(String category) {
//     selectedCategory = category;
//     _filterTools();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Search and Filter Section
//         _buildSearchAndFilter(),

//         // Active Tools Counter
//         if (activeAiTools.isNotEmpty) _buildActiveToolsHeader(),

//         // Tools Grid
//         Expanded(child: _buildToolsGrid()),
//       ],
//     );
//   }

//   Widget _buildSearchAndFilter() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//       child: Column(
//         children: [
//           // Search Bar
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12.r),
//               color: AppColors.textFieldBackgroundColor,
//               border: Border.all(color: AppColors.borderColor.withOpacity(0.3)),
//             ),
//             child: TextField(
//               onChanged: _onSearchChanged,
//               style: TextStyle(color: AppColors.whiteColor, fontSize: 14.sp),
//               decoration: InputDecoration(
//                 hintText: "Search AI tools...",
//                 hintStyle: TextStyle(
//                   color: AppColors.greyColor,
//                   fontSize: 14.sp,
//                 ),
//                 prefixIcon: Icon(
//                   Icons.search,
//                   color: AppColors.greyColor,
//                   size: 20.w,
//                 ),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 16.w,
//                   vertical: 12.h,
//                 ),
//               ),
//             ),
//           ),

//           SizedBox(height: 12.h),

//           // Category Filter
//           _buildCategoryFilter(),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryFilter() {
//     List<String> categories = [
//       "All",
//       "Image",
//       "Video",
//       "Audio",
//       "Text",
//       "Voice",
//       "Music",
//     ];

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children:
//             categories.map((category) {
//               bool isSelected = selectedCategory == category;
//               return GestureDetector(
//                 onTap: () => _onCategoryChanged(category),
//                 child: Container(
//                   margin: EdgeInsets.only(right: 8.w),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 16.w,
//                     vertical: 8.h,
//                   ),
//                   decoration: BoxDecoration(
//                     // borderRadius: BorderRadius.circular(20.r),
//                     color:
//                         isSelected
//                             ? AppColors.primaryColor
//                             : AppColors.textFieldBackgroundColor,
//                     border: Border.all(
//                       color:
//                           isSelected
//                               ? AppColors.primaryColor
//                               : AppColors.borderColor.withOpacity(0.3),
//                     ),
//                   ),
//                   child: Text(
//                     category,
//                     style: TextStyle(
//                       color:
//                           isSelected
//                               ? AppColors.whiteColor
//                               : AppColors.greyColor,
//                       fontSize: 12.sp,
//                       fontWeight:
//                           isSelected ? FontWeight.w600 : FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//       ),
//     );
//   }

//   Widget _buildActiveToolsHeader() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.r),
//         color: Colors.white.withOpacity(0.05),
//         border: Border.all(color: Colors.white.withOpacity(0.2)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 20.w,
//             height: 20.w,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 colors: [
//                   HexColor('#A855F7'),
//                   HexColor('#3B82F6'),
//                   HexColor('#06B6D4'),
//                 ],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//             ),
//             child: Icon(Icons.check_circle, color: Colors.white, size: 16.w),
//           ),
//           SizedBox(width: 8.w),
//           Text(
//             "${activeAiTools.length}/3 AI Tools Active",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Spacer(),
//           if (activeAiTools.length == 3)
//             Text(
//               "Maximum reached",
//               style: TextStyle(color: HexColor('#CCCCCC'), fontSize: 12.sp),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildToolsGrid() {
//     if (filteredTools.isEmpty) {
//       return _buildEmptyState();
//     }

//     return GridView.builder(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12.w,
//         mainAxisSpacing: 12.h,
//         childAspectRatio: 0.85,
//       ),
//       itemCount: filteredTools.length,
//       itemBuilder: (context, index) {
//         return _buildToolCard(filteredTools[index]);
//       },
//     );
//   }

//   Widget _buildToolCard(AiTool tool) {
//     bool isActive = activeAiTools.any(
//       (activeTool) => activeTool.toolName == tool.toolName,
//     );
//     bool canActivate = activeAiTools.length < 3 || isActive;

//     return GestureDetector(
//       onTap: () {
//         if (widget.onToolTap != null) {
//           widget.onToolTap!(tool);
//         }
//       },
//       child: Container(
//         decoration:
//             isActive
//                 ? BoxDecoration(
//                   border: GradientBoxBorder(
//                     gradient: LinearGradient(
//                       colors: [
//                         HexColor('#A855F7'),
//                         HexColor('#3B82F6'),
//                         HexColor('#06B6D4'),
//                       ],
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                     ),
//                     width: 2,
//                   ),
//                   borderRadius: BorderRadius.circular(16.r),
//                   color: Colors.white.withOpacity(0.05),
//                   boxShadow: [
//                     // Subtle glow effect only - 5% opacity
//                     BoxShadow(
//                       color: HexColor('#3B82F6').withOpacity(0.05),
//                       blurRadius: 20,
//                       offset: Offset(0, 0),
//                       spreadRadius: 0,
//                     ),
//                     BoxShadow(
//                       color: HexColor('#A855F7').withOpacity(0.05),
//                       blurRadius: 15,
//                       offset: Offset(0, 0),
//                       spreadRadius: 0,
//                     ),
//                   ],
//                 )
//                 : BoxDecoration(
//                   borderRadius: BorderRadius.circular(16.r),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.2),
//                     width: 1,
//                   ),
//                   color: Colors.white.withOpacity(0.05),
//                 ),
//         child: Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header with icon and toggle
//               Row(
//                 children: [
//                   // Tool Icon
//                   Container(
//                     width: 40.w,
//                     height: 40.w,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.r),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Text(
//                         tool.categoryIcon,
//                         style: TextStyle(fontSize: 20.sp),
//                       ),
//                     ),
//                   ),

//                   Spacer(),

//                   // Toggle Switch
//                   GestureDetector(
//                     onTap:
//                         canActivate
//                             ? () {
//                               if (widget.onToolToggle != null) {
//                                 widget.onToolToggle!(tool, !isActive);
//                               }
//                             }
//                             : null,
//                     child: Container(
//                       width: 44.w,
//                       height: 24.h,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12.r),
//                         gradient:
//                             isActive
//                                 ? LinearGradient(
//                                   colors: [
//                                     HexColor('#A855F7'),
//                                     HexColor('#3B82F6'),
//                                     HexColor('#06B6D4'),
//                                   ],
//                                   begin: Alignment.centerLeft,
//                                   end: Alignment.centerRight,
//                                 )
//                                 : null,
//                         color:
//                             isActive
//                                 ? null
//                                 : canActivate
//                                 ? Colors.white.withOpacity(0.2)
//                                 : Colors.white.withOpacity(0.1),
//                         border:
//                             !isActive
//                                 ? Border.all(
//                                   color: Colors.white.withOpacity(0.3),
//                                   width: 1,
//                                 )
//                                 : null,
//                       ),
//                       child: AnimatedAlign(
//                         duration: Duration(milliseconds: 200),
//                         curve: Curves.easeInOut,
//                         alignment:
//                             isActive
//                                 ? Alignment.centerRight
//                                 : Alignment.centerLeft,
//                         child: Container(
//                           width: 20.w,
//                           height: 20.h,
//                           margin: EdgeInsets.all(2.w),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 blurRadius: 4,
//                                 offset: Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               SizedBox(height: 12.h),

//               // Tool Name with badges
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       tool.toolName,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w700,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   if (tool.isNew) ...[
//                     SizedBox(width: 4.w),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 6.w,
//                         vertical: 2.h,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(4.r),
//                         gradient: LinearGradient(
//                           colors: [
//                             HexColor('#A855F7'),
//                             HexColor('#3B82F6'),
//                             HexColor('#06B6D4'),
//                           ],
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ),
//                       ),
//                       child: Text(
//                         "NEW",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 8.sp,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ],
//                   if (tool.isPro) ...[
//                     SizedBox(width: 4.w),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 6.w,
//                         vertical: 2.h,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(4.r),
//                         color: Colors.amber,
//                       ),
//                       child: Text(
//                         "PRO",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 8.sp,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),

//               SizedBox(height: 8.h),

//               // Description
//               Expanded(
//                 child: Text(
//                   tool.description,
//                   style: TextStyle(
//                     color: HexColor('#CCCCCC'),
//                     fontSize: 12.sp,
//                     height: 1.3,
//                   ),
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),

//               SizedBox(height: 8.h),

//               // Tags
//               Wrap(
//                 spacing: 4.w,
//                 runSpacing: 4.h,
//                 children:
//                     tool.tags.take(2).map((tag) {
//                       return Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 6.w,
//                           vertical: 2.h,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4.r),
//                           color: Colors.white.withOpacity(0.1),
//                         ),
//                         child: Text(
//                           tag,
//                           style: TextStyle(
//                             color: HexColor('#CCCCCC'),
//                             fontSize: 10.sp,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.search_off,
//             size: 64.w,
//             color: Colors.white.withOpacity(0.3),
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             "No AI tools found",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             "Try adjusting your search or filter",
//             style: TextStyle(color: HexColor('#CCCCCC'), fontSize: 14.sp),
//           ),
//         ],
//       ),
//     );
//   }
// }
