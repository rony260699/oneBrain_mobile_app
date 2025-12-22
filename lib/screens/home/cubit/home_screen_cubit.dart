import 'dart:math';
import 'package:OneBrain/models/ai_model.dart';
import 'package:OneBrain/models/attachment_model.dart';
import 'package:OneBrain/models/chart_model.dart';
import 'package:OneBrain/models/message_model.dart';
import 'package:OneBrain/services/ai_model_service.dart';
import 'package:OneBrain/services/profile_service.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../../common_widgets/app_utils.dart';
import '../../../repo_api/dio_helper.dart';
import '../../../repo_api/rest_constants.dart';
import '../../../repo_api/stream_post_service.dart';
import '../../side_menu/model/ai_list_model.dart';
import '../../../utils/ai_tool_intent_detector.dart';
import '../model/conversation_list_model.dart';
import 'home_screen_states.dart';
import '../../../services/chat_stream_manager.dart';
import '../../../services/slack_notification_service.dart';

class HomeScreenCubit extends Cubit<HomeScreenStates> {
  HomeScreenCubit() : super(HomeScreenInitialState());

  // bool isHomeScreenInitialized = false;

  List<Chat>? chats;
  String? currentChatID;
  bool isThinking = false;
  bool isListening = false;
  String recognizedText = '';
  bool isGeneratingMessage = false;
  String? currentGeneratingMessageId;
  StreamSubscription? _messageStreamSubscription;
  final stt.SpeechToText _speech = stt.SpeechToText();
  static HomeScreenCubit get(context) => BlocProvider.of(context);
  bool stopGeneration = false; // Flag to signal generation should stop
  StringBuffer? _currentMessageBuffer; // Track current message content
  http.Client? _currentHttpClient; // Track current HTTP client for cancellation
  Map<String, List<Chat>> get getChatsByDateTag {
    Map<String, List<Chat>> chatsByDateTag = {};

    List<String> dateTags =
        (chats?.map((chat) => chat.dateTag).toList() ?? [])
            .whereType<String>()
            .toList()
            .reversed
            .toList();

    for (String dateTag in dateTags) {
      chatsByDateTag[dateTag] =
          chats
              ?.where((chat) => chat.dateTag == dateTag)
              .toList()
              .reversed
              .toList() ??
          [];
    }

    return chatsByDateTag;
  }

  bool isScrollable = false;

  List<Attachments> selectedAttachments = [];

  clearCubit() {
    chatMessages.clear();
    currentChatID = null;
    txtMessage.clear();
    focusMessage.unfocus();
    selectedAttachments.clear();
    chats?.clear();
    deepSearchStatus = false;
    reasoningStatus = false;
  }

  List<Message> chatMessages = [];
  final TextEditingController txtMessage = TextEditingController();
  final FocusNode focusMessage = FocusNode();
  // bool reasoningStatus = false;
  bool deepSearchStatus = false;

  ValueNotifier<bool> isMessageGenerating = ValueNotifier<bool>(false);

  /// AI Tool Integration
  List<ToolSuggestion> currentToolSuggestions = [];
  bool showToolSuggestions = false;
  AiTool? currentActiveTool;
  bool isTransitioningToTool = false;
  String? lastUserMessage;
  String currentLocale = "en_US"; // ✅ Default: English

  /// Tool Context Management
  Map<String, String> toolContext = {}; // Store context for each tool
  String? pendingToolSwitch; // Tool ID waiting to be activated

  bool isLoadingAttachments = false;

  bool isPrivateVisibility = false;
  bool reasoningStatus = false;

  // Edit message state
  bool isEditingMessage = false;
  Message? messageBeingEdited;

  /// Dismiss tool suggestions
  void dismissToolSuggestions() {
    showToolSuggestions = false;
    currentToolSuggestions.clear();
    emit(HomeScreenToolSuggestionsDismissed());
  }

