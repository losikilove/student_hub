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
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: Color.fromARGB(255, 0, 0, 0),
          width: 2,
        )),
      ),
      child: ListTile(
        leading: Icon(icon, size: 50),
        title: Text(text),
        onTap: onTap,
        subtitle: subtext != null ? Text(subtext!) : null,
      ),
    );
  }
}
