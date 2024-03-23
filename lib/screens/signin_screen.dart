import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  void OnSignUp() {
    NavigationUtil.toSignUpStepOneScreen(context);
  }

  void OnSignIn() {}
  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: onPressed, currentContext: context),
      body: InitialBody(
        child: Column(children: [
          const Center(
              child: CustomText(
            text: 'Log in with StudentHub',
            isBold: true,
          )),
          const SizedBox(
            height: SpacingUtil.largeHeight,
          ),
          CustomTextfield(controller: emailController, hintText: 'email'),
          const SizedBox(
            height: SpacingUtil.mediumHeight,
          ),
          CustomTextfield(
              controller: emailController,
              hintText: 'password',
              obscureText: true),
          const SizedBox(
            height: SpacingUtil.mediumHeight,
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Center(
                  child: CustomText(
                    text: '__Don\'t have an Student Hub account?__',
                    isCenter: true,
                  ),
                ),
                CustomButton(onPressed: OnSignUp, text: 'sign up'),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
