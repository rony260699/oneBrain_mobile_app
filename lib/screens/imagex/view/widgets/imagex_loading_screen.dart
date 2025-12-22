import 'package:flutter/material.dart';

class ImageXLoadingScreen extends StatelessWidget {
  final String? imageUrl;
  final bool loading;
  
  const ImageXLoadingScreen({
    Key? key,
    this.imageUrl,
    required this.loading,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: loading ? Color(0xFF656FE2) : Color(0xFFC0C6FC),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          height: 320,
          color: Colors.grey[900],
          child: Stack(
            children: [
              // Background image (blurred)
              if (imageUrl != null)
                Positioned.fill(
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.6),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
              
              // Loading overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated loading icon
                        Container(
                          width: 60,
                          height: 60,
                          child: Stack(
                            children: [
                              // Outer spinning ring
                              Positioned.fill(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF656FE2),
                                  ),
                                ),
                              ),
                              // Inner pulsing dot
                              Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF656FE2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 16),
                        
                        // ImageX logo
                        Image.network(
                          'https://digitxevents.com/wp-content/uploads/2025/05/imagexsvg.svg',
                          height: 40,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        
                        SizedBox(height: 8),
                        
                        Text(
                          'Generating Image...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 