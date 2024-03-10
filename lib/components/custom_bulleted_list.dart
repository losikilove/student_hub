import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';

class CustomBulletedList extends StatelessWidget {
  final List<String> listItems;
  final double textSize;
  final Color textColor;
  final Color bulletColor;

  const CustomBulletedList({
    super.key,
    required this.listItems,
    this.textSize = 14.0,
    this.textColor = Colors.black,
    this.bulletColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return BulletedList(
      style: TextStyle(
        fontSize: textSize,
        color: textColor,
      ),
      bulletColor: bulletColor,
      listItems: listItems,
    );
  }
}
