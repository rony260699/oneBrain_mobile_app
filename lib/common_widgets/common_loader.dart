import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../utils/app_constants.dart';

class GlobalLoader {
  static OverlayEntry? _loaderEntry;

  static void show() {
    if (_loaderEntry != null) return;

    _loaderEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
              Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulse,
                    colors: const [Colors.white],
                    strokeWidth: 2,
                    backgroundColor: Colors.transparent,
                    pathBackgroundColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
    );

    rootNavigatorKey.currentState?.overlay?.insert(_loaderEntry!);
  }

  static void hide() {
    _loaderEntry?.remove();
    _loaderEntry = null;
  }
}
