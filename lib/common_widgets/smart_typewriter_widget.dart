import 'package:flutter/material.dart';
import '../../services/chat_stream_manager.dart';
import 'chatgpt_typewriter_renderer.dart';

/// Smart widget that automatically shows typewriter animation or nothing
/// based on global stream state for the given chatId
class SmartTypewriterWidget extends StatelessWidget {
  final String chatId;
  final String strFontName;
  final String? messageIdForAssistant;
  final VoidCallback? onComplete;
  final Duration characterDelay;

  const SmartTypewriterWidget({
    super.key,
    required this.chatId,
    required this.strFontName,
    this.messageIdForAssistant,
    this.onComplete,
    this.characterDelay = const Duration(milliseconds: 15),
  });

  @override
  Widget build(BuildContext context) {
    final streamManager = ChatStreamManager();

    // If stream is active, show typewriter
    if (streamManager.hasActiveStream(chatId)) {
      return ChatGPTTypewriterRenderer(
        key: ValueKey('typewriter_$chatId'),
        messageStream: streamManager.getStream(chatId),
        messageIdForAssistant: messageIdForAssistant,
        strFontName: strFontName,
        characterDelay: characterDelay,
        onComplete: () {
          onComplete?.call();
          // Stream will be completed by the sender
        },
      );
    }

    // If stream is completed or no stream exists, show nothing
    return const SizedBox.shrink();
  }
}
