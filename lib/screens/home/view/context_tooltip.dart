import 'package:OneBrain/common_widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ContextTooltip extends StatefulWidget {
  const ContextTooltip({super.key, required this.contextUsed});

  final int contextUsed;

  @override
  State<ContextTooltip> createState() => _ContextTooltipState();
}

class _ContextTooltipState extends State<ContextTooltip> {
  @override
  Widget build(BuildContext context) {
    int contextUsed = widget.contextUsed;
    if (contextUsed == 0) {
      return SizedBox();
    }
    // Cap the display value at 100%
    int displayPercentage = contextUsed > 100 ? 100 : contextUsed;
    double progressValue = (contextUsed / 100).clamp(0.0, 1.0);

    return Tooltip(
      message:
          "$displayPercentage% • ${displayPercentage * 2}K / 200.0K context used",
      triggerMode: TooltipTriggerMode.tap,
      child: Row(
        children: [
          TextWidget(
            text: "$displayPercentage%",
            color: Color(0xffA1A1AA),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(width: 4),
          SizedBox(
            width: 9,
            height: 9,
            child: CircularProgressIndicator(
              value: progressValue,
              strokeWidth: 1,
              backgroundColor: Color(0xff2E3234),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffA1A1AA)),
            ),
          ),
        ],
      ),
    );
  }
}
