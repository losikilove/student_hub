import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';

class CustomBulletedList extends StatelessWidget {
  final List<String> listItems;
  final double textSize;
  final Color? textColor;
  final Color? bulletColor;

  const CustomBulletedList({
    super.key,
    required this.listItems,
    this.textSize = 14.0,
    this.textColor,
    this.bulletColor,
  });

  @override
  Widget build(BuildContext context) {
    return BulletedList(
      style: TextStyle(
        fontSize: textSize,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      bulletColor: bulletColor ?? Theme.of(context).colorScheme.onPrimary,
      listItems: listItems,
    );
  }
}
