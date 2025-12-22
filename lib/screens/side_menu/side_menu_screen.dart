import 'package:OneBrain/common_widgets/app_utils.dart';
import 'package:OneBrain/models/chart_model.dart';
import 'package:OneBrain/models/folder_model.dart';
import 'package:OneBrain/screens/explore/explore_ai_library_screen.dart';
import 'package:OneBrain/screens/explore/imagine_screen.dart';
import 'package:OneBrain/screens/home/cubit/home_screen_cubit.dart';
import 'package:OneBrain/screens/home/cubit/home_screen_states.dart';
import 'package:OneBrain/screens/side_menu/view/chat_history_view.dart';

import 'package:OneBrain/screens/side_menu/view/chat_listing_view.dart';
import 'package:OneBrain/services/ai_model_service.dart';
import 'package:OneBrain/services/folder_service.dart';
import 'package:OneBrain/screens/payment_billing/payment_page.dart';
import 'package:OneBrain/services/profile_service.dart';
import 'package:OneBrain/utils/app_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../base/base_stateful_state.dart';
import '../../common_widgets/common_widgets.dart';
import '../../utils/slide_left_route.dart';

class SideMenuScreen extends StatefulWidget {
  final VoidCallback closeMenu;

  const SideMenuScreen({super.key, required this.closeMenu});

  @override
  State<SideMenuScreen> createState() => _SideMenuScreenState();
}

class _SideMenuScreenState extends State<SideMenuScreen> {
  // Folders section visibility
  bool foldersExpanded = false;

  // Chat history visibility and archive state
  bool chatHistoryVisible = false; // Collapsed by default when user logs in
  // bool showArchivedChats = false;

  String selectedFolder =
      ""; // No folder selected by default - chat history is independent

  String? versionString;

  @override
  void initState() {
    super.initState();
    AppInfo.getVersionString().then(
      (value) => setState(() {
        versionString = value;
      }),
    );
    HomeScreenCubit.get(context).getAllChats();
  }

