import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:OneBrain/common_widgets/common_loader.dart';

import 'package:OneBrain/utils/app_constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:OneBrain/base/base_stateful_state.dart';
import 'package:OneBrain/screens/authentication/login/cubit/login_cubit.dart';
import 'package:OneBrain/screens/authentication/login/cubit/login_state.dart';
import 'package:OneBrain/screens/main_app_wrapper.dart';
import '../../../common_widgets/app_utils.dart';
import '../../../utils/shared_preference_util.dart';
import '../../home/cubit/home_screen_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseStatefulWidgetState<LoginScreen> {
  // Form management
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _scrollController = ScrollController();
  final _emailFocusNode = FocusNode();

  // UI state
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isKeyboardVisible = false;

  @override
  bool get shouldHaveSafeArea => false;

  @override
  bool get resizeToAvoidBottomInset => true;

  @override
  void initState() {
    super.initState();
    // Add focus listener to automatically scroll when email field is focused
    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        setState(() => _isKeyboardVisible = true);
        // Delay scroll to ensure keyboard animation has started
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted && _scrollController.hasClients) {
            // Scroll to position both email and Go button above keyboard with less gap
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent *
                  0.35, // Scroll less to bring Go button closer to keyboard
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      } else {
        setState(() => _isKeyboardVisible = false);
      }
    });
  }

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    _emailController.dispose();
    _scrollController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  /**
   * Handles Google Sign-In functionality
   */
  // Future<void> onTapContinueWithGoogle() async {

  // }

  /**
   * Handles email search/login functionality
   * Validates email format and triggers authentication process
   * Shows spinner immediately when Go button is pressed
   */
  Future<void> _handleEmailSearch() async {
    // Validate email input
    if (_emailController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please enter your email address.');
      return;
    }

    // Email format validation using regex
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      return;
    }

    // Show spinner immediately when Go button is pressed
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Trigger authentication through Cubit
    await context.read<LoginCubit>().loginAPI(
      _emailController.text.trim(),
      context,
      null,
    );

    setState(() => _isLoading = false);
  }

  /**
   * Handles Google Sign-In functionality
   */
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await context.read<LoginCubit>().googleLogin(context);
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocListener<LoginCubit, LoginStates>(
      listener: (context, state) async {
        // Handle authentication state changes
        if (state is LoginSuccessState) {
          // Stop loading and navigate to home screen after successful login

          setState(() => _isLoading = false);

          // RegisterCubit.get(context).clearAll();
          await HomeScreenCubit.get(context).getAllChats();
          GlobalLoader.show();
          pushAndClearStack(context, enterPage: const MainAppWrapper());
          GlobalLoader.hide();

          /// Login ///
          SharedPreferenceUtil.putBool(isLoginKey, true);

          // push(context, enterPage: const MainAppWrapper());
        } else if (state is LoginErrorState) {
          // Stop loading and display error message
          setState(() {
            _isLoading = false;
            _errorMessage = state.errorMsg;
          });
        } else if (state is LoginNewAccountState) {
          // Stop loading and display error for account not found instead of navigating to signup
          setState(() {
            _isLoading = false;
            _errorMessage = 'Account not found. Please contact support.';
          });
        }
        // Keep loading state active for LoginLoadingState to show spinner
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1E2139),
        resizeToAvoidBottomInset: true, // Enable resizing when keyboard appears
        body: Stack(
          children: [
            // Background with gradient matching splash screen
            _buildBackground(),

            // Main content overlay - Keyboard-friendly layout
            SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics:
                    _isKeyboardVisible
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                // Disable manual scrolling only when keyboard is visible
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        MediaQuery.of(
                          context,
                        ).viewInsets.bottom, // Account for keyboard
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 120,
                        ), // Original space for top area
                        // OneBrain Logo (same as splash screen) - FULL SIZE PRESERVED
                        _buildOneBrainLogo(),

                        // "Multiverse of AI" title (same styling as splash screen) - FULL SIZE PRESERVED
                        _buildMultiverseTitle(),

                        const SizedBox(height: 48),

                        // Google Sign-In Button - FULL SIZE PRESERVED
                        _buildGoogleSignInButton(),

                        // Apple Sign-In Button (iOS only) - FULL SIZE PRESERVED
                        if (Platform.isIOS && false) ...[
                          const SizedBox(height: 16),
                          _buildAppleSignInButton(),
                        ],

                        const SizedBox(height: 32),

                        // Divider with "or" text - FULL SIZE PRESERVED
                        _buildDivider(),

                        const SizedBox(height: 32),

                        // Email input form with Go button directly underneath - ORIGINAL DESIGN
                        _buildEmailForm(),

                        // Error message display - FULL SIZE PRESERVED
                        if (_errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildErrorMessage(),
                        ],

                        const SizedBox(height: 60), // Extra space before footer
                        // Terms & Privacy Policy - PRESERVED
                        _buildTermsAndPrivacy(),

                        const SizedBox(height: 16),

                        // About Us section - PRESERVED
                        _buildAboutUs(),

                        const SizedBox(
                          height: 80,
                        ), // Moderate space to allow scrolling Go button above keyboard
                      ],
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

  /**
   * Builds the background with OneBrain header image and gradient
   * Matches the design from OneBrain web app staging branch
   */
  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // Same dark blue gradient as chat screen background for consistency
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
      child: Stack(
        children: [
          // OneBrain header image from web app staging branch - Full display with zoom out
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 320, // Increased height to show more of the image
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Pasted Graphic.png'),
                  fit: BoxFit.contain, // Changed to contain to show full image
                  alignment:
                      Alignment
                          .topCenter, // Align to top to show header properly
                ),
              ),
              // Light gradient overlay to make header image more visible
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      const Color(0xFF000000).withOpacity(0.2),
                      const Color(0xFF000000).withOpacity(0.6),
                    ],
                    stops: const [0.0, 0.5, 0.7, 0.9, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Builds the OneBrain logo widget (same as splash screen)
   * Uses the same asset as splash screen: ic_app_logo.png
   */
  Widget _buildOneBrainLogo() {
    return Image.asset(
      'assets/images/ic_app_logo.png',
      width: 280,
      height: 85,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback text if image fails to load
        return const Text(
          'OneBrain',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    );
  }

  /// Builds the "Multiverse of AI" title with gradient text (same as splash screen)
  Widget _buildMultiverseTitle() {
    return ShaderMask(
      shaderCallback:
          (bounds) => const LinearGradient(
            colors: [
              Color(0xFF6366F1), // Indigo
              Color(0xFF8B5CF6), // Violet
              Color(0xFFEC4899), // Pink
              Color(0xFFF59E0B), // Amber
            ],
          ).createShader(bounds),
      child: const Text(
        'Multiverse of AI',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Builds the Google Sign-In button with beautiful capsule styling
  Widget _buildGoogleSignInButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF8F9FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28), // Capsule shape (height/2)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _handleGoogleSignIn,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/ic_google_icon.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E2139),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /**
   * Builds the Apple Sign-In button for iOS with beautiful capsule styling
   */
  Widget _buildAppleSignInButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1C1C1E), Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28), // Capsule shape (height/2)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              _isLoading
                  ? null
                  : () {
                    // Handle Apple Sign-In
                    // TODO: Implement Apple Sign-In functionality
                    showSuccess(
                      message:
                          'Apple Sign-In functionality will be implemented',
                    );
                  },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/ic_apple_icon.png',
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Continue with Apple',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /**
   * Builds the divider with "or" text
   */
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: Colors.white.withOpacity(0.3)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: Colors.white.withOpacity(0.3)),
        ),
      ],
    );
  }

  /**
   * Builds the email input form with Go button directly underneath - ORIGINAL DESIGN
   */
  Widget _buildEmailForm() {
    return Column(
      children: [
        // Email input field
        TextFormField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          keyboardAppearance: Brightness.dark,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 16,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email address';
            }
            final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
            if (!emailRegex.hasMatch(value.trim())) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),

        const SizedBox(height: 24),

        // Go button directly under email field - ORIGINAL POSITION
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4285F4), // Beautiful blue (Google Blue)
                Color(0xFF1E88E5), // Deeper blue
                Color(0xFF1976D2), // Rich blue
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(28), // Perfect capsule shape
            boxShadow: [
              // Main shadow with blue glow
              BoxShadow(
                color: const Color(0xFF4285F4).withOpacity(0.4),
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
              // Subtle inner highlight
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isLoading ? null : _handleEmailSearch,
              borderRadius: BorderRadius.circular(28),
              splashColor: Colors.white.withOpacity(0.2),
              highlightColor: Colors.white.withOpacity(0.1),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                          : const Text(
                            'Go',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              fontFamily: 'Roboto',
                            ),
                          ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /**
   * Builds the error message display
   */
  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade300, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage,
              style: TextStyle(color: Colors.red.shade300, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * Builds the terms and privacy policy section
   */
  Widget _buildTermsAndPrivacy() {
    return Text(
      'By continuing, you agree to our Terms of Service and Privacy Policy',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
    );
  }

  /**
   * Builds the DIGITX logo in footer section
   */
  Widget _buildAboutUs() {
    return Image.asset(
      'assets/images/DIGITX White.png',
      width: 100,
      height: 32,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback text if image fails to load
        return Text(
          'DIGITX',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}
