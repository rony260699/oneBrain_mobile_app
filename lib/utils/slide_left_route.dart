import 'package:flutter/material.dart';

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;

  SlideLeftRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideTween = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.fastOutSlowIn));

      final fadeTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeIn));

      // Add exit animation for the previous page
      final exitSlideTween = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.3, 0.0),
      ).chain(CurveTween(curve: Curves.fastOutSlowIn));

      return Stack(
        children: [
          // Exit animation for previous page
          SlideTransition(
            position: secondaryAnimation.drive(exitSlideTween),
            child: Container(),
          ),
          // Enter animation for new page
          SlideTransition(
            position: animation.drive(slideTween),
            child: FadeTransition(
              opacity: animation.drive(fadeTween),
              child: child,
            ),
          ),
        ],
      );
    },
  );
}

// Enhanced slide transition for OTP verification flow
class OTPSlideTransition extends PageRouteBuilder {
  final Widget page;
  final SlideDirection direction;

  OTPSlideTransition({
    required this.page,
    this.direction = SlideDirection.rightToLeft,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset beginOffset;
      Offset exitOffset;
      
      switch (direction) {
        case SlideDirection.rightToLeft:
          beginOffset = const Offset(1.0, 0.0);
          exitOffset = const Offset(-0.3, 0.0);
          break;
        case SlideDirection.leftToRight:
          beginOffset = const Offset(-1.0, 0.0);
          exitOffset = const Offset(0.3, 0.0);
          break;
        case SlideDirection.bottomToTop:
          beginOffset = const Offset(0.0, 1.0);
          exitOffset = const Offset(0.0, -0.3);
          break;
        case SlideDirection.topToBottom:
          beginOffset = const Offset(0.0, -1.0);
          exitOffset = const Offset(0.0, 0.3);
          break;
      }

      final slideTween = Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOutCubic));

      final exitSlideTween = Tween<Offset>(
        begin: Offset.zero,
        end: exitOffset,
      ).chain(CurveTween(curve: Curves.easeInOutCubic));

      final fadeTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeIn));

      final scaleTween = Tween<double>(
        begin: 0.95,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOut));

      return Stack(
        children: [
          // Exit animation for previous page
          SlideTransition(
            position: secondaryAnimation.drive(exitSlideTween),
            child: FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.7).animate(secondaryAnimation),
              child: Container(),
            ),
          ),
          // Enter animation for new page
          SlideTransition(
            position: animation.drive(slideTween),
            child: FadeTransition(
              opacity: animation.drive(fadeTween),
              child: ScaleTransition(
                scale: animation.drive(scaleTween),
                child: child,
              ),
            ),
          ),
        ],
      );
    },
  );
}

// Smooth swipe transition with elastic effect
class SwipeTransition extends PageRouteBuilder {
  final Widget page;
  final bool isForward;

  SwipeTransition({
    required this.page,
    this.isForward = true,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideTween = Tween<Offset>(
        begin: isForward ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.elasticOut));

      final exitSlideTween = Tween<Offset>(
        begin: Offset.zero,
        end: isForward ? const Offset(-0.5, 0.0) : const Offset(0.5, 0.0),
      ).chain(CurveTween(curve: Curves.easeInOut));

      final fadeTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeInOut));

      final shadowTween = Tween<double>(
        begin: 0.0,
        end: 0.3,
      ).chain(CurveTween(curve: Curves.easeInOut));

      return Stack(
        children: [
          // Shadow effect
          SlideTransition(
            position: secondaryAnimation.drive(exitSlideTween),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      shadowTween.evaluate(animation),
                    ),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),
          // Main transition
          SlideTransition(
            position: animation.drive(slideTween),
            child: FadeTransition(
              opacity: animation.drive(fadeTween),
              child: child,
            ),
          ),
        ],
      );
    },
  );
}

// Card-like transition for OTP modals
class CardTransition extends PageRouteBuilder {
  final Widget page;

  CardTransition({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideTween = Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      final scaleTween = Tween<double>(
        begin: 0.9,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOut));

      final fadeTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeIn));

      return SlideTransition(
        position: animation.drive(slideTween),
        child: ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        ),
      );
    },
  );
}

enum SlideDirection {
  rightToLeft,
  leftToRight,
  bottomToTop,
  topToBottom,
}

