import 'package:flutter/material.dart';
import '../../base/base_stateful_state.dart';

class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String value;
  final bool isEditable;
  final VoidCallback? onEdit;

  const ProfileInfoCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    this.isEditable = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 350;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: HexColor('#1F2937').withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HexColor('#656FE2')),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon section
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),

            const SizedBox(width: 12),

            // Content section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: HexColor('#9CA3AF'),
                      fontSize: isSmallScreen ? 11 : 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  // Value section - moved here for better layout
                  _buildValueSection(isSmallScreen),
                ],
              ),
            ),

            // Edit button section (if applicable)
            if (isEditable && onEdit != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: isSmallScreen ? 14 : 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValueSection(bool isSmallScreen) {
    // Handle different value types and lengths
    final isLongValue = value.length > 25;

    if (isLongValue || isSmallScreen) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: HexColor('#656FE2').withOpacity(0.3)),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 13 : 14,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: HexColor('#656FE2').withOpacity(0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 13 : 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      );
    }
  }
}
