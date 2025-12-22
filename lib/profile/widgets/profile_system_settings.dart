import 'package:flutter/material.dart';
import '../../resources/color.dart';
import '../../utils/theme_colors.dart';

class ProfileSystemSettings extends StatelessWidget {
  const ProfileSystemSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.borderColor),
      ),
      child: const Center(
        child: Text(
          'System Settings Placeholder',
          style: TextStyle(
            color: color0B0B40,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
} 