  void pushAndClearStack(
    BuildContext context, {
    required Widget enterPage,
    bool shouldUseRootNavigator = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Future.delayed(Duration(milliseconds: 200)).then(
      (value) => Navigator.of(
        context,
        rootNavigator: shouldUseRootNavigator,
      ).pushAndRemoveUntil(SlideLeftRoute(page: enterPage), (route) => false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeScreenCubit, HomeScreenStates>(
      listener: (cubit, state) {},
      builder: (context, snapshot) {
        var homeCubit = HomeScreenCubit.get(context);

        List<FolderModel> folders = FolderService.getAllFolders;
        return SafeArea(
          bottom: true,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                right: BorderSide(
                  color: HexColor('#1D2142'),
                  width: 1.0, // border width
                ),
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25), // 25% opacity
                  offset: const Offset(0, 25), // X=0, Y=25
                  blurRadius: 50, // blur
                  spreadRadius: 0, // spread
                ),
              ],
            ),

            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(width: 5),
                    SvgPicture.asset(
                      "assets/icons/logo.svg",
                      height: 30.sp,
                      width: 30.sp,
                      fit: BoxFit.scaleDown,
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        // homeCubit.startNewChat();
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        "assets/icons/sidebar_menu.svg",
                        height: 30.sp,
                        width: 30.sp,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ],
                ),
                heightBox(24),
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    Future.delayed(Duration(milliseconds: 200), () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      homeCubit.startNewChat();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF111827),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/new_chat.svg",
                          height: 22,
                          width: 22,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "New Chat",
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                heightBox(6),
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExploreAiLibraryScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Color(0xFF111827),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/ask.svg",
                          height: 22,
                          width: 22,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Ask",
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Imagine Section
                heightBox(6),
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImagineScreen()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF111827),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          height: 22,
                          width: 22,
                          "assets/icons/photo_badge.svg",
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Imagine",
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                heightBox(3),
                Divider(color: Color(0xFF1F2937)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 6),
                    child: Column(
                      children: [
                        // Chat History Header Section (STICKY)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Chat History Header
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: SvgPicture.asset(
                                      "assets/icons/ic_history.svg",
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "HISTORY",
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  // Hide/Show button
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        chatHistoryVisible =
                                            !chatHistoryVisible;
                                      });
                                    },
                                    child: Icon(
                                      Icons.folder_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),

                                  SizedBox(width: 16),
                                  // Add Folder button
                                  GestureDetector(
                                    onTap: () async {
                                      await showDialog(
                                        context: context,
                                        builder:
                                            (context) => _CreateFolderDialog(
                                              onCreate: (
                                                String name,
                                                String color,
                                              ) async {
                                                try {
                                                  final newFolder =
                                                      await FolderService.createFolder(
                                                        name,
                                                        color,
                                                      );
                                                  if (newFolder != null) {
                                                    // Close dialog
                                                    Navigator.pop(context);
                                                    // Show success message
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Folder "$name" created successfully',
                                                        ),
                                                        backgroundColor:
                                                            Colors.green,
                                                        duration: Duration(
                                                          seconds: 2,
                                                        ),
                                                      ),
                                                    );
                                                    // Refresh the UI
                                                    setState(() {});
                                                  }
                                                } catch (e) {
                                                  // Show error message
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Failed to create folder: $e',
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                      duration: Duration(
                                                        seconds: 3,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 6),
                            // Folders List (STICKY) - These are just visual organizers
                            if (chatHistoryVisible)
                              Column(
                                children:
                                    folders.map((folder) {
                                      return FolderTile(
                                        folder: folder,
                                        color: folder.getColor ?? Colors.white,
                                        name: folder.name ?? "",
                                        chats:
                                            HomeScreenCubit.get(context).chats
                                                ?.where(
                                                  (chat) =>
                                                      chat.folderId ==
                                                      folder.id,
                                                )
                                                .toList() ??
                                            [],
                                        onChatTap: (chat) async {
                                          widget.closeMenu();

                                          final homeCubit = HomeScreenCubit.get(
                                            context,
                                          );

                                          homeCubit.switchChat(chat.id ?? "");
                                          await Future.delayed(
                                            const Duration(milliseconds: 200),
                                          );
                                          Navigator.of(
                                            context,
                                          ).popUntil((route) => route.isFirst);
                                        },
                                      );
                                    }).toList(),
                              ),
                          ],
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child:
                                  (homeCubit.chats?.isEmpty ?? true)
                                      ? Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 20,
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.chat_bubble_outline,
                                              color: Colors.white.withValues(
                                                alpha: 0.3,
                                              ),
                                              size: 24,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "No recent chats",
                                              style: TextStyle(
                                                color: Colors.white.withValues(
                                                  alpha: 0.5,
                                                ),
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "Start a new conversation to see it here",
                                              style: TextStyle(
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : CustomScrollView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        slivers: [
                                          SliverList(
                                            delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                                var chatsByDateTag = homeCubit
                                                    .getChatsByDateTag
                                                    .entries
                                                    .elementAt(index);
                                                return RepaintBoundary(
                                                  child: ChatListingView(
                                                    key: ValueKey(
                                                      'chat_${chatsByDateTag.key}_$index',
                                                    ),
                                                    tag: chatsByDateTag.key,
                                                    chats: chatsByDateTag.value,
                                                    closeMenu: () {
                                                      widget.closeMenu();
                                                    },
                                                  ),
                                                );
                                              },
                                              childCount:
                                                  homeCubit
                                                      .getChatsByDateTag
                                                      .length,
                                              addAutomaticKeepAlives: false,
                                              addRepaintBoundaries:
                                                  false, // We're adding them manually
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                if (!isBypassPayment)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentPage()),
                      );
                    },
                    child:
                        (ProfileService.user?.package?.currentPlan?.price ??
                                    0) ==
                                0
                            ? SvgPicture.asset(
                              "assets/icons/try_pro.svg",
                              height: 30,
                            )
                            : SvgPicture.asset(
                              "assets/icons/pro.svg",
                              height: 30,
                            ),
                  ),
                SizedBox(height: 4),
                SizedBox(
                  height: 20,
                  child: Text(
                    "$versionString",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
// Folder creation dialog widget
class _CreateFolderDialog extends StatefulWidget {
  final Future<void> Function(String name, String color) onCreate;

  const _CreateFolderDialog({required this.onCreate});

  @override
  State<_CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<_CreateFolderDialog> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedColor = _colors[0];
  bool _isCreating = false;
  static const List<String> _colors = [
    '#3B82F6',
    '#06B6D4',
    '#10B981',
    '#EC4899',
    '#A78BFA',
    '#F59E0B',
    '#F97316',
    '#EF4444',
    '#6366F1',
    '#84CC16',
  ];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF181F2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Folder',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Folder Name',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF232B39),
                hintText: 'Enter folder name',
                hintStyle: TextStyle(color: Colors.white38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (_) => setState(() {}),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Color',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children:
                  _colors.map((color) {
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(int.parse('0xFF${color.substring(1)}')),
                          shape: BoxShape.circle,
                          border:
                              isSelected
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isCreating ? null : () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF232B39),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed:
                      (_isCreating || _nameController.text.trim().isEmpty)
                          ? null
                          : () async {
                            setState(() => _isCreating = true);
                            await widget.onCreate(
                              _nameController.text.trim(),
                              _selectedColor!,
                            );
                            setState(() => _isCreating = false);
                          },
                  child:
                      _isCreating
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text('Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FolderTile extends StatefulWidget {
  const FolderTile({
    super.key,
    required this.color,
    required this.name,
    required this.chats,
    required this.onChatTap,
    required this.folder,
  });

  final Color color;
  final String name;
  final List<Chat> chats;
  final Function(Chat chat) onChatTap;
  final FolderModel folder;

  @override
  State<FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<FolderTile> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Expand/Collapse Arrow
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0.0,
                    duration: Duration(milliseconds: 200),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 12,
                    ),
                  ),
                  SizedBox(width: 12),
                  // Colored dot
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Folder name
                  Expanded(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // Chat count
                  Text(
                    "(${widget.chats.length})",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Edit button
                  GestureDetector(
                    onTap: () => _showEditFolderDialog(widget.folder, context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 16,
                      ),
                    ),
                  ),
                  // Delete button
                  GestureDetector(
                    onTap:
                        () => _showDeleteFolderDialog(widget.folder, context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red.withValues(alpha: 0.7),
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable content for chats - Show empty state with move option
          if (isExpanded)
            Visibility(
              visible: widget.chats.isNotEmpty,
              replacement: Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.color.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      color: widget.color.withValues(alpha: 0.6),
                      size: 20,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Folder is empty",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: widget.chats.length,
                itemBuilder: (context, index) {
                  Chat chat = widget.chats[index];
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      widget.onChatTap(chat);
                    },
                    child: ChatHistoryView(chat: chat),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// Method to show delete folder confirmation dialog
void _showDeleteFolderDialog(FolderModel folder, BuildContext context) {
  String folderName = folder.name ?? "Unnamed Folder";
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: HexColor('#1a1b3e'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: HexColor('#EF4444').withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: HexColor('#EF4444').withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.delete_outline,
                color: HexColor('#EF4444'),
                size: 18,
              ),
            ),
            SizedBox(width: 12),
            Text(
              "Delete Folder",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to delete the folder \"$folderName\"?",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: HexColor('#EF4444').withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: HexColor('#EF4444').withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_outlined,
                      color: HexColor('#EF4444'),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "This action cannot be undone. All chats in this folder will be moved to the default folder.",
                        style: TextStyle(
                          color: HexColor('#EF4444').withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: HexColor('#EF4444'),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () async {
                try {
                  final success = await FolderService.deleteFolder(
                    folder.id ?? '',
                  );
                  Navigator.of(context).pop();
                  if (success) {
                    showSuccess(message: "Folder deleted successfully!");
                  } else {
                    showError(message: "Failed to delete folder");
                  }
                } catch (e) {
                  Navigator.of(context).pop();
                  showError(message: "Failed to delete folder: $e");
                }
              },
              child: Text(
                "Delete Folder",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// Method to show edit folder dialog
void _showEditFolderDialog(FolderModel folder, BuildContext context) {
  String currentName = folder.name ?? "";
  Color currentColor = folder.getColor ?? Colors.blue;
  final TextEditingController folderNameController = TextEditingController(
    text: currentName,
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: HexColor('#1a1b3e'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: currentColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: currentColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.edit_outlined, color: currentColor, size: 18),
            ),
            SizedBox(width: 12),
            Text(
              "Edit Folder",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: folderNameController,
                keyboardAppearance: Brightness.dark,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter new folder name",
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: HexColor('#2a2d3a'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: currentColor.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: currentColor.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: currentColor, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [currentColor, currentColor.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () async {
                if (folderNameController.text.trim().isNotEmpty &&
                    folderNameController.text.trim() != currentName) {
                  await FolderService.updateFolder(
                    folder.id ?? '',
                    name: folderNameController.text.trim(),
                  ).then((value) {
                    if (value != null) {
                      showSuccess(message: "Folder renamed successfully!");
                      // setState(() {}); // Refresh the UI
                      Future.delayed(const Duration(milliseconds: 100), () {
                        Navigator.of(context).pop();
                      });
                    } else {
                      showError(message: "Failed to rename folder");
                    }
                  });
                }
              },
              child: Text(
                "Save Changes",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class ModernEditIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Create the modern edit icon path similar to the image
    // Outer rounded rectangle (container)
    final outerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
      Radius.circular(4),
    );

    // Draw the main container outline
    canvas.drawRRect(outerRect, paint);

    // Draw the edit/pencil icon inside
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.5;

    // Pencil/edit stroke
    path.moveTo(centerX - 4, centerY + 4);
    path.lineTo(centerX + 4, centerY - 4);

    // Pencil tip
    path.moveTo(centerX + 2, centerY - 2);
    path.lineTo(centerX + 4, centerY - 4);
    path.lineTo(centerX + 2, centerY - 6);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
