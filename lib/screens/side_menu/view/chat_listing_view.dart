import 'package:OneBrain/models/chart_model.dart';
import 'package:flutter/material.dart';
import '../../../base/base_stateful_state.dart';
import '../../home/cubit/home_screen_cubit.dart';
import 'chat_history_view.dart';

class ChatListingView extends StatefulWidget {
  final String tag;
  final List<Chat> chats;
  final VoidCallback closeMenu;
  const ChatListingView({
    super.key,
    required this.tag,
    required this.chats,
    required this.closeMenu,
  });

  @override
  State<ChatListingView> createState() => _ChatListingViewState();
}

class _ChatListingViewState extends State<ChatListingView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false; // Don't keep alive for better memory management

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    // if (widget.currentChat.arrOfConversations.isEmpty) {
    //   return const SizedBox.shrink();
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Date header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: 2.0,
            bottom: 4.0,
            top: 8.0,
          ), // Further reduced left padding from 4 to 2
          child: Text(
            widget.tag,
            style: TextStyle(
              fontSize: 12, // Increased from 11 to 12
              color: HexColor('#9CA3AF'),
              fontWeight: FontWeight.w600, // Increased from w500 to w600
            ),
          ),
        ),
        // Chat items
        ...widget.chats.map<Widget>((chat) {
          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => _onChatTap(chat),
            child: ChatHistoryView(chat: chat),
          );
        }),
      ],
    );
  }

  void _onChatTap(Chat chat) async {
    try {
      widget.closeMenu();

      // NO LOADER - Instant switching with cache!
      final homeCubit = HomeScreenCubit.get(context);
      homeCubit.switchChat(chat.id ?? "");

      // Update selection state immediately for instant UI feedback
      // for (var model in homeCubit.arrOfConversations) {
      //   for (var model2 in model.arrOfConversations) {
      //     model2.isSelected = false;
      //   }
      // }
      // chat.isSelected = true;

      // if (mounted) {
      //   setState(() {});
      // }

      // Close menu immediately for responsive feel
      await Future.delayed(const Duration(milliseconds: 200));

      Navigator.of(context).popUntil((route) => route.isFirst);

      // Load conversation (instant if cached, fast if not)
      // await homeCubit.getSingleConversation();
    } catch (e) {
      debugPrint('Error loading conversation: $e');
      // Even on error, don't show loader - just handle gracefully
    }
  }
}
