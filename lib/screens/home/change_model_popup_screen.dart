import 'package:OneBrain/common_widgets/common_widgets.dart';
import 'package:OneBrain/models/ai_model.dart';
import 'package:OneBrain/resources/color.dart';
import 'package:OneBrain/screens/home/view/ai_model_popup_view.dart';
import 'package:OneBrain/models/plan_user_model.dart';
import 'package:OneBrain/services/ai_model_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../base/base_stateful_state.dart';
import '../../resources/image.dart';
import '../../resources/strings.dart';
import '../../common_widgets/text_widget.dart';
import '../side_menu/model/ai_list_model.dart';

class ChangeModelPopupScreen extends StatefulWidget {
  final AIModel? selectedAiModel;
  final UserModel user;
  const ChangeModelPopupScreen({
    super.key,
    this.selectedAiModel,
    required this.user,
  });

  @override
  State<ChangeModelPopupScreen> createState() => _ChangeModelPopupScreenState();
}

class _ChangeModelPopupScreenState extends State<ChangeModelPopupScreen> {
  late final List<Map<String, dynamic>> activeProviders;

  @override
  void initState() {
    activeProviders = AIModelService.getProviderByPlan(widget.user);
    super.initState();
  }

  String? selectedProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height * 0.8, // Maximum 80% of screen
        minHeight: 200, // Minimum height for usability
      ),
      decoration: BoxDecoration(
        // Optimized gradient for better text readability
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
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32.0),
          topLeft: Radius.circular(32.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize:
              MainAxisSize
                  .min, // This will make the column take only needed space
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 32.0),

                TextWidget(
                  text: 'Change Model',
                  fontSize: 24.sp,
                  color: appBarTitleColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto',
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    PNGImages.closeIcon,
                    width: 22,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            heightBox(12),
            // Use Flexible with fit: FlexFit.loose to allow shrinking
            Flexible(
              fit:
                  FlexFit
                      .loose, // Allow the widget to be smaller than the available space
              child: Builder(
                builder: (context) {
                  if (activeProviders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.white54,
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No AI models selected",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Please select models from the Explore page",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return RepaintBoundary(
                    // Performance optimization
                    child: ListView.builder(
                      itemCount: activeProviders.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(), // Better performance
                      padding: const EdgeInsets.only(top: 8, bottom: 0),
                      // Cache extent for better scrolling performance
                      cacheExtent: 500,
                      itemBuilder: (context, index) {
                        // Show AI Models only
                        final model = activeProviders[index];
                        return RepaintBoundary(
                          key: ValueKey(model['provider']),
                          child: AIPopupListView(
                            selectedModel: widget.selectedAiModel,
                            aiModelImage: model['icon'],
                            provider: model['provider'],
                            isExpanded: selectedProvider == model['provider'],
                            onModelSelected: (model) {
                              Navigator.pop(context, model);
                            },
                            onProviderSelected: (provider) {
                              setState(() {
                                if (selectedProvider == provider) {
                                  selectedProvider = null;
                                } else {
                                  selectedProvider = provider;
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            // Add some bottom spacing
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// AI Tool Popup View Widget - matches the design of AI Model popup
class AIToolPopupView extends StatefulWidget {
  final AiTool currentAiTool;
  final int index;
  final VoidCallback reloadView;
  final VoidCallback? onToolSelected;

  const AIToolPopupView({
    super.key,
    required this.currentAiTool,
    required this.index,
    required this.reloadView,
    this.onToolSelected,
  });

  @override
  State<AIToolPopupView> createState() => _AIToolPopupViewState();
}

class _AIToolPopupViewState extends State<AIToolPopupView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 12),
      child: Container(
        height: 34,
        decoration: BoxDecoration(
          color:
              widget.currentAiTool.isSelected
                  ? HexColor('#495083').withValues(alpha: 0.3)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            widget.onToolSelected?.call();
            widget.reloadView();
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 4,
                  top: 2,
                  bottom: 2,
                ),
                child: Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    color: HexColor('#495083').withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      widget.currentAiTool.category.isNotEmpty
                          ? widget.currentAiTool.category[0].toUpperCase()
                          : widget.currentAiTool.toolName[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              widthBox(4),
              Expanded(
                child: TextWidget(
                  text: widget.currentAiTool.toolName,
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontFamily: strFontName,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
