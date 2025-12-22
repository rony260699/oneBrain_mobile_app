import 'package:flutter/material.dart';

class AdaptiveKeyboardTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final TextStyle? style;
  final InputDecoration? decoration;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const AdaptiveKeyboardTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.style,
    this.decoration,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the system brightness
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDark = brightness == Brightness.dark;
    
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      keyboardAppearance: isDark ? Brightness.dark : Brightness.light,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      style: style,
      decoration: decoration,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      focusNode: focusNode,
    );
  }
} 