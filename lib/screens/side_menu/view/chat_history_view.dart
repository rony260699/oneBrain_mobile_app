import 'package:OneBrain/common_widgets/app_utils.dart';
import 'package:OneBrain/models/chart_model.dart';
import 'package:OneBrain/repo_api/dio_helper.dart';
import 'package:OneBrain/repo_api/rest_constants.dart';
import 'package:OneBrain/services/folder_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../base/base_stateful_state.dart';
import '../../home/cubit/home_screen_cubit.dart';

class ChatHistoryView extends StatefulWidget {
  final Chat chat;
  final VoidCallback? onChatDeleted;
  final VoidCallback? onChatMoved;
  const ChatHistoryView({
    super.key,
    required this.chat,
    this.onChatDeleted,
    this.onChatMoved,
  });

  @override
  State<ChatHistoryView> createState() => _ChatHistoryViewState();
}

class _ChatHistoryViewState extends State<ChatHistoryView> {
  @override
  Widget build(BuildContext context) {
    bool isSelected =
        HomeScreenCubit.get(context).currentChatID == widget.chat.id;
    return GestureDetector(
      onLongPress: () => _showOptionsMenu(context),
      child: Container(
        height: 48,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 2,
        ), // Removed horizontal margin
        decoration: BoxDecoration(
          color:
              isSelected
                  ? HexColor('#656FE2').withValues(alpha: 0.15)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border:
              isSelected
                  ? Border.all(
                    color: HexColor('#656FE2').withValues(alpha: 0.3),
                    width: 1,
                  )
                  : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 8,
          ), // Further reduced from 8 to 4
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Simple indicator bar
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? HexColor('#656FE2')
                          : HexColor('#4B5563').withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6), // Further reduced from 8 to 6
              // Chat title with proper constraints
              Expanded(
                child: Text(
                  widget.chat.title ?? "",
                  style: TextStyle(
                    fontSize: 14, // Increased from 14 to 16
                    color:
                        isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.8),
                    fontWeight:
                        isSelected
                            ? FontWeight
                                .w600 // Increased from w500 to w600
                            : FontWeight.w500, // Increased from w400 to w500
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              //   PopupMenuButton<String>(
              //     icon: Icon(
              //       Icons.more_vert,
              //       color: Colors.white.withValues(alpha: 0.6),
              //       size: 18,
              //     ),
              //     color: HexColor('#2D3748'),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     onSelected: (value) {
              //       _handleMenuAction(value);
              //     },
              //     itemBuilder:
              //         (context) => [
              //           PopupMenuItem<String>(
              //             value: 'move',
              //             child: Row(
              //               children: [
              //                 Icon(
              //                   Icons.folder_outlined,
              //                   color: Colors.white.withValues(alpha: 0.8),
              //                   size: 16,
              //                 ),
              //                 const SizedBox(width: 8),
              //                 Text(
              //                   'Move',
              //                   style: TextStyle(
              //                     color: Colors.white.withValues(alpha: 0.8),
              //                     fontSize: 14,
              //                   ),
              //                 ),
              //                 const SizedBox(width: 8),
              //                 Icon(
              //                   Icons.arrow_forward_ios,
              //                   color: Colors.white.withValues(alpha: 0.6),
              //                   size: 12,
              //                 ),
              //               ],
              //             ),
              //           ),
              //           PopupMenuItem<String>(
              //             value: 'delete',
              //             child: Row(
              //               children: [
              //                 Icon(
              //                   Icons.delete_outline,
              //                   color: Colors.red.withValues(alpha: 0.8),
              //                   size: 16,
              //                 ),
              //                 const SizedBox(width: 8),
              //                 Text(
              //                   'Delete',
              //                   style: TextStyle(
              //                     color: Colors.red.withValues(alpha: 0.8),
              //                     fontSize: 14,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final Size screenSize = MediaQuery.of(context).size;

    showMenu(
      context: context,
      position: RelativeRect.fromSize(
        Rect.fromLTWH(
          position.dx + (button.size.width - 120),
          position.dy + button.size.height,
          position.dx + (button.size.width - 120),
          button.size.height,
        ),
        screenSize,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        PopupMenuItem<String>(
          value: 'move',
          child: Row(
            children: [
              Icon(
                Icons.folder_outlined,
                color: Colors.white.withValues(alpha: 0.8),
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                'Move',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: Colors.red.withValues(alpha: 0.8),
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'move') {
        _showMoveToFolderDialog();
      } else if (value == 'delete') {
        _showDeleteConfirmationDialog();
      }
    });
  }

  void _showMoveToFolderDialog() async {
    try {
      final folders = FolderService.getAllFolders;

      if (!mounted) return;
      bool isLoading = false;

      showDialog(
        context: context,
        builder:
            (context) => StatefulBuilder(
              builder:
                  (context, setState) => AlertDialog(
                    backgroundColor: HexColor('#1A202C'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text(
                      'Move to Folder',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(color: Colors.grey),
                          ...folders.map(
                            (folder) => ListTile(
                              leading: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: folder.getColor ?? Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Text(
                                folder.name ?? 'Unnamed Folder',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () async {
                                isLoading = true;
                                setState(() {});
                                await _moveToFolder(folder.id);
                                await HomeScreenCubit.get(
                                  context,
                                ).getAllChats();
                                isLoading = false;
                                setState(() {});
                                Navigator.of(context).pop(); // Close dialog
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      if (isLoading)
                        const CircularProgressIndicator(color: Colors.white)
                      else
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                    ],
                  ),
            ),
      );
    } catch (e) {
      showError(message: 'Failed to load folders');
    }
  }

  Future<void> _moveToFolder(String? folderId) async {
    // try {
    bool success;
    if (folderId == null) {
      success = await FolderService.removeChatFromFolder(widget.chat.id ?? '');
    } else {
      success = await FolderService.moveChatToFolder(
        widget.chat.id ?? '',
        folderId,
      );
    }

    if (success) {
      showSuccess(message: 'Chat moved successfully');
      widget.onChatMoved?.call();
    } else {
      showError(message: 'Failed to move chat');
    }
    // } catch (e) {
    //   showError(message: 'Failed to move chat');
    // }
  }

  void _showDeleteConfirmationDialog() {
    bool isLoading = false;

    final title = widget.chat.title ?? '';
    final displayTitle =
        title.length > 25 ? '${title.substring(0, 25)}...' : title;
    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: HexColor('#1A202C'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(
                  'Delete Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: Text(
                  'Are you sure you want to delete "${displayTitle}"? This action cannot be undone.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      isLoading = true;
                      setState(() {});
                      await _deleteChat(context);
                      isLoading = false;
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        isLoading
                            ? const CupertinoActivityIndicator()
                            : const Text('Delete'),
                  ),
                ],
              );
            },
          ),
    );
  }

  Future<void> _deleteChat(BuildContext context) async {
    try {
      final response = await DioHelper.deleteData(
        url: '${RestConstants.baseUrl}${RestConstants.chat}/${widget.chat.id}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await HomeScreenCubit.get(context).getAllChats();
        Navigator.of(context).pop(); // Close dialog

        showSuccess(message: 'Chat deleted successfully');
        widget.onChatDeleted?.call();
      } else {
        showError(message: 'Failed to delete chat');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close dialog

      showError(message: 'Failed to delete chat');
    }
  }
}
