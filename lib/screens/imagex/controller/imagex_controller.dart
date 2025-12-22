import 'dart:convert';
import 'package:OneBrain/utils/helper/dio_error_handler.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../repo_api/dio_helper.dart';
import '../../../repo_api/rest_constants.dart';
import '../models/imagex_message.dart';

class ImageXController extends GetxController {
  // Core
  final Uuid uuid = Uuid();
  final FocusNode focusNode = FocusNode();
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // User-selected images
  final int maxImages = 2;
  final RxList<XFile> selectedImages = <XFile>[].obs;

  // State
  final RxBool isGenerating = false.obs;
  final RxString selectedQuality = 'low'.obs;
  final RxString selectedSize = '1024x1024'.obs;
  final Rx<String?> conversationId = Rx<String?>(null);

  final RxList<ImageXMessageModel> messages = <ImageXMessageModel>[].obs;
  final Rx<GenerationProgress?> generationProgress = Rx<GenerationProgress?>(
    null,
  );

  // Options
  final List<Map<String, String>> availableSizes = [
    {"label": "Square (1024x1024)", "value": "1024x1024"},
    {"label": "Portrait (1024x1536)", "value": "1024x1536"},
    {"label": "Landscape (1536x1024)", "value": "1536x1024"},
  ];

  final List<Map<String, String>> availableQualities = [
    {"label": "Low", "value": "low"},
    {"label": "Medium", "value": "medium"},
    {"label": "High", "value": "high"},
  ];

  // Token costs
  final Map<String, Map<String, int>> _tokenCosts = {
    "1024x1024": {"low": 4024, "medium": 15366, "high": 61098},
    "1024x1536": {"low": 5854, "medium": 23049, "high": 91585},
    "1536x1024": {"low": 5854, "medium": 23049, "high": 91585},
  };

  int getTokenCost(String quality) =>
      _tokenCosts[selectedSize.value]?[quality] ?? 0;

