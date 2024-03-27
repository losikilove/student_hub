import 'package:flutter/material.dart';
import 'package:student_hub/utils/text_util.dart';

// set up enum for size of custom button
enum CustomButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final CustomButtonSize size;
  final bool isDisabled;
  final Color? buttonColor;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.size = CustomButtonSize.small,
    this.isDisabled = false,
    this.buttonColor,
    this.textColor = Colors.white,
  });

  // set up the witdh of button
  Size _setWidth(CustomButtonSize size) {
    const double fixedHeight = 40;

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
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? Theme.of(context).colorScheme.primary,
        minimumSize: _setWidth(size),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: TextUtil.textSize,
          color: textColor,
        ),
      ),
    );
  }
}
