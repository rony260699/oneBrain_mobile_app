// class SingleConversationModel {
//   SingleConversationModel({
//     required this.saveDetails,
//     required this.id,
//     required this.conversationId,
//     required this.owner,
//     required this.currentModel,
//     required this.currentProvider,
//     required this.title,
//     required this.messages,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });

//   final SaveDetails? saveDetails;
//   final String id;
//   late String conversationId;
//   final String owner;
//   final String currentModel;
//   final String currentProvider;
//   final String title;
//   late List<ConversationMessage> messages = [];
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final int v;

//   factory SingleConversationModel.fromJson(Map<String, dynamic> json) {
//     return SingleConversationModel(
//       saveDetails: json["save_details"] == null ? null : SaveDetails.fromJson(json["save_details"]),
//       id: json["_id"] ?? "",
//       conversationId: json["conversationId"] ?? "",
//       owner: json["owner"] ?? "",
//       currentModel: json["currentModel"] ?? "",
//       currentProvider: json["currentProvider"] ?? "",
//       title: json["title"] ?? "",
//       messages:
//           json["messages"] == null
//               ? []
//               : List<ConversationMessage>.from(json["messages"]!.map((x) => ConversationMessage.fromJson(x))),
//       createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
//       updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
//       v: json["__v"] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     "save_details": saveDetails?.toJson(),
//     "_id": id,
//     "conversationId": conversationId,
//     "owner": owner,
//     "currentModel": currentModel,
//     "currentProvider": currentProvider,
//     "title": title,
//     "messages": messages.map((x) => x?.toJson()).toList(),
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "__v": v,
//   };
// }

// class ConversationMessage {
//   ConversationMessage({
//     required this.content,
//     required this.webSearchResults,
//     required this.isUser,
//     required this.provider,
//     required this.model,
//     required this.role,
//     required this.forPro,
//     required this.attachments,
//     required this.images,
//     required this.id,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.reasoning,
//     required this.taskId,
//     required this.generationId,
//   });

//   late String content;
//   final dynamic webSearchResults;
//   late bool isUser;
//   late String provider;
//   late String model;
//   late String role;
//   final bool forPro;
//   final List<dynamic> attachments;
//   final List<dynamic> images;
//   late String id;
//   late bool isMessageRunning = false;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final String reasoning;
//   final dynamic taskId;
//   final dynamic generationId;
//   late bool isNeConversation = false;

//   factory ConversationMessage.fromJson(Map<String, dynamic> json) {
//     return ConversationMessage(
//       content: json["content"] ?? "",
//       webSearchResults: json["webSearchResults"],
//       isUser: json["isUser"] ?? false,
//       provider: json["provider"] ?? "",
//       model: json["model"] ?? "",
//       role: json["role"] ?? "",
//       forPro: json["forPro"] ?? false,
//       attachments: json["attachments"] == null ? [] : List<dynamic>.from(json["attachments"]!.map((x) => x)),
//       images: json["images"] == null ? [] : List<dynamic>.from(json["images"]!.map((x) => x)),
//       id: json["_id"] ?? "",
//       createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
//       updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
//       reasoning: json["reasoning"] ?? "",
//       taskId: json["taskId"],
//       generationId: json["generationId"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     "content": content,
//     "webSearchResults": webSearchResults,
//     "isUser": isUser,
//     "provider": provider,
//     "model": model,
//     "role": role,
//     "forPro": forPro,
//     "attachments": attachments.map((x) => x).toList(),
//     "images": images.map((x) => x).toList(),
//     "_id": id,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "reasoning": reasoning,
//     "taskId": taskId,
//     "generationId": generationId,
//   };
// }

// class SaveDetails {
//   SaveDetails({required this.isSaved});

//   final bool isSaved;

//   factory SaveDetails.fromJson(Map<String, dynamic> json) {
//     return SaveDetails(isSaved: json["is_saved"] ?? false);
//   }

//   Map<String, dynamic> toJson() => {"is_saved": isSaved};
// }
