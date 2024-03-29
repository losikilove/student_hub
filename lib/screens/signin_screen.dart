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
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void onSignUp() {
    NavigationUtil.toSignUpStepOneScreen(context);
  }

  void onSignIn() {}
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
            height: SpacingUtil.mediumHeight,
          ),
          CustomTextfield(
            controller: emailController,
            hintText: 'email',
          ),
          const SizedBox(
            height: SpacingUtil.mediumHeight,
          ),
          CustomTextfield(
              controller: passwordController,
              hintText: 'password',
              obscureText: true),
          const SizedBox(
            height: SpacingUtil.mediumHeight,
          ),
          CustomButton(
            onPressed: onSignIn,
            text: 'sign in',
            size: CustomButtonSize.medium,
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
                CustomButton(onPressed: onSignUp, text: 'sign up'),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
