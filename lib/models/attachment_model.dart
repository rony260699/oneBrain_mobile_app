import 'package:OneBrain/models/message_model.dart';

class AttachmentModel {
  List<Attachments>? attachments;
  String? summary;
  Statistics? statistics;
  Metadata? metadata;

  AttachmentModel({
    this.attachments,
    this.summary,
    this.statistics,
    this.metadata,
  });

  AttachmentModel.fromJson(Map<String, dynamic> json) {
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    }
    summary = json['summary'];
    statistics =
        json['statistics'] != null
            ? Statistics.fromJson(json['statistics'])
            : null;
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    data['summary'] = summary;
    if (statistics != null) {
      data['statistics'] = statistics!.toJson();
    }
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    return data;
  }
}


class VisionData {
  String? rawAnalysis;
  String? extractedText;
  List<dynamic>? mathematicalContent;
  List<dynamic>? codeBlocks;
  double? confidence;
  String? modelUsed;
  String? provider;
  int? processingTime;

  VisionData({
    this.rawAnalysis,
    this.extractedText,
    this.mathematicalContent,
    this.codeBlocks,
    this.confidence,
    this.modelUsed,
    this.provider,
    this.processingTime,
  });

  VisionData.fromJson(Map<String, dynamic> json) {
    rawAnalysis = json['rawAnalysis'];
    extractedText = json['extractedText'];
    if (json['mathematicalContent'] != null) {
      mathematicalContent = json['mathematicalContent'];
    }
    if (json['codeBlocks'] != null) {
      codeBlocks = json['codeBlocks'];
    }
    confidence = json['confidence'];
    modelUsed = json['modelUsed'];
    provider = json['provider'];
    processingTime = json['processingTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rawAnalysis'] = rawAnalysis;
    data['extractedText'] = extractedText;
    if (mathematicalContent != null) {
      data['mathematicalContent'] =
          mathematicalContent!.map((v) => v.toJson()).toList();
    }
    if (codeBlocks != null) {
      data['codeBlocks'] = codeBlocks!.map((v) => v.toJson()).toList();
    }
    data['confidence'] = confidence;
    data['modelUsed'] = modelUsed;
    data['provider'] = provider;
    data['processingTime'] = processingTime;
    return data;
  }
}

class Preview {
  bool? hasContent;
  int? contentLength;
  bool? isImage;
  bool? isDocument;
  bool? isArchive;
  bool? isCode;

  Preview({
    this.hasContent,
    this.contentLength,
    this.isImage,
    this.isDocument,
    this.isArchive,
    this.isCode,
  });

  Preview.fromJson(Map<String, dynamic> json) {
    hasContent = json['hasContent'];
    contentLength = json['contentLength'];
    isImage = json['isImage'];
    isDocument = json['isDocument'];
    isArchive = json['isArchive'];
    isCode = json['isCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hasContent'] = hasContent;
    data['contentLength'] = contentLength;
    data['isImage'] = isImage;
    data['isDocument'] = isDocument;
    data['isArchive'] = isArchive;
    data['isCode'] = isCode;
    return data;
  }
}

class Statistics {
  int? totalFiles;
  int? processedFiles;
  int? totalSize;
  int? processingTime;
  int? successRate;
  String? processingMethod;

  Statistics({
    this.totalFiles,
    this.processedFiles,
    this.totalSize,
    this.processingTime,
    this.successRate,
    this.processingMethod,
  });

  Statistics.fromJson(Map<String, dynamic> json) {
    totalFiles = json['totalFiles'];
    processedFiles = json['processedFiles'];
    totalSize = json['totalSize'];
    processingTime = json['processingTime'];
    successRate = json['successRate'];
    processingMethod = json['processingMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalFiles'] = totalFiles;
    data['processedFiles'] = processedFiles;
    data['totalSize'] = totalSize;
    data['processingTime'] = processingTime;
    data['successRate'] = successRate;
    data['processingMethod'] = processingMethod;
    return data;
  }
}

class Metadata {
  String? model;
  String? provider;
  String? chatId;
  bool? useVision;
  String? timestamp;
  String? version;
  String? fileType;
  bool? isProcessed;
  int? processingTime;
  List<dynamic>? extractedFiles;
  String? aiAnalysis;
  String? processingMethod;
  VisionData? visionData;
  String? fileName;
  String? type;
  String? modelUsed;
  double? confidence;

  Metadata({
    this.model,
    this.provider,
    this.chatId,
    this.useVision,
    this.timestamp,
    this.version,
    this.fileType,
    this.isProcessed,
    this.processingTime,
    this.extractedFiles,
    this.aiAnalysis,
    this.processingMethod,
    this.visionData,
    this.fileName,
    this.type,
    this.modelUsed,
    this.confidence,
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    provider = json['provider'];
    chatId = json['chatId'];
    useVision = json['useVision'];
    timestamp = json['timestamp'];
    version = json['version'];
    fileType = json['fileType'];
    isProcessed = json['isProcessed'];
    processingTime = json['processingTime'];
    if (json['extractedFiles'] != null) {
      extractedFiles = json['extractedFiles'];
    }
    aiAnalysis = json['aiAnalysis'];
    processingMethod = json['processingMethod'];
    visionData =
        json['visionData'] != null
            ? VisionData.fromJson(json['visionData'])
            : null;
    fileName = json['fileName'];
    type = json['type'];
    modelUsed = json['modelUsed'];
    confidence = json['confidence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model'] = model;
    data['provider'] = provider;
    data['chatId'] = chatId;
    data['useVision'] = useVision;
    data['timestamp'] = timestamp;
    data['version'] = version;
    data['fileType'] = fileType;
    data['isProcessed'] = isProcessed;
    data['processingTime'] = processingTime;
    if (extractedFiles != null) {
      data['extractedFiles'] = extractedFiles!.map((v) => v.toJson()).toList();
    }
    data['aiAnalysis'] = aiAnalysis;
    data['processingMethod'] = processingMethod;
    if (visionData != null) {
      data['visionData'] = visionData!.toJson();
    }
    data['fileName'] = fileName;
    data['type'] = type;
    data['modelUsed'] = modelUsed;
    data['confidence'] = confidence;
    return data;
  }
}
