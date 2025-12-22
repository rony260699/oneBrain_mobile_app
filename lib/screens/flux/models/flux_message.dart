import 'package:flutter/material.dart';

enum FluxMessageStatus {
  pending,
  generating,
  completed,
  error,
}

class FluxMessage {
  final String id;
  final String prompt;
  final bool isUser;
  final DateTime timestamp;
  final String model;
  final String style;
  final String aspectRatio;
  final int steps;
  final double guidanceScale;
  final FluxMessageStatus status;
  final String? imageUrl;
  final String? error;
  final String? generationTime;
  final Map<String, dynamic>? metadata;

  FluxMessage({
    required this.id,
    required this.prompt,
    required this.isUser,
    required this.timestamp,
    required this.model,
    required this.style,
    required this.aspectRatio,
    required this.steps,
    required this.guidanceScale,
    this.status = FluxMessageStatus.pending,
    this.imageUrl,
    this.error,
    this.generationTime,
    this.metadata,
  });

  FluxMessage copyWith({
    String? id,
    String? prompt,
    bool? isUser,
    DateTime? timestamp,
    String? model,
    String? style,
    String? aspectRatio,
    int? steps,
    double? guidanceScale,
    FluxMessageStatus? status,
    String? imageUrl,
    String? error,
    String? generationTime,
    Map<String, dynamic>? metadata,
  }) {
    return FluxMessage(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      model: model ?? this.model,
      style: style ?? this.style,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      steps: steps ?? this.steps,
      guidanceScale: guidanceScale ?? this.guidanceScale,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      error: error ?? this.error,
      generationTime: generationTime ?? this.generationTime,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'model': model,
      'style': style,
      'aspectRatio': aspectRatio,
      'steps': steps,
      'guidanceScale': guidanceScale,
      'status': status.toString(),
      'imageUrl': imageUrl,
      'error': error,
      'generationTime': generationTime,
      'metadata': metadata,
    };
  }

  factory FluxMessage.fromJson(Map<String, dynamic> json) {
    return FluxMessage(
      id: json['id'],
      prompt: json['prompt'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      model: json['model'],
      style: json['style'],
      aspectRatio: json['aspectRatio'],
      steps: json['steps'],
      guidanceScale: json['guidanceScale'].toDouble(),
      status: FluxMessageStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => FluxMessageStatus.pending,
      ),
      imageUrl: json['imageUrl'],
      error: json['error'],
      generationTime: json['generationTime'],
      metadata: json['metadata'],
    );
  }

  String get statusDisplayText {
    switch (status) {
      case FluxMessageStatus.pending:
        return 'Pending...';
      case FluxMessageStatus.generating:
        return 'Generating image...';
      case FluxMessageStatus.completed:
        return generationTime != null ? 'Generated in $generationTime' : 'Generated';
      case FluxMessageStatus.error:
        return error ?? 'Generation failed';
    }
  }

  Color get statusColor {
    switch (status) {
      case FluxMessageStatus.pending:
        return Colors.orange;
      case FluxMessageStatus.generating:
        return Colors.blue;
      case FluxMessageStatus.completed:
        return Colors.green;
      case FluxMessageStatus.error:
        return Colors.red;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case FluxMessageStatus.pending:
        return Icons.schedule;
      case FluxMessageStatus.generating:
        return Icons.sync;
      case FluxMessageStatus.completed:
        return Icons.check_circle;
      case FluxMessageStatus.error:
        return Icons.error;
    }
  }

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get hasError => status == FluxMessageStatus.error;
  bool get isGenerating => status == FluxMessageStatus.generating;
  bool get isCompleted => status == FluxMessageStatus.completed;

  String get formattedTimestamp {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String get settingsDisplayText {
    return '$model • $style • $aspectRatio • ${steps} steps • CFG: ${guidanceScale.toStringAsFixed(1)}';
  }
} 