import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void onTap() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onTap,
        currentContext: context,
      ),
      body: CustomButton(
        onPressed: onTap,
        text: 'test',
        size: CustomButtonSize.large,
      ),
    );
  }
}
