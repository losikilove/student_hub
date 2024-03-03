import 'package:flutter/material.dart';

// set up enum for size of custom button
enum CustomButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final CustomButtonSize size;

  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.size = CustomButtonSize.small});

  // set up the witdh of button
  Size _setWidth(CustomButtonSize size) {
    const double fixedHeight = 36;

    // size of button is fullwidth
    if (size == CustomButtonSize.large) {
      return const Size(double.infinity, fixedHeight);
    }

    if (size == CustomButtonSize.medium) {
      return const Size(192, fixedHeight);
    }

    return const Size(128, fixedHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(minimumSize: _setWidth(size)),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
