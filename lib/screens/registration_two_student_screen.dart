import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_anchor.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/spacing_util.dart';

class RegistrationTwoStudentScreen extends StatefulWidget {
  const RegistrationTwoStudentScreen({super.key});

  @override
  State<RegistrationTwoStudentScreen> createState() =>
      _RegistrationTwoStudentScreenState();
}

class _RegistrationTwoStudentScreenState
    extends State<RegistrationTwoStudentScreen> {
  final fullnameController = TextEditingController();
  bool _isAcceptedRules = false;

  void onPressed() {}

  // accept rules of this app
  void tickCheckBox(bool? value) {
    setState(() {
      _isAcceptedRules = value!;
    });
  }

  // create a student account
  void submit() {}

  // switch to student
  void switchToStudent() {}

  // get color of checkbox
  Color getColorCheckbox(Set<MaterialState> states) {
    // black color background of checkbox when is ticked checkbox
    if (states.contains(MaterialState.selected)) {
      return Colors.black;
    }

    // white color background of checkbox
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: onPressed, currentContext: context),
      body: InitialBody(
        child: Column(
          children: [
            // Title text
            const Center(
              child: CustomText(
                text: 'Sign up as Student',
                isBold: true,
              ),
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // Fullname textfield
            CustomTextfield(
                controller: fullnameController, hintText: 'Fullname'),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // Email textfield
            CustomTextfield(controller: fullnameController, hintText: 'Email'),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // Password textfield
            CustomTextfield(
              controller: fullnameController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // Confirm password textfield
            CustomTextfield(
              controller: fullnameController,
              hintText: 'Confirm password',
              obscureText: true,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // Checkbox
            Row(
              children: [
                Checkbox(
                  shape: const RoundedRectangleBorder(),
                  checkColor: Colors.white,
                  fillColor: MaterialStateColor.resolveWith(getColorCheckbox),
                  value: _isAcceptedRules,
                  onChanged: tickCheckBox,
                ),
                const CustomText(
                    text: 'Yes, I understand and agree to StudentHub'),
              ],
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // submit button
            CustomButton(
              onPressed: submit,
              text: 'Create my account',
              size: CustomButtonSize.large,
              isDisabled: !_isAcceptedRules,
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // Anchor which switches to student
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomText(text: 'Looking for a project? '),
                CustomAnchor(
                  text: 'Apply as a Student',
                  onTap: switchToStudent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
