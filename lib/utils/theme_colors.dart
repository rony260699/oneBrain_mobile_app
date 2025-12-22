import 'package:flutter/material.dart';

class ThemeColors {
  // Primary Background Colors
  static const Color backgroundColor = Color(0xFF111827); // gray-900
  static const Color cardBackground = Color(0xFF1F2937); // gray-800
  static const Color darkCardBackground = Color(0xFF0F172A); // slate-900
  
  // Border Colors
  static const Color borderColor = Color(0xFF374151); // gray-700
  static const Color lightBorderColor = Color(0xFF4B5563); // gray-600
  static const Color accentBorderColor = Color(0xFF3B82F6); // blue-500
  
  // Text Colors
  static const Color primaryText = Color(0xFFFFFFFF); // white
  static const Color secondaryText = Color(0xFF9CA3AF); // gray-400
  static const Color tertiaryText = Color(0xFF6B7280); // gray-500
  
  // Gradient Colors
  static const Color gradientStart = Color(0xFF8B5CF6); // purple-500
  static const Color gradientEnd = Color(0xFF06B6D4); // cyan-500
  
  // Success Colors
  static const Color successGreen = Color(0xFF10B981); // emerald-500
  static const Color successGreenDark = Color(0xFF059669); // emerald-600
  static const Color successColor = Color(0xFF10B981); // emerald-500
  
  // Warning Colors
  static const Color warningYellow = Color(0xFFF59E0B); // amber-500
  static const Color warningOrange = Color(0xFFF97316); // orange-500
  static const Color warningColor = Color(0xFFF59E0B); // amber-500
  
  // Error Colors
  static const Color errorRed = Color(0xFFEF4444); // red-500
  static const Color errorRedDark = Color(0xFFDC2626); // red-600
  static const Color errorColor = Color(0xFFEF4444); // red-500
  
  // Plan Colors
  static const Color basicPlanColor = Color(0xFF10B981); // green-500
  static const Color proPlanColor = Color(0xFF3B82F6); // blue-500
  static const Color premiumPlanColor = Color(0xFF8B5CF6); // purple-500
  static const Color legendPlanColor = Color(0xFFF59E0B); // amber-500
  
  // Additional Colors for compatibility
  static const Color primaryBlue = Color(0xFF3B82F6); // blue-500
  static const Color primaryPurple = Color(0xFF8B5CF6); // purple-500
  static const Color primaryCyan = Color(0xFF06B6D4); // cyan-500
  static const Color textPrimary = Color(0xFFFFFFFF); // white
  static const Color textSecondary = Color(0xFF9CA3AF); // gray-400
  static const Color surfaceBackground = Color(0xFF0F172A); // slate-900
  
  // Bangladesh specific colors
  static const Color bangladeshGreen = Color(0xFF00A651); // Bangladesh flag green
  static const Color bangladeshRed = Color(0xFFE4002B); // Bangladesh flag red
  
  // Glassmorphism effect colors
  static Color glassMorphismBackground = Colors.white.withOpacity(0.05);
  static Color glassMorphismBorder = Colors.white.withOpacity(0.1);
  
  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [successGreen, successGreenDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    colors: [warningYellow, warningOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient errorGradient = LinearGradient(
    colors: [errorRed, errorRedDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Plan gradients
  static const LinearGradient basicPlanGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient proPlanGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient premiumPlanGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient legendPlanGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Additional gradients for compatibility
  static const LinearGradient primaryLinearGradient = LinearGradient(
    colors: [primaryBlue, primaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background gradient for app backgrounds
  static const LinearGradient backgroundLinearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      backgroundColor,
      cardBackground,
      darkCardBackground,
    ],
    stops: [0.0, 0.7, 1.0],
  );
  
  // Shadow colors
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  // Helper methods
  static Color getTokenBalanceColor(int remainingTokens) {
    if (remainingTokens > 100) {
      return successGreen;
    } else if (remainingTokens > 50) {
      return warningYellow;
    } else {
      return errorRed;
    }
  }
  
  static LinearGradient getTokenBalanceGradient(int remainingTokens) {
    if (remainingTokens > 100) {
      return successGradient;
    } else if (remainingTokens > 50) {
      return warningGradient;
    } else {
      return errorGradient;
    }
  }
  
  static Color getPlanColorByIndex(int index) {
    switch (index) {
      case 0:
        return basicPlanColor;
      case 1:
        return proPlanColor;
      case 2:
        return premiumPlanColor;
      case 3:
        return legendPlanColor;
      default:
        return proPlanColor;
    }
  }
  
  static LinearGradient getPlanGradientByIndex(int index) {
    switch (index) {
      case 0:
        return basicPlanGradient;
      case 1:
        return proPlanGradient;
      case 2:
        return premiumPlanGradient;
      case 3:
        return legendPlanGradient;
      default:
        return proPlanGradient;
    }
  }
} 