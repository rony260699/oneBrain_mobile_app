import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/hexcolor.dart';
import 'provider/flux_provider.dart';
import 'widgets/flux_loading_indicator.dart';

class FluxImageGeneratorPage extends StatefulWidget {
  @override
  _FluxImageGeneratorPageState createState() => _FluxImageGeneratorPageState();
}

class _FluxImageGeneratorPageState extends State<FluxImageGeneratorPage> {
  double? _progress;
  String? _generatedImageUrl;
  String? _lastPrompt;

  @override
  Widget build(BuildContext context) {
    return Consumer<FluxProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Center(child: _buildImageContainer(provider)),
        );
      },
    );
  }

  Widget _buildImageContainer(FluxProvider provider) {
    final isLoading = provider.isGenerating;
    final hasImage =
        provider.messages.isNotEmpty &&
        provider.messages.first.imageUrl != null &&
        !isLoading;

    return Container(
      width: double.infinity,
      height: 420.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isLoading ? Colors.transparent : HexColor('#656FE2'),
          width: 2,
        ),
        gradient:
            isLoading
                ? LinearGradient(
                  // Rainbow effect for loading
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.indigo,
                    Colors.purple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: _buildImageContent(provider, isLoading, hasImage),
      ),
    );
  }

  Widget _buildImageContent(
    FluxProvider provider,
    bool isLoading,
    bool hasImage,
  ) {
    if (isLoading) {
      return FluxLoadingIndicator(
        progress: _progress,
        currentProvider: provider.getModelDisplayName(provider.selectedModel),
      );
    } else if (hasImage) {
      // Get the latest generated image from provider messages
      final latestMessage =
          provider.messages.isNotEmpty ? provider.messages.first : null;
      final imageUrl = latestMessage?.imageUrl;

      if (imageUrl == null) {
        return Container(
          color: Color(0xFF121d32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Flux logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        HexColor('#656FE2').withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            HexColor('#7C3AED'),
                            HexColor('#3B82F6'),
                            HexColor('#10B981'),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'FLUX',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Generate Amazing Images with AI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Describe what you want to create',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Stack(
        children: [
          Image.network(
            imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Color(0xFF121d32),
                child: Center(
                  child: CircularProgressIndicator(
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                    color: HexColor('#656FE2'),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Color(0xFF121d32),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                      SizedBox(height: 8.h),
                      Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Action buttons
          Positioned(
            bottom: 8.h,
            right: 8.w,
            child: Row(
              children: [
                _buildActionButton(
                  icon: Icons.refresh,
                  onTap: _handleRegenerate,
                  tooltip: 'Regenerate Image',
                ),
                SizedBox(width: 8.w),
                _buildActionButton(
                  icon: Icons.download,
                  onTap: () => _handleDownload(imageUrl),
                  tooltip: 'Download Image',
                ),
                SizedBox(width: 8.w),
                _buildActionButton(
                  icon: Icons.share,
                  onTap: () => _handleShare(imageUrl),
                  tooltip: 'Share Image',
                ),
              ],
            ),
          ),
          // Image info overlay
          Positioned(
            top: 8.h,
            left: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                provider.getModelDisplayName(provider.selectedModel),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        color: Color(0xFF121d32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Flux logo
              Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      HexColor('#656FE2').withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          HexColor('#7C3AED'),
                          HexColor('#3B82F6'),
                          HexColor('#10B981'),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'FLUX',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Generate Amazing Images with AI',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Describe what you want to create',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.grey[700]!.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: Colors.white, size: 16.sp),
      ),
    );
  }

  // Action Methods
  void _handleRegenerate() {
    if (_lastPrompt != null) {
      final provider = Provider.of<FluxProvider>(context, listen: false);
      provider.generateImage(prompt: _lastPrompt!);
    }
  }

  void _handleDownload(String imageUrl) {
    // Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Download functionality coming soon!'),
        backgroundColor: HexColor('#656FE2'),
      ),
    );
  }

  void _handleShare(String imageUrl) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share functionality coming soon!'),
        backgroundColor: HexColor('#656FE2'),
      ),
    );
  }
}
