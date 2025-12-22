class Message {
  Metadata? metadata;
  String? sId;
  int? iV;
  List<Attachments>? attachments;
  String? chatId;
  String? createdAt;
  List<dynamic>? parts;
  String? role;
  String? updatedAt;
  String? model;
  String? provider;
  bool? isGenerating;
  Stream<String>? messageStream;

  Message({
    this.metadata,
    this.sId,
    this.iV,
    this.attachments,
    this.chatId,
    this.createdAt,
    this.parts,
    this.role,
    this.updatedAt,
    this.model,
    this.provider,
    this.isGenerating,
    this.messageStream,
  });

  Message.fromJson(Map<String, dynamic> json) {
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    sId = json['_id'];
    iV = json['__v'];
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    }
    chatId = json['chatId'];
    createdAt = json['createdAt'];
    parts = json['parts'];
    // if (json['parts'] != null) {
    //   parts = <Parts>[];
    //   json['parts'].forEach((v) {
    //     parts!.add(Parts.fromJson(v));
    //   });
    // }
    role = json['role'];
    updatedAt = json['updatedAt'];

    model = json['metadata']['model'];
    provider = json['metadata']['provider'];
    isGenerating = json['isGenerating'] ?? false;
    messageStream = json['messageStream'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['_id'] = sId;
    data['__v'] = iV;
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    data['chatId'] = chatId;
    data['createdAt'] = createdAt;
    data['parts'] = parts;
    data['role'] = role;
    data['updatedAt'] = updatedAt;
    data['model'] = model;
    data['provider'] = provider;
    data['isGenerating'] = isGenerating;
    data['messageStream'] = messageStream;
    return data;
  }

  /// Creates a copy of this message with the given fields replaced by the new values
  Message copyWith({
    Metadata? metadata,
    String? sId,
    int? iV,
    List<Attachments>? attachments,
    String? chatId,
    String? createdAt,
    List<dynamic>? parts,
    String? role,
    String? updatedAt,
    String? model,
    String? provider,
    bool? isGenerating,
    Stream<String>? messageStream,
  }) {
    return Message(
      metadata: metadata ?? this.metadata,
      sId: sId ?? this.sId,
      iV: iV ?? this.iV,
      attachments: attachments ?? this.attachments,
      chatId: chatId ?? this.chatId,
      createdAt: createdAt ?? this.createdAt,
      parts: parts ?? this.parts,
      role: role ?? this.role,
      updatedAt: updatedAt ?? this.updatedAt,
      model: model ?? this.model,
      provider: provider ?? this.provider,
      isGenerating: isGenerating ?? this.isGenerating,
      messageStream: messageStream ?? this.messageStream,
    );
  }
}

class Metadata {
  TokenUsage? tokenUsage;
  String? model;
  String? provider;
  bool? reasoningEnabled;

  Metadata({this.tokenUsage, this.model, this.provider, this.reasoningEnabled});

  Metadata.fromJson(Map<String, dynamic> json) {
    tokenUsage =
        json['tokenUsage'] != null
            ? TokenUsage.fromJson(json['tokenUsage'])
            : null;
    model = json['model'];
    provider = json['provider'];
    reasoningEnabled = json['reasoningEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tokenUsage != null) {
      data['tokenUsage'] = tokenUsage!.toJson();
    }
    data['model'] = model;
    data['provider'] = provider;
    data['reasoningEnabled'] = reasoningEnabled;
    return data;
  }
}

class TokenUsage {
  CostBreakdown? costBreakdown;
  int? inputTokens;
  int? outputTokens;
  int? totalTokens;
  int? platformTokensDeducted;
  int? totalServicesUsed;
  int? totalPlatformTokensDeducted;
  List<Services>? services;
  String? lastUpdated;

  TokenUsage({
    this.costBreakdown,
    this.inputTokens,
    this.outputTokens,
    this.totalTokens,
    this.platformTokensDeducted,
    this.totalServicesUsed,
    this.totalPlatformTokensDeducted,
    this.services,
    this.lastUpdated,
  });

  TokenUsage.fromJson(Map<String, dynamic> json) {
    costBreakdown =
        json['costBreakdown'] != null
            ? CostBreakdown.fromJson(json['costBreakdown'])
            : null;
    inputTokens = json['inputTokens'];
    outputTokens = json['outputTokens'];
    totalTokens = json['totalTokens'];
    platformTokensDeducted = json['platformTokensDeducted'];
    totalServicesUsed = json['totalServicesUsed'];
    totalPlatformTokensDeducted = json['totalPlatformTokensDeducted'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    lastUpdated = json['lastUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (costBreakdown != null) {
      data['costBreakdown'] = costBreakdown!.toJson();
    }
    data['inputTokens'] = inputTokens;
    data['outputTokens'] = outputTokens;
    data['totalTokens'] = totalTokens;
    data['platformTokensDeducted'] = platformTokensDeducted;
    data['totalServicesUsed'] = totalServicesUsed;
    data['totalPlatformTokensDeducted'] = totalPlatformTokensDeducted;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    data['lastUpdated'] = lastUpdated;
    return data;
  }
}

class CostBreakdown {
  int? chatTokens;
  int? documentTokens;
  int? toolTokens;
  int? suggestionTokens;
  int? otherTokens;

  CostBreakdown({
    this.chatTokens,
    this.documentTokens,
    this.toolTokens,
    this.suggestionTokens,
    this.otherTokens,
  });

