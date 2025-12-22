import 'package:flutter/material.dart';
import '../../utils/theme_colors.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.borderColor,
        ),
        boxShadow: ThemeColors.cardShadow,
      ),
      child: Column(
        children: [
          // Header
          Text(
            'How It Works',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ThemeColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your tokens work with all available AI models. Each model costs different tokens per use - you choose how to spend them!',
            style: const TextStyle(
              fontSize: 14,
              color: ThemeColors.secondaryText,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Steps
          Row(
            children: [
              Expanded(
                child: _buildStep(
                  stepNumber: 1,
                  icon: '🪙',
                  title: 'Buy Tokens',
                  description: 'Choose your package',
                  color: ThemeColors.warningYellow,
                ),
              ),
              // Arrow connector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: ThemeColors.tertiaryText,
                ),
              ),
              Expanded(
                child: _buildStep(
                  stepNumber: 2,
                  icon: '🤖',
                  title: 'Access AI Tools',
                  description: 'Use any AI model',
                  color: ThemeColors.proPlanColor,
                ),
              ),
              // Arrow connector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: ThemeColors.tertiaryText,
                ),
              ),
              Expanded(
                child: _buildStep(
                  stepNumber: 3,
                  icon: '⚡',
                  title: 'Control Usage',
                  description: 'Spend tokens as you like',
                  color: ThemeColors.premiumPlanColor,
                ),
              ),
            ],
          ),
          
          // Additional info
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ThemeColors.darkCardBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ThemeColors.accentBorderColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: ThemeColors.accentBorderColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pro tip: Different AI models have different token costs. Choose wisely to maximize your usage!',
                    style: const TextStyle(
                      fontSize: 12,
                      color: ThemeColors.secondaryText,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required int stepNumber,
    required String icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColors.darkCardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Icon with step number
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ThemeColors.primaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          
          // Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: ThemeColors.secondaryText,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 