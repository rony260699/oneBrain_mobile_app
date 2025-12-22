import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Performance utility class with optimized widgets and helpers
class PerformanceUtils {
  
  /// Debounced setState to prevent excessive rebuilds
  static void debouncedSetState(VoidCallback callback, {Duration delay = const Duration(milliseconds: 16)}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(delay, callback);
    });
  }
  
  /// Optimized AnimatedContainer with performance tweaks
  static Widget optimizedAnimatedContainer({
    required Widget child,
    required Duration duration,
    BoxDecoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    AlignmentGeometry? alignment,
    Curve curve = Curves.easeInOut,
  }) {
    return RepaintBoundary(
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        decoration: decoration,
        padding: padding,
        margin: margin,
        width: width,
        height: height,
        alignment: alignment,
        child: child,
      ),
    );
  }
  
  /// Optimized ListView with performance settings
  static Widget optimizedListView({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    ScrollController? controller,
    bool reverse = false,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    double? cacheExtent,
    bool shrinkWrap = false,
  }) {
    return RepaintBoundary(
      child: ListView.builder(
        controller: controller,
        reverse: reverse,
        physics: physics ?? const ClampingScrollPhysics(),
        padding: padding,
        cacheExtent: cacheExtent ?? 1000,
        shrinkWrap: shrinkWrap,
        itemCount: itemCount,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
        itemBuilder: (context, index) {
          return RepaintBoundary(
            key: ValueKey(index),
            child: itemBuilder(context, index),
          );
        },
      ),
    );
  }
  
  /// Optimized gradient with reduced complexity
  static LinearGradient optimizedGradient({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
    List<double>? stops,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
      stops: stops,
    );
  }
  
  /// Throttled function execution
  static Function throttle(Function func, Duration delay) {
    DateTime? lastExecution;
    return ([dynamic args]) {
      final now = DateTime.now();
      if (lastExecution == null || now.difference(lastExecution!) >= delay) {
        lastExecution = now;
        return func(args);
      }
    };
  }
  
  /// Optimized shadow effects
  static List<BoxShadow> optimizedShadow({
    Color color = Colors.black,
    double opacity = 0.2,
    double blurRadius = 8,
    Offset offset = const Offset(0, 2),
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: blurRadius,
        offset: offset,
      ),
    ];
  }
} 