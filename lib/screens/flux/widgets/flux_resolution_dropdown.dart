import 'package:flutter/material.dart';

class FluxResolutionDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const FluxResolutionDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  static const resolutions = ['1:1', '16:9', '9:16', '3:2', '2:3'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Color(0xFF656fe2)),
        gradient: LinearGradient(
          colors: [Color(0xFF0f1747), Color(0xFF1a1f3a)],
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: enabled ? onChanged : null,
          dropdownColor: Color(0xFF121d32),
          style: TextStyle(color: Colors.white, fontSize: 14),
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildResolutionIcon(value),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, color: Colors.white),
            ],
          ),
          items: resolutions.map((resolution) {
            return DropdownMenuItem<String>(
              value: resolution,
              child: Row(
                children: [
                  _buildResolutionIcon(resolution),
                  SizedBox(width: 8),
                  Text(resolution),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildResolutionIcon(String resolution) {
    late double width, height;
    switch (resolution) {
      case '1:1':
        width = height = 16;
        break;
      case '16:9':
        width = 24; height = 12;
        break;
      case '9:16':
        width = 12; height = 24;
        break;
      case '3:2':
        width = 20; height = 12;
        break;
      case '2:3':
        width = 12; height = 20;
        break;
      default:
        width = height = 16;
    }
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
} 