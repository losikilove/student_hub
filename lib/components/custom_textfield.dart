import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_hub/utils/text_util.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isBox;
  final int maxLines;
  final double fontSize;
  final bool obscureText;
  final bool isBold;
  final bool isFocus;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormaters;
  final IconData? prefixIcon;
  final void Function(String text)? onChanged;

  const CustomTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      this.fontSize = TextUtil.textSize,
      this.isBold = false,
      this.isBox = false,
      this.maxLines = 1,
      this.obscureText = false,
      this.isFocus = false,
      this.keyboardType,
      this.inputFormaters,
      this.prefixIcon,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      // remove underline
      decoration: isBox
          ? InputDecoration(
              prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide()),
            )
          : InputDecoration(
              prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
            ),
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
      autofocus: isFocus,
      keyboardType: keyboardType,
      inputFormatters: inputFormaters,
      onChanged: onChanged,
    );
  }
}
