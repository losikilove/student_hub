import 'package:flutter/material.dart';
import 'package:student_hub/components/circle_progress.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_textform.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/services/user_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgottenPasswordScreen extends StatefulWidget {
  const ForgottenPasswordScreen({super.key});

  @override
  State<ForgottenPasswordScreen> createState() =>
      _ForgottenPasswordScreenState();
}

class _ForgottenPasswordScreenState extends State<ForgottenPasswordScreen> {
  final emailController = TextEditingController();
  bool _isFilledEmail = false;

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  void onPressed() {}

  Future<void> onSubmitted() async {
    showCircleProgress(context: context);
    final response =
        await UserService.forgotPassword(email: emailController.text);
    Navigator.pop(context);

    // submit successfully
    if (response.statusCode == StatusCode.created.code) {
      final message = ApiUtil.getResult(response)['message'] as String;

      await popupNotification(
        context: context,
        type: NotificationType.success,
        content: '$message \nBack to sign in',
        textSubmit: 'Ok',
        submit: null,
      );

      Navigator.pop(context);
      return;
    }

    // other errors
    ApiUtil.handleOtherStatusCode(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,
        title: AppLocalizations.of(context)!.titleForgottenPassword,
        isBack: true,
      ),
      body: InitialBody(
        child: Column(
          children: [
            // Email text form
            CustomTextForm(
              controller: emailController,
              listErros: const <InvalidationType>[
                InvalidationType.isBlank,
                InvalidationType.isInvalidEmail
              ],
              hintText: 'Email',
              isFocus: true,
              onHelper: (messageError) {
                setState(() {
                  _isFilledEmail = messageError == null ? true : false;
                });
              },
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            CustomButton(
              onPressed: onSubmitted,
              text: AppLocalizations.of(context)!.submit,
              size: CustomButtonSize.large,
              isDisabled: !_isFilledEmail,
            ),
          ],
        ),
      ),
    );
  }
}
