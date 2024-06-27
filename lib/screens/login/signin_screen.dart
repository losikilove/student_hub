import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:student_hub/components/circle_progress.dart';
import 'package:student_hub/components/custom_anchor.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_textfield.dart';
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
    // showCircleProgress(context: context);
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      text: "Signing in..."
    );

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

      switchToCreateProfileOrMain();
    } else if (response.statusCode == StatusCode.notFound.code) {
      // pop the loading progress
      // Navigator.of(context).pop();

      // the user is not found
      final errorDetails = body['errorDetails'];

      // show popup error message
      QuickAlert.show(
        context: context, 
        type: QuickAlertType.error,
        text: errorDetails.toString(),
      );
  
    } else if (response.statusCode == StatusCode.unprocessableEntity.code) {
      // pop the loading progress
      // Navigator.of(context).pop();

      // incorrect password
      final errorDetails = body['errorDetails'];

      // show popup error message
      QuickAlert.show(
        context: context, 
        type: QuickAlertType.error,
        text: errorDetails.toString(),
      );

    } else {
      // pop the loading progress
      // Navigator.of(context).pop();

      // others
      // show popup error message
      QuickAlert.show(
        context: context, 
        type: QuickAlertType.error,
        text: AppLocalizations.of(context)!.somethingWentWrong,
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
      
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          height: MediaQuery.of(context).size.height ,
          child: Column(children: [
            Image.asset("assets/images/login1_img1.png", 
              width: MediaQuery.sizeOf(context).width, 
              height: 220
            ),
            Center(
                child: CustomText(
              text: AppLocalizations.of(context)!.loginWithStudentHub,
              size: 30,
              isBold: true,
            )),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            CustomTextfield(
              controller: emailController,
              hintText: 'email',
              prefixIcon: Icons.email_outlined,
              isBox: true,
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
              isBox: true,
              prefixIcon: Icons.lock_outline,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomAnchor(
                  text: AppLocalizations.of(context)!.forgottenYourPassword,
                  onTap: onForgottenPassword,
                ),
              ],
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
              height:20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(text: '${AppLocalizations.of(context)!.dontHaveAccount} '),
                const SizedBox(width:6),
                CustomAnchor(text: "Register", onTap: onSignUp)
              ],
            ),
           
            
          ]),
        ),
      ),
      // ),
    );
  }
}

