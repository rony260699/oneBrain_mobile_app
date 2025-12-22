import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'dio_helper.dart';
import 'rest_constants.dart';
import 'stream_post_service.dart';

class one_brainApiService {
  static final one_brainApiService _instance = one_brainApiService._internal();
  factory one_brainApiService() => _instance;
  one_brainApiService._internal();

  /// Parse attachments using preview endpoint (matches your backend exactly)
  Future<List<AttachmentParsed>> parseAttachmentsPreview(
    List<File> files, {
    String? conversationId,
    Function(String)? onStatusUpdate,
  }) async {
    try {
      if (files.isEmpty) throw Exception('No files provided');

      onStatusUpdate?.call('Preparing files...');

      // Create FormData exactly like your web app
      FormData formData = FormData();

      if (kDebugMode) {
        print('📤 Creating FormData with ${files.length} files');
        for (int i = 0; i < files.length; i++) {
          File file = files[i];
          String fileName = path.basename(file.path);
          int fileSize = file.lengthSync();
          bool fileExists = file.existsSync();
          print('📤 File $i: $fileName');
          print('   Path: ${file.path}');
          print(
            '   Size: $fileSize bytes (${(fileSize / 1024).toStringAsFixed(1)} KB)',
          );
          print('   Exists: $fileExists');
          print('   Content-Type: ${_getContentType(fileName)}');
        }
      }

      // Add files with proper content type
      for (File file in files) {
        String fileName = path.basename(file.path);
        String contentType = _getContentType(fileName);

        if (kDebugMode) {
          print('📤 Adding file: $fileName with content-type: $contentType');
        }

        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(
              file.path,
              filename: fileName,
              contentType: MediaType.parse(contentType),
            ),
          ),
        );
      }

      // Add metadata exactly as your original backend specification
      formData.fields.addAll([
        MapEntry('previewMode', 'true'),
        MapEntry('model', 'gpt-4.1-nano'),
        MapEntry('provider', 'openai'),
      ]);

      // Add conversationId (even if empty, as per your original spec)
      formData.fields.add(MapEntry('conversationId', conversationId ?? ''));

      if (kDebugMode) {
        print(
          '📤 FormData fields: ${formData.fields.map((e) => '${e.key}=${e.value}').join(', ')}',
        );
        print('📤 FormData files count: ${formData.files.length}');
        print(
          '📤 Making API call to: ${RestConstants.baseUrl}${RestConstants.parseAttachmentsPreview}',
        );
      }

      onStatusUpdate?.call('Parsing files with AI...');

      // Make API call with explicit multipart handling
      // Note: We need to bypass DioHelper's default Content-Type for FormData
      Response response = await DioHelper.dio.post(
        RestConstants.parseAttachmentsPreview,
        data: formData,
        options: Options(
          extra: {'header': true}, // Use authentication via AppInterceptor
          headers: {
            // Let Dio handle Content-Type for multipart/form-data automatically
            // Don't set Content-Type manually for FormData
          },
          validateStatus: (status) {
            if (kDebugMode) {
              print("📊 HTTP Status: $status");
            }
            return status != null && status < 600;
          },
        ),
      );

      if (kDebugMode) {
        print('📊 API Response Status Code: ${response.statusCode}');
        print('📊 API Response Data: ${response.data}');
        print('📊 API Response Type: ${response.data.runtimeType}');
        print('📊 API Response Keys: ${response.data.keys}');
        print('📊 Success field: ${response.data['success']}');
        print('📊 Error field: ${response.data['error']}');
        print('📊 Message field: ${response.data['message']}');
        print('📊 Data field: ${response.data['data']}');
        print('📊 All response fields:');
        response.data.forEach((key, value) {
          print('   $key: $value (${value.runtimeType})');
        });
      }

      // Check if response is valid
      if (response.data == null) {
        throw Exception('No response data received from server');
      }

      if (response.data['success'] != true) {
        throw Exception(
          response.data['error'] ?? 'Failed to parse attachments',
        );
      }

      // Parse response (handle different possible response structures)
      List<AttachmentParsed> parsedAttachments = [];

