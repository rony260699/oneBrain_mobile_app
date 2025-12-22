import 'package:OneBrain/base/base_stateful_state.dart';
import 'package:OneBrain/common_widgets/drawer_menu.dart';
import 'package:OneBrain/common_widgets/new_chat_menu.dart';
import 'package:OneBrain/resources/color.dart';
import 'package:OneBrain/screens/imagex/view/imagex_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../common_widgets/common_appbar.dart';
import '../../common_widgets/text_widget.dart';
import '../../resources/image.dart';
import '../home/cubit/home_screen_cubit.dart';
import '../../utils/haptic_service.dart';

class ImagineScreen extends StatefulWidget {
  const ImagineScreen({super.key});

  @override
  State<ImagineScreen> createState() => _ImagineScreenState();
}

class _ImagineScreenState extends State<ImagineScreen> {
  ImagineType _selectedTab = ImagineType.image;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(0xff1F2937),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          buildTabItem("Image", ImagineType.image),
          buildTabItem("Videos", ImagineType.videos),
          buildTabItem("Audio", ImagineType.audio),
          buildTabItem("Tools", ImagineType.tools),
        ],
      ),
    );
  }

  Widget buildTabItem(String label, ImagineType type) {
    bool isSelected = _selectedTab == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = type;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xff3B82F6) : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xffD1D5DB),
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContentList() {
    List<ImagineDataModel> filteredData =
        imagineData.where((item) => item.type == _selectedTab).toList();

    return ListView.builder(
      itemCount: filteredData.length,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemBuilder: (context, index) {
        final item = filteredData[index];
        return buildImagineCard(item);
      },
    );
  }

  Widget buildImagineCard(ImagineDataModel item) {
    return GestureDetector(
      onTap: () => item.onTap(context),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xff1E293B),
          borderRadius: BorderRadius.circular(12.sp),
          border: Border.all(color: Color(0xffD1D5DB), width: 1),
        ),
        child: Row(
          children: [
            // Icon/Logo
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xffD8D8D8),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(6),
              child: Center(child: getIconForItem(item)),
            ),
            SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: TextWidget(
                                text: item.title,
                                fontSize: 16.sp,
                                color: colorWhite,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Roboto",
                              ),
                            ),
                            if (item.isNew) ...<Widget>[
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xff3B82F6),
                                  borderRadius: BorderRadius.circular(20.sp),
                                ),
                                child: TextWidget(
                                  text: "New",
                                  fontSize: 10.sp,
                                  color: colorWhite,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(width: 12),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 16,
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextWidget(
                          text: item.description,
                          fontSize: 12.sp,
                          color: colorWhite,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getIconForItem(ImagineDataModel item) {
    if (item.image.contains(".png")) {
      return Image.asset(item.image, height: 55.sp, width: 55.sp);
    }
    return SvgPicture.asset(item.image, height: 55.sp, width: 55.sp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: getAppDrawer(context: context, rootScaffoldKey: scaffoldKey),
      appBar: CommonAppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        shouldShowBackButton: true,
        leading: DrawerMenu(
          onTap: () {
            scaffoldKey.currentState?.openDrawer();
          },
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(SVGImg.appLogo, width: 140, height: 22),
            SizedBox(height: 28),
          ],
        ),
        titleFontSize: 18,
        titleFontWeight: FontWeight.w500,
        textColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF000000), Color(0xFF0A0E24)],
          ),
        ),
        child: Column(
          children: [
            // Header Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextWidget(
                text: "The All-in-One AI Super App",
                fontSize: 26.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                fontFamily: "Roboto",
              ),
            ),

            SizedBox(height: 20),
            // Tab Bar
            buildTabBar(),
            SizedBox(height: 20),
            // Content List
            Expanded(child: buildContentList()),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

enum ImagineType { image, videos, audio, tools }

class ImagineDataModel {
  final bool isNew;
  final String image;
  final String title;
  final ImagineType type;
  final String description;
  final Function(BuildContext context) onTap;

  ImagineDataModel({
    this.isNew = false,
    required this.type,
    required this.title,
    required this.image,
    required this.onTap,
    required this.description,
  });
}

