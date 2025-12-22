import 'dart:ui';

import 'package:OneBrain/base/base_stateful_state.dart';
import 'package:OneBrain/common_widgets/new_chat_menu.dart';

import 'package:OneBrain/models/ai_model.dart' show AIModel;
import 'package:OneBrain/screens/explore/view/model_list_view.dart';
import 'package:OneBrain/common_widgets/common_widgets.dart';
import 'package:OneBrain/screens/home/change_model_popup_screen.dart';
import 'package:OneBrain/services/ai_model_service.dart';
import 'package:OneBrain/services/profile_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../common_widgets/common_appbar.dart';
import '../../common_widgets/text_widget.dart';
import '../../resources/image.dart';
import '../home/cubit/home_screen_cubit.dart';
import '../../utils/haptic_service.dart';

class ExploreAiLibraryScreen extends StatefulWidget {
  const ExploreAiLibraryScreen({super.key});

  @override
  State<ExploreAiLibraryScreen> createState() => _ExploreAiLibraryScreenState();
}

class _ExploreAiLibraryScreenState
    extends BaseStatefulWidgetState<ExploreAiLibraryScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    shouldHaveSafeArea = false; // Disable safe area to remove bottom white bar
    extendBodyBehindAppBar = false;
    scaffoldBgColor = Color(
      0xFF0A0E27,
    ); // Set dark background to match the theme

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
      builder:
          (context) => BackdropFilter(
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

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CommonAppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      shouldShowBackButton: true,
      leading: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          // Navigator.of(context).pop();
          FocusScope.of(context).requestFocus(FocusNode());
          rootScaffoldKey.currentState?.openDrawer();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: SvgPicture.asset(
            "assets/icons/logo.svg",
            height: 30.sp,
            width: 30.sp,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
      prefixWidget: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: NewChatMenu(
          onTap: () {
            HapticService.onNewConversation();
            final homeCubit = HomeScreenCubit.get(context);
            homeCubit.startNewChat();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
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
              child:
                  ProfileService.user != null
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
      titleFontSize: 18,
      titleFontWeight: FontWeight.w500,
      textColor: Colors.white,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: _buildChatModelsTab(),
    );
  }

  Widget _buildChatModelsTab() {
    List<Map<String, dynamic>> models =
        AIModelService.getConversationsProviders;

    return ListView.builder(
      itemCount: models.length,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 8, bottom: 40),
      itemBuilder: (context, index) {
        final model = models[index];
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            await AIModelService.toggleProviderStatus(
              model['provider'],
              context,
            );
            setState(() {});
          },
          child: ModelListView(
            provider: model['provider'],
            isActive: AIModelService.isProviderActive(model['provider']),
            image: model['icon'],
            description: model['description'],
          ),
        );
      },
    );
  }
}
