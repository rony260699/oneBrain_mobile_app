import 'package:OneBrain/common_widgets/app_utils.dart';
import 'package:OneBrain/models/message_model.dart';
import 'package:OneBrain/screens/home/cubit/home_screen_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RightMessageView extends StatefulWidget {
  final Message currentMessage;
  const RightMessageView({super.key, required this.currentMessage});

  @override
  State<RightMessageView> createState() => _RightMessageViewState();
}

class _RightMessageViewState extends State<RightMessageView> {
  // Helper method to check if file is an image
  bool _isImageFile(String filePath) {
    String extension = filePath.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(extension);
  }

  bool _isNetworkAttachment() {
    Map<String, dynamic> response = widget.currentMessage.toJson();

    if (response["attachments"] != null && response["attachments"] is List) {
      final attachment = response["attachments"].first;

      // If attachment has a URL that starts with http or https → network file
      if (attachment is Map && attachment["url"] != null) {
        final url = attachment["url"].toString().toLowerCase();
        return url.startsWith("http");
      }

      // If attachment path starts with /data/user → local file
      if (attachment is String) {
        return false; // It's a local file
      }
    }
    return false;
  }

  // Helper method to get file name from path
  String _getFileName(String filePath) {
    return filePath.split('/').last;
  }

  // Helper method to get appropriate file icon
  IconData _getFileIcon(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'txt':
        return Icons.text_snippet;
      case 'csv':
        return Icons.table_view;
      case 'mp3':
      case 'wav':
        return Icons.audiotrack;
      case 'zip':
      case 'rar':
        return Icons.archive;
      default:
        return Icons.attach_file;
    }
  }

  Dio dio = Dio();
  final ValueNotifier<double> progressNotifier = ValueNotifier(0.0);
  final ValueNotifier<String> downloadingFile = ValueNotifier("");

  Future<bool> _downloadFile(String filePath) async {
    try {
      downloadingFile.value = widget.currentMessage.sId ?? "";

      String url = widget.currentMessage.attachments?.first?.url ?? "";

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progressNotifier.value = (received / total);
          }
        },
      );

      if (progressNotifier.value == 1) {
        downloadingFile.value = "";
        return true;
      }

      return false;
    } catch (e) {
      downloadingFile.value = "";
      return false;
    }
  }

  Future<void> _onOpenFileTap() async {
    // App-specific temp storage (no permission needed)
    Directory tempDir = await getTemporaryDirectory();

    String fileName = widget.currentMessage.attachments?.first?.name ?? "file";
    String filePath = '${tempDir.path}/${widget.currentMessage.sId}_$fileName';

    final File docFile = File(filePath);

    if (!await docFile.exists()) {
      try {
        final bool result = await _downloadFile(filePath);

        if (result) {
          await OpenFilex.open(filePath);
          return;
        }
      } catch (e) {
        showError(message: "Error downloading file: $e");
      }
    } else {
      print("File already exists at: $filePath");
      await OpenFilex.open(filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    String message = "";

    for (var part in widget.currentMessage.parts ?? []) {
      if (part["type"] == "text") {
        message = part["text"];
      }
    }

    // Stream<String>? messageStream = widget.currentMessage.messageStream;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30.0,
        // horizontal: 8.0,
      ), // Match AI message spacing
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onLongPress: () => _showMessageOptions(context, message),
            child: IgnorePointer(
              child: Container(
                margin: EdgeInsets.only(right: 20),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                decoration: BoxDecoration(
                  // Match web app: bg-blue-500/40 (blue with 40% opacity)
                  color: Color(0xFF1a1a1a),
                  // color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(
                      16,
                    ), // Special web app corner: rounded-tr-[2.5px]
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show attachments if any
                      if (widget.currentMessage.attachments?.isNotEmpty ??
                          false)
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                widget.currentMessage.attachments?.map((
                                  attachment,
                                ) {
                                  bool isNetworkUrl = _isNetworkAttachment();

                                  if (isNetworkUrl) {
                                    String url = attachment.url ?? "";

                                    String fileName = attachment.name ?? "";
                                    bool isImage = _isImageFile(url);

                                    if (isImage) {
                                      // Show full image without file name overlay
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 6),
                                        constraints: BoxConstraints(
                                          maxWidth: 250,
                                          maxHeight: 250,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              showImageViewer(
                                                context,
                                                CachedNetworkImageProvider(url),
                                                useSafeArea: true,
                                                swipeDismissible: true,
                                                doubleTapZoomable: true,
                                              );
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: url,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              errorWidget: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Container(
                                                  width: double.infinity,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.broken_image,
                                                        color: Colors.white
                                                            .withOpacity(0.7),
                                                        size: 32,
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        'Image not found',
                                                        style: TextStyle(
                                                          color: Colors.white
                                                              .withOpacity(0.7),
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Show file chip for non-image files
                                      return GestureDetector(
                                        onTap: _onOpenFileTap,
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 4),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.3,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                _getFileIcon(fileName),
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  fileName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              ListenableBuilder(
                                                listenable: Listenable.merge([
                                                  downloadingFile,
                                                  progressNotifier,
                                                ]),
                                                builder:
                                                    (context, child) =>
                                                        downloadingFile.value ==
                                                                widget
                                                                    .currentMessage
                                                                    .sId
                                                            ? Container(
                                                              height: 12.h,
                                                              width: 12.h,
                                                              margin:
                                                                  EdgeInsets.only(
                                                                    left: 6,
                                                                  ),
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                value:
                                                                    progressNotifier
                                                                        .value,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                backgroundColor:
                                                                    Colors.white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.1,
                                                                        ),
                                                              ),
                                                            )
                                                            : SizedBox.shrink(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    String filePath = attachment.toString();
                                    String fileName = _getFileName(filePath);
                                    bool isImage = _isImageFile(filePath);

                                    if (isImage) {
                                      // Show full image without file name overlay
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 6),
                                        constraints: BoxConstraints(
                                          maxWidth: 250,
                                          maxHeight: 250,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child:
                                              File(filePath).existsSync()
                                                  ? GestureDetector(
                                                    onTap: () {
                                                      showImageViewer(
                                                        context,
                                                        FileImage(
                                                          File(filePath),
                                                        ),
                                                        useSafeArea: true,
                                                        swipeDismissible: true,
                                                        doubleTapZoomable: true,
                                                      );
                                                    },
                                                    child: Image.file(
                                                      File(filePath),
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      errorBuilder: (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          width:
                                                              double.infinity,
                                                          height: 150,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  0.2,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .broken_image,
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                      0.7,
                                                                    ),
                                                                size: 32,
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Text(
                                                                'Image not found',
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                        0.7,
                                                                      ),
                                                                  fontSize:
                                                                      12.sp,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                  : Container(
                                                    width: double.infinity,
                                                    height: 150,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.image,
                                                          color: Colors.white
                                                              .withOpacity(0.7),
                                                          size: 32,
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          'Image preview',
                                                          style: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  0.7,
                                                                ),
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                        ),
                                      );
                                    } else {
                                      // Show file chip for non-image files
                                      return GestureDetector(
                                        onTap: () => OpenFilex.open(filePath),
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 4),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.3,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                _getFileIcon(fileName),
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  fileName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }).toList() ??
                                [],
                          ),
                        ),

                      // Message text - only show if there's actual text content
                      // if (message.isNotEmpty)
                      //   Container(
                      //     margin: EdgeInsets.only(
                      //       top:
                      //           (widget.currentMessage.attachments?.isNotEmpty ??
                      //                   false)
                      //               ? 4
                      //               : 0,
                      //     ),
                      //     child: _buildMessageContent(message),
                      //   ),
                      if (message.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(
                            top:
                                (widget
                                            .currentMessage
                                            .attachments
                                            ?.isNotEmpty ??
                                        false)
                                    ? 4
                                    : 0,
                          ),
                          child: SelectableText(
                            message,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily:
                                  '.SF Pro Text', // Use iOS system font for consistency
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show message options popup menu
  void _showMessageOptions(BuildContext context, String message) async {
    print("_showMessageOptions");

    // Get the RenderBox to position the popup
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    // Get screen dimensions and position menu on right side with 100 padding
    final screenWidth = overlay.size.width;
    final screenHeight = overlay.size.height;

    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        screenWidth - 250, // Left position (250 is menu width + padding)
        position.dy + 72, // Top position (aligned with message)
        38, // 100 padding from right edge
        screenHeight - position.dy - button.size.height, // Bottom
      ),
      color: Color(0xFF2D2D2D), // Dark background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        PopupMenuItem<String>(
          value: 'copy',
          height: 48,
          child: Row(
            children: [
              Icon(Icons.copy, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                'Copy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'edit',
          height: 48,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                'Edit Message',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // Handle the selection
    if (result == 'copy') {
      Clipboard.setData(ClipboardData(text: message));
    } else if (result == 'edit') {
      HomeScreenCubit.get(context).enterEditMode(widget.currentMessage);
    }
  }
}
