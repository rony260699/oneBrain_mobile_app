import 'package:flutter/material.dart';

class ThemeColors {
  // Main background - dark theme
  static const Color background = Color(0xFF0F172A); // Dark slate/navy
  
  // Card backgrounds
  static const Color cardBackground = Color(0xFF1E293B); // Slightly lighter dark
  static const Color cardBackgroundHover = Color(0xFF334155); // Hover state
  
  // Primary colors
  static const Color primary = Color(0xFF3B82F6); // Blue
  static const Color primaryHover = Color(0xFF2563EB); // Darker blue
  
  // Secondary colors
  static const Color secondary = Color(0xFF8B5CF6); // Purple
  static const Color secondaryHover = Color(0xFF7C3AED); // Darker purple
  
  // Accent colors
  static const Color accent = Color(0xFF06B6D4); // Cyan
  static const Color accentHover = Color(0xFF0891B2); // Darker cyan
  
  // Status colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Orange/Yellow
  static const Color error = Color(0xFFEF4444); // Red
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFF94A3B8); // Gray
  static const Color textTertiary = Color(0xFF64748B); // Darker gray
  
  // Border colors
  static const Color borderColor = Color(0xFF334155); // Border gray
  static const Color borderColorHover = Color(0xFF475569); // Hover border
  
  // Popular badge colors
  static const Color popularBadge = Color(0xFFFBBF24); // Yellow/gold
  static const Color popularBadgeText = Color(0xFF1F2937); // Dark text
  
  // Special badges
  static const Color klingAIBadge = Color(0xFFDB2777); // Pink/magenta
  static const Color veo3Badge = Color(0xFFDC2626); // Red/orange
  
  // Button colors
  static const Color buttonPrimary = Color(0xFF3B82F6); // Blue
  static const Color buttonSecondary = Color(0xFF6B7280); // Gray
  static const Color buttonSuccess = Color(0xFF10B981); // Green
  static const Color buttonDanger = Color(0xFFEF4444); // Red
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Shadow colors
  static const Color shadowColor = Color(0x40000000); // Black with opacity
  static const Color cardShadow = Color(0x1A000000); // Lighter shadow
  static const Color shadowLight = Color(0x0A000000); // Very light shadow
  
  // Currency specific colors for BD
  static const Color bdCurrency = Color(0xFF10B981); // Green for Taka
  static const Color bdCurrencyBackground = Color(0xFF064E3B); // Dark green bg
  
  // Token colors
  static const Color tokenColor = Color(0xFFFBBF24); // Gold/yellow
  static const Color tokenBackground = Color(0xFF451A03); // Dark yellow bg
  
  // Icon colors
  static const Color iconPrimary = Color(0xFF94A3B8); // Gray
  static const Color iconSecondary = Color(0xFF64748B); // Darker gray
  static const Color iconAccent = Color(0xFF3B82F6); // Blue
  
  // How it works section colors
  static const Color howItWorksBackground = Color(0xFF1E293B);
  static const Color howItWorksIcon = Color(0xFF3B82F6);
  static const Color howItWorksIconBackground = Color(0xFF1E3A8A);
  
  // Plan card specific colors
  static const Color planCardBackground = Color(0xFF1E293B);
  static const Color planCardBorder = Color(0xFF334155);
  static const Color planCardHover = Color(0xFF475569);
  
  // Active plan colors
  static const Color activePlanBorder = Color(0xFF10B981);
  static const Color activePlanBackground = Color(0xFF064E3B);
  static const Color activePlanText = Color(0xFF10B981);
  
  // Popular plan colors
  static const Color popularPlanBorder = Color(0xFFFBBF24);
  static const Color popularPlanBackground = Color(0xFF451A03);
  static const Color popularPlanText = Color(0xFFFBBF24);
  
  // Plan-specific colors
  static const Color planBasic = Color(0xFF3B82F6); // Blue
  static const Color planCreator = Color(0xFF10B981); // Green
  static const Color planProCreator = Color(0xFF8B5CF6); // Purple
  static const Color planLegend = Color(0xFFEF4444); // Red
}

// Helper class for common decorations
class ThemeDecorations {
  static BoxDecoration get planCard => BoxDecoration(
    color: ThemeColors.planCardBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: ThemeColors.planCardBorder,
      width: 1,
    ),
    boxShadow: const [
      BoxShadow(
        color: ThemeColors.cardShadow,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );
  
  static BoxDecoration get popularPlanCard => BoxDecoration(
    color: ThemeColors.planCardBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: ThemeColors.popularPlanBorder,
      width: 2,
    ),
    boxShadow: const [
      BoxShadow(
        color: ThemeColors.cardShadow,
        blurRadius: 15,
        offset: Offset(0, 6),
      ),
    ],
  );
  
  static BoxDecoration get activePlanCard => BoxDecoration(
    color: ThemeColors.planCardBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: ThemeColors.activePlanBorder,
      width: 2,
    ),
    boxShadow: const [
      BoxShadow(
        color: ThemeColors.cardShadow,
        blurRadius: 15,
        offset: Offset(0, 6),
      ),
    ],
  );
  
  static BoxDecoration get howItWorksCard => BoxDecoration(
    color: ThemeColors.howItWorksBackground,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: ThemeColors.borderColor,
      width: 1,
    ),
  );
}

// Helper class for common text styles
class ThemeTextStyles {
  static const TextStyle planTitle = TextStyle(
    color: ThemeColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );
  
  static const TextStyle planDescription = TextStyle(
    color: ThemeColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  
  static const TextStyle planPrice = TextStyle(
    color: ThemeColors.textPrimary,
    fontSize: 32,
    fontWeight: FontWeight.w800,
  );
  
  static const TextStyle planTokens = TextStyle(
    color: ThemeColors.tokenColor,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle featureTitle = TextStyle(
    color: ThemeColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle featureItem = TextStyle(
    color: ThemeColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  
  static const TextStyle badgeText = TextStyle(
    color: ThemeColors.textPrimary,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle howItWorksTitle = TextStyle(
    color: ThemeColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle howItWorksDescription = TextStyle(
    color: ThemeColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
} 