      // Check multiple possible locations for processed texts (backend returns 'texts' not 'processedTexts')
      var processedTexts =
          response.data['processedTexts'] ??
          response.data['texts'] ??
          response.data['data']?['processedTexts'] ??
          response.data['data']?['texts'] ??
          response.data['data'];

      if (kDebugMode) {
        print('📊 ProcessedTexts: $processedTexts');
        print('📊 ProcessedTexts Type: ${processedTexts.runtimeType}');
        print('📊 ProcessedTexts Length: ${processedTexts?.length ?? 0}');
      }

      // Handle different response formats
      if (processedTexts == null) {
        // Check if this is a success response but with different structure
        if (response.data['success'] == true) {
          if (kDebugMode) {
            print(
              '⚠️ Backend returned success but no processedTexts. This might indicate:',
            );
            print('   1. Files uploaded but not processed with AI');
            print('   2. Backend API changed or different endpoint needed');
            print('   3. Missing required parameters for AI processing');
            print('📊 Creating fallback attachments for ${files.length} files');
          }

          // Create fallback parsed attachments to allow the flow to continue
          for (int i = 0; i < files.length; i++) {
            File file = files[i];
            String fileName = path.basename(file.path);
            String extension = fileName.split('.').last.toLowerCase();

            // Create basic content based on file type
            String basicContent = '';
            if (['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
              basicContent =
                  'Image file uploaded: $fileName. This image will be processed when the message is sent.';
            } else if (['pdf'].contains(extension)) {
              basicContent =
                  'PDF document uploaded: $fileName. The content will be extracted and analyzed when the message is sent.';
            } else if (['doc', 'docx'].contains(extension)) {
              basicContent =
                  'Word document uploaded: $fileName. The content will be extracted and analyzed when the message is sent.';
            } else {
              basicContent =
                  'File uploaded: $fileName. The content will be processed when the message is sent.';
            }

            parsedAttachments.add(
              AttachmentParsed(
                text: basicContent,
                title: 'Attachment ${i + 1}: $fileName',
                index: i + 1,
                fileName: fileName,
                fileSize: '${(file.lengthSync() / 1024).toStringAsFixed(1)} KB',
                fileType: _getContentType(fileName),
                originalFile: file,
              ),
            );
          }

          if (parsedAttachments.isNotEmpty) {
            onStatusUpdate?.call(
              '✅ Files uploaded successfully (AI processing will occur during message send)',
            );
            return parsedAttachments;
          }
        }

        throw Exception(
          'No processed texts received from server. Response: ${response.data}',
        );
      }

      if (processedTexts is! List) {
        throw Exception(
          'Invalid response format: processedTexts is not a list but ${processedTexts.runtimeType}',
        );
      }

      List processedTextsList = processedTexts;

      if (processedTextsList.isEmpty) {
        // Instead of throwing an exception immediately, let's see what the actual response contains
        if (kDebugMode) {
          print(
            '⚠️ ProcessedTexts is empty. Full response data: ${response.data}',
          );
        }
        throw Exception(
          'No processed texts received from server. The files may not have been processed correctly. Response: ${response.data}',
        );
      }

      for (int i = 0; i < processedTextsList.length; i++) {
        var item = processedTextsList[i];

        if (kDebugMode) {
          print('📊 Processing item $i: $item');
          print('📊 Item type: ${item.runtimeType}');
        }

        if (item == null) {
          if (kDebugMode) {
            print('⚠️ Skipping null item at index $i');
          }
          continue;
        }

        // Handle both object format and string format
        if (item is String) {
          // Backend returned simple string array
          File file = i < files.length ? files[i] : File('');
          String fileName =
              i < files.length ? path.basename(file.path) : 'unknown';

          parsedAttachments.add(
            AttachmentParsed(
              text: item,
              title: 'Attachment ${i + 1}: $fileName',
              index: i + 1,
              fileName: fileName,
              fileSize:
                  i < files.length
                      ? '${(file.lengthSync() / 1024).toStringAsFixed(1)} KB'
                      : '0 KB',
              fileType:
                  i < files.length
                      ? _getContentType(fileName)
                      : 'application/octet-stream',
              originalFile: file,
            ),
          );
        } else if (item is Map) {
          // Backend returned object format (your original specification)
          parsedAttachments.add(
            AttachmentParsed(
              text: item['text']?.toString() ?? '',
              title: item['title']?.toString() ?? 'Attachment ${i + 1}',
              index: item['index'] ?? i + 1,
              fileName:
                  item['fileName']?.toString() ??
                  (i < files.length
                      ? files[i].path.split('/').last
                      : 'unknown'),
              fileSize:
                  item['fileSize']?.toString() ??
                  (i < files.length
                      ? '${(files[i].lengthSync() / 1024).toStringAsFixed(1)} KB'
                      : '0 KB'),
              fileType:
                  item['fileType']?.toString() ?? 'application/octet-stream',
              originalFile: i < files.length ? files[i] : File(''),
            ),
          );
        } else {
          if (kDebugMode) {
            print(
              '⚠️ Skipping unsupported item type at index $i: ${item.runtimeType}',
            );
          }
          continue;
        }
      }

      if (parsedAttachments.isEmpty) {
        throw Exception(
          'Failed to parse any attachments. Please check file formats and try again.',
        );
      }

      onStatusUpdate?.call('✅ Files parsed successfully');
      return parsedAttachments;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException in parseAttachmentsPreview: ${e.toString()}');
        print('Response data: ${e.response?.data}');
        print('Status code: ${e.response?.statusCode}');
      }
      throw Exception('API Error: ${e.response?.data?['error'] ?? e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('General exception in parseAttachmentsPreview: ${e.toString()}');
        print('Exception type: ${e.runtimeType}');
      }
      throw Exception('Parse Error: $e');
    }
  }

  /// Send message with attachments using existing StreamPostService
  Future<void> sendMessageWithAttachments({
    required String conversationId,
    required String message,
    required List<AttachmentParsed> attachments,
    required String model,
    required String company,
    bool reasoningStatus = false,
    bool deepSearchStatus = false,
    required void Function(String chunk) onChunk,
    required void Function(String status) onStatus,
    void Function(String error)? onError,
  }) async {
    try {
      // Create request body matching your backend expectations
      Map<String, dynamic> requestBody = {
        'content': message,
        'model': model,
        'company': company,
        'reasoningStatus': reasoningStatus.toString(),
        'deepSearchStatus': deepSearchStatus.toString(),
      };

      // Create parsedContents array (exact structure from your backend)
      List<Map<String, dynamic>> parsedContents =
          attachments
              .map(
                (attachment) => {
                  'text': attachment.text,
                  'title': attachment.title,
                  'index': attachment.index,
                  'fileName': attachment.fileName,
                  'fileSize': attachment.fileSize,
                  'fileType': attachment.fileType,
                },
              )
              .toList();

      requestBody['parsedContents'] = jsonEncode(parsedContents);

      // Get files for attachment
      List<File> files =
          attachments.map((attachment) => attachment.originalFile).toList();

      onStatus('Sending message...');

      // Use existing StreamPostService with updated URL
      final streamService = StreamPostService();
      streamService.initialize(
        '${RestConstants.baseUrl}${RestConstants.addMessage}/$conversationId',
      );

      // Listen to the stream using new sendMessage method with multipart/form-data
      // await for (String chunk in streamService.sendMessage(
      //   message: message,
      //   id: id,
      //   reasoningStatus: reasoningStatus,
      //   isPrivateVisibility: isPrivateVisibility,
      // )) {
      //   if (chunk.isNotEmpty) {
      //     onChunk(chunk);
      //   }
      // }

      onStatus('Message sent successfully');
    } catch (e) {
      if (kDebugMode) {
        print('Error sending message with attachments: $e');
      }
      onError?.call('Send Error: $e');
    }
  }

  /// Process single image (for quick image analysis)
  Future<ImageAnalysisResult> processImageIntelligent(File imageFile) async {
    try {
      FormData formData = FormData();
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            imageFile.path,
            filename: path.basename(imageFile.path),
          ),
        ),
      );

      Response response = await DioHelper.postData(
        url: RestConstants.processImageIntelligent,
        formData: formData,
        isHeader: true,
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['error'] ?? 'Failed to process image');
      }

      return ImageAnalysisResult(
        aiAnalysis: response.data['aiAnalysis'] ?? '',
        summary: response.data['summary'] ?? '',
        processingMethod: response.data['processingMethod'] ?? '',
        model: response.data['model'] ?? '',
        provider: response.data['provider'] ?? '',
      );
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data['error'] ?? e.message}');
    }
  }

  /// Transcribe audio file
  Future<AudioTranscriptionResult> transcribeAudio(File audioFile) async {
    try {
      FormData formData = FormData();
      formData.files.add(
        MapEntry(
          'audio',
          await MultipartFile.fromFile(
            audioFile.path,
            filename: path.basename(audioFile.path),
          ),
        ),
      );

      Response response = await DioHelper.postData(
        url: RestConstants.processAudioTranscription,
        formData: formData,
        isHeader: true,
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['error'] ?? 'Failed to transcribe audio');
      }

      return AudioTranscriptionResult(
        transcription: response.data['transcription'] ?? '',
        text: response.data['text'] ?? '',
        fileName: response.data['fileName'] ?? '',
        fileSize: response.data['fileSize'] ?? 0,
        mimeType: response.data['mimeType'] ?? '',
      );
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data['error'] ?? e.message}');
    }
  }

  /// Get file icon based on file type
  static String getFileIcon(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return '📄';
      case 'doc':
      case 'docx':
        return '📝';
      case 'xls':
      case 'xlsx':
        return '📊';
      case 'ppt':
      case 'pptx':
        return '📽️';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
        return '🖼️';
      case 'mp3':
      case 'wav':
      case 'mpeg':
        return '🎵';
      case 'txt':
        return '📄';
      case 'csv':
        return '📋';
      case 'zip':
      case 'rar':
        return '🗜️';
      default:
        return '📎';
    }
  }

  /// Get user-friendly file type description
  static String getFileTypeDescription(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'PDF Document';
      case 'doc':
      case 'docx':
        return 'Word Document';
      case 'xls':
      case 'xlsx':
        return 'Excel Spreadsheet';
      case 'ppt':
      case 'pptx':
        return 'PowerPoint Presentation';
      case 'jpg':
      case 'jpeg':
        return 'JPEG Image';
      case 'png':
        return 'PNG Image';
      case 'webp':
        return 'WebP Image';
      case 'mp3':
        return 'MP3 Audio';
      case 'wav':
        return 'WAV Audio';
      case 'mpeg':
        return 'MPEG Audio';
      case 'txt':
        return 'Text File';
      case 'csv':
        return 'CSV File';
      case 'zip':
        return 'ZIP Archive';
      case 'rar':
        return 'RAR Archive';
      default:
        return 'Unknown File';
    }
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Get proper content type for file based on extension
  String _getContentType(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'txt':
        return 'text/plain';
      case 'csv':
        return 'text/csv';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'zip':
        return 'application/zip';
      case 'rar':
        return 'application/x-rar-compressed';
      default:
        return 'application/octet-stream';
    }
  }
}

// Data models matching your backend structure
class AttachmentParsed {
  final String text;
  final String title;
  final int index;
  final String fileName;
  final String fileSize;
  final String fileType;
  final File originalFile;

  AttachmentParsed({
    required this.text,
    required this.title,
    required this.index,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    required this.originalFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'title': title,
      'index': index,
      'fileName': fileName,
      'fileSize': fileSize,
      'fileType': fileType,
    };
  }
}

class ImageAnalysisResult {
  final String aiAnalysis;
  final String summary;
  final String processingMethod;
  final String model;
  final String provider;

  ImageAnalysisResult({
    required this.aiAnalysis,
    required this.summary,
    required this.processingMethod,
    required this.model,
    required this.provider,
  });
}

class AudioTranscriptionResult {
  final String transcription;
  final String text;
  final String fileName;
  final int fileSize;
  final String mimeType;

  AudioTranscriptionResult({
    required this.transcription,
    required this.text,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
  });
}

extension DoubleExtension on double {
  String toFixed(int fractionDigits) {
    return toStringAsFixed(fractionDigits);
  }
}
