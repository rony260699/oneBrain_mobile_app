import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class NewAppStyledText extends StatelessWidget {
  final String message;
  final String strFontName;
  // final ConversationMessage currentMessage;
  // final Message message;

  const NewAppStyledText(
    this.message, {
    required this.strFontName,
    super.key,
    // required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final spans = _parseMessage(message);
    return Container(
      constraints: BoxConstraints(minHeight: 1, minWidth: double.infinity),
      child: SelectableText.rich(
        TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            fontFamily: strFontName,
          ),
          children: spans,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  List<TextSpan> _parseMessage(String text) {
    final lines = text.split('\n');
    final List<TextSpan> allSpans = [];

    for (String line in lines) {
      final trimmed = line.trim();

      // Case 1: Full line wrapped in **...**
      if (trimmed.startsWith('**') &&
          trimmed.endsWith('**') &&
          trimmed.length > 4) {
        final header = trimmed.substring(2, trimmed.length - 2);
        allSpans.add(
          TextSpan(
            text: '$header\n',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: strFontName,
            ),
          ),
        );
      } else {
        // Handle styles in-line (*bold*, _italic_, ~strike~, `code`)
        allSpans.addAll(_parseInlineStyles(line));
        allSpans.add(const TextSpan(text: '\n')); // preserve line break
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
        spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
      }

      final matchText = match.group(0)!;
      TextStyle? style;
      String content = matchText;

      if (matchText.startsWith('*') && matchText.endsWith('*')) {
        style = TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontFamily: strFontName,
        );
        content = matchText.substring(1, matchText.length - 1);
      } else if (matchText.startsWith('_') && matchText.endsWith('_')) {
        style = TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w400,
          fontFamily: strFontName,
        );
        content = matchText.substring(1, matchText.length - 1);
      } else if (matchText.startsWith('~') && matchText.endsWith('~')) {
        style = TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          decoration: TextDecoration.lineThrough,
          fontWeight: FontWeight.w400,
          fontFamily: strFontName,
        );
        content = matchText.substring(1, matchText.length - 1);
      } else if (matchText.startsWith('`') && matchText.endsWith('`')) {
        style = TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontFamily: strFontName,
          backgroundColor: Colors.white24,
        );
        content = matchText.substring(1, matchText.length - 1);
      }

      spans.add(TextSpan(text: content, style: style));
      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return spans;
  }
}
