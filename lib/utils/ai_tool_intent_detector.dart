// AI Tool Intent Detection System
// This system analyzes user messages and suggests appropriate AI tools
// for seamless workflow transitions

import '../screens/side_menu/model/ai_list_model.dart';

class ToolSuggestion {
  final AiTool tool;
  final String reason;
  final double confidence;
  final String suggestedPrompt;
  final String transitionMessage;

  ToolSuggestion({
    required this.tool,
    required this.reason,
    required this.confidence,
    required this.suggestedPrompt,
    required this.transitionMessage,
  });
}

class AiToolIntentDetector {
  static final Map<String, List<String>> _intentKeywords = {
    'image_generation': [
      'create image', 'generate image', 'make picture', 'draw', 'design',
      'visual', 'artwork', 'illustration', 'photo', 'picture', 'portrait',
      'logo', 'banner', 'poster', 'thumbnail', 'icon', 'sketch'
    ],
    'video_generation': [
      'create video', 'generate video', 'make video', 'animation', 'movie',
      'clip', 'footage', 'cinematic', 'motion', 'scene', 'short film'
    ],
    'audio_generation': [
      'create music', 'generate audio', 'make song', 'compose', 'soundtrack',
      'melody', 'beat', 'voice', 'speech', 'sound effect', 'jingle'
    ],
    'text_processing': [
      'humanize', 'rewrite', 'improve text', 'make natural', 'paraphrase',
      'enhance writing', 'better wording', 'professional tone'
    ],
    'voice_cloning': [
      'clone voice', 'voice synthesis', 'speech generation', 'voice over',
      'narration', 'voice acting', 'voice model'
    ]
  };

  static final Map<String, List<String>> _contextKeywords = {
    'professional': ['business', 'corporate', 'professional', 'formal', 'commercial'],
    'creative': ['artistic', 'creative', 'unique', 'innovative', 'experimental'],
    'social_media': ['instagram', 'tiktok', 'youtube', 'social', 'viral', 'trending'],
    'marketing': ['marketing', 'advertisement', 'promotional', 'brand', 'campaign'],
  };

  /// Analyze user message and suggest appropriate AI tools
  static List<ToolSuggestion> analyzeMessage(String message, List<AiTool> availableTools) {
    List<ToolSuggestion> suggestions = [];
    String lowerMessage = message.toLowerCase();

    // Check for direct tool mentions
    for (var tool in availableTools) {
      if (lowerMessage.contains(tool.toolName.toLowerCase())) {
        suggestions.add(ToolSuggestion(
          tool: tool,
          reason: "You mentioned ${tool.toolName} directly",
          confidence: 0.95,
          suggestedPrompt: message,
          transitionMessage: "🎯 Switching to ${tool.toolName} as requested",
        ));
      }
    }

    // Intent-based detection
    for (var tool in availableTools) {
      double confidence = _calculateToolConfidence(lowerMessage, tool);
      if (confidence > 0.6) {
        String adaptedPrompt = _adaptPromptForTool(message, tool);
        suggestions.add(ToolSuggestion(
          tool: tool,
          reason: _getReasonForTool(lowerMessage, tool),
          confidence: confidence,
          suggestedPrompt: adaptedPrompt,
          transitionMessage: _getTransitionMessage(tool, confidence),
        ));
      }
    }

    // Sort by confidence
    suggestions.sort((a, b) => b.confidence.compareTo(a.confidence));
    return suggestions.take(3).toList(); // Return top 3 suggestions
  }

  /// Calculate confidence score for a tool based on message content
  static double _calculateToolConfidence(String message, AiTool tool) {
    double score = 0.0;
    int matches = 0;

    // Check capabilities
    for (var capability in tool.capabilities) {
      if (_intentKeywords.containsKey(capability)) {
        for (var keyword in _intentKeywords[capability]!) {
          if (message.contains(keyword)) {
            score += 0.3;
            matches++;
          }
        }
      }
    }

    // Check tool-specific patterns
    if (tool.isImageTool) {
      score += _checkImagePatterns(message);
    } else if (tool.isVideoTool) {
      score += _checkVideoPatterns(message);
    } else if (tool.isAudioTool) {
      score += _checkAudioPatterns(message);
    }

    // Normalize score
    return matches > 0 ? (score / (matches + 1)).clamp(0.0, 1.0) : 0.0;
  }

  static double _checkImagePatterns(String message) {
    double score = 0.0;
    List<String> imagePatterns = [
      'show me', 'visualize', 'what does', 'looks like', 'appearance',
      'style of', 'in the style', 'realistic', 'cartoon', 'artistic'
    ];
    
    for (var pattern in imagePatterns) {
      if (message.contains(pattern)) score += 0.2;
    }
    return score;
  }

  static double _checkVideoPatterns(String message) {
    double score = 0.0;
    List<String> videoPatterns = [
      'moving', 'action', 'sequence', 'story', 'scene', 'cinematic',
      'motion', 'animated', 'dynamic', 'timeline'
    ];
    
    for (var pattern in videoPatterns) {
      if (message.contains(pattern)) score += 0.2;
    }
    return score;
  }

