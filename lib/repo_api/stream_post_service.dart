import 'dart:convert';
import 'dart:developer';
import 'package:OneBrain/models/ai_model.dart';
import 'package:OneBrain/models/message_model.dart';
import 'package:OneBrain/repo_api/rest_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/shared_preference_util.dart';

class StreamPostService {
  static final StreamPostService _instance = StreamPostService._internal();

  factory StreamPostService() => _instance;

  StreamPostService._internal();

  late Uri _apiUrl;

  void initialize(String url) {
    _apiUrl = Uri.parse(url);
    if (kDebugMode) {
      print("[StreamPostService] Initialized with URL: $_apiUrl");
    }
  }

  Future<String> getToken() async {
    final token = SharedPreferenceUtil.getUserData()?.accessToken ?? "";
    final accessToken = 'Bearer $token';
    if (kDebugMode) log("Authorization $accessToken");
    return accessToken;
  }

  String getAccessToken() {
    return SharedPreferenceUtil.getUserData()?.accessToken ?? "";
  }

  Stream<String> sendMessage({
    required String message,
    required String id,
    required bool reasoningStatus,
    required bool isPrivateVisibility,
    String? editMessageId,
    AIModel? aiModel,
    List<Attachments>? attachments,
  }) async* {
    String model = aiModel?.model ?? "";
    String provider = aiModel?.provider ?? "";
    print("-------------------------------------------------");
    print("-------------------------------------------------Model $model");
    print(
      "-------------------------------------------------Provider $provider",
    );
    print("-------------------------------------------------");

    // try {
    List<Map<String, dynamic>> aiParts = [];

    // Add attachment content first
    for (var attachment in attachments ?? []) {
      if (attachment.content != null) {
        aiParts.add({'type': 'text', 'text': attachment.content});
      }
    }

    aiParts.add({'type': 'text', 'text': message});

    // Prepare database message (only user input)
    List<Map<String, dynamic>> dbParts = [
      {'type': 'text', 'text': message},
    ];

    List<Map<String, dynamic>> messageAttachments = [];
    for (var attachment in attachments ?? []) {
      messageAttachments.add({
        'id': attachment.id,
        'name': attachment.name,
        'originalName': attachment.originalName ?? attachment.name,
        'contentType': attachment.contentType,
        'size': attachment.size,
        'url': attachment.url,
        'metadata': {
          'fileType': attachment.metadata?.fileType ?? 'unknown',
          'isProcessed': attachment.metadata?.isProcessed ?? false,
          'processingTime': attachment.metadata?.processingTime ?? 0,
          'processingMethod':
              attachment.metadata?.processingMethod ?? 'traditional',
        },
        'preview': {
          'isImage': attachment.contentType?.startsWith('image/') ?? false,
          'isDocument': attachment.contentType?.contains('pdf') ?? false,
          'isArchive': attachment.contentType?.contains('zip') ?? false,
          'isCode': attachment.contentType?.contains('javascript') ?? false,
        },
      });
    }

    var headers = {
      'Authorization': await getToken(),
      'Content-Type': 'application/json',
      'Accept': 'text/event-stream',
      'x-platform': 'mobile',
    };

    var request = http.Request(
      'POST',
      Uri.parse('${RestConstants.baseUrl}${RestConstants.chat}'),
    );

    // List<Map<String, dynamic>> aiParts = [];

    // String messageId = Uuid().v4();
    // String? model = AIModelService.defaultModel?.model;
    // String? model = null;

    // request.body = json.encode({
    //   "id": id,
    //   "message": {
    //     "id": messageId,
    //     "parts": [
    //       for (Attachments item in attachments ?? [])
    //         {"type": "text", "text": item.content},
    //       {"type": "text", "text": message},
    //     ],
    //     "role": "user",
    //   },
    //   "selectedChatModel": aiModel?.model,
    //   "selectedVisibilityType": isPrivateVisibility ? "private" : "public",
    //   "reasoningEnabled": reasoningStatus,
    //   "attachments": attachments?.map((e) => e.toJson()).toList(),
    // });

    // print("selectedChatModel ${aiModel?.model}");

    request.body = json.encode({
      'id': id, // Your chat ID
      'message': {
        if (editMessageId != null) 'id': editMessageId,
        '_parsedContent': aiParts, // Full content for AI processing
        'attachments': messageAttachments, // Attachment metadata
        'metadata': {
          // 'model': aiModel?.model,
          // 'provider': aiModel?.provider,
          // 'reasoningEnabled': reasoningStatus,
          'model': model,
          'provider': provider,
          'reasoningEnabled': false,
        },
        'parts': dbParts, // Only user message for database
        'role': 'user',
      },
      'selectedChatModel': model,
      // 'selectedChatModel': 'claude-haiku-4-5-20251001',
      'selectedVisibilityType': isPrivateVisibility ? 'private' : 'public',
      'reasoningEnabled': reasoningStatus,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (kDebugMode) {
      print("[StreamPostService] Response status: ${response.statusCode}");
    }

    if (response.statusCode == 200) {
      print("[StreamPostService] Response status: ${response.statusCode}");
      await for (var chunk in response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (chunk.trim().isEmpty || !chunk.startsWith("data:")) continue;

        final raw = chunk.substring(5).trim();

        if (raw == "[DONE]") {
          if (kDebugMode) print("Stream ended with [DONE]");
          return;
        }

        // try {
        final parsed = json.decode(raw);

        if (parsed is Map<String, dynamic>) {
          switch (parsed["type"]) {
            case "error":
              throw Exception(
                parsed["data"]?["message"] ?? "Something went wrong",
              );

            // case "start":
            //   final delta = parsed["messageId"];
            //   if (delta != null && delta.toString().isNotEmpty) {
            //     yield "MESSAGEID-${delta.toString()}";
            //   }
            //   break;

            case "text-delta":
              final delta = parsed["delta"];
              if (delta != null && delta.toString().isNotEmpty) {
                yield delta.toString();
              }
              break;

            case "data-codeDelta":
              final text = parsed["data"];
              if (text != null && text.toString().isNotEmpty) {
                yield text.toString();
              }
              break;

            default:
              final content = parsed["content"];
              if (content != null && content.toString().isNotEmpty) {
                yield content.toString();
              }
          }
        }
        // } catch (e) {
        //   if (kDebugMode) {
        //     print("⚠️ JSON parsing failed: $e");
        //     print("Raw data: $raw");
        //   }
        //   throw Exception(e);
        // }
      }

      // Decode the response stream line by line
      // await for (var chunk in response.stream.transform(utf8.decoder)) {
      //   for (final line in LineSplitter().convert(chunk)) {
      //     if (line.trim().isEmpty) continue;
      //     if (!line.startsWith("data:")) continue;

      //     final raw = line.substring(5).trim(); // remove "data:"

      //     if (raw == "[DONE]") {
      //       if (kDebugMode) print("Stream ended with [DONE].");
      //       return; // stop streaming
      //     }

      //     // try {
      //     final parsed = json.decode(raw);

      //     if (parsed is Map<String, dynamic>) {
      //       // Handle SSE delta response
      //       if (parsed["type"] == "error") {
      //         throw Exception(
      //           parsed["data"]?["message"] ?? "Something went wrong",
      //         );
      //       }
      //       if (parsed["type"] == "text-delta") {
      //         final delta = parsed["delta"];
      //         if (delta != null && delta.toString().isNotEmpty) {
      //           yield delta.toString(); // emit incremental content
      //         }
      //       } else if (parsed["type"] == "data-codeDelta") {
      //         final text = parsed["data"];
      //         if (text != null && text.toString().isNotEmpty) {
      //           yield text.toString();
      //         }
      //       }
      //       // Fallback: if backend sends whole content instead of deltas
      //       else if (parsed.containsKey("content")) {
      //         final content = parsed["content"];
      //         if (content != null && content.toString().isNotEmpty) {
      //           yield content.toString();
      //         }
      //       }
      //     }
      //     // } catch (e) {
      //     //   if (kDebugMode) {
      //     //     print("JSON parsing failed: $e");
      //     //     print("Raw data: $raw");
      //     //   }
      //     // }
      //   }
      // }

      if (kDebugMode) {
        print("Streaming completed successfully.");
      }
    } else {
      final errorBody = await response.stream.bytesToString();
      if (kDebugMode) {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        print("Error body: $errorBody");
      }
      throw Exception(
        'Failed to get stream: ${response.statusCode} - ${response.reasonPhrase}',
      );
    }
    // } catch (e, stackTrace) {
    //   if (kDebugMode) {
    //     print("Exception: $e");
    //     print("StackTrace: $stackTrace");
    //   }
    //   rethrow;
    // } finally {
    //   if (kDebugMode) {
    //     print("HTTP client closed.");
    //   }
    // }
  }

  // Deprecated methods - keeping for backward compatibility but redirecting to new method
  // @deprecated
  // Stream<String> postAndListenAsJson(Map<String, dynamic> body) async* {
  //   if (kDebugMode) {
  //     print(
  //       "[StreamPostService] DEPRECATED: postAndListenAsJson called, redirecting to sendMessage",
  //     );
  //   }
  //   yield* sendMessage(
  //     message: body['message'] ?? '',
  //     timezoneOffset: body['timezoneOffset'] ?? '-04:00',
  //     model: body['model'],
  //     company: body['company'],
  //     reasoningStatus: body['reasoningStatus']?.toString(),
  //     deepSearchStatus: body['deepSearchStatus']?.toString(),
  //   );
  // }

  // @deprecated
  // Stream<String> postAndListenAsForm(
  //   Map<String, dynamic> body, {
  //   List<File>? files,
  // }) async* {
  //   if (kDebugMode) {
  //     print(
  //       "[StreamPostService] DEPRECATED: postAndListenAsForm called, redirecting to sendMessage",
  //     );
  //   }
  //   yield* sendMessage(
  //     message: body['message'] ?? body['content'] ?? '',
  //     timezoneOffset: body['timezoneOffset'] ?? '-04:00',
  //     model: body['model'],
  //     company: body['company'],
  //     reasoningStatus: body['reasoningStatus']?.toString(),
  //     deepSearchStatus: body['deepSearchStatus']?.toString(),
  //     attachments: files,
  //   );
  // }
}
