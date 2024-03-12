import 'package:flutter/material.dart';
import 'package:student_hub/utils/text_util.dart';

class CustomText extends StatelessWidget {
  final String text;
  final bool isBold;
  final bool isItalic;
  final bool isCenter;
  final double size;
  final bool isOverflow;
  const CustomText(
      {super.key,
      required this.text,
      this.isBold = false,
      this.isItalic = false,
      this.isCenter = false,
      this.isOverflow = false,
      this.size = TextUtil.textSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: isOverflow ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: size,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      ),
      textAlign: isCenter ? TextAlign.center : TextAlign.left,
    );
  }
}
