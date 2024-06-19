import 'package:flutter/material.dart';

class InitialBody extends StatelessWidget {
  final Widget child;
  final double left;
  final double right;
  final double top;
  final double bottom;
  const InitialBody(
      {super.key,
      required this.child,
      this.left = 18.0,
      this.right = 18.0,
      this.top = 16.0,
      this.bottom = 0.0});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: EdgeInsets.only(
              left: left, right: right, top: top, bottom: bottom),
          child: child,
        ),
      ),
    );
  }
}
