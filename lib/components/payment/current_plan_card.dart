// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../models/user_model.dart';
// import '../../models/plan_model.dart';
// import '../../utils/theme_colors.dart';

// class CurrentPlanCard extends StatelessWidget {
//   final UserModel? user;
//   final VoidCallback? onUpgradePressed;
//   final VoidCallback? onManagePressed;

//   const CurrentPlanCard({
//     Key? key,
//     this.user,
//     this.onUpgradePressed,
//     this.onManagePressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (user?.package?.currentPlan == null) {
//       return _buildNoPlanCard();
//     }

//     final currentPlan = user!.package!.currentPlan!;
//     final package = user!.package!;

//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: ThemeColors.cardBackground,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: ThemeColors.cardShadow,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header Section
//           _buildHeader(currentPlan, package),
//           SizedBox(height: 20.h),
          
//           // Plan Details
//           _buildPlanDetails(currentPlan, package),
//           SizedBox(height: 20.h),
          
//           // Usage Section
//           _buildUsageSection(currentPlan, user!),
//           SizedBox(height: 20.h),
          
//           // Features Section
//           _buildFeaturesSection(currentPlan),
//           SizedBox(height: 20.h),
          
//           // Action Buttons
//           _buildActionButtons(),
//         ],
//       ),
//     );
//   }

//   Widget _buildNoPlanCard() {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: ThemeColors.cardBackground,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: ThemeColors.cardShadow,
//       ),
//       child: Column(
//         children: [
//           Icon(
//             Icons.info_outline,
//             size: 48.w,
//             color: ThemeColors.warningColor,
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             'No Active Plan',
//             style: TextStyle(
//               color: ThemeColors.primaryText,
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             'Choose a plan to get started with one_brain',
//             style: TextStyle(
//               color: ThemeColors.secondaryText,
//               fontSize: 14.sp,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method to convert String? to PlanType
//   PlanType _stringToPlanType(String? typeString) {
//     switch (typeString?.toLowerCase()) {
//       case 'premium':
//         return PlanType.premium;
//       case 'legendofai':
//       case 'legend_of_ai':
//         return PlanType.legendOfAi;
//       case 'pro':
//         return PlanType.pro;
//       case 'basic':
//       default:
//         return PlanType.basic;
//     }
//   }

