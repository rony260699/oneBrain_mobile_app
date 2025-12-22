import 'dart:math';
import 'package:OneBrain/common_widgets/chatgpt_style_renderer.dart';
import 'package:OneBrain/common_widgets/smart_typewriter_widget.dart';
import 'package:OneBrain/common_widgets/model_gradient_animation.dart';
import 'package:OneBrain/models/message_model.dart';
import 'package:OneBrain/resources/strings.dart';
import 'package:OneBrain/services/ai_model_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../common_widgets/app_utils.dart';
import '../../../common_widgets/text_widget.dart';

class ModelMessageView extends StatefulWidget {
  final Message currentMessage;
  const ModelMessageView({super.key, required this.currentMessage});

  @override
  State<ModelMessageView> createState() => _ModelMessageViewState();
}

class _ModelMessageViewState extends State<ModelMessageView> {
  bool _copied = false;

  Future<void> _handleCopy(message) async {
    await Clipboard.setData(ClipboardData(text: message));
    setState(() {
      _copied = true;
    });
    showSuccess(message: "Copied successfully");
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentActiveProvider =
        widget.currentMessage.provider?.toLowerCase() ?? "";

    bool isGenerating = widget.currentMessage.isGenerating ?? false;

    String message = "";
    for (var part in widget.currentMessage.parts ?? []) {
      if (part["type"] == "text") {
        message = part["text"];
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 0.0, bottom: 6.0),
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isGenerating
                    ? RotatingSvgIcon(
                      assetPath: AIModelService.getIcon(
                        currentActiveProvider,
                        true,
                      ),
                      size: 24,
                    )
                    : SvgPicture.asset(
                      AIModelService.getIcon(currentActiveProvider, true),
                      height: 24,
                      width: 24,
                    ),
                SizedBox(width: 8),
                isGenerating
                    ? ModelGradientAnimation(
                      modelName: currentActiveProvider.capitalizeFirst,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )
                    : TextWidget(
                      text: currentActiveProvider.capitalizeFirst,
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontFamily: strFontName,
                      textAlign: TextAlign.left,
                    ),
              ],
            ),
          ),

          // Message Content Container (matching web app clean design)
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.95,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 0.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Always show the message content, whether generating or not
                  // When generating, show both the streaming content and existing content
                  ChatGPTStyleRenderer(
                    message: message,
                    strFontName: strFontName,
                    messageIdForAssistant: widget.currentMessage.sId,
                  ),
                  // Show the typewriter only when actually generating
                  if (isGenerating)
                    SmartTypewriterWidget(
                      strFontName: "Roboto",
                      key: ValueKey(widget.currentMessage.sId),
                      chatId: widget.currentMessage.chatId ?? '',
                    ),

                  if (!isGenerating)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: GestureDetector(
                        onTap: () => _handleCopy(message),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.transparent,
                          ),
                          child: Icon(
                            _copied ? Icons.check : Icons.copy,
                            size: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RotatingSvgIcon extends StatefulWidget {
  final String assetPath;
  final double size;

  const RotatingSvgIcon({super.key, required this.assetPath, this.size = 24});

  @override
  State<RotatingSvgIcon> createState() => _RotatingSvgIconState();
}

class _RotatingSvgIconState extends State<RotatingSvgIcon> {
  bool _repeat = true; // flip-flop to restart tween

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(_repeat), // force restart
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      curve: Curves.linear,
      onEnd: () {
        setState(() => _repeat = !_repeat);
      },
      builder: (context, value, child) {
        return Transform.rotate(angle: value * 2 * pi, child: child);
      },
      child: SvgPicture.asset(
        widget.assetPath,
        height: widget.size,
        width: widget.size,
      ),
    );
  }
}
