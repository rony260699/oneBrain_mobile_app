import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../screens/settings/profile_setting_screen.dart';
import '../base/base_stateful_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // UserModel? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ProfileService.getCurrentUser();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700 || screenWidth < 350;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF000000), // Pure black at top
                  Color(0xFF0A0E24), // Deep dark blue
                  Color(0xFF0C1028), // Slightly lighter dark blue
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      HexColor('#6BA2FB'),
                    ),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Text(
                    'Loading profile...',
                    style: TextStyle(
                      color: HexColor('#9CA3AF'),
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF000000), // Pure black at top
                  Color(0xFF0A0E24), // Deep dark blue
                  Color(0xFF0C1028), // Slightly lighter dark blue
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: isSmallScreen ? 48 : 64,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Text(
                      'Failed to load profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        color: HexColor('#1F2937').withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: HexColor('#656FE2')),
                      ),
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: HexColor('#9CA3AF'),
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 24),
                    ElevatedButton.icon(
                      onPressed: _loadUserProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('#6BA2FB'),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 24,
                          vertical: isSmallScreen ? 12 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (ProfileService.user == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF000000), // Pure black at top
                  Color(0xFF0A0E24), // Deep dark blue
                  Color(0xFF0C1028), // Slightly lighter dark blue
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        color: HexColor('#1F2937').withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: HexColor('#656FE2')),
                      ),
                      child: Icon(
                        Icons.person_off_outlined,
                        color: HexColor('#9CA3AF'),
                        size: isSmallScreen ? 48 : 64,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Text(
                      'No user data available',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),
                    Text(
                      'Please sign in again to view your profile',
                      style: TextStyle(
                        color: HexColor('#9CA3AF'),
                        fontSize: isSmallScreen ? 12 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 24),
                    ElevatedButton.icon(
                      onPressed: _loadUserProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor('#6BA2FB'),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 24,
                          vertical: isSmallScreen ? 12 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        'Reload Profile',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else if (ProfileService.user != null) {
      return ProfileSettingScreen();
    }

    return const Center(child: CircularProgressIndicator());
  }
}
