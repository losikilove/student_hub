import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final bool isFullWidth;

  const CustomDivider({super.key, this.isFullWidth = false});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Divider(
        height: 0,
        thickness: 2,
        indent: isFullWidth ? 0 : 40,
        endIndent: isFullWidth ? 0 : 35,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
