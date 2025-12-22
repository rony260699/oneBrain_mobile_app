import 'package:flutter/material.dart';
import '../theme/theme_colors.dart';

class TokenCostSection extends StatelessWidget {
  const TokenCostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: ThemeColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'So How Much Tokens Per Generation Cost?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Token Cost Tables
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI Image and Upscaler Column
              Expanded(
                child: _buildTokenCostTable(
                  'AI Image and Upscaler',
                  [
                    _TokenCostItem('Imagex', '4,824 - 7,434', '4,824'),
                    _TokenCostItem('Midjourney', '5,136 - 7,434', '5,136'),
                    _TokenCostItem('Flux', '7,096 - 9,656', '7,096'),
                    _TokenCostItem('Flux Pro', '8,432', '8,432'),
                    _TokenCostItem('Flux Dev', '5,056', '5,056'),
                    _TokenCostItem('FLUX-1.1 Pro', '8,432', '8,432'),
                    _TokenCostItem('ChatGPT 4o', '7,096', '7,096'),
                    _TokenCostItem('DALL·E 3', '7,096', '7,096'),
                    _TokenCostItem('Llama Upscaler', '8,432', '8,432'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // AI Video Generation Column
              Expanded(
                child: _buildTokenCostTable(
                  'AI Video Generation',
                  [
                    _TokenCostItem('Vgen', '25,76,800', '25,76,800'),
                    _TokenCostItem('Runway', '1,87,952', '1,87,952'),
                    _TokenCostItem('Kling', '1,87,952', '1,87,952'),
                    _TokenCostItem('Luma', '1,87,952', '1,87,952'),
                    _TokenCostItem('510 v1.5 - 5s', '1,87,952', '1,87,952'),
                    _TokenCostItem('510 v1.5 - 10s', '3,75,904', '3,75,904'),
                    _TokenCostItem('Pro v1.5 - 5s', '3,75,904', '3,75,904'),
                    _TokenCostItem('Pro v1.5 - 10s', '3,75,904', '3,75,904'),
                    _TokenCostItem('Pro v1.5 - 10s', '3,75,904', '3,75,904'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // AI Text to Speech and Music Column
              Expanded(
                child: _buildTokenCostTable(
                  'AI Text to Speech and Music',
                  [
                    _TokenCostItem('Udio AI', '4,56,133', '4,56,133'),
                    _TokenCostItem('Suno AI', '4,56,133', '4,56,133'),
                    _TokenCostItem('PlayHT', '89,760', '89,760'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // AI Detector Column
              Expanded(
                child: _buildTokenCostTable(
                  'AI Detector',
                  [
                    _TokenCostItem('Humanizer', '300 per word', '300'),
                    _TokenCostItem('Detector', '300 per word', '300'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTokenCostTable(String title, List<_TokenCostItem> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: ThemeColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Table Items
          ...items.map((item) => _buildTokenCostRow(item)),
        ],
      ),
    );
  }

  Widget _buildTokenCostRow(_TokenCostItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Model Name
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: ThemeColors.warning,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.modelName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Token Cost
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ThemeColors.warning,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.tokenCost,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TokenCostItem {
  final String modelName;
  final String tokenRange;
  final String tokenCost;

  _TokenCostItem(this.modelName, this.tokenRange, this.tokenCost);
} 