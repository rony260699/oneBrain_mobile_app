import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../base/base_stateful_state.dart';
import '../resources/color.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false ? widget.onChanged(true) : widget.onChanged(false);
          },
          child: Container(
            width: 50.w,
            height: 24.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    widget.value == false
                        ? [HexColor('#9CA3AF'), HexColor('#414449')]
                        : [HexColor('#BA87FC'), HexColor('#6BA2FB')],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Container(
                alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
                child:
                    widget.value
                        ? Container(
                          width: 15.w,
                          height: 15.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorWhite,
                          ),
                        )
                        : Container(
                          width: 15.w,
                          height: 15.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorWhite,
                          ),
                        ),
              ),
            ),
          ),
        );
      },
    );
  }
}
