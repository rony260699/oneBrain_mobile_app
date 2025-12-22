import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/imagex_message.dart';
import 'imagex_message_bubble.dart';

class ImageXMessagesList extends StatelessWidget {
  final List<ImageXMessageModel> messages;
  final ScrollController scrollController;

  const ImageXMessagesList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.builder(
        itemCount: messages.length,
        controller: scrollController,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: ImageXMessageBubble(message: message),
          );
        },
      ),
    );
  }
}
