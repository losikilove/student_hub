import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/circle_progress.dart';
import 'package:student_hub/components/custom_anchor.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/screens/main_screen.dart';
import 'package:student_hub/services/auth_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/utils/user_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    // handle company role
    if (Provider.of<UserProvider>(context, listen: false)
            .user!
            .isNullPriorityRole() ==
        true) {
      UserUtil.switchToCreateProfile(context);
      return;
    }

    // go to main screen
    // NavigationUtil.toMainScreen(context, MainScreenIndex.dashboard);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen(
                  contentBody: MainScreenIndex.dashboard,
                )));
    ;
  }

  // sign up
  void onSignUp() {
    NavigationUtil.toSignUpStepOneScreen(context);
  }

  // sign in
  void onSignIn() async {
    // loading in progress
    showCircleProgress(context: context);

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
      await Provider.of<UserProvider>(context, listen: false).signin(token);

      // pop the loading progress
      Navigator.of(context).pop();

      // switch to create profile or main screeen
      switchToCreateProfileOrMain();
    } else if (response.statusCode == StatusCode.notFound.code) {
      // pop the loading progress
      Navigator.of(context).pop();

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
      // pop the loading progress
      Navigator.of(context).pop();

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
      // pop the loading progress
      Navigator.of(context).pop();

      // others
      // show popup error message
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: AppLocalizations.of(context)!.somethingWentWrong,
        textSubmit: 'Ok',
        submit: null,
      );
    }
  }

  void onPressed() {}

  void onForgottenPassword() {
    NavigationUtil.toForgottenPassword(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: onPressed, currentContext: context),
      body: InitialBody(
        child: Column(children: [
          Center(
              child: CustomText(
            text: AppLocalizations.of(context)!.loginWithStudentHub,
            size: 20,
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
            hintText: AppLocalizations.of(context)!.password,
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
            text: AppLocalizations.of(context)!.signIn,
            size: CustomButtonSize.large,
            isDisabled: !_isFilledEmail || !_isFilledPassword,
          ),
          const SizedBox(
            height: SpacingUtil.mediumHeight,
          ),
          CustomAnchor(
            text: AppLocalizations.of(context)!.forgottenYourPassword,
            onTap: onForgottenPassword,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: CustomText(
                    text:
                        '__${AppLocalizations.of(context)!.dontHaveAccount}__',
                    isCenter: true,
                  ),
                ),
                CustomButton(
                    onPressed: onSignUp,
                    text: AppLocalizations.of(context)!.signUp,
                    size: CustomButtonSize.small),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