  /// Remove an attachment by index
  void removeAttachment(int index) {
    if (index >= 0 && index < selectedAttachments.length) {
      final removedFile = selectedAttachments.removeAt(index);
      if (kDebugMode) {
        print("🗑️ Removed attachment: ${removedFile.localPath}");
        print("📎 Remaining attachments: ${selectedAttachments.length}");
      }
      emit(HomeScreenSuccessState());
    }
  }

  /// Clear all attachments
  void clearAttachments() {
    selectedAttachments.clear();
    // parsedAttachments.clear();
    isLoadingAttachments = false;
    if (kDebugMode) {
      print("🧹 Cleared all attachments");
    }
    emit(HomeScreenSuccessState());
  }

  List<ConversationListModel> groupConversationsByDate(List<dynamic> jsonList) {
    final List<ConversationListModelData> conversations =
        jsonList.map((e) => ConversationListModelData.fromJson(e)).toList();

    if (conversations.isNotEmpty) {}

    final Map<String, List<ConversationListModelData>> groupedMap = {};

    for (var convo in conversations) {
      final dateKey =
          convo.updatedAt != null
              ? "${convo.updatedAt!.year}-${convo.updatedAt!.month.toString().padLeft(2, '0')}-${convo.updatedAt!.day.toString().padLeft(2, '0')}"
              : "Unknown";

      if (!groupedMap.containsKey(dateKey)) {
        groupedMap[dateKey] = [];
      }
      groupedMap[dateKey]!.add(convo);
    }

    final List<ConversationListModel> groupedList =
        groupedMap.entries.map((entry) {
          return ConversationListModel(
            date: entry.key,
            arrOfConversations: entry.value,
          );
        }).toList();

    // Optional: Sort by date descending
    groupedList.sort((a, b) => b.date.compareTo(a.date));

    return groupedList;
  }

  Future<void> getAllChats() async {
    emit(HomeScreenConversationLoadingState());
    // try {
    final value = await DioHelper.getData(
      url: "${RestConstants.chatUserHistory}?limit=50",
      isHeader: true,
    );
    // txtMessage.clear();

    if ((value.statusCode ?? 0) == 201) {
      if (value.data["data"] is List) {
        List<Chat> chatsData =
            value.data["data"].map<Chat>((e) => Chat.fromJson(e)).toList();

        chats = chatsData.reversed.toList();
      }
      emit(HomeScreenConversationSuccessState());
    } else {
      emit(HomeScreenErrorState(value.data["message"]));
    }
    // } catch (error) {
    //   emit(HomeScreenErrorState(error.toString()));
    // }
  }

  /// Preload a single conversation in background
  Future<List<Message>?> getChatMessages(String conversationId) async {
    try {
      final value = await DioHelper.getData(
        url: "${RestConstants.chat}/$conversationId/messages",
        isHeader: true,
      );

      if ((value.statusCode ?? 0) == 201) {
        if (value.data["data"] is List) {
          List<Message> messages =
              value.data["data"]
                  .map<Message>((e) => Message.fromJson(e))
                  .toList();

          return messages;
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print("⚠️ Failed to preload conversation $conversationId: $error");
      }
    }
    return null;
  }

  Future<void> sendMessageAPI(String message) async {
    try {
      late String offset = getFormattedTimezoneOffset();
      late Map<String, dynamic> data = {
        "message": message,
        "timezoneOffset": offset,
      };
      final value = await DioHelper.postData(
        url: RestConstants.sendMessage,
        isHeader: true,
        data: data,
      );

      if ((value.statusCode ?? 0) == 201) {
        if (value.data["data"] is Map) {
          print("Response Data: ${value.data["data"]}");
        }
        emit(HomeScreenSuccessState());
      } else {
        emit(HomeScreenErrorState(value.data["message"]));
      }
    } catch (error) {
      emit(HomeScreenErrorState(error.toString()));
    }
  }

  void toggleLanguage() {
    if (currentLocale == "en_US") {
      currentLocale = "bn_BD";
    } else {
      currentLocale = "en_US";
    }

    emit(HomeScreenLanguageChanged(currentLocale));
  }

  Future<void> toggleVoiceListening() async {
    if (!isListening) {
      // 🟢 Start listening
      bool available = await _speech.initialize(
        onError: (error) {
          isListening = false;
          emit(HomeScreenVoiceError("Speech error: $error"));
        },
      );

      if (available) {
        isListening = true;
        emit(HomeScreenVoiceListening());

        _speech.listen(
          localeId: currentLocale,
          partialResults: true,
          onResult: (result) {
            recognizedText = result.recognizedWords;
            txtMessage.text = recognizedText;
            txtMessage.selection = TextSelection.fromPosition(
              TextPosition(offset: txtMessage.text.length),
            );
            emit(HomeScreenVoiceRecognized(recognizedText));
          },
        );
      } else {
        emit(HomeScreenVoiceError("Speech recognition not available"));
      }
    } else {
      await stopVoiceListening();
    }
  }

  /// Stop completely when user presses button
  Future<void> stopVoiceListening() async {
    await _speech.stop();

    isListening = false;

    // ✅ Final update before clearing
    if (recognizedText.isNotEmpty) {
      txtMessage.text = recognizedText;
      txtMessage.selection = TextSelection.fromPosition(
        TextPosition(offset: txtMessage.text.length),
      );
    }

    emit(HomeScreenVoiceStopped());

    // ✅ Clear after completion
    recognizedText = "";
  }

  String generateTimestamp() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }

