import 'dart:ui';

class FolderModel {
  String? id;
  String? name;
  String? color;
  String? userId;
  bool? isCollapsed;
  int? version;
  String? createdAt;
  String? updatedAt;
  bool? isExpanded;

  FolderModel({
    this.id,
    this.name,
    this.color,
    this.userId,
    this.isCollapsed,
    this.version,
    this.createdAt,
    this.updatedAt,
    this.isExpanded,
  });

  Color? get getColor =>
      color != null
          ? Color(int.parse('0xFF${color?.substring(1) ?? "FFFFFF"}'))
          : null;

  FolderModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    color = json['color'];
    userId = json['userId'];
    isCollapsed = json['isCollapsed'];
    version = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isExpanded = json['isExpanded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['color'] = color;
    data['userId'] = userId;
    data['isCollapsed'] = isCollapsed;
    data['__v'] = version;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'FolderModel{id: $id, name: $name, color: $color, isCollapsed: $isCollapsed}';
  }
}

class FolderResponse {
  int? statusCode;
  List<FolderModel>? data;
  String? message;
  bool? success;
  Map<String, dynamic>? meta;

  FolderResponse({
    this.statusCode,
    this.data,
    this.message,
    this.success,
    this.meta,
  });

  FolderResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <FolderModel>[];
      json['data'].forEach((v) {
        data!.add(FolderModel.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
    meta =
        json['meta'] != null ? Map<String, dynamic>.from(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['success'] = success;
    data['meta'] = meta;
    return data;
  }
}
