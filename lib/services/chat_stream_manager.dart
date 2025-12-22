import 'dart:async';

/// Global singleton that manages streaming message states by chatId
class ChatStreamManager {
  static final ChatStreamManager _instance = ChatStreamManager._internal();
  factory ChatStreamManager() => _instance;
  ChatStreamManager._internal();

  final Map<String, StreamController<String>> _controllers = {};
  final Map<String, bool> _completedStreams = {};
  final Map<String, Completer<void>> _stopCompleters = {};
  final Map<String, String> _currentContent =
      {}; // Track current content for each chat

  /// Get or create a broadcast stream for a chatId
  Stream<String> getStream(String chatId) {
    return _controllers
        .putIfAbsent(chatId, () => StreamController<String>.broadcast())
        .stream;
  }

  /// Add a new chunk to the stream
  void addChunk(String chatId, String chunk) {
    if (_controllers.containsKey(chatId) && !_controllers[chatId]!.isClosed) {
      // Update the current content for this chat
      _currentContent[chatId] = (_currentContent[chatId] ?? '') + chunk;
      _controllers[chatId]!.add(chunk);
    }
  }

  /// Complete and close the stream
  void completeStream(String chatId) {
    if (_controllers.containsKey(chatId)) {
      _controllers[chatId]!.close();
      _controllers.remove(chatId);
      _completedStreams[chatId] = true;
    }
  }

  /// Check if stream is currently active (streaming)
  bool hasActiveStream(String chatId) {
    return _controllers.containsKey(chatId) && !_controllers[chatId]!.isClosed;
  }

  /// Check if stream was completed (finished streaming)
  bool isStreamCompleted(String chatId) {
    return _completedStreams.containsKey(chatId);
  }

  /// Start a new stream (clears any previous completed state)
  void startStream(String chatId) {
    _completedStreams.remove(chatId);
    _stopCompleters[chatId] = Completer<void>();
    // Controller will be created lazily in getStream()
  }

  /// Stop the current stream for a chat
  Future<void> stopStream(String chatId) async {
    if (_stopCompleters.containsKey(chatId)) {
      _stopCompleters[chatId]!.complete();
      _stopCompleters.remove(chatId);
    }
    if (_controllers.containsKey(chatId)) {
      _controllers[chatId]!.close();
      _controllers.remove(chatId);
    }
    // Don't clear current content here - it will be used by the UI
  }

  /// Get the stop future for a chat stream
  Future<void>? getStopFuture(String chatId) {
    return _stopCompleters[chatId]?.future;
  }

  /// Get the current content of a stream
  String getCurrentContent(String chatId) {
    return _currentContent[chatId] ?? '';
  }

  /// Clean up all streams (useful for app disposal)
  void dispose() {
    for (final controller in _controllers.values) {
      if (!controller.isClosed) {
        controller.close();
      }
    }
    for (final completer in _stopCompleters.values) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }
    _controllers.clear();
    _completedStreams.clear();
    _stopCompleters.clear();
    _currentContent.clear();
  }

  /// Remove completed stream state (for cleanup)
  void clearCompletedState(String chatId) {
    _completedStreams.remove(chatId);
  }
}
