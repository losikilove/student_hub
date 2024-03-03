import 'package:flutter/material.dart';
import 'package:student_hub/utils/text_util.dart';

class CustomText extends StatelessWidget {
  final String text;
  final bool isBold;
  final bool isCenter;
  const CustomText(
      {super.key,
      required this.text,
      this.isBold = false,
      this.isCenter = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: TextUtil.textSize,
      ),
      textAlign: isCenter ? TextAlign.center : TextAlign.left,
    );
  }
}
