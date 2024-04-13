import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final bool isFullWidth;
  final double height;

  const CustomDivider(
      {super.key, this.isFullWidth = false, this.height = 20.0});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Divider(
        height: height,
        thickness: 2,
        indent: isFullWidth ? 0 : 40,
        endIndent: isFullWidth ? 0 : 35,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
