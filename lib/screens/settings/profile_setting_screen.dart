import 'package:OneBrain/common_widgets/app_utils.dart';
import 'package:OneBrain/common_widgets/text_widget.dart';
import 'package:OneBrain/screens/payment_billing/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../base/base_stateful_state.dart';
import '../../profile/widgets/profile_avatar_section.dart';
import '../../resources/color.dart';
import '../../services/profile_service.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  // late UserModel _currentUser;
  bool _isEditingPhone = false;
  bool _isLoading = false;
  bool _isImageLoading = false;

  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Handle keyboard appearance
    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _scrollToPhoneSection();
        });
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToPhoneSection() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent * 0.6,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _handleImageSelection() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _isImageLoading = true;
        });

        final bool? isUpdated = await ProfileService.updateProfileImage(image);

        setState(() {
          _isImageLoading = false;
        });
        if (isUpdated == true) {
          _showSuccessSnackBar('Profile image updated successfully');
        }
      }
    } catch (e) {
      setState(() {
        _isImageLoading = false;
      });
      _showErrorSnackBar('Failed to update profile image: ${e.toString()}');
    }
  }

  Future<void> _handlePhoneSave() async {
    if (_phoneController.text.trim() == ProfileService.phone) {
      setState(() {
        _isEditingPhone = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ProfileService.updateProfile(_phoneController.text.trim());

      setState(() {
        _isEditingPhone = false;
        _isLoading = false;
      });

      _showSuccessSnackBar('Phone number updated successfully');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to update phone number: ${e.toString()}');
    }
  }

  void _handlePhoneCancel() {
    _phoneController.text = ProfileService.phone ?? '';
    setState(() {
      _isEditingPhone = false;
    });
  }

  Future<void> _handleDeleteAccount() async {
    final bool? confirmed = await _showDeleteAccountDialog();
    if (confirmed == true) {
      try {
        await ProfileService.deleteAccount(context);
      } catch (e) {
        _showErrorSnackBar('Failed to delete account: ${e.toString()}');
      }
    }
  }

  Future<bool?> _showDeleteAccountDialog() async {
    return await showCupertinoDialogBox(
      context,
      "Are you sure want to delete your account?",
      isShowCancel: true,
      okText: "Delete",
      (context) async {
        Navigator.pop(context, true);
        // await SharedPreferenceUtil.clear();
        // await GoogleSignIn().signOut();
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => const LoginScreen()),
        //   (route) => false,
        // );
      },
      cancelText: "Cancel",
    );

    // return showDialog<bool>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       backgroundColor: color323337,
    //       title: const Text(
    //         'Delete Account',
    //         // style: TextStyle(color: color0B0B40),
    //       ),
    //       content: const Text(
    //         'Are you sure you want to delete your account? This action cannot be undone.',
    //         // style: TextStyle(color: color9E9E9E),
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.of(context).pop(false),
    //           child: const Text('Cancel'),
    //         ),
    //         TextButton(
    //           onPressed: () => Navigator.of(context).pop(true),
    //           style: TextButton.styleFrom(foregroundColor: Colors.red),
    //           child: const Text('Delete'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700 || screenWidth < 350;

    print("ProfileService.user: ${ProfileService.user}");

    return Scaffold(
      backgroundColor: Color(0xFF000000),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF000000),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, color: HexColor('#FFFFFF')),
        ),
        title: TextWidget(
          text: 'Account Settings',
          fontSize: 28.sp,
          color: appBarTitleColor,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
        ),
      ),
      // Color(0xA01C1D34) // Bottom dark color with 62.7% opacity
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF000000), // Top pure black

                Color(0xFF1C1D34).withOpacity(0.62),
              ],
              stops: [0.7, 1.0],
            ),
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 10, // Left & right padding
              vertical: 2, // Top & bottom padding 0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            'Manage your account preferences and security settings',
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: isSmallScreen ? 10 : 12,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isSmallScreen ? 24 : 32),

                // Account Information Card
                _buildAccountInformationCard(isSmallScreen),

                SizedBox(height: isSmallScreen ? 16 : 24),

                // System Settings Card
                _buildSystemSettingsCard(isSmallScreen),

                // Add bottom padding for better scrolling experience
                SizedBox(height: isSmallScreen ? 20 : 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountInformationCard(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF52525B), width: 0.4),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              left: isSmallScreen ? 12 : 16,
              right: isSmallScreen ? 12 : 16,
              top: isSmallScreen ? 12 : 12,
              bottom: isSmallScreen ? 12 : 16,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Account Information',
                  style: TextStyle(
                    color: HexColor('#FFFFFF'),
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.only(
              left: isSmallScreen ? 12 : 14,
              right: isSmallScreen ? 12 : 14,
              // top: isSmallScreen ? 6 : 8,
              bottom: isSmallScreen ? 8 : 10,
            ),
            child: Column(
              children: [
                // Profile Picture Section
                ProfileAvatarSection(
                  user: ProfileService.user,
                  isLoading: _isImageLoading,
                  onImageTap: _handleImageSelection,
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                // Email Section
                _buildProfileInfoCard(
                  icon: Icons.email_outlined,
                  iconColor: Colors.white,
                  title: 'Email Address',
                  subtitle: 'Your primary email for notifications',
                  value: ProfileService.user?.email ?? "",
                  isEditable: false,
                  isSmallScreen: isSmallScreen,
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                // Phone Section
                _buildPhoneSection(isSmallScreen),

                SizedBox(height: isSmallScreen ? 12 : 16),

                // Subscription Section (if user has a package)
                if (ProfileService.user?.package != null)
                  _buildProfileInfoCard(
                    icon: Icons.card_membership,
                    iconColor: Colors.white,
                    title: 'Subscription',
                    subtitle: 'Manage your billing and plan',
                    value:
                        ProfileService.user?.package!.currentPlan?.name ?? "",
                    isEditable: false,
                    isSmallScreen: isSmallScreen,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildProfileAvatarSection() {
  //   return Row(
  //     children: [
  //       Stack(
  //         children: [
  //           CircleAvatar(
  //             radius: 30,
  //             backgroundColor: colorPrimary,
  //             backgroundImage:
  //                 _profileService.user?.profileImage != null
  //                     ? NetworkImage(_profileService.user!.profileImage!)
  //                     : null,
  //             child:
  //                 _profileService.user?.profileImage == null
  //                     ? Text(
  //                       _getInitial(
  //                         _profileService.user?.firstName,
  //                         _profileService.user?.email,
  //                       ),
  //                       style: const TextStyle(
  //                         fontSize: 24,
  //                         fontWeight: FontWeight.bold,
  //                         color: color0B0B40,
  //                       ),
  //                     )
  //                     : null,
  //           ),
  //           if (_isImageLoading)
  //             const CircleAvatar(
  //               radius: 30,
  //               backgroundColor: Colors.black54,
  //               child: CircularProgressIndicator(
  //                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  //               ),
  //             ),
  //           Positioned(
  //             bottom: 0,
  //             right: 0,
  //             child: GestureDetector(
  //               onTap: _handleImageSelection,
  //               child: Container(
  //                 padding: const EdgeInsets.all(4),
  //                 decoration: const BoxDecoration(
  //                   color: Colors.blue,
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: const Icon(
  //                   Icons.camera_alt,
  //                   color: Colors.white,
  //                   size: 16,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(width: 16),
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               _currentUser.firstName ?? 'No name set',
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             Text(
  //               _currentUser.email!,
  //               style: TextStyle(color: HexColor('#9CA3AF'), fontSize: 14),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildProfileInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String value,
    required bool isEditable,
    required bool isSmallScreen,
  }) {
    return Container(
      padding:
          (title == 'Subscription')
              ? EdgeInsets.only(
                left: isSmallScreen ? 10 : 10,
                top: isSmallScreen ? 12 : 17,
                bottom: isSmallScreen ? 12 : 17,
                right: 5,
              )
              : EdgeInsets.only(
                left: isSmallScreen ? 10 : 10,
                top: isSmallScreen ? 10 : 10,
                bottom: isSmallScreen ? 10 : 10,
                right: 5,
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
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF10151C),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                (title == 'Subscription')
                    ? Image.asset(
                      'assets/icons/subscriptionIconOne.png',
                      width: 20,
                      height: 20,
                    )
                    : Image.asset(
                      'assets/icons/mailIcon.png', // <-- msg icon
                      width: 20,
                      height: 20,
                    ),
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: HexColor('#FFFFFF'),
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: HexColor('#9CA3AF'),
                    fontSize: isSmallScreen ? 10 : 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                // Only show value if not Subscription
                if (title != 'Subscription') ...[
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: HexColor('#FFFFFF'),
                      fontSize: isSmallScreen ? 12 : 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ],
            ),
          ),

          // Edit icon (if editable)
          if (isEditable)
            Icon(Icons.edit, color: HexColor('#9CA3AF'), size: 20),

          // Learn More button only for Subscription card
          if (title == 'Subscription') SizedBox(width: 8), // Optional gap
          if (title == 'Subscription')
            ElevatedButton(
              onPressed: () {
                // Button action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF111827), // Button background
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6), // Border radius 12
                  side: const BorderSide(
                    color: Color(0xFF52525B),
                    width: 1,
                  ), // Border color
                ),
                minimumSize: Size(
                  0,
                  isSmallScreen ? 26 : 28,
                ), // <-- dynamic height

                padding: EdgeInsets.symmetric(
                  horizontal:
                      isSmallScreen ? 4 : 6, // <- Reduce horizontal padding
                  vertical: 0,
                ),
                // minimumSize: const Size(
                //   28,
                //   28,
                // ),
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // <-- default 48dp height
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Learn More',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 12,
                      color: Color(0xFF9CA3AF), // <-- text color
                    ),
                  ),
                  SizedBox(width: 4),
                  Image.asset(
                    'assets/icons/arrowIcon.png',
                    width: isSmallScreen ? 14 : 16,
                    height: isSmallScreen ? 14 : 16,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhoneSection(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.only(
        left: isSmallScreen ? 10 : 10,
        top: isSmallScreen ? 10 : 10,
        bottom: isSmallScreen ? 0 : 0,
        // right intentionally 0
        right: 0,
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
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),

                decoration: BoxDecoration(
                  color: Color(0xFF10151C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  'assets/icons/callIcon.png', // <--  path
                  width: 20,
                  height: 20,
                  // color: Colors.white,  //
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        color: HexColor('#FFFFFF'),
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'For account recovery and notifications',
                      style: TextStyle(
                        color: HexColor('#9CA3AF'),
                        fontSize: isSmallScreen ? 10 : 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!_isEditingPhone) ...[
                      // SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            ProfileService.user?.phone ?? 'Not set',
                            style: TextStyle(
                              color: HexColor('#FFFFFF'),
                              fontSize: isSmallScreen ? 11 : 13,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          IconButton(
                            onPressed: () {
                              _phoneController.text =
                                  ProfileService.phone ?? '';
                              setState(() {
                                _isEditingPhone = true;
                              });
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () => _phoneFocusNode.requestFocus(),
                              );
                            },
                            icon: Image.asset(
                              'assets/icons/phoneIcon.png',
                              width: 13,
                              height: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: isSmallScreen ? 6 : 8),

          if (_isEditingPhone) ...[
            TextField(
              controller: _phoneController,
              focusNode: _phoneFocusNode,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                hintStyle: TextStyle(color: HexColor('#9CA3AF')),
                filled: true,
                fillColor: HexColor('#1F2937'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: HexColor('#656FE2')),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: HexColor('#656FE2')),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                  vertical: isSmallScreen ? 10 : 12,
                ),
              ),
              style: TextStyle(color: HexColor('#FFFFFF')),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handlePhoneSave(),
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : _handlePhoneCancel,
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: HexColor('#9CA3AF')),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handlePhoneSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 16,
                      vertical: isSmallScreen ? 8 : 12,
                    ),
                  ),
                  child:
                      _isLoading
                          ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Text(
                            'Save Changes',
                            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                          ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSystemSettingsCard(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF52525B), width: 0.4),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF000000), // top pure black
            Color(0xA11C1D34).withOpacity(0.26), // bottom dark with opacity
          ],
          stops: [0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              left: isSmallScreen ? 12 : 16,
              right: isSmallScreen ? 12 : 16,
              top: isSmallScreen ? 12 : 12,
              bottom: isSmallScreen ? 12 : 16,
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'System Settings',
                  style: TextStyle(
                    color: HexColor('#FFFFFF'),
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.only(
              left: isSmallScreen ? 12 : 14,
              right: isSmallScreen ? 12 : 14,
              top: isSmallScreen ? 0 : 0,
              bottom: isSmallScreen ? 8 : 10,
            ),

            child: Column(
              children: [
                // Active Account
                _buildSystemSettingItem(
                  iconWidget: Image.asset(
                    'assets/icons/activeSessionIcon.png',
                    width: 20,
                    height: 20,
                    // color: Colors.white,
                  ),
                  iconColor: Colors.white,
                  iconBgColor: Color(0xFF10151C),
                  title: 'Active Account',
                  subtitle:
                      'You are signed in as ${ProfileService.user?.getFullName ?? ProfileService.user?.email}',
                  actionWidget: ElevatedButton(
                    onPressed: () async {
                      await ProfileService.logOut(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(0, isSmallScreen ? 20 : 28),
                      backgroundColor: Color(0xFF111827),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 10 : 10,

                        //  vertical: isSmallScreen ? 4 : 6, // Vertical padding kam kiya
                      ),
                      side: BorderSide(color: Color(0xFF52525B), width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'Sign out',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 10 : 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                  isSmallScreen: isSmallScreen,
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                _buildSystemSettingItem(
                  iconWidget: Image.asset(
                    'assets/icons/logoutIcon.png',
                    width: 20,
                    height: 20,
                    // color: Colors.white,  <-- हटाओ इसे
                  ),

                  iconColor: Colors.white,
                  iconBgColor: Color(0xFF10151C),
                  title: 'Active Sessions',
                  subtitle: 'Devices or browsers\nwhere you are signed in',
                  actionWidget: ElevatedButton(
                    onPressed: () async {
                      await ProfileService.logOut(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(0, isSmallScreen ? 20 : 28),
                      backgroundColor: Color(0xFF111827),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 10 : 08,
                        // vertical: isSmallScreen ? 8 : 10,
                      ),
                      side: BorderSide(color: Color(0xFF52525B), width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'Sign out of all sessions',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                  isSmallScreen: isSmallScreen,
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                // Delete Account
                _buildSystemSettingItem(
                  iconWidget: Image.asset(
                    'assets/icons/trashIcon.png',
                    width: 20,
                    height: 20,
                  ),
                  iconColor: Colors.white,
                  iconBgColor: Color(0xFF10151C), // Custom background color

                  title: 'Delete Account',
                  subtitle: 'Permanently delete your\naccount and data',
                  actionWidget: ElevatedButton(
                    onPressed: _handleDeleteAccount,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(0, isSmallScreen ? 20 : 28),
                      backgroundColor: Colors.red.withOpacity(0.1),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 10 : 12,

                        // vertical: isSmallScreen ? 8 : 12,
                      ),
                      side: BorderSide(color: Color(0xFF991B1B), width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                  isDestructive: true,
                  isSmallScreen: isSmallScreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSettingItem({
    Widget? iconWidget, // <- use this for Image.asset
    IconData? icon, // make optional
    required Color iconColor,
    Color? iconBgColor, // <- NEW property for background

    required String title,
    required String subtitle,
    required Widget actionWidget,
    bool isDestructive = false,
    required bool isSmallScreen,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: isSmallScreen ? 10 : 10,
        top: isSmallScreen ? 10 : 10,
        bottom: isSmallScreen ? 10 : 10,
        // right intentionally 0
        right: 6,
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
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor ?? iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: iconWidget ?? Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: HexColor('#FFFFFF'),
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: HexColor('#9CA3AF'),
                    fontSize: isSmallScreen ? 10 : 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          // Right-aligned button
          Align(alignment: Alignment.centerRight, child: actionWidget),
        ],
      ),
    );
  }
}
