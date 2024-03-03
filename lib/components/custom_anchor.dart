import 'package:flutter/material.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/text_util.dart';

class CustomAnchor extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const CustomAnchor({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
            fontSize: TextUtil.textSize,
            decoration: TextDecoration.underline,
            decorationColor: ColorUtil.primary,
            color: ColorUtil.primary),
      ),
    );
  }
}
