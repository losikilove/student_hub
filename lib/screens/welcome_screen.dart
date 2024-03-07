import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final String name = 'Hai';

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          children: [
            // signpost icon
            const Icon(
              Icons.signpost_outlined,
              size: 40.0,
            ),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            // welcome text
            Center(
              child: CustomText(text: 'Welcome, $name!'),
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // greeting text
            const Center(
              child: CustomText(
                text: 'Let\'s start with your first project post',
              ),
            ),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            // switch to dashboard button
            CustomButton(
              onPressed: (){
                NavigationUtil.toMainScreen(context);
              },
              text: 'Get started!',
            ),
          ],
        ),
      ),
    );
  }
}
