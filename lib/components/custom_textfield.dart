import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isBox;
  final int maxLines;
  final double fontSize;
  final bool obscureText;
  final bool isBold;
  final bool isFocus;
  const CustomTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      this.fontSize = 15,
      this.isBold = false,
      this.isBox = false,
      this.maxLines = 1,
      this.obscureText = false,
      this.isFocus = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      // remove underline
      decoration: isBox
          ? const InputDecoration(
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide()),
            )
          : InputDecoration.collapsed(hintText: hintText),
      textCapitalization: TextCapitalization.sentences,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
      autofocus: isFocus,
    );
  }
}
