import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:OneBrain/base/base_stateful_state.dart';
import 'package:OneBrain/common_widgets/common_widgets.dart';
import 'package:OneBrain/common_widgets/image_select_dialog.dart';
import 'package:OneBrain/common_widgets/model_gradient_animation.dart';
import 'package:OneBrain/common_widgets/new_chat_menu.dart';
import 'package:OneBrain/common_widgets/profile_menu.dart';
import 'package:OneBrain/common_widgets/shuffle_text.dart';
import 'package:OneBrain/common_widgets/text_widget.dart';
import 'package:OneBrain/models/ai_model.dart';
import 'package:OneBrain/models/chat_statistics.dart';
import 'package:OneBrain/models/message_model.dart';
import 'package:OneBrain/resources/strings.dart';
import 'package:OneBrain/screens/home/change_model_popup_screen.dart';
import 'package:OneBrain/screens/home/cubit/home_screen_cubit.dart';
import 'package:OneBrain/screens/home/view/context_tooltip.dart';
import 'package:OneBrain/screens/home/view/model_message_view.dart';
import 'package:OneBrain/screens/home/view/right_message_view.dart';
import 'package:OneBrain/screens/home/view/shimmer.dart';
import 'package:OneBrain/screens/payment_billing/payment_page.dart';
import 'package:OneBrain/services/ai_model_service.dart';
import 'package:OneBrain/services/folder_service.dart';
import 'package:OneBrain/services/profile_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../common_widgets/app_utils.dart';
import '../../common_widgets/common_appbar.dart';
import '../../common_widgets/drawer_menu.dart';
import '../../resources/image.dart';
import '../../utils/haptic_service.dart';
import '../../utils/helper/sse_service_helper.dart';
import 'cubit/home_screen_states.dart';
import 'model/live_event_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStatefulWidgetState<HomeScreen>
    with TickerProviderStateMixin {
  bool isPopupOpen = false;

  late final SseManager<LiveEvent> sseManager;

  // Profile menu controller

  @override
  void initState() {
    getDataModel();
    scaffoldBgColor = Colors.transparent;
    shouldHaveSafeArea = true; // Enable safe area to avoid navigation buttons
    extendBodyBehindAppBar = true;
    resizeToAvoidBottomInset = false;
    isBackgroundImage = true;
    scrollController.addListener(onScroll);
    String? chatId = HomeScreenCubit.get(context).currentChatID;
    HomeScreenCubit.get(context).switchChat(chatId);
    super.initState();
  }

  double maxHeight = 0;
  bool _showScrollToBottomButton = false;
  onScroll() {
    if (scrollController.hasClients) {
      bool canShowScrollToBottomButton =
          (scrollController.position.maxScrollExtent -
              scrollController.position.pixels) >
          300;

      if (canShowScrollToBottomButton != _showScrollToBottomButton) {
        _showScrollToBottomButton = canShowScrollToBottomButton;
        HomeScreenCubit.get(context).isBtnVisible = true;
        setState(() {});
      }
    }
  }

  Future<void> _onScrollToBottomTapped() async {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  Future<void> getDataModel() async {
    AIModelService.initDefaultModel();

    if (mounted) {
      setState(() {});
    }
    await ProfileService.getChatStatistics();

    await ProfileService.getCurrentUser();
    AIModelService.initDefaultModel();

    if (mounted) {
      setState(() {});
    }
    FolderService.init();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    bool canShowNewChatButton =
        HomeScreenCubit.get(context).currentChatID != null;
    return CommonAppBar(
      titleFontSize: 18,
      centerTitle: true,
      textColor: Colors.white,
      shouldShowBackButton: true,
      titleFontWeight: FontWeight.w500,
      backgroundColor: Colors.transparent,
      leading: DrawerMenu(
        onTap: () {
          rootScaffoldKey.currentState?.openDrawer();
        },
      ),
      prefixWidget: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: canShowNewChatButton
            ? NewChatMenu(
                onTap: () {
                  HomeScreenCubit.get(context).startNewChat();
                  setState(() {});
                },
              )
            : ProfileMenu(),
      ),
      titleWidget: Column(
        children: [
          SvgPicture.asset(SVGImg.appLogo, width: 140, height: 22),
          SizedBox(height: 4),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              if (ProfileService.user == null) {
                return;
              }
              AIModel? model = await openChangeModelPopup();
              if (model != null) {
                AIModelService.setDefaultModel(model);
                if (mounted) {
                  setState(() {});
                }
              }
            },
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    HexColor('#A855F7').withValues(alpha: 0.15),
                    HexColor('#3B82F6').withValues(alpha: 0.15),
                    HexColor('#06B6D4').withValues(alpha: 0.15),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 0.5, 1.0],
                  tileMode: TileMode.clamp,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ProfileService.user != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        right: 8.0,
                        top: 2,
                        bottom: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextWidget(
                            text: AIModelService.defaultModel?.name,
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                          widthBox(4),
                          Image.asset(
                            PNGImages.downArrow2,
                            color: Colors.white,
                            height: 12,
                            width: 12,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 8,
                      width: 8,
                      child: Center(child: CupertinoActivityIndicator()),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<AIModel?> openChangeModelPopup() async {
    AIModel? model = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: ChangeModelPopupScreen(
            selectedAiModel: AIModelService.defaultModel,
            user: ProfileService.user!,
          ),
        ),
      ),
    );
    return model;
  }

  final ScrollController scrollController = ScrollController();

  Future<void> scrollToBottom() async {
    if (!scrollController.hasClients) return;
    await Future.delayed(const Duration(milliseconds: 300));
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> scrollToBottomonChatInit() async {
    if (!scrollController.hasClients) return;
    // scrollController.animateTo(
    //   scrollController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  // Helper method to check if send button should be active - UPDATED FOR IMMEDIATE ATTACHMENT SENDING
  bool _isSendButtonActive() {
    final cubit = HomeScreenCubit.get(context);

    // If a message is being generated, the send button is not active (it will show as a stop button)
    if (cubit.isGeneratingMessage) {
      return false;
    }
    if (cubit.isLoadingAttachments) {
      return false;
    }
    // Case 1: Text message only (no attachments) - always allow send
    if (cubit.txtMessage.text.isNotEmpty && cubit.selectedAttachments.isEmpty) {
      return true;
    }
    // Case 2: Text message + attachments - allow immediate send
    if (cubit.txtMessage.text.isNotEmpty &&
        cubit.selectedAttachments.isNotEmpty) {
      return !cubit.isLoadingAttachments; // Only block during processing
    }
    // Case 3: Attachments only (no text) - allow immediate send
    if (cubit.txtMessage.text.isEmpty && cubit.selectedAttachments.isNotEmpty) {
      return !cubit.isLoadingAttachments; // Only block during processing
    }
    // Case 4: No text and no attachments - button should be inactive
    return false;
  }

  @override
  Widget buildBody(BuildContext context) {
    return BlocConsumer<HomeScreenCubit, HomeScreenStates>(
      listener: (cubit, state) async {
        if (state is HomeScreenErrorState) {
          showError(message: state.errorMessage);
        }
        if (state is ChatSwitched) {
          setState(() {});
          scrollToBottomonChatInit();
          await Future.delayed(const Duration(milliseconds: 100));
          scrollToBottomonChatInit();
          await Future.delayed(const Duration(milliseconds: 100));
          scrollToBottomonChatInit();
          await Future.delayed(const Duration(milliseconds: 100));
          scrollToBottomonChatInit();
          // await Future.delayed(const Duration(milliseconds: 200));
          // scrollToBottomonChatInit();
        }
        // Handle stop generation state to ensure immediate UI update
        if (state is HomeScreenMessageGenerationStopped) {
          setState(() {});
        }
        // Handle edit mode state changes
        if (state is HomeScreenEditModeEntered ||
            state is HomeScreenEditModeCancelled) {
          setState(() {});
        }
      },
      builder: (context, snapshot) {
        List<Message> messages = HomeScreenCubit.get(context).chatMessages;
        ChatStatistics? chatStatistics = ProfileService.chatStatistics;
        bool isDailyCapHit = ProfileService.isDailyCapHit;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0.6, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Color(0xff0E0E1A)],
                  ),
                ),
                child: SafeArea(
                  bottom: MediaQuery.of(context).viewInsets.bottom == 0,
                  child: Column(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            maxHeight = constraints.maxHeight;
                            return snapshot is HomeScreenSwitchLoadingState
                                ? Center(child: CupertinoActivityIndicator())
                                : HomeScreenCubit.get(context).currentChatID !=
                                      null
                                ? Stack(
                                    children: [
                                      Opacity(
                                        opacity:
                                            HomeScreenCubit.get(
                                              context,
                                            ).isLoadingChat
                                            ? 0
                                            : 1,
                                        child: ListView.builder(
                                          controller: scrollController,
                                          itemCount: messages.length,
                                          cacheExtent: 1000,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          padding: const EdgeInsets.only(
                                            top: 12,
                                            bottom: 40,
                                          ),
                                          addRepaintBoundaries: true,
                                          itemBuilder: (context, index) {
                                            bool isGenerating = true;
                                            int messageIndex = index;
                                            int lastMessageIndex =
                                                messages.length - 1;
                                            int secondLastMessageIndex =
                                                messages.length - 2;
                                            bool isLastMessage =
                                                messageIndex ==
                                                lastMessageIndex;
                                            bool isSecondLastMessage =
                                                messageIndex ==
                                                secondLastMessageIndex;
                                            if (isGenerating &&
                                                messages.length >= 2) {
                                              if (isSecondLastMessage) {
                                                return const SizedBox.shrink();
                                              } else if (isLastMessage) {
                                                String currentActiveProvider =
                                                    messages[lastMessageIndex]
                                                        .provider
                                                        ?.toLowerCase() ??
                                                    "";
                                                return Container(
                                                  constraints: BoxConstraints(
                                                    minHeight:
                                                        constraints.maxHeight -
                                                        50,
                                                  ),
                                                  width: double.infinity,
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: RightMessageView(
                                                          currentMessage:
                                                              messages[secondLastMessageIndex],
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child:
                                                            HomeScreenCubit.get(
                                                              context,
                                                            ).isThinking
                                                            ? Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(
                                                                      left:
                                                                          18.0,
                                                                      bottom:
                                                                          20,
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        RotatingSvgIcon(
                                                                          assetPath: AIModelService.getIcon(
                                                                            currentActiveProvider,
                                                                            true,
                                                                          ),
                                                                          size:
                                                                              24,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        ModelGradientAnimation(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          modelName:
                                                                              currentActiveProvider.capitalizeFirst,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5.h,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.only(
                                                                          left:
                                                                              20.0,
                                                                        ),
                                                                    child: Text(
                                                                      "Thinking...",
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  ThinkingShimmer(),
                                                                ],
                                                              ) // 👈 shimmer loader widget
                                                            : ModelMessageView(
                                                                currentMessage:
                                                                    messages[lastMessageIndex],
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            }

                                            return (messages[messageIndex]
                                                        .role ==
                                                    "user")
                                                ? RightMessageView(
                                                    currentMessage:
                                                        messages[messageIndex],
                                                  )
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom: isLastMessage
                                                          ? 40.h
                                                          : 0,
                                                    ),
                                                    child: ModelMessageView(
                                                      currentMessage:
                                                          messages[messageIndex],
                                                    ),
                                                  );
                                          },
                                        ),
                                      ),
                                      if (HomeScreenCubit.get(
                                        context,
                                      ).isLoadingChat)
                                        Center(
                                          child: CupertinoActivityIndicator(),
                                        ),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 32,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: ShuffleText(
                                        greetingText: HomeScreenCubit.get(
                                          context,
                                        ).getGreeting,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: strFontName,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        duration: Duration(milliseconds: 1500),
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                      AnimatedContainer(
                        width: double.infinity,
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          boxShadow: [],
                          color: HexColor('#0a0a0a'),
                          border: Border(
                            top: BorderSide(
                              width: 1.0,
                              color: HexColor('#52525B'),
                            ),
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 24.0,
                            right: 16.0,
                            // _getBottomPadding(), // Dynamic bottom padding based on AI tools and keyboard
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Tool Suggestion Widgets
                                  // Tool switcher removed - now using Change Model area
                                  // Attachment preview using new widget
                                  _buildAttachmentPreview(),
                                  const SizedBox(height: 4),
                                  // Editing banner
                                  if (HomeScreenCubit.get(
                                    context,
                                  ).isEditingMessage)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 4,
                                      ),
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: Color(
                                          0xFF3B82F6,
                                        ).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                        // border: Border.all(
                                        //   color: Color(0xFF3B82F6),
                                        //   width: 1,
                                        // ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.edit_outlined,
                                            color: Color(0xFF3B82F6),
                                            size: 22,
                                          ),
                                          SizedBox(width: 8),
                                          TextWidget(
                                            text: 'Editing message',
                                            color: Color(0xFF3B82F6),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              HomeScreenCubit.get(
                                                context,
                                              ).cancelEditMode();
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              child: Icon(
                                                Icons.close,
                                                color: Color(0xFF3B82F6),
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  // Text input field
                                  TextField(
                                    minLines: 1,
                                    maxLines: 6,
                                    enabled: !isDailyCapHit,
                                    scrollPadding: EdgeInsets.zero,
                                    keyboardAppearance: Brightness.dark,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    style: TextStyle(
                                      height: 1.3,
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontFamily: strFontName,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 1.3,
                                      leading: 0.5,
                                      fontSize: 16.sp,
                                      forceStrutHeight: true,
                                    ),
                                    focusNode: HomeScreenCubit.get(
                                      context,
                                    ).focusMessage,
                                    controller: HomeScreenCubit.get(
                                      context,
                                    ).txtMessage,
                                    onChanged: (string) {
                                      if (string.isNotEmpty) {
                                        String capitalizedText =
                                            _capitalizeSentences(string);
                                        if (capitalizedText != string) {
                                          int cursorPosition =
                                              HomeScreenCubit.get(
                                                context,
                                              ).txtMessage.selection.baseOffset;
                                          HomeScreenCubit.get(
                                            context,
                                          ).txtMessage.value = TextEditingValue(
                                            text: capitalizedText,
                                            selection: TextSelection.collapsed(
                                              offset: cursorPosition,
                                            ),
                                          );
                                        }
                                      } else {
                                        context
                                                .read<HomeScreenCubit>()
                                                .isListening =
                                            false;
                                        context
                                                .read<HomeScreenCubit>()
                                                .recognizedText =
                                            "";
                                      }
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintStyle: TextStyle(
                                        color: HexColor('#9CA3AF'),
                                        fontSize: 16.sp,
                                        fontFamily: strFontName,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 0,
                                      ),
                                      hintText: isDailyCapHit
                                          ? "You've reached the daily limit. You can get tokens again after ${chatStatistics?.resetAtFormatted}"
                                          : context
                                                    .watch<HomeScreenCubit>()
                                                    .currentLocale ==
                                                "en_US"
                                          ? messages.isEmpty
                                                ? "Send a message..."
                                                : HomeScreenCubit.get(context)
                                                      .getPlaceholder()
                                                      .replaceFirst(
                                                        '{username}',
                                                        ProfileService
                                                                .user
                                                                ?.getFullName ??
                                                            'You',
                                                      )
                                          : "একটি বার্তা পাঠান...",
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    HomeScreenCubit.get(
                                      context,
                                    ).isGeneratingMessage
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.spaceBetween,
                                children: [
                                  if (!HomeScreenCubit.get(
                                    context,
                                  ).isGeneratingMessage)
                                    GestureDetector(
                                      onTap: () async {
                                        // Show modern attachment selection dialog directly
                                        dynamic result =
                                            await ImageSelectDialog.onImageSelection2(
                                              mainContext: context,
                                              imageCount: 1,
                                            );
                                        if (result == "search_web") {
                                          return;
                                        }
                                        if (result == "think_longer") {
                                          return;
                                        }

                                        if (result != null) {
                                          await HomeScreenCubit.get(
                                            context,
                                          ).handleAttachmentResult(result);
                                        }
                                      },
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Image.asset(
                                            height: 36,
                                            width: 36,
                                            PNGImages.addImage,
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (!HomeScreenCubit.get(
                                    context,
                                  ).isGeneratingMessage) ...[
                                    SizedBox(width: 150.w),
                                    HomeScreenCubit.get(
                                              context,
                                            ).txtMessage.text.isEmpty &&
                                            !HomeScreenCubit.get(
                                              context,
                                            ).isListening
                                        ? const SizedBox.shrink()
                                        : HomeScreenCubit.get(
                                            context,
                                          ).isListening
                                        ? const Text("Click To Stop")
                                        : const SizedBox.shrink(),
                                  ],
                                  Opacity(
                                    opacity:
                                        _isSendButtonActive() ||
                                            HomeScreenCubit.get(
                                              context,
                                            ).isGeneratingMessage
                                        ? 1.0
                                        : 0.9,
                                    child:
                                        HomeScreenCubit.get(
                                          context,
                                        ).isGeneratingMessage
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              await HomeScreenCubit.get(
                                                context,
                                              ).stopGenerating();
                                              setState(() {});
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 2,
                                              padding: EdgeInsets.zero,
                                              shape: const CircleBorder(),
                                              fixedSize: const Size(31, 31),
                                              backgroundColor:
                                                  Colors.red.shade900,
                                            ),
                                            child: const Icon(
                                              size: 15,
                                              CupertinoIcons.stop_fill,
                                            ),
                                          )
                                        : HomeScreenCubit.get(
                                            context,
                                          ).txtMessage.text.isEmpty
                                        ? Stack(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  context
                                                      .read<HomeScreenCubit>()
                                                      .toggleVoiceListening();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 10.0,
                                                      ),
                                                  child: Container(
                                                    height: 40.h,
                                                    width: 40.w,
                                                    padding: EdgeInsets.all(
                                                      context
                                                              .read<
                                                                HomeScreenCubit
                                                              >()
                                                              .isListening
                                                          ? 8
                                                          : 5,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Color(
                                                          0xFF374151,
                                                        ),
                                                      ),
                                                      color:
                                                          context
                                                              .read<
                                                                HomeScreenCubit
                                                              >()
                                                              .isListening
                                                          ? Colors.white
                                                          : Color(0xFF1b2433),
                                                    ),
                                                    child:
                                                        context
                                                            .read<
                                                              HomeScreenCubit
                                                            >()
                                                            .isListening
                                                        ? Image.asset(
                                                            "assets/gifs/voice.gif",
                                                          )
                                                        : Image.asset(
                                                            "assets/icons/voice.png",
                                                            color: Color(
                                                              0xFF61a5fb,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    context
                                                        .read<HomeScreenCubit>()
                                                        .toggleLanguage();
                                                  },
                                                  child: Container(
                                                    height: 17.h,
                                                    width: 25.w,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                      border: Border.all(
                                                        width: 1.2,
                                                        color: Color(
                                                          0xFF374151,
                                                        ),
                                                      ),
                                                      color: Colors.black,
                                                    ),
                                                    child: Text(
                                                      context
                                                                  .watch<
                                                                    HomeScreenCubit
                                                                  >()
                                                                  .currentLocale ==
                                                              "en_US"
                                                          ? "EN"
                                                          : "বা",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 2,
                                              padding: EdgeInsets.zero,
                                              shape: const CircleBorder(),
                                              fixedSize: const Size(31, 31),
                                              backgroundColor: Colors.white,
                                            ),
                                            child: const Icon(
                                              size: 20,
                                              color: Colors.black,
                                              CupertinoIcons.arrow_up,
                                            ),
                                            onPressed: () async {
                                              if (_isSendButtonActive()) {
                                                // ChatGPT-style haptic feedback for message send
                                                HapticService.onMessageSent();
                                                // Store message before clearing for better UX
                                                String messageToSend =
                                                    HomeScreenCubit.get(
                                                      context,
                                                    ).txtMessage.text.isEmpty
                                                    ? "Attached ${HomeScreenCubit.get(context).selectedAttachments.length} file(s)"
                                                    : HomeScreenCubit.get(
                                                        context,
                                                      ).txtMessage.text;

                                                FocusScope.of(
                                                  context,
                                                ).requestFocus(FocusNode());

                                                final cubit =
                                                    HomeScreenCubit.get(
                                                      context,
                                                    );

                                                // Handle edit mode
                                                if (cubit.isEditingMessage &&
                                                    cubit.messageBeingEdited !=
                                                        null) {
                                                  // Step 1: Delete trailing messages
                                                  final messageId = cubit
                                                      .messageBeingEdited!
                                                      .sId;
                                                  if (messageId != null) {
                                                    final deleteSuccess =
                                                        await cubit
                                                            .deleteTrailingMessages(
                                                              messageId,
                                                            );

                                                    if (deleteSuccess) {
                                                      // Step 2: Remove messages from local list
                                                      final messageIndex = cubit
                                                          .chatMessages
                                                          .indexWhere(
                                                            (msg) =>
                                                                msg.sId ==
                                                                messageId,
                                                          );
                                                      if (messageIndex != -1) {
                                                        cubit.chatMessages
                                                            .removeRange(
                                                              messageIndex,
                                                              cubit
                                                                  .chatMessages
                                                                  .length,
                                                            );
                                                      }

                                                      // Step 3: Exit edit mode
                                                      cubit.cancelEditMode();

                                                      // Step 4: Send new message
                                                      cubit.sendMessage(
                                                        message: messageToSend,
                                                        onSuccess: () =>
                                                            setState(() {}),
                                                        editMessageId:
                                                            messageId,
                                                      );

                                                      scrollToBottom();
                                                    } else {
                                                      showError(
                                                        message:
                                                            "Failed to edit message",
                                                      );
                                                    }
                                                  }
                                                } else {
                                                  // Normal send message flow
                                                  cubit.sendMessage(
                                                    message: messageToSend,
                                                    onSuccess: () =>
                                                        setState(() {}),
                                                  );

                                                  scrollToBottom();
                                                }
                                              }
                                            },
                                          ),
                                  ),
                                ],
                              ),
                              if (isDailyCapHit)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      TextWidget(
                                        maxLines: 2,
                                        fontSize: 9.sp,
                                        fontFamily: "Roboto",
                                        color: Color(0xffF87171),
                                        fontWeight: FontWeight.w500,
                                        text:
                                            "You've reached the daily limit. You can get tokens again after ${chatStatistics?.resetAtFormatted}",
                                      ),
                                      SizedBox(height: 3),
                                      TextButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentPage(),
                                            ),
                                          );
                                        },
                                        icon: SvgPicture.asset(
                                          width: 14,
                                          height: 14,
                                          "assets/icons/upgrade.svg",
                                        ),
                                        label: Text(
                                          'Upgrade your plan to get more tokens',
                                          style: TextStyle(
                                            color: Color(0xff60a5fa),
                                            fontSize: 10.sp,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Color(0xff60a5fa),
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          minimumSize: Size(0, 0),
                                          padding: EdgeInsets.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Floating "Scroll to Bottom" button with enhanced UX (normal layout)
              Positioned(
                right: 16,
                bottom: 120,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child:
                      _showScrollToBottomButton &&
                          !HomeScreenCubit.get(context).isLoadingChat &&
                          HomeScreenCubit.get(context).isBtnVisible
                      ? FloatingActionButton.small(
                          onPressed: _onScrollToBottomTapped,
                          backgroundColor: Color(
                            0xff0E0E1A,
                          ).withValues(alpha: 0.9),
                          foregroundColor: Colors.white,
                          elevation: 4,
                          child: Icon(Icons.keyboard_arrow_down, size: 24),
                        )
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to capitalize sentences
  String _capitalizeSentences(String text) {
    if (text.isEmpty) return text;
    String result = text;
    // Capitalize first letter
    if (result.isNotEmpty &&
        result[0].toLowerCase() != result[0].toUpperCase()) {
      result = result[0].toUpperCase() + result.substring(1);
    }
    // Capitalize after sentence-ending punctuation (., !, ?)
    RegExp sentenceEnd = RegExp(r'[.!?]\s+[a-z]');
    result = result.replaceAllMapped(sentenceEnd, (match) {
      String matched = match.group(0)!;
      return matched.substring(0, matched.length - 1) +
          matched[matched.length - 1].toUpperCase();
    });
    return result;
  }

  // Helper method to build simplified attachment preview
  Widget _buildAttachmentPreview() {
    final cubit = HomeScreenCubit.get(context);
    return Container(
      // margin: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simple status row
          Row(
            children: [
              // Processing status
              if (cubit.isLoadingAttachments)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Processing...',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              // Clear button
              if (!cubit.isLoadingAttachments &&
                  cubit.selectedAttachments.isNotEmpty &&
                  cubit.selectedAttachments.length > 1) ...[
                InkWell(
                  onTap: () => cubit.clearAttachments(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF94A3B8).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Clear All',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.close, color: Colors.grey, size: 15),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
              ],

              ContextTooltip(contextUsed: cubit.chatMessages.length),
            ],
          ),
          if (cubit.selectedAttachments.isNotEmpty) const SizedBox(height: 12),

          // Simple file preview
          if (cubit.selectedAttachments.isNotEmpty)
            SizedBox(
              height: 60,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cubit.selectedAttachments.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final attachments = cubit.selectedAttachments[index];
                    final fileName =
                        attachments.originalName ?? attachments.name ?? '';
                    final isImage = _isImageFile(fileName);
                    final file = File(attachments.localPath ?? '');

                    return AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        children: [
                          // File content (image thumbnail or icon)
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: isImage
                                  ? Image.file(
                                      file,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return _buildFileIcon(fileName);
                                          },
                                    )
                                  : _buildFileIcon(fileName),
                            ),
                          ),

                          // Remove button
                          Align(
                            alignment: Alignment(1.3, -1.3),
                            child: InkWell(
                              onTap: () => cubit.removeAttachment(index),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: const Offset(0, 0),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to check if file is an image
  bool _isImageFile(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'].contains(extension);
  }

  // Helper method to build file icon
  Widget _buildFileIcon(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    IconData iconData;
    Color iconColor;

    switch (extension) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'doc':
      case 'docx':
        iconData = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'xls':
      case 'xlsx':
        iconData = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case 'ppt':
      case 'pptx':
        iconData = Icons.slideshow;
        iconColor = Colors.orange;
        break;
      case 'mp3':
      case 'wav':
      case 'mpeg':
        iconData = Icons.audiotrack;
        iconColor = Colors.purple;
        break;
      case 'txt':
      case 'csv':
        iconData = Icons.text_snippet;
        iconColor = Colors.grey;
        break;
      case 'zip':
      case 'rar':
        iconData = Icons.archive;
        iconColor = Colors.brown;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return Container(
      color: Colors.grey[800],
      child: Center(child: Icon(iconData, size: 32, color: iconColor)),
    );
  }

  /*  Widget _buildThinkingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: 150, color: Colors.grey[850]),
                  const SizedBox(height: 6),
                  Container(height: 12, width: 100, color: Colors.grey[850]),
                  const SizedBox(height: 6),
                  Container(height: 12, width: 180, color: Colors.grey[850]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  } */
}
