class UsageHistoryResponse {
  bool? success;
  List<UsageHistoryItem>? data;
  Pagination? pagination;

  UsageHistoryResponse({
    this.success,
    this.data,
    this.pagination,
  });

  UsageHistoryResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <UsageHistoryItem>[];
      json['data'].forEach((v) {
        data!.add(UsageHistoryItem.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class UsageHistoryItem {
  String? id;
  String? userId;
  String? service;
  String? action;
  String? model;
  String? provider;
  int? inputTokens;
  int? outputTokens;
  int? totalTokens;
  int? platformTokensDeducted;
  UsageMetadata? metadata;
  String? chatId;
  String? messageId;
  int? remainingTokens;
  String? status;
  String? createdAt;
  String? updatedAt;

  UsageHistoryItem({
    this.id,
    this.userId,
    this.service,
    this.action,
    this.model,
    this.provider,
    this.inputTokens,
    this.outputTokens,
    this.totalTokens,
    this.platformTokensDeducted,
    this.metadata,
    this.chatId,
    this.messageId,
    this.remainingTokens,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String get formattedDateTime {
    if (createdAt == null) return '';
    try {
      DateTime date = DateTime.parse(createdAt!).toLocal();
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
      final minute = date.minute.toString().padLeft(2, '0');
      final amPm = date.hour >= 12 ? 'PM' : 'AM';
      return '${months[date.month - 1]} ${date.day}, $hour:$minute $amPm';
    } catch (e) {
      return '';
    }
  }

  String get formattedTokens {
    if (platformTokensDeducted == null) return '0';
    if (platformTokensDeducted! >= 1000) {
      final value = platformTokensDeducted! / 1000;
      return '${value.toStringAsFixed(1)}K';
    }
    return '$platformTokensDeducted';
  }

  UsageHistoryItem.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    service = json['service'];
    action = json['action'];
    model = json['model'];
    provider = json['provider'];
    inputTokens = json['inputTokens'];
    outputTokens = json['outputTokens'];
    totalTokens = json['totalTokens'];
    platformTokensDeducted = json['platformTokensDeducted'];
    metadata = json['metadata'] != null
        ? UsageMetadata.fromJson(json['metadata'])
        : null;
    chatId = json['chatId'];
    messageId = json['messageId'];
    remainingTokens = json['remainingTokens'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['userId'] = userId;
    data['service'] = service;
    data['action'] = action;
    data['model'] = model;
    data['provider'] = provider;
    data['inputTokens'] = inputTokens;
    data['outputTokens'] = outputTokens;
    data['totalTokens'] = totalTokens;
    data['platformTokensDeducted'] = platformTokensDeducted;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['chatId'] = chatId;
    data['messageId'] = messageId;
    data['remainingTokens'] = remainingTokens;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class UsageMetadata {
  String? service;
  String? action;
  String? timestamp;
  String? chatId;
  bool? reasoningEnabled;
  int? messageCount;
  bool? hasAttachments;
  String? messageId;
  String? originalProvider;
  String? originalModel;
  String? changedProvider;
  String? changedModel;
  bool? isFreeModel;

  UsageMetadata({
    this.service,
    this.action,
    this.timestamp,
    this.chatId,
    this.reasoningEnabled,
    this.messageCount,
    this.hasAttachments,
    this.messageId,
    this.originalProvider,
    this.originalModel,
    this.changedProvider,
    this.changedModel,
    this.isFreeModel,
  });

  UsageMetadata.fromJson(Map<String, dynamic> json) {
    service = json['service'];
    action = json['action'];
    timestamp = json['timestamp'];
    chatId = json['chatId'];
    reasoningEnabled = json['reasoningEnabled'];
    messageCount = json['messageCount'];
    hasAttachments = json['hasAttachments'];
    messageId = json['messageId'];
    originalProvider = json['originalProvider'];
    originalModel = json['originalModel'];
    changedProvider = json['changedProvider'];
    changedModel = json['changedModel'];
    isFreeModel = json['isFreeModel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service'] = service;
    data['action'] = action;
    data['timestamp'] = timestamp;
    data['chatId'] = chatId;
    data['reasoningEnabled'] = reasoningEnabled;
    data['messageCount'] = messageCount;
    data['hasAttachments'] = hasAttachments;
    data['messageId'] = messageId;
    data['originalProvider'] = originalProvider;
    data['originalModel'] = originalModel;
    data['changedProvider'] = changedProvider;
    data['changedModel'] = changedModel;
    data['isFreeModel'] = isFreeModel;
    return data;
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Pagination({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    return data;
  }
}
