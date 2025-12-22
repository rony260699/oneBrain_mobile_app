import 'package:OneBrain/models/plan_user_model.dart';
import 'package:flutter/material.dart';
import '../../base/base_stateful_state.dart';

class ProfileAvatarSection extends StatelessWidget {
  final UserModel? user;
  final bool isLoading;
  final VoidCallback onImageTap;

  const ProfileAvatarSection({
    super.key,
    required this.user,
    required this.isLoading,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 350;
    final avatarSize = isSmallScreen ? 56.0 : 64.0;

    return Container(
      padding: EdgeInsets.only(
        left: isSmallScreen ? 10 : 10,
        top: isSmallScreen ? 10 : 10,
        bottom: isSmallScreen ? 10 : 13,
        // right intentionally 0
        right: 7,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF000000),
            const Color(0xFF1C1D34).withOpacity(0.62),
          ],
          stops: const [0.9, 1.0],
        ),

        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF52525B), width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // camera icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF10151C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              'assets/icons/cameraIconNew.png',
              width: 20,
              height: 20,
            ),
          ),

          const SizedBox(width: 12),

          // text section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Picture',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Update your profile image',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: isSmallScreen ? 10 : 11,
                  ),
                ),
              ],
            ),
          ),

          // avatar right side
          _buildAvatarSection(avatarSize, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(double avatarSize, bool isSmallScreen) {
    avatarSize = 52;
    if (isLoading) {
      return _buildLoadingAvatar(avatarSize, isSmallScreen);
    }

    return Center(
      child: SizedBox(
        width: avatarSize,
        height: avatarSize,
        child: Stack(
          children: [
            // Avatar circle
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.grey.shade600, Colors.grey.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child:
                    (user?.profileImage?.trim().isNotEmpty ?? false)
                        ? Image.network(
                          user?.profileImage?.trim() ?? '',
                          width: avatarSize,
                          height: avatarSize,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildInitialAvatar(avatarSize);
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
                        )
                        : _buildInitialAvatar(avatarSize),
              ),
            ),

            // Edit button
            Align(
              alignment: Alignment.bottomRight,
              child: Transform.translate(
                offset: const Offset(0, 6), // yaha 6 = 6px niche
                child: GestureDetector(
                  onTap: onImageTap,
                  child: Container(
                    width: 25,
                    height: 25,
                    padding: EdgeInsets.all(isSmallScreen ? 2 : 4),
                    decoration: BoxDecoration(
                      color: HexColor('#1F2937'),
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF52525B), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/icons/imagePickerIcon.png',
                      width: isSmallScreen ? 9 : 12,
                      height: isSmallScreen ? 9 : 12,
                      color: HexColor('#9CA3AF'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingAvatar(double avatarSize, bool isSmallScreen) {
    return Center(
      child: Column(
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.grey.shade600, Colors.grey.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          if (!isSmallScreen) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: null, // Disabled during loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                  child: const Text(
                    'Saving...',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: null, // Disabled during loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor('#9CA3AF'),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ] else ...[
            Text(
              'Uploading...',
              style: TextStyle(color: HexColor('#9CA3AF'), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  String _getInitial(String? name, String? email) {
    if (name != null && name.isNotEmpty) {
      return name.trim().substring(0, 1).toUpperCase();
    }
    if (email != null && email.isNotEmpty) {
      return email.trim().substring(0, 1).toUpperCase();
    }
    return 'U';
  }

  Widget _buildInitialAvatar(double avatarSize) {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.grey.shade600, Colors.grey.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          _getInitial(user?.getFullName, user?.email),
          style: TextStyle(
            color: Colors.white,
            fontSize: avatarSize * 0.375, // Responsive font size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
