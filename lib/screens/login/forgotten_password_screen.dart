import 'package:flutter/material.dart';

import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textform.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/services/user_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quickalert/quickalert.dart';
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
 
    QuickAlert.show(context: context, type: QuickAlertType.loading);
    final response =
        await UserService.forgotPassword(email: emailController.text);
    // Navigator.pop(context);

    // submit successfully
    if (response.statusCode == StatusCode.created.code) {
      final message = ApiUtil.getResult(response)['message'] as String;
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: '$message \nBack to sign in',
        text: message,
        confirmBtnText: 'Ok',
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
      body:SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          height: MediaQuery.of(context).size.height ,
          child: Column(
            children: [
              Image.asset('assets/images/forgot_img.png', 
                width: MediaQuery.sizeOf(context).width, 
                height: 220
              ),
              Center(
                child: CustomText(
                  text: AppLocalizations.of(context)!.insertemailtochangepassword,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
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
      ),
    );
  }
}
