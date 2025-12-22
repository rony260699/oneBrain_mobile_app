import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SseManager<T> {
  final String endpoint;
  final T Function(dynamic)? parser;
  http.Client? _client;
  StreamController<T>? _controller;
  bool _isConnected = false;

  SseManager({required this.endpoint, this.parser});

  /// Connect and return a stream of parsed data
  Stream<T> connect() {
    _controller = StreamController<T>.broadcast(
      onListen: _startListening,
      onCancel: _stopListening,
    );
    return _controller!.stream;
  }

  void _startListening() async {
    if (_isConnected) return;

    _client = http.Client();
    try {
      final request = http.Request("GET", Uri.parse(endpoint));
      final response = await _client!.send(request);

      if (response.statusCode != 200) {
        _controller?.addError("Failed to connect: ${response.statusCode}");
        return;
      }

      _isConnected = true;

      response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .where((line) => line.startsWith("data: "))
          .map((line) => line.substring(6).trim())
          .listen(
            (raw) {
          try {
            final parsed = parser != null ? parser!(jsonDecode(raw)) : raw as T;
            _controller?.add(parsed);
          } catch (e) {
            _controller?.addError("Parsing error: $e");
          }
        },
        onError: (e) => _controller?.addError("Stream error: $e"),
        onDone: () {
          _isConnected = false;
          _controller?.close();
        },
        cancelOnError: true,
      );
    } catch (e) {
      _controller?.addError("Connection error: $e");
    }
  }

  void _stopListening() {
    _isConnected = false;
    _client?.close();
    _controller?.close();
  }

  void dispose() {
    _stopListening();
  }
}