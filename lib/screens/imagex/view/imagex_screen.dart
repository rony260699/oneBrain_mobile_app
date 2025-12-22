import 'package:OneBrain/base/base_stateful_state.dart';
import 'package:OneBrain/common_widgets/common_appbar.dart';
import 'package:OneBrain/common_widgets/drawer_menu.dart';
import 'package:OneBrain/common_widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controller/imagex_controller.dart';
import 'widgets/imagex_chat_bar.dart';
import 'widgets/imagex_empty_state.dart';
import 'widgets/imagex_messages_list.dart';

class ImageXScreen extends StatefulWidget {
  final String? conversationId;
  const ImageXScreen({super.key, this.conversationId});

  @override
  ImageXScreenState createState() => ImageXScreenState();
}

class ImageXScreenState extends State<ImageXScreen> {
  late ImageXController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller and create new conversation
    _controller = Get.put(ImageXController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.conversationId != null) {
        _controller.setConversationId(widget.conversationId!);
      } else {
        // Create new conversation every time ImageXScreen is entered
        _controller.initializeConversation();
      }
    });
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        shouldShowBackButton: true,
        leading: DrawerMenu(
          onTap: () => scaffoldKey.currentState?.openDrawer(),
        ),
        prefixWidget: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ProfileMenu(),
        ),
      ),
      drawer: getAppDrawer(context: context, rootScaffoldKey: scaffoldKey),
      body: Container(
        // Updated to match main chat screen gradient exactly
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000), // Pure black at top for better text visibility
              Color(0xFF000000), // Keep black longer for content area
              Color(0xFF0A0E24), // Deep dark blue starts lower
              Color(0xFF0C1028), // Slightly lighter dark blue at bottom
            ],
            stops: [0.0, 0.7, 0.85, 1.0], // Push blue colors towards bottom
          ),
        ),
        child: SafeArea(
          child: GetBuilder<ImageXController>(
            init: ImageXController(),
            builder: (controller) {
              return Column(
                children: [
                  SvgPicture.asset('assets/images/imagexsvg.svg', height: 45.h),
                  // Messages Area
                  Expanded(
                    child: Obx(() {
                      final controller = Get.find<ImageXController>();
                      if (controller.messages.isEmpty) {
                        return ImageXEmptyState();
                      }
                      return ImageXMessagesList(
                        messages: controller.messages,
                        scrollController: controller.scrollController,
                      );
                    }),
                  ),
                  // Chat Input
                  ImageXChatBar(scrollController: controller.scrollController),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<ImageXController>();
    super.dispose();
  }
}