  static double _checkAudioPatterns(String message) {
    double score = 0.0;
    List<String> audioPatterns = [
      'sounds like', 'voice of', 'in the voice', 'audio', 'music',
      'rhythm', 'tempo', 'melody', 'harmony'
    ];
    
    for (var pattern in audioPatterns) {
      if (message.contains(pattern)) score += 0.2;
    }
    return score;
  }

  /// Adapt the user's prompt for the specific tool
  static String _adaptPromptForTool(String originalPrompt, AiTool tool) {
    if (tool.isImageTool) {
      return _adaptForImageTool(originalPrompt, tool);
    } else if (tool.isVideoTool) {
      return _adaptForVideoTool(originalPrompt, tool);
    } else if (tool.isAudioTool) {
      return _adaptForAudioTool(originalPrompt, tool);
    }
    return originalPrompt;
  }

  static String _adaptForImageTool(String prompt, AiTool tool) {
    // Remove video/audio specific words and enhance for image generation
    String adapted = prompt
        .replaceAll(RegExp(r'\b(video|animation|movie|clip)\b', caseSensitive: false), 'image')
        .replaceAll(RegExp(r'\b(sound|audio|music)\b', caseSensitive: false), 'visual');
    
    // Add image-specific enhancements if not present
    if (!adapted.toLowerCase().contains('high quality') && 
        !adapted.toLowerCase().contains('detailed') &&
        !adapted.toLowerCase().contains('resolution')) {
      adapted += ', high quality, detailed, professional';
    }
    
    return adapted;
  }

  static String _adaptForVideoTool(String prompt, AiTool tool) {
    // Remove image-specific words and enhance for video generation
    String adapted = prompt
        .replaceAll(RegExp(r'\b(picture|photo|image)\b', caseSensitive: false), 'video');
    
    // Add video-specific enhancements
    if (!adapted.toLowerCase().contains('cinematic') && 
        !adapted.toLowerCase().contains('motion') &&
        !adapted.toLowerCase().contains('dynamic')) {
      adapted += ', cinematic, smooth motion, high quality';
    }
    
    return adapted;
  }

  static String _adaptForAudioTool(String prompt, AiTool tool) {
    // Focus on audio aspects
    String adapted = prompt;
    
    if (tool.capabilities.contains('music_generation')) {
      if (!adapted.toLowerCase().contains('bpm') && 
          !adapted.toLowerCase().contains('tempo') &&
          !adapted.toLowerCase().contains('style')) {
        adapted += ', upbeat tempo, modern style';
      }
    }
    
    return adapted;
  }

  static String _getReasonForTool(String message, AiTool tool) {
    if (tool.isImageTool) {
      return "Your message suggests image creation";
    } else if (tool.isVideoTool) {
      return "Your message indicates video generation needs";
    } else if (tool.isAudioTool) {
      return "Your message relates to audio/music creation";
    } else if (tool.isTextTool) {
      return "Your message could benefit from text enhancement";
    }
    return "This tool might be helpful for your request";
  }

  static String _getTransitionMessage(AiTool tool, double confidence) {
    if (confidence > 0.9) {
      return "🎯 Perfect match! Switching to ${tool.toolName}";
    } else if (confidence > 0.8) {
      return "✨ ${tool.toolName} looks ideal for this task";
    } else if (confidence > 0.7) {
      return "💡 ${tool.toolName} might be helpful here";
    } else {
      return "🔧 Consider using ${tool.toolName} for this";
    }
  }

  /// Check if message indicates user wants to continue with current tool
  static bool shouldContinueWithCurrentTool(String message) {
    List<String> continuationKeywords = [
      'continue', 'keep going', 'more like this', 'similar', 'another',
      'try again', 'modify', 'change', 'adjust', 'improve', 'enhance'
    ];
    
    String lowerMessage = message.toLowerCase();
    return continuationKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  /// Extract specific modifications from user message
  static Map<String, String> extractModifications(String message) {
    Map<String, String> modifications = {};
    String lowerMessage = message.toLowerCase();
    
    // Color modifications
    if (lowerMessage.contains('more colorful') || lowerMessage.contains('brighter')) {
      modifications['color'] = 'more vibrant and colorful';
    } else if (lowerMessage.contains('darker') || lowerMessage.contains('muted')) {
      modifications['color'] = 'darker and more muted tones';
    }
    
    // Style modifications  
    if (lowerMessage.contains('realistic') || lowerMessage.contains('photorealistic')) {
      modifications['style'] = 'photorealistic style';
    } else if (lowerMessage.contains('cartoon') || lowerMessage.contains('animated')) {
      modifications['style'] = 'cartoon/animated style';
    }
    
    // Size/resolution modifications
    if (lowerMessage.contains('bigger') || lowerMessage.contains('larger')) {
      modifications['size'] = 'larger resolution';
    } else if (lowerMessage.contains('smaller')) {
      modifications['size'] = 'smaller resolution';
    }
    
    return modifications;
  }
} 