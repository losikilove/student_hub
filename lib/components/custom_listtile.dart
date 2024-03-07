import 'package:flutter/material.dart';

class CustomListTitle extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final String? subtext;
  final IconData icon;
  const CustomListTitle(
      {super.key,
      required this.icon,
      required this.text,
      required this.onTap,
      required this.subtext});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Icon(icon, size: 50),
        title: Text(text),
        onTap: onTap,
        subtitle: subtext != null ? Text(subtext!) : null,
      ),
    );
  }
}