  String? activeMessageId;
  void setThinking(bool value) {
    isThinking = value;
    emit(HomeScreenThinkingChanged(value));
  }

  void sendMessage({
    required String message,
    required Function onSuccess,
    String? editMessageId,
  }) async {
    // bool isExistingChat = currentChatID != null;

    String chatId = currentChatID ?? Uuid().v4();
    currentChatID = chatId;

    // Reset stop flag at the start of new message generation
    stopGeneration = false;

    emit(HomeScreenStartStreaming());

    AIModel? defaultModel = AIModelService.defaultModel;
    String messageIDForAssistant = Uuid().v4();
    String messageIDForUser = Uuid().v4();
    List<Attachments> attachments = List.from(selectedAttachments);

    // 🧍‍♂️ Add User message
    chatMessages.add(
      Message(
        iV: 0,
        role: "user",
        chatId: chatId,
        sId: messageIDForUser,
        attachments: attachments,
        model: defaultModel?.name,
        provider: defaultModel?.provider,
        parts: [
          {"type": "text", "text": message},
        ],
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
    );
    emit(ChatMessageAdded());
    txtMessage.clear();
    clearAttachments();
    // ✨ Show shimmer instantly
    isThinking = true;
    emit(HomeScreenThinkingChanged(isThinking));
    var newMessage = StringBuffer();
    _currentMessageBuffer =
        newMessage; // Track the buffer for stop functionality
    isGeneratingMessage = true;
    // Set the current generating message ID
    currentGeneratingMessageId = messageIDForAssistant;
    // Start global stream
    ChatStreamManager().startStream(chatId);
    // Add placeholder assistant message
    chatMessages.add(
      Message(
        sId: messageIDForAssistant,
        chatId: chatId,
        model: defaultModel?.name,
        provider: defaultModel?.provider,
        role: "assistant",
        parts: [
          {"type": "text", "text": newMessage.toString()},
        ],
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        iV: 0,
        isGenerating: true,
        messageStream: ChatStreamManager().getStream(chatId),
      ),
    );
    emit(ChatMessageAdded());
    await ProfileService.getCurrentUser();

    final stream = StreamPostService().sendMessage(
      message: message,
      id: chatId,
      aiModel: defaultModel,
      reasoningStatus: reasoningStatus,
      isPrivateVisibility: isPrivateVisibility,
      attachments: attachments,
      editMessageId: editMessageId ?? messageIDForUser,
    );

    // bool isUserAtBottom = true;

    Completer<void> completer = Completer<void>();

    // Store the subscription so we can cancel it later
    _messageStreamSubscription?.cancel();
    _messageStreamSubscription = stream.listen(
      (chunk) async {
        // Check if stop was requested - if so, IMMEDIATELY ignore new chunks
        if (stopGeneration) {
          if (kDebugMode) print('⏸️ Ignoring chunk - stop requested');
          return; // Don't process this chunk at all
        }

        // if (chunk.startsWith("MESSAGEID-")) {
        //   final messageId = chunk.split("-").last;

        //   final localId = messageIDForUser;

        //   chatMessages.firstWhere((message) => message.sId == localId).sId =
        //       messageId;
        //   return;
        // }

        newMessage.write(chunk);
        ChatStreamManager().addChunk(chatId, chunk);

        // 👇 Hide shimmer 2 seconds after first chunk arrives
        if (newMessage.length > 1) {
          isThinking = false;
          emit(HomeScreenThinkingChanged(isThinking));
        }
      },
      onError: (error) async {
        activeMessageId = null;
        isMessageGenerating.value = false;
        isGeneratingMessage = false;
        currentGeneratingMessageId = null;
        stopGeneration = false;
        _currentHttpClient = null;
        _currentMessageBuffer = null;

        int assistantMessageIndex = chatMessages.indexWhere(
          (message) => message.sId == messageIDForAssistant,
        );
        if (assistantMessageIndex != -1)
          chatMessages.removeAt(assistantMessageIndex);

        int userMessageIndex = chatMessages.indexWhere(
          (message) => message.sId == messageIDForUser,
        );
        if (userMessageIndex != -1) {
          Message? userMessage = chatMessages[userMessageIndex];
          txtMessage.text = userMessage.parts?.firstOrNull?["text"] ?? "";
          selectedAttachments.addAll(List.from(userMessage.attachments ?? []));
          chatMessages.removeAt(userMessageIndex);
        }

        showError(message: error.message ?? "Something went wrong");

        // Trigger Slack notification for free model failures
        try {
          final slackService = SlackNotificationService();
          final String errorMsg = error.message?.toLowerCase() ?? '';

          // Check if error is cap-related or model error
          final bool isKeywordCapError =
              errorMsg.contains('cap') ||
              errorMsg.contains('quota') ||
              errorMsg.contains('limit') ||
              errorMsg.contains('rate limit exceeded') ||
              errorMsg.contains('429');

          final bool isStatusCapError =
              error is DioException && error.response?.statusCode == 429;

          final bool isCapError = isKeywordCapError || isStatusCapError;

          final SlackNotificationType notificationType =
              isCapError
                  ? SlackNotificationType.capExceeded
                  : SlackNotificationType.modelError;

          // Get model name
          final String modelName = defaultModel?.name ?? 'Unknown Model';

          // Send Slack notification
          await slackService.triggerSlackNotification(
            type: notificationType,
            modelName: modelName,
            errorMessage: error.message,
          );

          if (kDebugMode) {
            print(
              'Slack notification triggered for chat failure: $notificationType',
            );
          }
        } catch (notifyErr) {
          // Ensure notification failure doesn't block main flow
          if (kDebugMode) {
            print('Failed to trigger Slack notification: $notifyErr');
          }
        }

        emit(HomeScreenStreamError(error.toString()));
        completer.completeError(error);
      },
      onDone: () {
        activeMessageId = null;
        isMessageGenerating.value = false;
        isGeneratingMessage = false;
        currentGeneratingMessageId = null;
        stopGeneration = false;
        _currentHttpClient = null;
        _currentMessageBuffer = null;
        _messageStreamSubscription = null;

        ChatStreamManager().completeStream(chatId);

        try {
          chatMessages.firstWhere((m) => m.sId == messageIDForAssistant)
            ..model = defaultModel?.name
            ..provider = defaultModel?.provider
            ..isGenerating = false
            ..parts = [
              {"type": "text", "text": newMessage.toString()},
            ]
            ..messageStream = null
            ..updatedAt = DateTime.now().toIso8601String()
            ..createdAt = DateTime.now().toIso8601String();
        } catch (e) {
          if (kDebugMode) print("Error updating message: $e");
        }

        // onSuccess();
        emit(HomeScreenStreamCompleted());
        completer.complete();
      },
    );

    completer.future.then((value) async {
      await ProfileService.getChatStatistics();
      emit(ChatStatisticsUpdated());
      onSuccess();
    });

    isMessageGenerating.value = true;
  }

  // Helper method to handle attachment selection result
  Future<void> handleAttachmentResult(dynamic result) async {
    isLoadingAttachments = true;
    emit(HomeScreenLoadingState());

    try {
      List<String> selectedFiles = [];
      if (result is String) {
        selectedFiles.add(result);
      } else if (result is List) {
        for (var file in result) {
          if (file is String) {
            selectedFiles.add(file);
          }
        }
      }

      if (selectedFiles.isEmpty) {
        return;
      }

      FormData formData = FormData.fromMap({
        'files':
            (await Future.wait(
              selectedFiles.map(
                (e) => MultipartFile.fromFile(e, filename: e.split('/').last),
              ),
            )).toList(),
      });

      Response response = await DioHelper.postData(
        url: RestConstants.baseUrl + RestConstants.parseAttachmentsPreview,
        formData: formData,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> json = response.data;
        AttachmentModel attachmentModel = AttachmentModel.fromJson(
          json['data'],
        );
        for (Attachments attachment in attachmentModel.attachments ?? []) {
          for (var file in selectedFiles) {
            if (attachment.originalName == file.split('/').last) {
              attachment.localPath = file;
            }
          }
        }
        selectedAttachments.addAll(attachmentModel.attachments ?? []);
      }
    } catch (e) {
      print("Error parsing attachments: $e");
    }

    isLoadingAttachments = false;
    emit(HomeScreenSuccessState());
  }

  static List<String> greetingTexts = [
    "Let's Explore",
    "What's on your mind?",
    "Ready to Create?",
    "Let's Build Something",
    "Ask me anything",
    "Ready to Discover?",
    "Let's Get Started",
    "What shall we explore?",
    "Time to Innovate",
    "Ready for AI Magic?",
    "Let's Chat",
    "Your AI Journey Begins",
    "Ready to Learn?",
    "Let's Make Ideas Reality",
    "Adventure Awaits",
    "Ready to Solve?",
    "Let's Think Together",
    "What's Next?",
    "Ready to Transform?",
    "Let's Brainstorm",
  ];

  String? randomGreeting;
  String? randomPlaceholder;

  String get getGreeting => randomGreeting ?? greetingTexts.first;
  List<String> creativePlaceholders = [
    "Send a message...",
    "What's on your mind, {username}?",
    "ask me anything!, {username}",
    "Share your thoughts, {username}...",
    "let's explore together!, {username}",
    "What can I help you with today, {username}?",
    "ready to create something amazing?, {username}",
    "Tell me what you're thinking, {username}...",
    "let's brainstorm!, {username}",
    "What would you like to discover, {username}?",
    "I'm here to help!, {username}",
    "Share your ideas with me, {username}...",
    " what shall we build today?, {username}",
    "Got a question, {username}?",
    "let's turn ideas into reality!, {username}",
    "What's your next move, {username}?",
    "ready for some AI magic?, {username}",
    "Tell me your vision, {username}...",
    "let's solve something together!, {username}",
    "What inspires you today, {username}?",
  ];

  List<String> creativePlaceholdersBn = [
    "একটি বার্তা পাঠান...",
    "তোমার মনে কি আছে?, {username}?",
    "আমাকে কিছু জিজ্ঞাসা করুন!, {username}",
    "আপনার চিন্তা শেয়ার করুন, {username}...",
    "চলো একসাথে ঘুরে দেখি!, {username}",
    "আজ আমি তোমাকে কী সাহায্য করতে পারি?, {username}?",
    "অসাধারণ কিছু তৈরি করতে প্রস্তুত?, {username}",
    "তুমি কি ভাবছো বলো।, {username}...",
    "চলো চিন্তাভাবনা করি!, {username}",
    "তুমি কী আবিষ্কার করতে চাও?, {username}?",
    "আমি সাহায্য করতে এসেছি!, {username}",
    "তোমার আইডিয়াগুলো আমার সাথে শেয়ার করো।, {username}...",
    " আজ আমরা কী তৈরি করব?, {username}",
    "একটি প্রশ্ন আছে, {username}?",
    "আসুন ধারণাগুলিকে বাস্তবে রূপান্তরিত করি!, {username}",
    "তোমার পরবর্তী পদক্ষেপ কী?, {username}?",
    "কিছু AI জাদুর জন্য প্রস্তুত?, {username}",
    "আমাকে আপনার দৃষ্টি বলুন, {username}...",
    "চলো একসাথে কিছু একটা সমাধান করি!, {username}",
    "আজ তোমাকে কী অনুপ্রাণিত করে?, {username}?",
  ];
  String getPlaceholder() {
    return randomPlaceholder ?? creativePlaceholders.first;
  }

  String getPlaceholderBn() {
    return randomPlaceholder ?? creativePlaceholdersBn.first;
  }

  String getRandomGreeting() {
    int randomIndex = Random().nextInt(greetingTexts.length);
    return greetingTexts[randomIndex];
  }

  String getRandomPlaceholder() {
    int randomIndex = Random().nextInt(creativePlaceholders.length);
    return creativePlaceholders[randomIndex];
  }

  String getRandomPlaceholderBn() {
    int randomIndex = Random().nextInt(creativePlaceholdersBn.length);
    return creativePlaceholdersBn[randomIndex];
  }

  /// Stop the currently generating message and preserve the partial response
  /// Implements immediate cancellation of HTTP request and stream
  Future<void> stopGenerating() async {
    if (currentGeneratingMessageId == null) return;

    try {
      // 1. FIRST - Set stop flag to true IMMEDIATELY to block any incoming chunks
      stopGeneration = true;
      final String stoppedMessageId = currentGeneratingMessageId!;

      if (kDebugMode) print('🛑 Stop button pressed - canceling request...');

      // 2. IMMEDIATELY capture partial content BEFORE any cleanup
      final currentContent = _currentMessageBuffer?.toString() ?? '';

      if (kDebugMode) {
        print('📝 Captured partial content: ${currentContent.length} chars');
        if (currentContent.isNotEmpty) {
          print(
            '📝 Preview: ${currentContent.substring(0, currentContent.length > 100 ? 100 : currentContent.length)}...',
          );
        }
      }

      // 3. IMMEDIATELY cancel stream subscription to stop receiving chunks
      await _messageStreamSubscription?.cancel();
      _messageStreamSubscription = null;

      if (kDebugMode) print('⚙️ Stream subscription canceled');

      // 4. Cancel HTTP client to stop the request at network level
      _currentHttpClient?.close();
      _currentHttpClient = null;

      if (kDebugMode) print('🌐 HTTP client closed');

      // 5. Get the current message being generated
      final index = chatMessages.indexWhere((m) => m.sId == stoppedMessageId);

      if (index != -1) {
        final message = chatMessages[index];
        final streamManager = ChatStreamManager();

        // 6. Stop the stream in the manager
        await streamManager.stopStream(stoppedMessageId);

        // 7. Create updated parts with the CAPTURED partial content
        List<dynamic> updatedParts = [];
        bool hasTextPart = false;

        // Check if there's already a text part to update
        if (message.parts != null) {
          for (var part in message.parts!) {
            if (part is Map && part['type'] == 'text') {
              updatedParts.add({
                'type': 'text',
                'text':
                    currentContent.isNotEmpty
                        ? currentContent
                        : (part['text'] ?? ''),
              });
              hasTextPart = true;
            } else {
              updatedParts.add(part);
            }
          }
        }

        // If no text part was found, add one with the current content
        if (!hasTextPart && currentContent.isNotEmpty) {
          updatedParts.add({'type': 'text', 'text': currentContent});
        }

        // 8. Update the message with the partial content and mark as stopped
        chatMessages[index] = message.copyWith(
          parts: updatedParts.isNotEmpty ? updatedParts : message.parts,
          isGenerating: false,
          messageStream: null,
          updatedAt: DateTime.now().toIso8601String(),
        );

        if (kDebugMode) {
          print('✅ Message updated with partial content');
        }

        // 9. Emit state to indicate generation was stopped (for cleanup, hide stop button)
        emit(HomeScreenMessageGenerationStopped());

        // 10. Emit success state to update UI with partial response
        emit(HomeScreenSuccessState());
      } else {
        // If message not found, just clean up
        await ChatStreamManager().stopStream(stoppedMessageId);

        emit(HomeScreenMessageGenerationStopped());
        emit(HomeScreenSuccessState());
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error stopping generation: $e');
      // Ensure we clean up even if there's an error
      _currentHttpClient?.close();
      _currentHttpClient = null;
      await _messageStreamSubscription?.cancel();
      _messageStreamSubscription = null;
      if (currentGeneratingMessageId != null) {
        await ChatStreamManager().stopStream(currentGeneratingMessageId!);
      }

      emit(HomeScreenMessageGenerationStopped());
      emit(HomeScreenSuccessState());
    } finally {
      // 11. Reset all state flags
      stopGeneration = false;
      currentGeneratingMessageId = null;
      isGeneratingMessage = false;
      isMessageGenerating.value = false;
      isThinking = false;
      _currentHttpClient = null;
      _currentMessageBuffer = null; // Clear the buffer reference
      emit(HomeScreenThinkingChanged(isThinking));

      if (kDebugMode) print('🏁 Stop generation complete - UI updated');
    }
  }

  void startNewChat() {
    isBtnVisible = false;
    selectedAttachments.clear();
    chatMessages.clear();
    currentChatID = null;
    currentLocale = "en_US";
    txtMessage.clear();
    randomGreeting = getRandomGreeting();
    randomPlaceholder = getRandomPlaceholder();
    cancelEditMode();
  }

  /// Enter edit mode for a message
  void enterEditMode(Message message) {
    String messageText = "";
    for (var part in message.parts ?? []) {
      if (part["type"] == "text") {
        messageText = part["text"] ?? "";
        break;
      }
    }

    isEditingMessage = true;
    messageBeingEdited = message;
    txtMessage.text = messageText;
    emit(HomeScreenEditModeEntered());
  }

  /// Cancel edit mode
  void cancelEditMode() {
    isEditingMessage = false;
    messageBeingEdited = null;
    txtMessage.clear();
    emit(HomeScreenEditModeCancelled());
  }

  /// Delete trailing messages starting from a specific message
  Future<bool> deleteTrailingMessages(String messageId) async {
    try {
      final value = await DioHelper.dio.delete(
        "${RestConstants.chat}/$currentChatID/messages/trailing",
        data: {"messageId": messageId},
        options: Options(extra: {'header': true}),
      );

      if ((value.statusCode ?? 0) == 200 || (value.statusCode ?? 0) == 201) {
        return true;
      }
      return false;
    } catch (error) {
      if (kDebugMode) print("Error deleting trailing messages: $error");
      return false;
    }
  }

  bool isLoadingChat = false;
  bool isBtnVisible = false;
  Future<void> switchChat(String? chatId) async {
    if (chatId == null) return;
    print("🎯 Switching to chat: $chatId");
    currentLocale = "en_US";

    isLoadingChat = true;
    emit(HomeScreenSwitchLoadingState());

    chatMessages = (await getChatMessages(chatId)) ?? [];
    currentChatID = chatId;

    emit(ChatSwitched());

    await Future.delayed(const Duration(milliseconds: 1000));

    isLoadingChat = false;
    emit(ChatLoaded());
  }
}
