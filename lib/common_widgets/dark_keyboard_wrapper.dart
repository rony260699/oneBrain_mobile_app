import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DarkKeyboardWrapper extends StatelessWidget {
  final Widget child;
  
  const DarkKeyboardWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        // Force the darkest possible theme
        brightness: Brightness.dark,
        colorScheme: Theme.of(context).colorScheme.copyWith(
          brightness: Brightness.dark,
          surface: const Color(0xFF000000), // Pure black for maximum darkness
          background: const Color(0xFF000000),
        ),
        // Override input decoration to force dark keyboard
        inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
          // This helps ensure dark keyboard
        ),
      ),
      child: child,
    );
  }
}

// Extension to add dark keyboard appearance to any TextField
extension DarkKeyboardTextField on TextField {
  TextField withDarkKeyboard() {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      style: style,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      textDirection: textDirection,
      readOnly: readOnly,
      showCursor: showCursor,
      autofocus: autofocus,
      obscureText: obscureText,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      onAppPrivateCommand: onAppPrivateCommand,
      inputFormatters: inputFormatters,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      keyboardAppearance: Brightness.dark, // Force dark keyboard
      scrollPadding: scrollPadding,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      onTap: onTap,
      mouseCursor: mouseCursor,
      buildCounter: buildCounter,
      scrollController: scrollController,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      scribbleEnabled: scribbleEnabled,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
    );
  }
} 