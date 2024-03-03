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
            // Title info text
            const Center(
              child: CustomText(
                text: 'Build your product with high-skilled student',
                isBold: true,
              ),
            ),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            // Detail of info text
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
            // Company button
            CustomButton(onPressed: onTap, text: 'Company'),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // Student button
            CustomButton(onPressed: onTap, text: 'Student'),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // Detail of info text
            const Center(
              child: CustomText(
                text:
                    'StudentHub is university market place to connect high-skilled student and company on a real-world project',
                isCenter: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
