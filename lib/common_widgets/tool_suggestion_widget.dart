import 'package:flutter/material.dart';
import '../screens/side_menu/model/ai_list_model.dart';
import '../utils/ai_tool_intent_detector.dart';
import '../resources/color.dart';
import '../main.dart';

class ToolSuggestionWidget extends StatelessWidget {
  final List<ToolSuggestion> suggestions;
  final Function(ToolSuggestion) onToolSelected;
  final VoidCallback? onDismiss;

  const ToolSuggestionWidget({
    Key? key,
    required this.suggestions,
    required this.onToolSelected,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            colorPrimary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI Tool Suggestions',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                if (onDismiss != null)
                  GestureDetector(
                    onTap: onDismiss,
                    child: Icon(
                      Icons.close,
                      color: AppColors.greyColor,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),
          
          // Suggestions List
          ...suggestions.map((suggestion) => _buildSuggestionItem(suggestion)),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(ToolSuggestion suggestion) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onToolSelected(suggestion),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Tool Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor.withOpacity(0.8),
                        colorPrimary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      suggestion.tool.categoryIcon,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Tool Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            suggestion.tool.toolName,
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildConfidenceBadge(suggestion.confidence),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        suggestion.reason,
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 12,
                        ),
                      ),
                      if (suggestion.suggestedPrompt != suggestion.tool.toolName)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Suggested: "${_truncatePrompt(suggestion.suggestedPrompt)}"',
                            style: TextStyle(
                              color: AppColors.primaryColor.withOpacity(0.8),
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryColor.withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfidenceBadge(double confidence) {
    Color badgeColor;
    String label;
    
    if (confidence > 0.9) {
      badgeColor = Colors.green;
      label = 'Perfect';
    } else if (confidence > 0.8) {
      badgeColor = Colors.blue;
      label = 'Great';
    } else if (confidence > 0.7) {
      badgeColor = Colors.orange;
      label = 'Good';
    } else {
      badgeColor = Colors.grey;
      label = 'Maybe';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: badgeColor.withOpacity(0.5),
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _truncatePrompt(String prompt) {
    if (prompt.length <= 50) return prompt;
    return '${prompt.substring(0, 50)}...';
  }
}

// Tool Context Widget - Shows current active tool
class ActiveToolWidget extends StatelessWidget {
  final AiTool? activeTool;
  final VoidCallback? onSwitchBack;
  final String? lastMessage;

  const ActiveToolWidget({
    Key? key,
    this.activeTool,
    this.onSwitchBack,
    this.lastMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (activeTool == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.15),
            colorPrimary.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Tool Icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    colorPrimary,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  activeTool!.categoryIcon,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Tool Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: AppColors.primaryColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Using ${activeTool!.toolName}',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (lastMessage != null)
                    Text(
                      'Continue the conversation or type "back" to return to chat',
                      style: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
            
            // Switch Back Button
            if (onSwitchBack != null)
              GestureDetector(
                onTap: onSwitchBack,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Back to Chat',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Tool Transition Animation Widget
class ToolTransitionWidget extends StatefulWidget {
  final String message;
  final AiTool tool;
  final VoidCallback onComplete;

  const ToolTransitionWidget({
    Key? key,
    required this.message,
    required this.tool,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<ToolTransitionWidget> createState() => _ToolTransitionWidgetState();
}

class _ToolTransitionWidgetState extends State<ToolTransitionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        widget.onComplete();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.2),
                    colorPrimary.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Animated Tool Icon
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, value, child) {
                        return Transform.rotate(
                          angle: value * 2 * 3.14159,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryColor,
                                  colorPrimary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                widget.tool.categoryIcon,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Transition Message
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.message,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Preparing ${widget.tool.toolName} for your request...',
                            style: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Loading Indicator
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Simple manual tool switcher widget
class ToolSwitcherWidget extends StatelessWidget {
  final String currentMode;
  final String currentModeIcon;
  final String currentModeDisplay;
  final AiTool? currentActiveTool;
  final Function(AiTool) onToolSelected;
  final VoidCallback onSwitchBackToChat;
  final Function(AiTool) onCopyToTool;
  final bool hasMessages;

  const ToolSwitcherWidget({
    Key? key,
    required this.currentMode,
    required this.currentModeIcon,
    required this.currentModeDisplay,
    this.currentActiveTool,
    required this.onToolSelected,
    required this.onSwitchBackToChat,
    required this.onCopyToTool,
    required this.hasMessages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorPrimary.withOpacity(0.1),
            colorPrimary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorPrimary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Mode Display
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  currentModeIcon,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Currently using:",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        currentModeDisplay,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Switch button
                if (currentMode == "tool")
                  TextButton(
                    onPressed: onSwitchBackToChat,
                    child: const Text(
                      "Back to Chat",
                      style: TextStyle(color: colorPrimary),
                    ),
                  ),
              ],
            ),
          ),
          
          // Tool Selection Grid
          if (currentMode == "chat")
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Switch to AI Tool:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: arrOfAiTools.take(6).map((tool) => _buildToolChip(
                      tool: tool,
                      onTap: () => onToolSelected(tool),
                      onCopyTap: hasMessages ? () => onCopyToTool(tool) : null,
                    )).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildToolChip({
    required AiTool tool,
    required VoidCallback onTap,
    VoidCallback? onCopyTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main tool button
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  Text(
                    tool.category,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tool.toolName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          // Copy button (only if there are messages)
          if (onCopyTap != null)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorPrimary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: InkWell(
                onTap: onCopyTap,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    "📋 Copy Last",
                    style: TextStyle(
                      fontSize: 10,
                      color: colorPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 