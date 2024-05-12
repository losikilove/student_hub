import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textform.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/services/user_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/text_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  bool _isFilledOldPassword = false;
  final newPasswordController = TextEditingController();
  bool _isFilledNewPassword = false;
  final confirmNewPasswordController = TextEditingController();
  bool _isFilledConfirmPassword = false;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();

    super.dispose();
  }

  // submit new password
  void onSubmit() async {
    // confirm changed password
    final isConfirmed = await _showDialogConfirmChangePassword();

    if (isConfirmed == null || isConfirmed == false) {
      return;
    }

    // when new password and confirm password do not match,
    // show popup error
    if (newPasswordController.text != confirmNewPasswordController.text) {
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: 'New password and confirm password do not match',
        textSubmit: 'Ok',
        submit: null,
      );
      return;
    }

    // get token
    final token = Provider.of<UserProvider>(context, listen: false).token;

    // get response when PUT change password
    final response = await UserService.changePassword(
      token: token!,
      oldPassword: oldPasswordController.text,
      newPassword: newPasswordController.text,
    );

    if (response.statusCode == StatusCode.ok.code) {
      // change password success
      // then back to login screen
      await popupNotification(
        context: context,
        type: NotificationType.success,
        content: 'Changed password success. Back to login',
        textSubmit: 'Ok',
        submit: () {
          // expire token
          Provider.of<UserProvider>(context, listen: false).signout();

          // back to login screen
          NavigationUtil.toSignInScreen(context);
        },
      );

      // auto back to login screen
      // after expire token
      Provider.of<UserProvider>(context, listen: false).signout();
      NavigationUtil.toSignInScreen(context);
    } else if (response.statusCode == StatusCode.forbidden.code) {
      // wrong old password or duplicate passwords
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: 'Wrong old password or New password is old password',
        textSubmit: 'Ok',
        submit: null,
      );
    } else if (response.statusCode == StatusCode.unauthorized.code) {
      // expire token
      ApiUtil.handleExpiredToken(context: context);
      return;
    } else {
      ApiUtil.handleOtherStatusCode(context: context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: () {},
        currentContext: context,
        isBack: true,
      ),
      body: InitialBody(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CustomText(
                  text: AppLocalizations.of(context)!.changePassword,
                  isBold: true,
                  size: 30,
                ),
              ),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
              // old password area
              CustomText(
                text: AppLocalizations.of(context)!.oldPassword,
                size: TextUtil.smallTextSize,
                isBold: true,
              ),
              CustomTextForm(
                controller: oldPasswordController,
                listErros: const [
                  InvalidationType.isBlank,
                ],
                hintText: AppLocalizations.of(context)!.enterOldPassword,
                onHelper: (String? errorMessage) {
                  setState(() {
                    _isFilledOldPassword = errorMessage == null ? true : false;
                  });
                },
                obscureText: true,
              ),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              // new password area
              CustomText(
                text: AppLocalizations.of(context)!.newPassword,
                size: TextUtil.smallTextSize,
                isBold: true,
              ),
              CustomTextForm(
                controller: newPasswordController,
                listErros: const [
                  InvalidationType.isBlank,
                  InvalidationType.isInvalidPassword,
                ],
                hintText: AppLocalizations.of(context)!.enterNewPassword,
                onHelper: (String? errorMessage) {
                  setState(() {
                    _isFilledNewPassword = errorMessage == null ? true : false;
                  });
                },
                obscureText: true,
              ),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              // confirm password area
              CustomText(
                text: AppLocalizations.of(context)!.comfirmPassword,
                size: TextUtil.smallTextSize,
                isBold: true,
              ),
              CustomTextForm(
                controller: confirmNewPasswordController,
                listErros: const [
                  InvalidationType.isBlank,
                  InvalidationType.isInvalidPassword,
                ],
                hintText: AppLocalizations.of(context)!.enterConfirmPassword,
                onHelper: (String? errorMessage) {
                  setState(() {
                    _isFilledConfirmPassword =
                        errorMessage == null ? true : false;
                  });
                },
                obscureText: true,
              ),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
              // update button
              CustomButton(
                onPressed: onSubmit,
                isDisabled: !_isFilledOldPassword ||
                    !_isFilledConfirmPassword ||
                    !_isFilledNewPassword,
                size: CustomButtonSize.large,
                text: AppLocalizations.of(context)!.submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDialogConfirmChangePassword() => showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'WARNING',
            style: TextStyle(color: Colors.red),
          ),
          content: const CustomText(
            text: 'Are you sure to change your password?',
          ),
          actions: [
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              text: 'Yes',
            ),
            CustomButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              text: 'No',
            ),
          ],
        );
      });
}
