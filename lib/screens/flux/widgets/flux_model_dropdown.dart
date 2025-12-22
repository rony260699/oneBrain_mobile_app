import 'package:flutter/material.dart';

class FluxModelDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const FluxModelDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  static const models = [
    {'value': 'flux-pro', 'label': 'Flux-pro'},
    {'value': 'flux-pro-1.1', 'label': 'Flux-pro-1.1'},
  ];

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
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
          items: models.map((model) {
            return DropdownMenuItem<String>(
              value: model['value'],
              child: Text(model['label']!),
            );
          }).toList(),
        ),
      ),
    );
  }
} 