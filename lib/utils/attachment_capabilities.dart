import 'dart:io';
import 'dart:async';

class AttachmentCapabilities {
  // File limits
  static const int maxFilesPerMessage = 10;
  static const Map<String, int> maxFileSize = {
    'image': 10 * 1024 * 1024, // 10MB for images
    'document': 50 * 1024 * 1024, // 50MB for documents
    'default': 10 * 1024 * 1024, // 10MB default
  };

  // Supported file types
  static const Map<String, List<String>> supportedTypes = {
    'images': [
      'image/jpeg',
      'image/jpg', 
      'image/png',
      'image/gif',
      'image/webp',
      'image/bmp',
      'image/svg+xml',
    ],
    'documents': [
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'application/vnd.ms-powerpoint',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'text/plain',
      'text/csv',
      'application/json',
      'text/markdown',
      // Archive Files
      'application/zip',
      'application/x-zip-compressed',
      'application/x-rar-compressed',
      'application/x-7z-compressed',
      'application/x-tar',
      'application/gzip',
    ],
    'audio': ['audio/mpeg', 'audio/wav', 'audio/mp3', 'audio/m4a', 'audio/ogg'],
    'video': ['video/mp4', 'video/avi', 'video/mov', 'video/wmv', 'video/webm'],
  };

  // Processing timeouts
  static const Map<String, int> timeouts = {
    'imageProcessing': 30000, // 30 seconds
    'documentProcessing': 60000, // 60 seconds
    'uploadTimeout': 120000, // 2 minutes
  };

  // Error messages
  static const Map<String, String> errorMessages = {
    'tooManyFiles': 'Maximum 10 files allowed per message',
    'unsupportedType': 'File type is not supported',
    'processingTimeout': 'File processing timed out. Please try again.',
    'uploadFailed': 'Failed to upload file. Please check your connection and try again.',
    'networkError': 'Network error occurred. Please check your connection.',
    'serverError': 'Server error occurred. Please try again later.',
  };

  static String formatFileSize(int bytes) {
    if (bytes == 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    final i = (bytes / k).floor();
    return '${(bytes / (k * i)).toStringAsFixed(2)} ${sizes[i]}';
  }

  static bool isImageFile(String mimeType) {
    return supportedTypes['images']!.contains(mimeType);
  }

  static bool isDocumentFile(String mimeType) {
    return supportedTypes['documents']!.contains(mimeType);
  }

  static int getMaxFileSize(String mimeType) {
    if (isImageFile(mimeType)) {
      return maxFileSize['image']!;
    }
    if (isDocumentFile(mimeType)) {
      return maxFileSize['document']!;
    }
    return maxFileSize['default']!;
  }

  static Map<String, dynamic> validateFile(String mimeType, int size) {
    // Get all supported types
    final allSupportedTypes = [
      ...supportedTypes['images']!,
      ...supportedTypes['documents']!,
      ...supportedTypes['audio']!,
      ...supportedTypes['video']!,
    ];

    if (!allSupportedTypes.contains(mimeType)) {
      return {
        'isValid': false,
        'error': '${errorMessages['unsupportedType']}: $mimeType',
      };
    }

    final maxSize = getMaxFileSize(mimeType);
    if (size > maxSize) {
      return {
        'isValid': false,
        'error': 'File size ${formatFileSize(size)} exceeds limit of ${formatFileSize(maxSize)}',
      };
    }

    return {'isValid': true};
  }

  static Map<String, dynamic> validateFiles(List<Map<String, dynamic>> files) {
    final errors = <String>[];
    final validFiles = <Map<String, dynamic>>[];

    if (files.length > maxFilesPerMessage) {
      errors.add(errorMessages['tooManyFiles']!);
      return {'validFiles': <Map<String, dynamic>>[], 'errors': errors};
    }

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final validation = validateFile(file['mimeType'], file['size']);
      
      if (validation['isValid']) {
        validFiles.add(file);
      } else {
        errors.add('File ${i + 1}: ${validation['error']}');
      }
    }

    return {'validFiles': validFiles, 'errors': errors};
  }
}

class AttachmentFile {
  final File file;
  final String fileName;
  final String mimeType;
  final int size;
  final String? localPath;

