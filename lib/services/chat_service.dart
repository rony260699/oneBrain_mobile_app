import 'package:OneBrain/repo_api/dio_helper.dart';
import 'package:OneBrain/repo_api/rest_constants.dart';
import 'package:OneBrain/services/profile_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  static String? activeChatId;

  static Future<void> sendMessage({required String message}) async {
    if (activeChatId == null) {
      await ChatRepository.createNewChat(title: message);
    }
  }
}

class ChatRepository {
  static Uuid uuid = Uuid();

  static Future<void> createNewChat({required String title}) async {
    String uniqueId = uuid.v4();
    Map<String, dynamic> data = {
      "id": uniqueId,
      "title": title,
      "visibility": "private",
    };
    print("Data: $data");
    Response response = await DioHelper.postData(
      url: RestConstants.createNewChat,
      data: data,
      isHeader: true,
    );
    print(response.data);
  }

  static Future<void> sendMessage({required String message}) async {
    if (kDebugMode) {
      print("🚀 message: '$message'");
    }
    await ProfileService.getCurrentUser();
  }
}
