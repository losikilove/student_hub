import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void onTap() {}

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onTap,
      text: 'test',
      size: CustomButtonSize.large,
    );
  }
}
