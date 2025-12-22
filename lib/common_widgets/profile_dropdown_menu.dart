import 'package:OneBrain/common_widgets/common_widgets.dart';
import 'package:OneBrain/services/profile_service.dart';
import 'package:OneBrain/utils/app_constants.dart' as AppConstants;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/profile_page.dart';
import '../common_widgets/hexcolor.dart';
import '../screens/usage_history/usage_history_screen.dart';

class ProfileDropdownMenu extends StatelessWidget {
  final VoidCallback onDismiss;
  final BuildContext mainContext;

  const ProfileDropdownMenu({
    super.key,
    required this.onDismiss,
    required this.mainContext,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 350;

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(isSmallScreen ? 8 : 12),
        constraints: BoxConstraints(maxWidth: isSmallScreen ? 280 : 320),
        decoration: BoxDecoration(
          color: HexColor('#010816'),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: HexColor('#1E293B')),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: HexColor('#1E293B').withOpacity(0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: isSmallScreen ? 28 : 32,
                    height: isSmallScreen ? 28 : 32,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      ProfileService.user?.profileImage?.trim() ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade600,
                                Colors.purple.shade600,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              ProfileService.user?.getFullName.substring(
                                    0,
                                    1,
                                  ) ??
                                  '',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ProfileService.user?.getFullName ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 12 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Close button
                  GestureDetector(
                    onTap: onDismiss,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: isSmallScreen ? 12 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Menu options
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
              child: Column(
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      onDismiss();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    isSmallScreen: isSmallScreen,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings,
                    title: 'Usage History',
                    onTap: () {
                      onDismiss();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UsageHistoryScreen(),
                        ),
                      );
                    },
                    isSmallScreen: isSmallScreen,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.people,
                    title: 'Join Community',
                    onTap: () {
                      onDismiss();
                      launchURL(AppConstants.communityUrl);
                    },
                    isSmallScreen: isSmallScreen,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.support_agent,
                    title: 'Support',
                    onTap: () {
                      onDismiss();
                      launchURL(AppConstants.whatsappUrl);
                    },
                    isSmallScreen: isSmallScreen,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.description,
                    title: 'Release notes',
                    onTap: () {
                      onDismiss();
                      // _showComingSoon(context, 'Release Notes');
                    },
                    isSmallScreen: isSmallScreen,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.policy,
                    title: 'Terms & policies',
                    onTap: () {
                      onDismiss();
                      // _showComingSoon(context, 'Terms & Policies');
                    },
                    isSmallScreen: isSmallScreen,
                    // isLast: true,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.logout,
                    title: 'Sign Out',
                    onTap: () async {
                      onDismiss();
                      // _showComingSoon(context, 'Sign Out');
                      await ProfileService.logOut(context);

                      // _showComingSoon(context, 'Terms & Policies');
                    },
                    isSmallScreen: isSmallScreen,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isSmallScreen,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : (isSmallScreen ? 2 : 4)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8 : 12,
              vertical: isSmallScreen ? 6 : 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.transparent),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 4 : 6),
                  decoration: BoxDecoration(
                    // color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: isSmallScreen ? 12 : 14,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 12 : 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: HexColor('#9CA3AF'),
                  size: isSmallScreen ? 10 : 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
