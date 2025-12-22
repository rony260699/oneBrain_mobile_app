import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/flux_message.dart';
import '../../../common_widgets/hexcolor.dart';

class FluxMessagesList extends StatelessWidget {
  final List<FluxMessage> messages;

  const FluxMessagesList({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageItem(context, message);
      },
    );
  }

  Widget _buildMessageItem(BuildContext context, FluxMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            // Flux AI Avatar
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    HexColor('#7C3AED'),
                    HexColor('#3B82F6'),
                    HexColor('#10B981'),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: HexColor('#7C3AED').withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.auto_fix_high,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
          ],
          
          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: message.isUser 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                // Message bubble
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: message.isUser
                        ? LinearGradient(
                            colors: [
                              HexColor('#656FE2'),
                              HexColor('#4F46E5'),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: message.isUser
                          ? HexColor('#656FE2').withOpacity(0.3)
                          : Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Prompt text
                      Text(
                        message.prompt,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                      
                      if (!message.isUser) ...[
                        SizedBox(height: 12.h),
                        
                        // Generation settings
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            message.settingsDisplayText,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 12.h),
                        
                        // Image or generation status
                        if (message.hasImage)
                          _buildImagePreview(message)
                        else
                          _buildGenerationStatus(message),
                      ],
                    ],
                  ),
                ),
                
                SizedBox(height: 8.h),
                
                // Timestamp
                Text(
                  message.formattedTimestamp,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          
          if (message.isUser) ...[
            SizedBox(width: 12.w),
            // User avatar
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    HexColor('#656FE2'),
                    HexColor('#4F46E5'),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImagePreview(FluxMessage message) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 300.h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Generated image
            Image.network(
              message.imageUrl!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(HexColor('#656FE2')),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        color: Colors.white.withOpacity(0.5),
                        size: 40.sp,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Failed to load image',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            // Success indicator
            if (message.isCompleted)
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: HexColor('#10B981').withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: HexColor('#10B981').withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        message.generationTime ?? 'Generated',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Download/Action buttons
            Positioned(
              bottom: 12.h,
              right: 12.w,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    icon: Icons.download,
                    onTap: () {
                      // TODO: Implement download
                    },
                  ),
                  SizedBox(width: 8.w),
                  _buildActionButton(
                    icon: Icons.share,
                    onTap: () {
                      // TODO: Implement share
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerationStatus(FluxMessage message) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            message.statusColor.withOpacity(0.2),
            message.statusColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: message.statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (message.isGenerating)
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(message.statusColor),
              ),
            )
          else
            Icon(
              message.statusIcon,
              color: message.statusColor,
              size: 20.sp,
            ),
          
          SizedBox(width: 12.w),
          
          Expanded(
            child: Text(
              message.statusDisplayText,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: message.statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18.sp,
        ),
      ),
    );
  }
} 