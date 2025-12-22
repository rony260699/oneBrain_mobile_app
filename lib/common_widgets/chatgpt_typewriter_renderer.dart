// chatgpt_typewriter_renderer.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'chatgpt_style_renderer.dart';

/// High-performance typewriter renderer for a streaming message.
/// Optimized for: minimal rebuilds, no controller churn, and smooth typing.
class ChatGPTTypewriterRenderer extends StatefulWidget {
  /// Stream of message chunks (e.g., SSE tokens). Must be UTF-8 text.
  final Stream<String> messageStream;

  final String? messageIdForAssistant;

  /// Font name forwarded to your ChatGPTStyleRenderer.
  final String strFontName;

  /// Called once when full message is completely rendered.
  final VoidCallback? onComplete;

  /// Delay per character (typing speed). Lower = faster.
  final Duration characterDelay;

  /// Start typing automatically on first data.
  final bool autoStart;

  /// Show blinking cursor while streaming/typing.
  final bool showCursor;

  /// Cursor glyph.
  final String cursorGlyph;

  /// Optional: initial text (rendered before stream starts).
  final String initialText;

  const ChatGPTTypewriterRenderer({
    super.key,
    required this.messageStream,
    required this.strFontName,
    required this.messageIdForAssistant,
    this.onComplete,
    this.characterDelay = const Duration(milliseconds: 15),
    this.autoStart = true,
    this.showCursor = true,
    this.cursorGlyph = '▊',
    this.initialText = '',
  });

  @override
  State<ChatGPTTypewriterRenderer> createState() =>
      _ChatGPTTypewriterRendererState();
}

class _ChatGPTTypewriterRendererState extends State<ChatGPTTypewriterRenderer>
    with TickerProviderStateMixin {
  // === Streaming state ===
  final StringBuffer _buffer = StringBuffer();
  late final ValueNotifier<String> _visibleText;
  StreamSubscription<String>? _sub;
  bool _streamEnded = false;

  // === Typing ticker (reveals characters) ===
  Ticker? _typingTicker;
  final Stopwatch _clock = Stopwatch();
  int _shown = 0; // chars currently shown
  int _baseShownAtStart = 0; // shown chars when (re)starting ticker
  bool _typingStarted = false;
  bool _typingComplete = false;

  // === Cursor blink ===
  late final AnimationController _cursorController;
  late final Animation<double> _cursorOpacity;

  int get _charDelayMs => widget.characterDelay.inMilliseconds.clamp(1, 2000);

  @override
  void initState() {
    super.initState();

    // Initialize visible text
    _visibleText = ValueNotifier<String>(widget.initialText);
    _shown = widget.initialText.length;
    if (widget.initialText.isNotEmpty) {
      _buffer.write(widget.initialText);
    }

    // Cursor
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _cursorOpacity = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _cursorController, curve: Curves.easeInOutSine),
    );

    _subscribeToStream(widget.messageStream);
  }

  @override
  void didUpdateWidget(covariant ChatGPTTypewriterRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.messageStream != widget.messageStream) {
      _unsubscribeFromStream();
      _resetTyping(keepInitialText: false); // new message → reset
      _subscribeToStream(widget.messageStream);
    }
  }

  // --- Stream management ---

  void _subscribeToStream(Stream<String> stream) {
    //check allready listenable
    _sub = stream.listen(
      (chunk) {
        if (chunk.isEmpty) return;
        _buffer.write(chunk);

        // Start ticker lazily on first data
        if (widget.autoStart && !_typingStarted) {
          _startTicker();
        }
      },
      onDone: () {
        _streamEnded = true;
        // If nothing is running yet (e.g., autoStart=false), do not force start.
        // If typing already started, ticker will naturally finish and complete.
      },
      onError: (e) {
        // You can add your own error handling/logging here.
        // We don't stop the typing ticker on errors—render what we have.
      },
      cancelOnError: false,
    );
  }

  void _unsubscribeFromStream() {
    _sub?.cancel();
    _sub = null;
  }

  // --- Typing ticker ---

  void _startTicker() {
    if (_typingTicker?.isActive == true) return;

    _typingStarted = true;
    _baseShownAtStart = _shown;
    _clock
      ..reset()
      ..start();

    _typingTicker ??= createTicker(_onTick);
    _typingTicker!.start();
  }

  void _stopTicker() {
    _typingTicker?.stop();
    _clock.stop();
  }

  void _onTick(Duration elapsed) {
    // Compute how many characters should be visible now based on elapsed time.
    final int producedSinceStart = (_clock.elapsedMilliseconds ~/ _charDelayMs);
    final int desired = _baseShownAtStart + producedSinceStart;

    // Clamp to what we actually have from the stream
    final int target = desired.clamp(0, _buffer.length);

    if (target > _shown) {
      _shown = target;
      // Update just the text via ValueNotifier (avoids full setState)
      _visibleText.value = _buffer.toString().substring(0, _shown);
    }

    // If stream ended and we've revealed everything, finish.
    if (_streamEnded && _shown >= _buffer.length) {
      _completeTyping();
    }
  }

  void _completeTyping() {
    if (_typingComplete) return;
    _typingComplete = true;
    _stopTicker();

    // Smoothly fade out the cursor after a brief delay.
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _cursorController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Fire completion callback once.
    widget.onComplete?.call();
    if (mounted) setState(() {}); // single rebuild to reflect completion state
  }

  // --- Controls ---

  /// Manually start typing if [autoStart] is false.
  void startTyping() {
    if (_typingComplete) return;
    _startTicker();
  }

  /// Instantly flush all current buffer (useful for "skip" UX).
  void skipToEnd() {
    _shown = _buffer.length;
    _visibleText.value = _buffer.toString();
    if (_streamEnded) {
      _completeTyping();
    }
  }

  /// Reset widget to initial state (keeps/clears initialText).
  void _resetTyping({required bool keepInitialText}) {
    _stopTicker();
    _typingTicker?.dispose();
    _typingTicker = null;

    _typingStarted = false;
    _typingComplete = false;
    _streamEnded = false;
    _clock.reset();

    final String seed =
        keepInitialText ? _visibleText.value : widget.initialText;
    _buffer
      ..clear()
      ..write(seed);
    _shown = seed.length;
    _visibleText.value = seed;

    // Reset cursor
    if (!_cursorController.isAnimating) {
      _cursorController.repeat(reverse: true);
    }
  }

  // --- Lifecycle ---

  @override
  void dispose() {
    _unsubscribeFromStream();
    _stopTicker();
    _typingTicker?.dispose();
    _cursorController.dispose();
    _visibleText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap to isolate repaints of this section.
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text subtree rebuilds only when the visible string changes.
          ValueListenableBuilder<String>(
            valueListenable: _visibleText,
            builder: (context, text, _) {
              return ChatGPTStyleRenderer(
                message: text,
                strFontName: widget.strFontName,
                messageIdForAssistant: widget.messageIdForAssistant,
                isStreaming: !_typingComplete,
              );
            },
          ),

          if (widget.showCursor && !_typingComplete)
            AnimatedBuilder(
              animation: _cursorOpacity,
              builder: (context, _) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    widget.cursorGlyph,
                    style: TextStyle(
                      color: Colors.white.withOpacity(_cursorOpacity.value),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
