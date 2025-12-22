import 'package:flutter/material.dart';
import '../models/flux_message.dart';

class FluxProvider with ChangeNotifier {
  List<FluxMessage> _messages = [];
  bool _isGenerating = false;
  String _selectedModel = 'flux-pro';
  String _selectedStyle = 'realistic';
  String _aspectRatio = '1:1';
  int _steps = 30;
  double _guidanceScale = 7.5;

  // Available Flux models
  static const List<String> availableModels = ['flux-pro', 'flux-pro-1.1'];

  // Available styles
  static const List<String> availableStyles = [
    'realistic',
    'artistic',
    'cartoon',
    'cinematic',
    'fantasy',
    'abstract',
  ];

  // Available aspect ratios
  static const List<String> availableAspectRatios = [
    '1:1',
    '16:9',
    '9:16',
    '3:2',
    '2:3',
  ];

  // Getters
  List<FluxMessage> get messages => _messages;
  bool get isGenerating => _isGenerating;
  String get selectedModel => _selectedModel;
  String get selectedStyle => _selectedStyle;
  String get aspectRatio => _aspectRatio;
  int get steps => _steps;
  double get guidanceScale => _guidanceScale;

  // Methods
  void addMessage(FluxMessage message) {
    _messages.insert(0, message);
    notifyListeners();
  }

  void updateMessage(String messageId, FluxMessage updatedMessage) {
    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _messages[index] = updatedMessage;
      notifyListeners();
    }
  }

  void removeMessage(String messageId) {
    _messages.removeWhere((msg) => msg.id == messageId);
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  void setGenerating(bool generating) {
    _isGenerating = generating;
    notifyListeners();
  }

  void setSelectedModel(String model) {
    if (availableModels.contains(model)) {
      _selectedModel = model;
      notifyListeners();
    }
  }

  void setSelectedStyle(String style) {
    if (availableStyles.contains(style)) {
      _selectedStyle = style;
      notifyListeners();
    }
  }

  void setAspectRatio(String ratio) {
    if (availableAspectRatios.contains(ratio)) {
      _aspectRatio = ratio;
      notifyListeners();
    }
  }

  void setSteps(int newSteps) {
    _steps = newSteps.clamp(10, 100);
    notifyListeners();
  }

  void setGuidanceScale(double scale) {
    _guidanceScale = scale.clamp(1.0, 20.0);
    notifyListeners();
  }

  Future<void> generateImage({
    required String prompt,
    String? model,
    String? aspectRatio,
    int? steps,
    double? guidanceScale,
    List<dynamic>? images,
  }) async {
    if (_isGenerating) return;

    // Use provided parameters or fall back to current settings
    final useModel = model ?? _selectedModel;
    final useAspectRatio = aspectRatio ?? _aspectRatio;
    final useSteps = steps ?? _steps;
    final useGuidanceScale = guidanceScale ?? _guidanceScale;

    setGenerating(true);

    // Create user message
    final userMessage = FluxMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      prompt: prompt,
      isUser: true,
      timestamp: DateTime.now(),
      model: useModel,
      style: _selectedStyle,
      aspectRatio: useAspectRatio,
      steps: useSteps,
      guidanceScale: useGuidanceScale,
    );

    addMessage(userMessage);

    // Create generating message
    final generatingMessage = FluxMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString() + '_gen',
      prompt: prompt,
      isUser: false,
      timestamp: DateTime.now(),
      model: useModel,
      style: _selectedStyle,
      aspectRatio: useAspectRatio,
      steps: useSteps,
      guidanceScale: useGuidanceScale,
      status: FluxMessageStatus.generating,
    );

    addMessage(generatingMessage);

    try {
      // Simulate image generation (replace with actual API call)
      await Future.delayed(Duration(seconds: 3));

      // Update with generated image
      final completedMessage = generatingMessage.copyWith(
        status: FluxMessageStatus.completed,
        imageUrl:
            'https://picsum.photos/512/512?random=${DateTime.now().millisecondsSinceEpoch}',
        generationTime: '3.2s',
      );

      updateMessage(generatingMessage.id, completedMessage);
    } catch (error) {
      // Handle error
      final errorMessage = generatingMessage.copyWith(
        status: FluxMessageStatus.error,
        error: error.toString(),
      );

      updateMessage(generatingMessage.id, errorMessage);
    }

    setGenerating(false);
  }

  String getModelDisplayName(String model) {
    switch (model) {
      case 'flux-pro':
        return 'Flux Pro';
      case 'flux-pro-1.1':
        return 'Flux Pro 1.1';
      default:
        return model;
    }
  }

  Color getModelColor(String model) {
    switch (model) {
      case 'flux-pro':
        return Color(0xFF3B82F6);
      case 'flux-pro-1.1':
        return Color(0xFF7C3AED);
      default:
        return Color(0xFF6B7280);
    }
  }

  IconData getStyleIcon(String style) {
    switch (style) {
      case 'realistic':
        return Icons.photo_camera;
      case 'artistic':
        return Icons.palette;
      case 'cartoon':
        return Icons.emoji_emotions;
      case 'cinematic':
        return Icons.movie;
      case 'fantasy':
        return Icons.auto_fix_high;
      case 'abstract':
        return Icons.blur_on;
      default:
        return Icons.image;
    }
  }
}