  CostBreakdown.fromJson(Map<String, dynamic> json) {
    chatTokens = json['chatTokens'];
    documentTokens = json['documentTokens'];
    toolTokens = json['toolTokens'];
    suggestionTokens = json['suggestionTokens'];
    otherTokens = json['otherTokens'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatTokens'] = chatTokens;
    data['documentTokens'] = documentTokens;
    data['toolTokens'] = toolTokens;
    data['suggestionTokens'] = suggestionTokens;
    data['otherTokens'] = otherTokens;
    return data;
  }
}

class Services {
  String? service;
  String? action;
  String? model;
  String? provider;
  int? inputTokens;
  int? outputTokens;
  int? platformTokensDeducted;
  ServicesMetadata? metadata;
  String? sId;
  String? timestamp;

  Services({
    this.service,
    this.action,
    this.model,
    this.provider,
    this.inputTokens,
    this.outputTokens,
    this.platformTokensDeducted,
    this.metadata,
    this.sId,
    this.timestamp,
  });

  Services.fromJson(Map<String, dynamic> json) {
    service = json['service'];
    action = json['action'];
    model = json['model'];
    provider = json['provider'];
    inputTokens = json['inputTokens'];
    outputTokens = json['outputTokens'];
    platformTokensDeducted = json['platformTokensDeducted'];
    metadata =
        json['metadata'] != null
            ? ServicesMetadata.fromJson(json['metadata'])
            : null;
    sId = json['_id'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service'] = service;
    data['action'] = action;
    data['model'] = model;
    data['provider'] = provider;
    data['inputTokens'] = inputTokens;
    data['outputTokens'] = outputTokens;
    data['platformTokensDeducted'] = platformTokensDeducted;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['_id'] = sId;
    data['timestamp'] = timestamp;
    return data;
  }
}

class ServicesMetadata {
  bool? reasoningEnabled;
  int? messageCount;
  bool? hasAttachments;

  ServicesMetadata({
    this.reasoningEnabled,
    this.messageCount,
    this.hasAttachments,
  });

  ServicesMetadata.fromJson(Map<String, dynamic> json) {
    reasoningEnabled = json['reasoningEnabled'];
    messageCount = json['messageCount'];
    hasAttachments = json['hasAttachments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reasoningEnabled'] = reasoningEnabled;
    data['messageCount'] = messageCount;
    data['hasAttachments'] = hasAttachments;
    return data;
  }
}

class Attachments {
  String? id;
  String? name;
  String? originalName;
  String? contentType;
  String? content;
  int? size;
  String? url;
  AttachmentsMetadata? metadata;
  Preview? preview;
  String? localPath;

  Attachments({
    this.id,
    this.name,
    this.originalName,
    this.contentType,
    this.size,
    this.url,
    this.metadata,
    this.preview,
    this.localPath,
  });

  Attachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    originalName = json['originalName'];
    contentType = json['contentType'];
    content = json['content'];
    size = json['size'];
    url = json['url'];
    metadata =
        json['metadata'] != null
            ? AttachmentsMetadata.fromJson(json['metadata'])
            : null;
    preview =
        json['preview'] != null ? Preview.fromJson(json['preview']) : null;
    localPath = json['localPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['originalName'] = originalName;
    data['contentType'] = contentType;
    data['content'] = content;
    data['size'] = size;
    data['url'] = url;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    if (preview != null) {
      data['preview'] = preview!.toJson();
    }
    data['localPath'] = localPath;
    return data;
  }
}

class AttachmentsMetadata {
  String? fileType;
  bool? isProcessed;
  int? processingTime;
  String? processingMethod;

  AttachmentsMetadata({
    this.fileType,
    this.isProcessed,
    this.processingTime,
    this.processingMethod,
  });

  AttachmentsMetadata.fromJson(Map<String, dynamic> json) {
    fileType = json['fileType'];
    isProcessed = json['isProcessed'];
    processingTime = json['processingTime'];
    processingMethod = json['processingMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileType'] = fileType;
    data['isProcessed'] = isProcessed;
    data['processingTime'] = processingTime;
    data['processingMethod'] = processingMethod;
    return data;
  }
}

class Preview {
  bool? isImage;
  bool? isDocument;
  bool? isArchive;
  bool? isCode;

  Preview({this.isImage, this.isDocument, this.isArchive, this.isCode});

  Preview.fromJson(Map<String, dynamic> json) {
    isImage = json['isImage'];
    isDocument = json['isDocument'];
    isArchive = json['isArchive'];
    isCode = json['isCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isImage'] = isImage;
    data['isDocument'] = isDocument;
    data['isArchive'] = isArchive;
    data['isCode'] = isCode;
    return data;
  }
}

// class Parts {
//   String? type;
//   String? text;
//   ProviderMetadata? providerMetadata;
//   String? state;

//   Parts({this.type, this.text, this.providerMetadata, this.state});

//   Parts.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     text = json['text'];
//     providerMetadata =
//         json['providerMetadata'] != null
//             ? ProviderMetadata.fromJson(json['providerMetadata'])
//             : null;
//     state = json['state'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['type'] = type;
//     data['text'] = text;
//     if (providerMetadata != null) {
//       data['providerMetadata'] = providerMetadata!.toJson();
//     }
//     data['state'] = state;
//     return data;
//   }
// }

// class ProviderMetadata {
//   Openai? openai;

//   ProviderMetadata({this.openai});

//   ProviderMetadata.fromJson(Map<String, dynamic> json) {
//     openai = json['openai'] != null ? Openai.fromJson(json['openai']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (openai != null) {
//       data['openai'] = openai!.toJson();
//     }
//     return data;
//   }
// }

class Openai {
  String? itemId;
  Null? reasoningEncryptedContent;

  Openai({this.itemId, this.reasoningEncryptedContent});

  Openai.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    reasoningEncryptedContent = json['reasoningEncryptedContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemId'] = itemId;
    data['reasoningEncryptedContent'] = reasoningEncryptedContent;
    return data;
  }
}