List<ImagineDataModel> imagineData = [
  ImagineDataModel(
    type: ImagineType.image,
    title: "Nano Banana",
    description:
        "Google's revolutionary Nano Banana model from Replicate - advanced AI image generation with cutting-edge technology.",
    image: "assets/ai_icon/google.svg",
    isNew: true,
    onTap: (BuildContext context) {
      print("Navigate to nano banana");
    },
  ),
  ImagineDataModel(
    type: ImagineType.image,
    title: "ImageX",
    description:
        "Experience the most advanced image generator developed by DIGITX",
    image: "assets/ai_icon/max_black.png",
    isNew: false,
    onTap: (BuildContext context) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const ImageXScreen()));
      return;
    },
  ),
  ImagineDataModel(
    type: ImagineType.image,
    title: "Flux",
    description:
        "Black Forest Labs (BFL) is an AI company specializing in generative media. Their main product, FLUX, is a powerful text-to-image model suite used to create, edit, and guide images with advanced tools like inpainting, depth mapping, and style variation. BFL focuses on fast, high-quality image generation for creators and enterprises.",
    image: "assets/ai_icon/flux_black.svg",
    isNew: false,
    onTap: (BuildContext context) {
      print("Navigate to Flux");
    },
  ),
  ImagineDataModel(
    type: ImagineType.image,
    title: "Kontext Restore",
    description:
        "AI-powered image restoration and enhancement - restore old photos, remove noise, and improve image quality.",
    image: "assets/ai_icon/flux_black.svg",
    isNew: false,
    onTap: (BuildContext context) {
      print("Navigate to Kontext Restore");
    },
  ),
  ImagineDataModel(
    type: ImagineType.videos,
    title: "KlingAI",
    description:
        "KlingAI is an AI tool by Kuaishou that turns text or images into high-quality videos. It supports 1080p resolution, motion effects, and multi-video generation. Users get free daily credits, with paid plans available. While powerful, some users report issues like slow rendering and poor support.",
    image: "assets/ai_icon/kling_black.svg",
    isNew: false,
    onTap: (BuildContext context) {
      print("Navigate to KlingAI");
    },
  ),
  ImagineDataModel(
    type: ImagineType.videos,
    title: "Veo3",
    description:
        "Experience next-generation video creation with Google's Veo3 - advanced AI video generation technology.",
    image: "assets/ai_icon/google.svg",
    isNew: false,
    onTap: (BuildContext context) {
      print("Navigate to Veo3");
    },
  ),
  ImagineDataModel(
    type: ImagineType.videos,
    title: "VGen",
    description:
        "Discover the cutting-edge video generation technology crafted by DIGITX.",
    image: "assets/ai_icon/vGen_black.svg",
    isNew: false,
    onTap: (BuildContext context) {
      print("Navigate to VGen");
    },
  ),
  ImagineDataModel(
    type: ImagineType.videos,
    title: "Seedance",
    description:
        "Revolutionary video generation powered by Replicate's Seedance model - create stunning videos with advanced AI technology and precision.",
    image: "assets/ai_icon/seedance.png",
    isNew: false,
    onTap: (BuildContext context) {
      print("Navigate to Seedance");
    },
  ),
  ImagineDataModel(
    type: ImagineType.videos,
    title: "Sora",
    description:
        "OpenAI's groundbreaking Sora model - create stunning, realistic videos from text descriptions with advanced AI video generation technology.",
    image: "assets/ai_icon/sora_black.svg",
    isNew: true,
    onTap: (BuildContext context) {
      print("Navigate to Sora");
    },
  ),
  ImagineDataModel(
    type: ImagineType.videos,
    title: "RunwayML",
    description:
        "Generate high-quality videos from text and images using Runway's advanced AI models. Create stunning motion graphics and video content.",
    image: "assets/ai_icon/runway_black.svg",
    isNew: false,
    onTap: (BuildContext context) {
      print("Navigate to RunwayML");
    },
  ),
  ImagineDataModel(
    type: ImagineType.videos,
    title: "Hailuo",
    description:
        "Next-generation video generation powered by MiniMax's Hailuo 2 model - ranked #2 globally with cinematic quality and ultra-realistic physics.",
    image: "assets/ai_icon/hailuo.svg",
    isNew: true,
    onTap: (BuildContext context) {
      print("Navigate to Hailuo");
    },
  ),
  ImagineDataModel(
    type: ImagineType.videos,
    title: "Wan",
    description:
        "Advanced text-to-video generation powered by Wan 2.2 model - create professional quality videos with exceptional detail and realistic motion.",
    image: "assets/ai_icon/wan.svg",
    isNew: true,
    onTap: (BuildContext context) {
      print("Navigate to Wan");
    },
  ),
  ImagineDataModel(
    type: ImagineType.audio,
    title: "UdioAI",
    description:
        "Create beautiful music with AI - from melodies to full compositions using advanced music generation.",
    image: "assets/ai_icon/udio_black.svg",
    isNew: false,
    onTap: (BuildContext context) {
      print("Navigate to UdioAI");
    },
  ),
  ImagineDataModel(
    type: ImagineType.audio,
    title: "ElevenLabs",
    description:
        "Transform text into lifelike speech with ElevenLabs' advanced AI voice synthesis technology. Create natural-sounding audio with multiple voices and languages.",
    image: "assets/ai_icon/elevenlabs_black.svg",
    isNew: true,
    onTap: (BuildContext context) {
      print("Navigate to ElevenLabs");
    },
  ),
  ImagineDataModel(
    type: ImagineType.tools,
    title: "Quiz Maker",
    description:
        "Generate interactive quizzes from images using advanced AI vision technology. Upload any image and create educational multiple-choice quizzes instantly.",
    image: "assets/ai_icon/quiz_maker.svg",
    isNew: true,
    onTap: (BuildContext context) {
      print("Navigate to Quiz Maker");
    },
  ),
  ImagineDataModel(
    type: ImagineType.tools,
    title: "Humanizer",
    description:
        "Transform AI-generated text into natural, human-like content. Make your text more engaging and authentic with advanced humanization technology.",
    image: "assets/ai_icon/humanizer_black.svg",
    isNew: false,
    onTap: (BuildContext context) {
      print("Navigate to Humanizer");
    },
  ),
];
