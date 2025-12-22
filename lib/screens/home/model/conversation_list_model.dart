class ConversationListModel {
  ConversationListModel({required this.date, required this.arrOfConversations});

  final String date;
  final List<ConversationListModelData> arrOfConversations;
}

class ConversationListModelData {
  ConversationListModelData({
    required this.id,
    required this.conversationId,
    required this.title,
    required this.updatedAt,
    required this.isSelected,
  });

  final String id;
  final String conversationId;
  final String title;
  final DateTime? updatedAt;
  late bool isSelected;

  factory ConversationListModelData.fromJson(Map<String, dynamic> json) {
    return ConversationListModelData(
      id: json["_id"] ?? "",
      conversationId: json["conversationId"] ?? json["_id"],
      title: json["title"] ?? "",
      isSelected: false,
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "conversationId": conversationId,
    "title": title,
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
