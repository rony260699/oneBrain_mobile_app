import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../resources/color.dart';

class MassageContainer extends StatelessWidget {
  const MassageContainer({
    super.key,
    required this.text,
    required this.time,
    required this.sender,
    required this.isMe,
  });

  final String text;
  final String time;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          CustomPaint(
            painter: CustomChatBubble(isOwn: isMe ? true : false, color: isMe ? colorPrimary : colorPrimary),
            child: Container(
              constraints: BoxConstraints(maxWidth: 250.w),
              decoration: BoxDecoration(
                color: isMe ? colorPrimary : colorPrimary,
                border: Border.all(color: Colors.transparent),
                borderRadius: isMe
                    ? const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0), bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0))
                    : const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      text,
                      // style: montserratMedium(fontSize: 12.sp, textColor: isMe ? whiteColor : blackColor, height: 1.5),
                    ),
                    Text(
                      time,
                      // style: montserratMedium(fontSize: 9.sp, textColor: isMe ? whiteColor : blackColor, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomChatBubble extends CustomPainter {
  CustomChatBubble({this.color, this.isOwn});

  final Color? color;
  final bool? isOwn;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color ?? Colors.blue;

    Path paintBubbleTail() {
      Path path = Path();
      if (isOwn == false) {
        path = Path()
          ..moveTo(8, size.height - 5)
          ..quadraticBezierTo(-5, size.height, -10, size.height - 4)
          ..quadraticBezierTo(-5, size.height - 5, 0, size.height - 17);
      }
      if (isOwn == true) {
        path = Path()
          ..moveTo(size.width - 8, size.height - 4)
          ..quadraticBezierTo(size.width + 4, size.height, size.width + 10, size.height - 4)
          ..quadraticBezierTo(size.width + 5, size.height - 5, size.width, size.height - 17);
      }
      return path;
    }

    final RRect bubbleBody = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(16));
    final Path bubbleTail = paintBubbleTail();

    canvas.drawRRect(bubbleBody, paint);
    canvas.drawPath(bubbleTail, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
