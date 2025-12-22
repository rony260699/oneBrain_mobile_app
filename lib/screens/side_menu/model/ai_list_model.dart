class AiModelListing {
  String? id; // Performance optimization: unique identifier
  late String aiName;
  late String aiModelImage;
  late bool isSelected;
  late bool isWhite;
  late bool isActive;
  late bool isExpanded;
  late String description;
  late List<ChatSubModel> arrOfChatModel;

  AiModelListing({
    this.id,
    this.aiName = "",
    this.aiModelImage = "",
    this.isSelected = false,
    this.isWhite = false,
    this.isActive = false,
    this.isExpanded = false,
    this.description = "",
    this.arrOfChatModel = const [],
  }) {
    // Generate ID if not provided for performance tracking
    id ??=
        aiName.isNotEmpty
            ? aiName.toLowerCase().replaceAll(' ', '_')
            : DateTime.now().millisecondsSinceEpoch.toString();
  }

  AiModelListing.fromJson(Map<String, dynamic> json) {
    id =
        json['id'] ??
        json['aiName']?.toString().toLowerCase().replaceAll(' ', '_');
    aiName = json['aiName'] ?? "";
    aiModelImage = json['aiModelImage'] ?? "";
    isSelected = json['isSelected'] ?? false;
    isWhite = json['isWhite'] ?? false;
    isActive = json['isActive'] ?? false;
    isExpanded = json['isExpanded'] ?? false;
    description = json['description'] ?? "";
    if (json['arrOfChatModel'] != null) {
      arrOfChatModel = <ChatSubModel>[];
      json['arrOfChatModel'].forEach((v) {
        arrOfChatModel.add(ChatSubModel.fromJson(v));
      });
    } else {
      arrOfChatModel = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['aiName'] = aiName;
    data['aiModelImage'] = aiModelImage;
    data['isSelected'] = isSelected;
    data['isWhite'] = isWhite;
    data['isActive'] = isActive;
    data['isExpanded'] = isExpanded;
    data['description'] = description;
    data['arrOfChatModel'] = arrOfChatModel.map((v) => v.toJson()).toList();
    return data;
  }
}

// AI Tool model for the explore page
class AiTool {
  late String id;
  late String toolName;
  late String description;
  late String category;
  late List<String> capabilities;
  late List<String> tags;
  late Map<String, dynamic> settings;
  late String iconUrl;
  late bool isActive;
  late bool isNew;
  late bool isPro;
  late bool isSelected;
  late List<PromptTemplate> promptTemplates;

  AiTool({
    this.id = "",
    this.toolName = "",
    this.description = "",
    this.category = "",
    this.capabilities = const [],
    this.tags = const [],
    this.settings = const {},
    this.iconUrl = "",
    this.isActive = false,
    this.isNew = false,
    this.isPro = false,
    this.isSelected = false,
    this.promptTemplates = const [],
  }) {
    // Generate ID if not provided
    if (id.isEmpty && toolName.isNotEmpty) {
      id = toolName.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_');
    }
    // Generate tags from capabilities for backward compatibility
    if (tags.isEmpty && capabilities.isNotEmpty) {
      tags = _generateTagsFromCapabilities(capabilities);
    }
  }

  List<String> _generateTagsFromCapabilities(List<String> capabilities) {
    List<String> generatedTags = [];
    if (capabilities.contains('image_generation')) generatedTags.add('Image');
    if (capabilities.contains('video_generation')) generatedTags.add('Video');
    if (capabilities.contains('speech_synthesis') ||
        capabilities.contains('music_generation'))
      generatedTags.add('Audio');
    if (capabilities.contains('text_processing') ||
        capabilities.contains('text_humanization'))
      generatedTags.add('Text');
    if (capabilities.contains('voice_cloning')) generatedTags.add('Voice');
    if (capabilities.contains('music_generation')) generatedTags.add('Music');
    generatedTags.add('AI');
    generatedTags.add('Tool');
    return generatedTags;
  }

  factory AiTool.fromJson(Map<String, dynamic> json) {
    return AiTool(
      id: json['id'] ?? '',
      toolName: json['toolName'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      capabilities: List<String>.from(json['capabilities'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      settings: json['settings'] ?? {},
      iconUrl: json['iconUrl'] ?? '',
      isActive: json['isActive'] ?? false,
      isNew: json['isNew'] ?? false,
      isPro: json['isPro'] ?? false,
      isSelected: json['isSelected'] ?? false,
      promptTemplates: List<PromptTemplate>.from(
        json['promptTemplates']?.map((v) => PromptTemplate.fromJson(v)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'toolName': toolName,
      'description': description,
      'category': category,
      'capabilities': capabilities,
      'tags': tags,
      'settings': settings,
      'iconUrl': iconUrl,
      'isActive': isActive,
      'isNew': isNew,
      'isPro': isPro,
      'isSelected': isSelected,
      'promptTemplates': promptTemplates.map((v) => v.toJson()).toList(),
    };
  }

  AiTool copyWith({
    String? id,
    String? toolName,
    String? description,
    String? category,
    List<String>? capabilities,
    List<String>? tags,
    Map<String, dynamic>? settings,
    String? iconUrl,
    bool? isActive,
    bool? isNew,
    bool? isPro,
    bool? isSelected,
    List<PromptTemplate>? promptTemplates,
  }) {
    return AiTool(
      id: id ?? this.id,
      toolName: toolName ?? this.toolName,
      description: description ?? this.description,
      category: category ?? this.category,
      capabilities: capabilities ?? this.capabilities,
      tags: tags ?? this.tags,
      settings: settings ?? this.settings,
      iconUrl: iconUrl ?? this.iconUrl,
      isActive: isActive ?? this.isActive,
      isNew: isNew ?? this.isNew,
      isPro: isPro ?? this.isPro,
      isSelected: isSelected ?? this.isSelected,
      promptTemplates: promptTemplates ?? this.promptTemplates,
    );
  }

  // Helper methods
  bool get isImageTool => capabilities.contains('image_generation');
  bool get isVideoTool => capabilities.contains('video_generation');
  bool get isAudioTool =>
      capabilities.contains('speech_synthesis') ||
      capabilities.contains('music_generation');
  bool get isTextTool => capabilities.contains('text_processing');

  String get categoryIcon {
    if (isImageTool) return '🎨';
    if (isVideoTool) return '🎬';
    if (isAudioTool) return '🎵';
    if (isTextTool) return '📝';
    return '🔧';
  }
}

// AI Tools Data Provider
class AiToolsData {
  static List<AiTool> getAllTools() {
    return [
      AiTool(
        toolName: "ImageX",
        description:
            "Experience the most advanced image generator developed by DIGITX",
        category: "AI Tools",
        capabilities: ["image_generation", "text_to_image"],
        settings: {
          "max_resolution": "1024x1024",
          "formats": ["png", "jpg", "webp"],
        },
        iconUrl: "imageX_icon.svg",
        isNew: true,
        promptTemplates: [
          PromptTemplate(
            title: "Professional Portrait",
            description: "Create a high-quality professional portrait",
            prompt:
                "Create a professional portrait of a [person description], shot with studio lighting, clean background, high resolution, photorealistic, sharp focus",
            category: "Portrait",
            tags: ["professional", "portrait", "studio"],
          ),
          PromptTemplate(
            title: "Product Photography",
            description: "Generate stunning product images",
            prompt:
                "Create a professional product photography of [product description], clean white background, studio lighting, commercial quality, high resolution, detailed",
            category: "Product",
            tags: ["product", "commercial", "photography"],
          ),
          PromptTemplate(
            title: "Artistic Landscape",
            description: "Generate beautiful landscape artwork",
            prompt:
                "Create a breathtaking landscape of [location/scene], golden hour lighting, cinematic composition, ultra-detailed, photorealistic, 8K quality",
            category: "Landscape",
            tags: ["landscape", "artistic", "nature"],
          ),
        ],
      ),
      AiTool(
        toolName: "Flux",
        description:
            "Black Forest Labs text-to-image model suite with advanced tools like inpainting, depth mapping, and style variation",
        category: "AI Tools",
        capabilities: [
          "image_generation",
          "inpainting",
          "depth_mapping",
          "style_variation",
        ],
        settings: {
          "max_resolution": "1024x1024",
          "styles": ["realistic", "artistic", "cartoon"],
        },
        iconUrl: "flux_icon.svg",
      ),
      AiTool(
        toolName: "KlingAI",
        description:
            "AI tool that turns text or images into high-quality videos. Supports 1080p resolution and motion effects",
        category: "AI Tools",
        capabilities: ["video_generation", "text_to_video", "image_to_video"],
        settings: {"max_resolution": "1080p", "max_duration": "10s"},
        iconUrl: "kling_icon.svg",
      ),
      AiTool(
        toolName: "Veo3",
        description:
            "Experience next-generation video creation with Google's Veo3 - advanced AI video generation technology",
        category: "AI Tools",
        capabilities: ["video_generation", "high_quality_video"],
        settings: {"max_resolution": "4K", "max_duration": "60s"},
        iconUrl: "veo3_icon.svg",
        isPro: true,
      ),
      AiTool(
        toolName: "VGen",
        description:
            "Discover the cutting-edge video generation technology crafted by DIGITX",
        category: "AI Tools",
        capabilities: ["video_generation", "custom_styles"],
        settings: {"max_resolution": "1080p", "custom_styles": true},
        iconUrl: "vgen_icon.svg",
      ),
      AiTool(
        toolName: "SpeechAI",
        description:
            "Generate and manage AI-powered speech synthesis with advanced voice features",
        category: "AI Tools",
        capabilities: ["speech_synthesis", "voice_cloning", "multi_language"],
        settings: {
          "languages": ["en", "es", "fr", "de", "it"],
          "voice_types": ["male", "female", "child"],
        },
        iconUrl: "voice_icon.svg",
      ),
      AiTool(
        toolName: "UdioAI",
        description:
            "Create beautiful music with AI - from melodies to full compositions using advanced music generation",
        category: "AI Tools",
        capabilities: [
          "music_generation",
          "melody_creation",
          "full_composition",
        ],
        settings: {
          "genres": ["pop", "rock", "classical", "electronic"],
          "duration": "30s-3min",
        },
        iconUrl: "udio_icon.svg",
      ),
      AiTool(
        toolName: "Kontext Restore",
        description:
            "AI-powered image restoration and enhancement - restore old photos, remove noise, and improve image quality",
        category: "AI Tools",
        capabilities: [
          "image_restoration",
          "noise_removal",
          "quality_enhancement",
        ],
        settings: {
          "enhancement_types": ["denoise", "upscale", "colorize", "restore"],
        },
        iconUrl: "restorer_icon.svg",
      ),
      AiTool(
        toolName: "RunwayML",
        description:
            "Generate high-quality videos from text and images using Runway's advanced AI models. Create stunning motion graphics",
        category: "AI Tools",
        capabilities: ["video_generation", "motion_graphics", "text_to_video"],
        settings: {
          "styles": ["cinematic", "artistic", "realistic"],
          "motion_types": ["smooth", "dynamic", "static"],
        },
        iconUrl: "runway_icon.svg",
      ),
      AiTool(
        toolName: "Humanizer",
        description:
            "Transform AI-generated text into natural, human-like content. Make your text more engaging and authentic",
        category: "AI Tools",
        capabilities: [
          "text_humanization",
          "style_improvement",
          "authenticity_enhancement",
        ],
        settings: {
          "writing_styles": ["casual", "formal", "creative", "technical"],
          "languages": ["en", "es", "fr", "de"],
        },
        iconUrl: "humanizer_icon.svg",
      ),
    ];
  }

  static List<AiTool> getToolsByCategory(String category) {
    return getAllTools().where((tool) => tool.category == category).toList();
  }

  static List<AiTool> getToolsByTag(String tag) {
    return getAllTools()
        .where((tool) => tool.capabilities.contains(tag))
        .toList();
  }

  static List<AiTool> searchTools(String query) {
    final lowerQuery = query.toLowerCase();
    return getAllTools()
        .where(
          (tool) =>
              tool.toolName.toLowerCase().contains(lowerQuery) ||
              tool.description.toLowerCase().contains(lowerQuery) ||
              tool.capabilities.any(
                (tag) => tag.toLowerCase().contains(lowerQuery),
              ),
        )
        .toList();
  }

  static List<String> getAllCategories() {
    return getAllTools().map((tool) => tool.category).toSet().toList();
  }

  static List<String> getAllTags() {
    return getAllTools().expand((tool) => tool.capabilities).toSet().toList();
  }
}

class ChatSubModel {
  String model;
  String company;
  String provider;
  String name;
  bool isPopular;
  int tokens;

  ChatSubModel({
    required this.model,
    required this.company,
    required this.provider,
    required this.name,
    required this.isPopular,
    required this.tokens,
  });

  factory ChatSubModel.fromJson(Map<String, dynamic> json) {
    return ChatSubModel(
      model: json['model'] ?? '',
      company: json['company'] ?? '',
      provider: json['provider'] ?? '',
      name: json['name'] ?? json['model'] ?? '',
      isPopular: json['isPopular'] ?? false,
      tokens: json['tokens'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'company': company,
      'provider': provider,
      'name': name,
      'isPopular': isPopular,
      'tokens': tokens,
    };
  }
}

// New class for prompt templates
class PromptTemplate {
  final String title;
  final String description;
  final String prompt;
  final String category;
  final List<String> tags;
  final bool isPro;

  PromptTemplate({
    required this.title,
    required this.description,
    required this.prompt,
    required this.category,
    this.tags = const [],
    this.isPro = false,
  });

  factory PromptTemplate.fromJson(Map<String, dynamic> json) {
    return PromptTemplate(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      prompt: json['prompt'] ?? '',
      category: json['category'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      isPro: json['isPro'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'prompt': prompt,
      'category': category,
      'tags': tags,
      'isPro': isPro,
    };
  }
}
  