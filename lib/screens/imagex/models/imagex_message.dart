class ImageXMessageModel {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? userLocalImages;
  final String? imageUrl;
  final List<String>? imageUrls;
  final bool isGenerating;
  final bool isError;
  final Map<String, dynamic>? metadata;

  ImageXMessageModel({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.userLocalImages,
    this.imageUrl,
    this.imageUrls,
    this.isGenerating = false,
    this.isError = false,
    this.metadata,
  });

  ImageXMessageModel copyWith({
    String? id,
    bool? isUser,
    String? content,
    DateTime? timestamp,
    List<String>? userLocalImages,
    String? imageUrl,
    List<String>? imageUrls,
    bool? isGenerating,
    bool? isError,
    Map<String, dynamic>? metadata,
  }) {
    return ImageXMessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      userLocalImages: userLocalImages ?? this.userLocalImages,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      isGenerating: isGenerating ?? this.isGenerating,
      isError: isError ?? this.isError,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get hasTextContent => content.trim().isNotEmpty;
  bool get hasLocalImages =>
      userLocalImages != null && userLocalImages!.isNotEmpty;
  bool get hasSingleImage =>
      imageUrl != null && (imageUrls == null || imageUrls!.isEmpty);
  bool get hasMultipleImages => imageUrls != null && imageUrls!.isNotEmpty;
}

class ImageXApiResponse {
  final bool? generatingImage;
  final double? progress;
  final String? partialImage;
  final List<String>? finalImages;
  final String? revisedPrompt;
  final String? status;
  final String? error;

  ImageXApiResponse({
    this.generatingImage,
    this.progress,
    this.partialImage,
    this.finalImages,
    this.revisedPrompt,
    this.status,
    this.error,
  });

  factory ImageXApiResponse.fromJson(Map<String, dynamic> json) {
    return ImageXApiResponse(
      generatingImage: json["generatingImage"],
      progress: (json["progress"] ?? 0).toDouble(),
      partialImage: json["partialImage"],
      finalImages:
          json["images"] != null
              ? (json["images"] as List).map((e) => e["url"] as String).toList()
              : null,
      revisedPrompt:
          json["images"] != null && (json["images"] as List).isNotEmpty
              ? json["images"][0]["revisedPrompt"]
              : null,
      status: json["status"],
      error: json["error"],
    );
  }
}
