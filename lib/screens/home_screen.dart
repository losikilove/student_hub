import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/spacing_util.dart';

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
      body: InitialBody(
        child: Column(
          children: [
            const Center(
              child: CustomText(
                text: 'Build your product with high-skilled student',
                isBold: true,
              ),
            ),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            const Center(
              child: CustomText(
                text:
                    'Find and onboard best-skilled student for your product. Student works to gain experience & skills from real-world projects',
                isCenter: true,
              ),
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            Center(
              child: SizedBox(
                height: SpacingUtil.mediumHeight,
                child: CustomButton(onPressed: onTap, text: 'Company'),
              ),
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            Center(
              child: SizedBox(
                height: SpacingUtil.mediumHeight,
                child: CustomButton(onPressed: onTap, text: 'Student'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
