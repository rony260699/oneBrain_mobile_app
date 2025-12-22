import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/haptic_service.dart';

class TypewriterText extends StatefulWidget {
  final String message;
  final String strFontName;
  // final Message message;
  final VoidCallback? onComplete;
  final Duration characterDelay;

  const TypewriterText(
    this.message, {
    required this.strFontName,
    // required this.currentMessage,
    this.onComplete,
    this.characterDelay = const Duration(milliseconds: 25),
    super.key,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with TickerProviderStateMixin {
  late AnimationController _typewriterController;
  late AnimationController _cursorController;
  late Animation<int> _characterAnimation;
  late Animation<double> _cursorAnimation;

  String _displayedText = '';
  bool _isTypingComplete = false;
  int _hapticCounter = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startTypewriterEffect();
  }

  void _initializeAnimations() {
    // Typewriter animation controller
    _typewriterController = AnimationController(
      duration: Duration(
        milliseconds:
            widget.message.length * widget.characterDelay.inMilliseconds,
      ),
      vsync: this,
    );

    // Cursor blinking animation controller
    _cursorController = AnimationController(
      duration: const Duration(milliseconds: 530), // ChatGPT cursor blink rate
      vsync: this,
    )..repeat(reverse: true);

    // Character reveal animation
    _characterAnimation = IntTween(
      begin: 0,
      end: widget.message.length,
    ).animate(
      CurvedAnimation(parent: _typewriterController, curve: Curves.linear),
    );

    // Cursor opacity animation
    _cursorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cursorController, curve: Curves.easeInOut),
    );
  }

  void _startTypewriterEffect() {
    // Initial haptic feedback when starting
    HapticService.onResponseStart();

    _characterAnimation.addListener(() {
      final currentLength = _characterAnimation.value;

      if (currentLength <= widget.message.length) {
        setState(() {
          _displayedText = widget.message.substring(0, currentLength);
        });

        // ChatGPT-style haptic feedback pattern
        _hapticCounter++;
        HapticService.chatGPTTypingPattern(_hapticCounter);
      }
    });

    _typewriterController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isTypingComplete = true;
        });

        // Stop cursor blinking after a delay
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            _cursorController.stop();
            setState(() {});
          }
        });

        // Final haptic feedback when complete
        HapticService.onResponseComplete();

        // Call completion callback
        widget.onComplete?.call();
      }
    });

    // Start the typewriter animation
    _typewriterController.forward();
  }

  @override
  void dispose() {
    _typewriterController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_characterAnimation, _cursorAnimation]),
      builder: (context, child) {
        return Container(
          constraints: BoxConstraints(minHeight: 1, minWidth: double.infinity),
          child: SelectableText.rich(
            TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                fontFamily: '.SF Pro Text', // iOS system font
                height: 1.5, // Slightly tighter line height like ChatGPT
                letterSpacing: 0.0, // No letter spacing for cleaner look
              ),
              children: [
                ..._parseMessage(_displayedText),
                // Blinking cursor
                if (!_isTypingComplete || _cursorController.isAnimating)
                  TextSpan(
                    text: '▊',
                    style: TextStyle(
                      color: Colors.white.withOpacity(_cursorAnimation.value),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        );
      },
    );
  }

  List<TextSpan> _parseMessage(String text) {
    final lines = text.split('\n');
    final List<TextSpan> allSpans = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();

      // Skip empty lines to reduce gaps (like ChatGPT)
      if (trimmed.isEmpty && i < lines.length - 1) {
        allSpans.add(const TextSpan(text: '\n'));
        continue;
      }

      // Case 1: Full line wrapped in **...**
      if (trimmed.startsWith('**') &&
          trimmed.endsWith('**') &&
          trimmed.length > 4) {
        final header = trimmed.substring(2, trimmed.length - 2);
        allSpans.add(
          TextSpan(
            text: header,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: '.SF Pro Text',
              height: 1.5,
              letterSpacing: 0.0,
            ),
          ),
        );
      } else if (trimmed.isNotEmpty) {
        // Handle styles in-line (*bold*, _italic_, ~strike~, `code`)
        allSpans.addAll(_parseInlineStyles(line));
      }

      // Add line break only if not the last line
      if (i < lines.length - 1) {
        allSpans.add(const TextSpan(text: '\n'));
      }
    }

    return allSpans;
  }

  List<TextSpan> _parseInlineStyles(String text) {
    final RegExp pattern = RegExp(r'(\*[^*]+\*|_[^_]+_|~[^~]+~|`[^`]+`)');
    final List<TextSpan> spans = [];
    int currentIndex = 0;

    final matches = pattern.allMatches(text);

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              fontFamily: '.SF Pro Text',
              height: 1.5,
              letterSpacing: 0.0,
            ),
          ),
        );
      }

      final matchText = match.group(0)!;
      TextStyle? style;
      String content = matchText;

      if (matchText.startsWith('*') && matchText.endsWith('*')) {
        style = TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontFamily: '.SF Pro Text',
          height: 1.5,
          letterSpacing: 0.0,
        );
        content = matchText.substring(1, matchText.length - 1);
      } else if (matchText.startsWith('_') && matchText.endsWith('_')) {
        style = TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w400,
          fontFamily: '.SF Pro Text',
          height: 1.5,
          letterSpacing: 0.0,
        );
        content = matchText.substring(1, matchText.length - 1);
      } else if (matchText.startsWith('~') && matchText.endsWith('~')) {
        style = TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          decoration: TextDecoration.lineThrough,
          fontWeight: FontWeight.w400,
          fontFamily: '.SF Pro Text',
          height: 1.5,
          letterSpacing: 0.0,
        );
        content = matchText.substring(1, matchText.length - 1);
      } else if (matchText.startsWith('`') && matchText.endsWith('`')) {
        style = TextStyle(
          color: Colors.white,
          fontSize: 14.sp, // Slightly smaller for code like ChatGPT
          fontFamily: 'SF Mono', // iOS monospace font for code
          backgroundColor: Colors.white.withOpacity(0.15), // Subtle background
          height: 1.5,
          letterSpacing: 0.0,
        );
        content = matchText.substring(1, matchText.length - 1);
      }

      spans.add(TextSpan(text: content, style: style));
      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            fontFamily: '.SF Pro Text',
            height: 1.5,
            letterSpacing: 0.0,
          ),
        ),
      );
    }

    return spans;
  }
}