//   Widget _buildHeader(PlanModel currentPlan, UserPackage package) {
//     return Row(
//       children: [
//         // Plan Icon
//         Container(
//           padding: EdgeInsets.all(12.w),
//           decoration: BoxDecoration(
//             gradient: _getPlanGradient(_stringToPlanType(currentPlan.type)),
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           child: Icon(
//             _getPlanIcon(_stringToPlanType(currentPlan.type)),
//             color: Colors.white,
//             size: 24.w,
//           ),
//         ),
//         SizedBox(width: 16.w),
        
//         // Plan Info
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     currentPlan.name,
//                     style: TextStyle(
//                       color: ThemeColors.primaryText,
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   if (currentPlan.badgeText != null) ...[
//                     SizedBox(width: 8.w),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
//                       decoration: BoxDecoration(
//                         color: _getPlanColor(_stringToPlanType(currentPlan.type)),
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Text(
//                         currentPlan.badgeText!,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 10.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//               SizedBox(height: 4.h),
//               Text(
//                 currentPlan.description ?? currentPlan.bestFor ?? 'Your current plan',
//                 style: TextStyle(
//                   color: ThemeColors.secondaryText,
//                   fontSize: 14.sp,
//                 ),
//               ),
//             ],
//           ),
//         ),
        
//         // Status Badge
//         _buildStatusBadge(package),
//       ],
//     );
//   }

//   Widget _buildStatusBadge(UserPackage package) {
//     Color statusColor = ThemeColors.successColor;
//     String statusText = 'Active';
    
//     if (package.isExpired) {
//       statusColor = ThemeColors.errorRed;
//       statusText = 'Expired';
//     } else if (package.isInTrial) {
//       statusColor = ThemeColors.warningColor;
//       statusText = 'Trial';
//     }
    
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//       decoration: BoxDecoration(
//         color: statusColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: statusColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Text(
//         statusText,
//         style: TextStyle(
//           color: statusColor,
//           fontSize: 12.sp,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   Widget _buildPlanDetails(PlanModel currentPlan, UserPackage package) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: ThemeColors.darkCardBackground,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(
//           color: ThemeColors.borderColor,
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           // Price and Interval
//           Row(
//             children: [
//               Text(
//                 currentPlan.isFree ? 'Free' : currentPlan.formattedPrice,
//                 style: TextStyle(
//                   color: ThemeColors.primaryText,
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               if (!currentPlan.isFree) ...[
//                 SizedBox(width: 4.w),
//                 Text(
//                   '/${currentPlan.intervalDisplayText}',
//                   style: TextStyle(
//                     color: ThemeColors.secondaryText,
//                     fontSize: 14.sp,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//           SizedBox(height: 12.h),
          
//           // Next billing date
//           if (!currentPlan.isFree && package.isActive) ...[
//             Row(
//               children: [
//                 Icon(
//                   Icons.schedule,
//                   size: 16.w,
//                   color: ThemeColors.secondaryText,
//                 ),
//                 SizedBox(width: 8.w),
//                 Text(
//                   'Next billing: ${package.formattedRemainingTime}',
//                   style: TextStyle(
//                     color: ThemeColors.secondaryText,
//                     fontSize: 12.sp,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildUsageSection(PlanModel currentPlan, UserModel user) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Usage This Month',
//           style: TextStyle(
//             color: ThemeColors.primaryText,
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         SizedBox(height: 12.h),
        
//         // Messages Usage
//         _buildUsageItem(
//           'Messages',
//           Icons.chat,
//           user.usage.messagesUsed,
//           currentPlan.messageLimit ?? 0,
//           currentPlan.hasUnlimitedMessages,
//           ThemeColors.primaryBlue,
//         ),
//         SizedBox(height: 12.h),
        
//         // Images Usage
//         _buildUsageItem(
//           'Images',
//           Icons.image,
//           user.usage.imagesUsed,
//           currentPlan.imageLimit ?? 0,
//           currentPlan.hasUnlimitedImages,
//           ThemeColors.primaryPurple,
//         ),
//         SizedBox(height: 12.h),
        
//         // Voice Usage
//         _buildUsageItem(
//           'Voice Minutes',
//           Icons.mic,
//           user.usage.voiceMinutesUsed,
//           currentPlan.voiceLimit ?? 0,
//           currentPlan.hasUnlimitedVoice,
//           ThemeColors.primaryCyan,
//         ),
//       ],
//     );
//   }

//   Widget _buildUsageItem(
//     String title,
//     IconData icon,
//     int used,
//     int limit,
//     bool isUnlimited,
//     Color color,
//   ) {
//     double progress = 0.0;
//     String usageText = '';
    
//     if (isUnlimited) {
//       usageText = '$used / Unlimited';
//       progress = 0.0;
//     } else if (limit > 0) {
//       progress = (used / limit).clamp(0.0, 1.0);
//       usageText = '$used / $limit';
//     } else {
//       usageText = '$used / 0';
//       progress = 1.0;
//     }
    
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: ThemeColors.darkCardBackground,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: color.withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 icon,
//                 color: color,
//                 size: 16.w,
//               ),
//               SizedBox(width: 8.w),
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: ThemeColors.primaryText,
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Spacer(),
//               Text(
//                 usageText,
//                 style: TextStyle(
//                   color: ThemeColors.secondaryText,
//                   fontSize: 12.sp,
//                 ),
//               ),
//             ],
//           ),
//           if (!isUnlimited) ...[
//             SizedBox(height: 8.h),
//             LinearProgressIndicator(
//               value: progress,
//               backgroundColor: color.withOpacity(0.1),
//               valueColor: AlwaysStoppedAnimation<Color>(color),
//               minHeight: 4.h,
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildFeaturesSection(PlanModel currentPlan) {
//     final features = currentPlan.features?.take(4).toList() ?? [];
    
//     if (features.isEmpty) {
//       return SizedBox.shrink();
//     }
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Included Features',
//           style: TextStyle(
//             color: ThemeColors.primaryText,
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         SizedBox(height: 12.h),
        
//         ...features.map((feature) => Padding(
//           padding: EdgeInsets.only(bottom: 8.h),
//           child: Row(
//             children: [
//               Container(
//                 width: 16.w,
//                 height: 16.w,
//                 decoration: BoxDecoration(
//                   color: ThemeColors.successColor,
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//                 child: Icon(
//                   Icons.check,
//                   color: Colors.white,
//                   size: 12.w,
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Text(
//                   feature.toString(),
//                   style: TextStyle(
//                     color: ThemeColors.secondaryText,
//                     fontSize: 13.sp,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )),
//       ],
//     );
//   }

//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         // Upgrade Button
//         if (onUpgradePressed != null) ...[
//           Expanded(
//             child: ElevatedButton(
//               onPressed: onUpgradePressed,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ThemeColors.primaryBlue,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 12.h),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//               ),
//               child: Text(
//                 'Upgrade Plan',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 12.w),
//         ],
        
//         // Manage Button
//         if (onManagePressed != null) ...[
//           Expanded(
//             child: OutlinedButton(
//               onPressed: onManagePressed,
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: ThemeColors.primaryText,
//                 side: BorderSide(color: ThemeColors.borderColor),
//                 padding: EdgeInsets.symmetric(vertical: 12.h),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//               ),
//               child: Text(
//                 'Manage Plan',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   Color _getPlanColor(PlanType type) {
//     switch (type) {
//       case PlanType.premium:
//         return ThemeColors.premiumPlanColor;
//       case PlanType.legendOfAi:
//         return ThemeColors.legendPlanColor;
//       case PlanType.pro:
//         return ThemeColors.proPlanColor;
//       case PlanType.basic:
//         return ThemeColors.basicPlanColor;
//       default:
//         return ThemeColors.basicPlanColor;
//     }
//   }

//   LinearGradient _getPlanGradient(PlanType type) {
//     switch (type) {
//       case PlanType.premium:
//         return ThemeColors.premiumPlanGradient;
//       case PlanType.legendOfAi:
//         return ThemeColors.legendPlanGradient;
//       case PlanType.pro:
//         return ThemeColors.proPlanGradient;
//       case PlanType.basic:
//         return ThemeColors.basicPlanGradient;
//       default:
//         return ThemeColors.basicPlanGradient;
//     }
//   }

//   IconData _getPlanIcon(PlanType type) {
//     switch (type) {
//       case PlanType.premium:
//         return Icons.diamond;
//       case PlanType.legendOfAi:
//         return Icons.auto_awesome;
//       case PlanType.pro:
//         return Icons.bolt;
//       case PlanType.basic:
//         return Icons.star;
//       default:
//         return Icons.star;
//     }
//   }
// } 