  AttachmentFile({
    required this.file,
    required this.fileName,
    required this.mimeType,
    required this.size,
    this.localPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'mimeType': mimeType,
      'size': size,
      'localPath': localPath,
    };
  }
}

class ParsedContent {
  final String text;
  final String title;
  final int index;
  final String fileName;
  final String fileSize;
  final String fileType;
  final List<ExtractedFile>? extractedFiles;

  ParsedContent({
    required this.text,
    required this.title,
    required this.index,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    this.extractedFiles,
  });

  factory ParsedContent.fromJson(Map<String, dynamic> json) {
    return ParsedContent(
      text: json['text'] ?? '',
      title: json['title'] ?? '',
      index: json['index'] ?? 0,
      fileName: json['fileName'] ?? '',
      fileSize: json['fileSize'] ?? '',
      fileType: json['fileType'] ?? '',
      extractedFiles: json['extractedFiles'] != null
          ? (json['extractedFiles'] as List)
              .map((e) => ExtractedFile.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'title': title,
      'index': index,
      'fileName': fileName,
      'fileSize': fileSize,
      'fileType': fileType,
      'extractedFiles': extractedFiles?.map((e) => e.toJson()).toList(),
    };
  }
}

class ExtractedFile {
  final String fileName;
  final String type;
  final String? content;
  final bool? processed;

  ExtractedFile({
    required this.fileName,
    required this.type,
    this.content,
    this.processed,
  });

  factory ExtractedFile.fromJson(Map<String, dynamic> json) {
    return ExtractedFile(
      fileName: json['fileName'] ?? '',
      type: json['type'] ?? '',
      content: json['content'],
      processed: json['processed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'type': type,
      'content': content,
      'processed': processed,
    };
  }
}

class AttachmentWithParsedContent {
  final AttachmentFile file;
  final ParsedContent parsedContent;

  AttachmentWithParsedContent({
    required this.file,
    required this.parsedContent,
  });

  factory AttachmentWithParsedContent.fromJson(Map<String, dynamic> json) {
    return AttachmentWithParsedContent(
      file: AttachmentFile(
        file: File(json['file']['localPath']),
        fileName: json['file']['fileName'],
        mimeType: json['file']['mimeType'],
        size: json['file']['size'],
        localPath: json['file']['localPath'],
      ),
      parsedContent: ParsedContent.fromJson(json['parsedContent']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file': file.toJson(),
      'parsedContent': parsedContent.toJson(),
    };
  }
}

class MessageAttachment {
  final String name;
  final String type;
  final int size;
  final String? parsedContent;
  final Map<String, dynamic>? structuredData;

  MessageAttachment({
    required this.name,
    required this.type,
    required this.size,
    this.parsedContent,
    this.structuredData,
  });
}

class AttachmentService {
  final String baseUrl;
  final String? authToken;

  AttachmentService({
    required this.baseUrl,
    this.authToken,
  });

  Future<Map<String, dynamic>> parseAttachmentsPreview({
    required List<AttachmentFile> files,
    String? conversationId,
    String model = 'gpt-4.1-nano',
    String provider = 'openai',
  }) async {
    // Mock implementation for now - replace with actual API call
    await Future.delayed(Duration(seconds: 1));
    
    List<Map<String, dynamic>> parsedTexts = [];
    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      parsedTexts.add({
        'text': 'Parsed content from ${file.fileName}',
        'title': file.fileName,
        'index': i,
      });
    }
    
    return {
      'success': true,
      'parsedTexts': parsedTexts,
      'filesCount': files.length,
    };
  }

  Future<Stream<String>> sendMessageWithAttachments({
    required String conversationId,
    required String message,
    required List<AttachmentWithParsedContent> attachments,
    required String model,
    required String provider,
    bool reasoningStatus = false,
    bool deepSearchStatus = false,
  }) async {
    // Mock implementation for now - replace with actual API call
    final controller = StreamController<String>();
    
    Future.delayed(Duration(milliseconds: 500), () {
      controller.add('data: {"content": "I can see your attachments and will help you with them."}');
    });
    
    Future.delayed(Duration(milliseconds: 1000), () {
      controller.add('data: [DONE]');
      controller.close();
    });
    
    return controller.stream;
  }
} 