  @override
  void onClose() {
    scrollController.dispose();
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  // ---------------- UI HELPERS ----------------
  void setSize(String size) {
    selectedSize.value = size;
    update();
  }

  void setQuality(String quality) {
    selectedQuality.value = quality;
    update();
  }

  bool canAddMoreImages() => selectedImages.length < maxImages;
  bool get isSendButtonActive => textController.text.trim().isNotEmpty;

  void addImage(XFile image) {
    if (canAddMoreImages()) selectedImages.add(image);
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  void clearInput() {
    textController.clear();
    selectedImages.clear();
    focusNode.unfocus();
  }

  double getBottomPadding(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 10;
  }

  void setConversationId(String? id) {
    conversationId.value = id;
    update();
  }

  // ---------------- CREATE CONVERSATION ----------------

  void handleImageSelection(dynamic result) {
    if (result == null) return;

    if (result is String) {
      if (canAddMoreImages()) selectedImages.add(XFile(result));
    } else if (result is List<String>) {
      for (final path in result) {
        if (canAddMoreImages()) {
          selectedImages.add(XFile(path));
        } else {
          break;
        }
      }
    }
    update();
  }

  Future<void> initializeConversation() async {
    final newId = uuid.v4();
    await createConversationId(conversationId: newId);
  }

  Future<String?> createConversationId({required String conversationId}) async {
    try {
      final response = await DioHelper.postData(
        isHeader: true,
        responseType: dio.ResponseType.stream,
        url: RestConstants.createImageConversation,
        headers: {'Content-Type': 'application/json'},
        data: {
          "currentModel": "imageX",
          "currentProvider": "openai",
          "conversationId": conversationId,
        },
      );

      if ((response.statusCode ?? 0) == 200) {
        setConversationId(conversationId);
        return conversationId;
      }
    } catch (e) {
      if (kDebugMode) print("❌ Conversation create error: $e");
    }
    return null;
  }

  // ---------------- SEND MESSAGE ----------------

  Future<void> sendMessage({
    required String prompt,
    List<XFile> images = const [],
  }) async {
    await generateImage(prompt: prompt, images: images);
  }

  // ---------------- MAIN GENERATE IMAGE LOGIC ----------------

  Future<void> generateImage({
    required String prompt,
    required List<XFile> images,
  }) async {
    // Add user bubble
    final userMessage = ImageXMessageModel(
      id: uuid.v4(),
      content: prompt,
      isUser: true,
      timestamp: DateTime.now(),
      userLocalImages: images.map((e) => e.path).toList(),
    );
    messages.add(userMessage);
    await scrollToBottom();

    // Bot placeholder
    final botId = uuid.v4();
    messages.add(
      ImageXMessageModel(
        id: botId,
        content: "",
        metadata: {},
        isUser: false,
        isGenerating: true,
        timestamp: DateTime.now(),
      ),
    );
    await scrollToBottom();

    isGenerating.value = true;
    generationProgress.value = GenerationProgress(
      progress: 0,
      status: "Starting...",
    );

    try {
      final formData = dio.FormData();
      formData.fields.add(MapEntry("model", "imageX"));
      formData.fields.add(MapEntry("provider", "openai"));

      for (int i = 0; i < images.length; i++) {
        final XFile img = images[i];
        if (kDebugMode) print("📤 Uploading image $i → ${img.path}");
        formData.files.add(
          MapEntry(
            "images",
            await dio.MultipartFile.fromFile(
              img.path,
              contentType: MediaType('image', 'png'),
            ),
          ),
        );
      }

      formData.fields.add(
        MapEntry(
          "mainProps",
          jsonEncode({
            "quantity": 1,
            "content": prompt,
            "size": selectedSize.value,
            "quality": selectedQuality.value,
          }),
        ),
      );
      final url = RestConstants.generateImage(conversationId.value ?? "");
      final response = await DioHelper.postData(
        url: url,
        isHeader: true,
        formData: formData,
      );
      if (response.data is String) {
        parseSSEStream(response.data, botId, prompt);
      } else if (response.data is Map<String, dynamic>) {
        applyApiChunk(botId, ImageXApiResponse.fromJson(response.data), prompt);
      }

      generationProgress.value = GenerationProgress(
        progress: 1,
        status: "Completed",
      );
      isGenerating.value = false;
      await scrollToBottom();
    } catch (e) {
      final cleanMessage = ErrorHandler.handle(e);
      if (kDebugMode) print("❌ Internal Error Log → $e");
      setBotError(botId, cleanMessage);
      isGenerating.value = false;
    }
  }

  // ---------------- SSE PARSER ----------------

  void parseSSEStream(String raw, String botId, String userPrompt) {
    final lines = raw.split("\n");

    for (final line in lines) {
      if (line.trim().isEmpty) continue;

      var jsonLine = line.trim();
      if (jsonLine.startsWith("data:")) {
        jsonLine = jsonLine.substring(5).trim();
      }

      try {
        final parsed = jsonDecode(jsonLine);
        applyApiChunk(botId, ImageXApiResponse.fromJson(parsed), userPrompt);
      } catch (_) {
        print("❌ Failed to parse SSE line: $jsonLine");
      }
    }
  }

  void applyApiChunk(String botId, ImageXApiResponse resp, String userPrompt) {
    if (resp.error != null) {
      setBotError(botId, resp.error!);
      return;
    }

    // Update progress
    final progress = resp.progress ?? 0;
    generationProgress.value = GenerationProgress(
      progress: progress.clamp(0, 1),
      status: resp.status ?? "Processing",
    );

    // Partial image update
    if (resp.partialImage != null) {
      updateBotPartial(botId, resp.partialImage!, progress);
    }

    // FINAL IMAGE HANDLING — CRITICAL
    if (resp.finalImages != null && resp.finalImages!.isNotEmpty) {
      updateBotFinal(botId, resp.finalImages!);
    }
  }

  // ---------------- BOT UPDATERS ----------------

  void updateBotPartial(String botId, String url, double progress) {
    final index = messages.indexWhere((m) => m.id == botId);
    if (index == -1) return;

    final old = messages[index];
    final newMetadata = {
      ...?old.metadata,
      "progress": progress,
      "partialImage": url,
    };

    messages[index] = old.copyWith(
      imageUrl: url,
      isGenerating: true,
      metadata: newMetadata,
      content: old.content.isEmpty ? "" : old.content,
    );

    update();
    scrollToBottom();
  }

  void updateBotFinal(String botId, List<String> urls) {
    final index = messages.indexWhere((m) => m.id == botId);
    if (index == -1) return;

    final old = messages[index];

    messages[index] = old.copyWith(
      imageUrls: urls,
      imageUrl: urls.isNotEmpty ? urls.first : null,
      isGenerating: false,
      metadata: {...?old.metadata, "finalImages": urls},
      content: old.content.isEmpty ? "Generated image completed" : old.content,
    );

    update();
  }

  void setBotError(String botId, String msg) {
    final index = messages.indexWhere((m) => m.id == botId);
    if (index == -1) return;

    final old = messages[index];

    messages[index] = old.copyWith(
      isError: true,
      content: msg,
      imageUrl: null,
      imageUrls: null,
      isGenerating: false,
      metadata: {"error": true},
    );
    update();
  }

  Future<void> scrollToBottom() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }
}

class GenerationProgress {
  final double progress;
  final String status;
  GenerationProgress({required this.progress, required this.status});
}
