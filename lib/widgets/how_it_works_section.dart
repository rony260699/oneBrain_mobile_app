import 'package:flutter/material.dart';
import '../theme/theme_colors.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header text
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              'Your tokens work with all available AI models. Each model costs different tokens per use - you choose how to spend them!',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Steps container
          Row(
            children: [
              // Step 1
              Expanded(
                child: _buildStep(
                  stepNumber: '1',
                  title: 'Buy Tokens',
                  description: 'Choose your package',
                  icon: Icons.shopping_cart_outlined,
                  iconColor: ThemeColors.warning,
                  iconBackground: ThemeColors.tokenBackground,
                ),
              ),
              
              // Step 2
              Expanded(
                child: _buildStep(
                  stepNumber: '2',
                  title: 'Access AI Tools',
                  description: 'Use any AI model',
                  icon: Icons.smart_toy_outlined,
                  iconColor: ThemeColors.primary,
                  iconBackground: ThemeColors.howItWorksIconBackground,
                ),
              ),
              
              // Step 3
              Expanded(
                child: _buildStep(
                  stepNumber: '3',
                  title: 'Control Usage',
                  description: 'Spend tokens as you like',
                  icon: Icons.tune_outlined,
                  iconColor: ThemeColors.secondary,
                  iconBackground: const Color(0xFF581C87),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ThemeColors.howItWorksBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Step number and title
          Text(
            '$stepNumber. $title',
            style: const TextStyle(
              color: ThemeColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 4),
          
          // Description
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Alternative responsive version for larger screens
class HowItWorksSectionLarge extends StatelessWidget {
  const HowItWorksSectionLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          // Header text
          Container(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              'Your tokens work with all available AI models. Each model costs different tokens per use - you choose how to spend them!',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 18,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Steps container for larger screens
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Step 1
              Expanded(
                child: _buildLargeStep(
                  stepNumber: '1',
                  title: 'Buy Tokens',
                  description: 'Choose your package',
                  icon: Icons.shopping_cart_outlined,
                  iconColor: ThemeColors.warning,
                  iconBackground: ThemeColors.tokenBackground,
                ),
              ),
              
              // Arrow connector
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
              
              // Step 2
              Expanded(
                child: _buildLargeStep(
                  stepNumber: '2',
                  title: 'Access AI Tools',
                  description: 'Use any AI model',
                  icon: Icons.smart_toy_outlined,
                  iconColor: ThemeColors.primary,
                  iconBackground: ThemeColors.howItWorksIconBackground,
                ),
              ),
              
              // Arrow connector
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
              
              // Step 3
              Expanded(
                child: _buildLargeStep(
                  stepNumber: '3',
                  title: 'Control Usage',
                  description: 'Spend tokens as you like',
                  icon: Icons.tune_outlined,
                  iconColor: ThemeColors.secondary,
                  iconBackground: const Color(0xFF581C87),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLargeStep({
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.howItWorksBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Step number and title
          Text(
            '$stepNumber. $title',
            style: const TextStyle(
              color: ThemeColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Description
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Responsive wrapper that chooses the appropriate version
class ResponsiveHowItWorksSection extends StatelessWidget {
  const ResponsiveHowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 768) {
          return const HowItWorksSectionLarge();
        } else {
          return const HowItWorksSection();
        }
      },
    );
  }
}