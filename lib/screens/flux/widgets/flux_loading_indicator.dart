import 'package:flutter/material.dart';

class FluxLoadingIndicator extends StatefulWidget {
  final double? progress;
  final String currentProvider;

  const FluxLoadingIndicator({
    Key? key,
    this.progress,
    required this.currentProvider,
  }) : super(key: key);

  @override
  _FluxLoadingIndicatorState createState() => _FluxLoadingIndicatorState();
}

class _FluxLoadingIndicatorState extends State<FluxLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _rotationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF111827),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Logo
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8 + (_pulseController.value * 0.2),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF656fe2),
                        Color(0xFF7c84ff),
                        Color(0xFF9ba3fd),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF656fe2).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.network(
                      'https://digitxevents.com/wp-content/uploads/2025/05/generate_logo.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              );
            },
          ),
          
          SizedBox(height: 30),
          
          // Progress Text
          Text(
            'Generating with ${widget.currentProvider}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          SizedBox(height: 20),
          
          // Progress Bar
          if (widget.progress != null) ...[
            Container(
              width: 200,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: widget.progress! / 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF656fe2), Color(0xFF7c84ff)],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${widget.progress!.toInt()}%',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ] else ...[
            // Spinning indicator
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationController.value * 2 * 3.14159,
                  child: Container(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: Color(0xFF656fe2),
                      strokeWidth: 3,
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
} 