import 'package:flutter/material.dart';
import 'package:student_hub/utils/text_util.dart';

class CustomText extends StatelessWidget {
  final String text;
  final bool isBold;
  final bool isCenter;
  final double size;
  const CustomText(
      {super.key,
      required this.text,
      this.isBold = false,
      this.isCenter = false,
      this.size = TextUtil.textSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: size,
      ),
      textAlign: isCenter ? TextAlign.center : TextAlign.left,
    );
  }
}
