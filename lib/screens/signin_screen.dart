import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/models/enums/enum_user.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/screens/main_screen.dart';
import 'package:student_hub/services/auth_service.dart';
import 'package:student_hub/utils/api_util.dart';
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
  bool _isFilledEmail = false;
  bool _isFilledPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  // switch to create profile or main screen after login successful
  void switchToCreateProfileOrMain() {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    // handle company role
    if (user!.priorityRole == EnumUser.company && user.company == null) {
      NavigationUtil.toCompanyRegisterScreen(context);
      return;
    }

    // handle student role
    if (user.priorityRole == EnumUser.student && user.student == null) {
      NavigationUtil.toProfileStudentStep1Screen(context);
      return;
    }

    // go to main screen
    NavigationUtil.toMainScreen(context, MainScreenIndex.dashboard);
    return;
  }

  // sign up
  void onSignUp() {
    NavigationUtil.toSignUpStepOneScreen(context);
  }

  // sign in
  void onSignIn() async {
    // get response from the server
    final response = await AuthService.signin(
        email: emailController.text, password: passwordController.text);

    // decode the response to get the body
    final body = ApiUtil.getBody(response);

    // validate the response
    if (response.statusCode == StatusCode.created.code) {
      // decode the response to get the result of response-body
      final result = ApiUtil.getResult(response);

      // response is ok
      final token = result['token'];
      // save the token
      Provider.of<UserProvider>(context, listen: false).signin(token);

      // switch to create profile or main screeen
      switchToCreateProfileOrMain();
    } else if (response.statusCode == StatusCode.notFound.code) {
      // the user is not found
      final errorDetails = body['errorDetails'];

      // show popup error message
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: errorDetails.toString(),
        textSubmit: 'Ok',
        submit: null,
      );
    } else if (response.statusCode == StatusCode.unprocessableEntity.code) {
      // incorrect password
      final errorDetails = body['errorDetails'];

      // show popup error message
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: errorDetails.toString(),
        textSubmit: 'Ok',
        submit: null,
      );
    } else {
      // others
      // show popup error message
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: 'Something went wrong',
        textSubmit: 'Ok',
        submit: null,
      );
    }
  }

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
            onChanged: (String text) {
              // disable/enable the sign-in button
              setState(() {
                _isFilledEmail = text.trim().isNotEmpty;
              });
            },
          ),
          const SizedBox(
            height: SpacingUtil.mediumHeight,
          ),
          CustomTextfield(
            controller: passwordController,
            hintText: 'password',
            obscureText: true,
            onChanged: (String text) {
              // disable/enable the sign-in button
              setState(() {
                _isFilledPassword = text.trim().isNotEmpty;
              });
            },
          ),
          const SizedBox(
            height: SpacingUtil.mediumHeight,
          ),
          CustomButton(
            onPressed: onSignIn,
            text: 'Sign in',
            size: CustomButtonSize.large,
            isDisabled: !_isFilledEmail || !_isFilledPassword,
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
                CustomButton(onPressed: onSignUp, text: 'Sign up'),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
