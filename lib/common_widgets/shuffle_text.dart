import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ShuffleText extends StatefulWidget {
  final TextStyle? style;
  final Duration duration;
  final String greetingText;

  const ShuffleText({
    super.key,
    this.style,
    this.duration = const Duration(milliseconds: 1500),
    required this.greetingText,
  });

  @override
  State<ShuffleText> createState() => _ShuffleTextState();
}

class _ShuffleTextState extends State<ShuffleText> {
  late String fullText = "";

  @override
  void initState() {
    super.initState();
    // final rawUsername = _capitalizeFirstLetter(AppUtils.getUsernameFromEmail(SharedPreferenceUtil.getUserData()?.user?.email ?? ""));
    // Remove manual truncation - let auto-sizing handle it
    // fullText = "Hello, $rawUsername";
  }

  // String _capitalizeFirstLetter(String text) {
  //   if (text.isEmpty) return text;
  //   return text[0].toUpperCase() + text.substring(1).toLowerCase();
  // }

  @override
  Widget build(BuildContext context) {
    // final style = widget.style ?? Theme.of(context).textTheme.bodyLarge!;
    // final rawUsername = _capitalizeFirstLetter(AppUtils.getUsernameFromEmail(SharedPreferenceUtil.getUserData()?.user?.email ?? ""));

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Auto-resizing gradient text for "Hello, Username" - forced to one line
          Container(
            width: MediaQuery.of(context).size.width * 0.90,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AutoSizeText(
              widget.greetingText,
              style: TextStyle(
                fontSize: 48,
                color: Color(0xff9CA3AF),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              minFontSize: 12,
              maxFontSize: 48,
            ),

            //  GradientTextAnimationScreen(
            //   text: widget.greetingText,
            //   fontSize: 48,
            //   maxLines: 1, // Force one line only
            //   overflow: TextOverflow.ellipsis, // Use ellipsis for overflow
            //   autoSize: true, // Enable auto-sizing
            //   minFontSize: 16, // Lower minimum font size for better fitting
            //   maxFontSize: 48, // Maximum font size
            // ),
          ),
        ],
      ),
    );
  }
}
