import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  final BuildContext context;
  final Widget title;
  final List<Widget> children;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final Color? textColor;
  final Color? collapsedTextColor;

  const CustomExpansionTile({
    super.key,
    required this.context,
    required this.title,
    required this.children,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.collapsedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      iconColor: Theme.of(context).colorScheme.onBackground,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.secondary,
      collapsedBackgroundColor:
          collapsedBackgroundColor ?? Theme.of(context).colorScheme.primary,
      textColor: textColor ?? Theme.of(context).colorScheme.onPrimary,
      collapsedTextColor:
          collapsedTextColor ?? Theme.of(context).colorScheme.onPrimary,
      title: title,
      children: children,
    );
  }
}
