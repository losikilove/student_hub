import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_anchor.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/enums/enum_user.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_appbar.dart';

class SignUpSetup1Screen extends StatefulWidget {
  const SignUpSetup1Screen({super.key});

  @override
  State<SignUpSetup1Screen> createState() => _SignUpSetup1ScreenState();
}

class _SignUpSetup1ScreenState extends State<SignUpSetup1Screen> {
  EnumUser? _user = EnumUser.student;

  void chooseUserType(EnumUser? value) {
    setState(() {
      _user = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: () {},
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          children: [
            // Title text
            const Center(
              child: CustomText(
                text: "Join as Company or Student",
                isBold: true,
              ),
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // Card of company introducing
            _cardChoice(Icons.account_box, EnumUser.company,
                'I am a Company, find engineer for project'),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // Card of student introducing
            _cardChoice(Icons.accessibility, EnumUser.student,
                'I am a Student, find a project'),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            CustomButton(
              onPressed: () {
                NavigationUtil.toSignUpStepTwoAsCompanyScreen(context);
              },
              text: 'Create account',
              size: CustomButtonSize.large,
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomText(text: 'Already have an account? '),
                CustomAnchor(text: "Log in", onTap: () {})
              ],
            ),
          ],
        ),
      ),
    );
  }

  // create card widget which is unique of this screen
  Widget _cardChoice(IconData icon, EnumUser user, String intro) {
    return Card(
      shape: Border.all(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon),
                Radio<EnumUser>(
                  activeColor: Color.fromARGB(236, 3, 70, 147),
                  value: user,
                  groupValue: _user,
                  onChanged: chooseUserType,
                ),
              ],
            ),
            CustomText(
              text: intro,
            ),
          ],
        ),
      ),
    );
  }
}
