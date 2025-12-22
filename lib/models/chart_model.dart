import 'package:intl/intl.dart';

class Chat {
  String? id;
  String? title;
  String? userId;
  String? visibility;
  String? folderId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? dateTag;

  Chat({
    this.id,
    this.title,
    this.userId,
    this.visibility,
    this.folderId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    userId = json['userId'];
    visibility = json['visibility'];
    folderId = json['folderId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    dateTag = formatDateTextFromString(json);
  }

  String formatDateTextFromString(Map<String, dynamic> json) {
    String dateString = json['createdAt'];

    String dateTag = "";

    print("createdAtt: $dateString");

    try {
      // Adjust the format to match your actual input format
      DateTime date = DateFormat("yyyy-MM-dd").parse(dateString);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final inputDate = DateTime(date.year, date.month, date.day);

      final difference = today.difference(inputDate).inDays;

      if (difference == 0) {
        dateTag = "Today";
      } else if (difference == 1) {
        dateTag = "Yesterday";
      } else {
        dateTag = DateFormat('dd MMM, yyyy').format(date);
      }
    } catch (e) {
      print("Error: $e : $dateString");
      dateTag = "Invalid Date";
    }

    print("dateTag: $dateTag");

    return dateTag;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['title'] = title;
    data['userId'] = userId;
    data['visibility'] = visibility;
    data['folderId'] = folderId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['dateTag'] = dateTag;
    return data;
  }
}
