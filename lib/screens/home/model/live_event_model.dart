class LiveEvent {
  final String message;

  LiveEvent({required this.message});

  factory LiveEvent.fromJson(Map<String, dynamic> json) {
    return LiveEvent(message: json['message']);
  }

  @override
  String toString() => message;
}
