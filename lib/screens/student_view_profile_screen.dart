import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class StudentViewProfileScreen extends StatefulWidget {
  const StudentViewProfileScreen({super.key});

  @override
  State<StudentViewProfileScreen> createState() =>
      _StudentViewProfileScreenState();
}

class _StudentViewProfileScreenState extends State<StudentViewProfileScreen> {
  void onPressed() {}

  // switch to update-company-profile screen
  void onSwitchedToStudentUpdateProfile() {
    // TODO:
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,
        isBack: true,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // update student button
            Align(
              alignment: Alignment.topRight,
              child: CustomButton(
                size: CustomButtonSize.small,
                onPressed: onSwitchedToStudentUpdateProfile,
                text: 'Update',
              ),
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // title of screen
            const Center(
              child: CustomText(
                text: 'Your student profile',
                isBold: true,
                size: 25,
              ),
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // info area
          ],
        ),
      ),
    );
  }
}
