import 'package:flutter/material.dart';
import 'package:student_hub/utils/color_util.dart';

class InitialBody extends StatelessWidget {
  final Widget child;
  const InitialBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorUtil.lightPrimary,
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 36.0),
        child: child,
      ),
    );
  }
}
