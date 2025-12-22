import 'package:flutter/material.dart';

class AnimatedGradientButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final String variant;
  final bool isLoading;
  final double? width;
  final double? height;

  const AnimatedGradientButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.variant = 'default',
    this.isLoading = false,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<AnimatedGradientButton> createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isLoading) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (!widget.isLoading) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  LinearGradient _getGradient() {
    switch (widget.variant) {
      case 'danger':
        return const LinearGradient(
          colors: [Color(0xFFFF4444), Color(0xFFCC0000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'warning':
        return const LinearGradient(
          colors: [Color(0xFFFF8800), Color(0xFFFF6600)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'success':
        return const LinearGradient(
          colors: [Color(0xFF00CC44), Color(0xFF00AA33)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF6BA2FB), Color(0xFF8B7CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color _getBackgroundColor() {
    switch (widget.variant) {
      case 'danger':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'success':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 350 || screenHeight < 700;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Responsive sizing
    final buttonWidth =
        widget.width ?? (isSmallScreen ? screenWidth * 0.4 : null);
    final buttonHeight = widget.height ?? (isSmallScreen ? 36.0 : 40.0);
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;
    final verticalPadding = isSmallScreen ? 6.0 : 8.0;
    final fontSize =
        (isSmallScreen ? 11.0 : 12.0) / textScaleFactor.clamp(0.8, 1.2);
    final borderRadius = isSmallScreen ? 6.0 : 8.0;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: widget.isLoading ? 0.7 : _opacityAnimation.value,
            child: GestureDetector(
              onTapDown: widget.isLoading ? null : _onTapDown,
              onTapUp: widget.isLoading ? null : _onTapUp,
              onTapCancel: widget.isLoading ? null : _onTapCancel,
              onTap: widget.isLoading ? null : widget.onPressed,
              child: Container(
                width: buttonWidth,
                height: buttonHeight,
                constraints: BoxConstraints(
                  minWidth: isSmallScreen ? 60 : 80,
                  minHeight: isSmallScreen ? 32 : 36,
                  maxWidth:
                      screenWidth * 0.8, // Prevent overflow on small screens
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                decoration: BoxDecoration(
                  gradient: _isPressed ? null : _getGradient(),
                  color: _isPressed ? _getBackgroundColor() : null,
                  borderRadius: BorderRadius.circular(borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: _getBackgroundColor().withOpacity(0.3),
                      blurRadius: _isPressed ? 4 : 8,
                      offset: Offset(0, _isPressed ? 1 : 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isLoading) ...[
                      SizedBox(
                        width: isSmallScreen ? 12 : 14,
                        height: isSmallScreen ? 12 : 14,
                        child: CircularProgressIndicator(
                          strokeWidth: isSmallScreen ? 1.5 : 2,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 6 : 8),
                    ],
                    Flexible(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
