import 'package:flutter/material.dart';
import 'package:student_hub/components/circle_progress.dart';
import 'package:student_hub/components/custom_anchor.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textform.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/models/enums/enum_user.dart';
import 'package:student_hub/services/auth_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quickalert/quickalert.dart';
class RegistrationTwoCompanyScreen extends StatefulWidget {
  const RegistrationTwoCompanyScreen({super.key});

  @override
  State<RegistrationTwoCompanyScreen> createState() =>
      _RegistrationTwoCompanyScreenState();
}

class _RegistrationTwoCompanyScreenState
    extends State<RegistrationTwoCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isAcceptedRules = false;
  bool _isValidFullname = false;
  bool _isValidEmail = false;
  bool _isValidPassword = false;
  bool _isValidConfirmPassword = false;

  // accept rules of this app
  void tickCheckBox(bool? value) {
    setState(() {
      _isAcceptedRules = value!;
    });
  }

  // create a company account
  Future<void> submit() async {
    // confimed password and password do not match
    if (confirmPasswordController.text != passwordController.text) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: AppLocalizations.of(context)!.comfirmPasswordDoesNotMatch,
        cancelBtnText: "OK"
        // text: AppLocalizations.of(context)!.passwordsDoNotMatch,
        // textSubmit: 'OK',
        // submit: null,
      );
      return;
    }

    // loading in progress
    showCircleProgress(context: context);
    // QuickAlert.show(
    //   context: context,
    //   type: QuickAlertType.loading,
    //   text: AppLocalizations.of(context)!.loading,
    // );

    // get response from the server
    final response = await AuthService.signup(
      fullname: fullnameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: EnumUser.company.value,
    );

    // stop loading
    Navigator.of(context).pop();

    // decode the response to get the body of response
    final body = ApiUtil.getBody(response);

    // validate the response
    if (response.statusCode == StatusCode.created.code) {
      // get the result about verified email
      final result = body['result'];

      // the response is ok
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: result['message'].toString(),
        cancelBtnText: 'OK',

      );
      // await popupNotification(
      //   context: context,
      //   type: NotificationType.success,
      //   // show a content about verified email
      //   content: result['message'].toString(),
      //   textSubmit: 'OK',
      //   submit: null,
      // );

      NavigationUtil.toSignInScreen(context);
      return;
    } else if (response.statusCode == StatusCode.error.code) {
      // the reponse got an error
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: AppLocalizations.of(context)!.somethingWentWrong,
        confirmBtnText: 'OK',
  
      );
    } else {
      // the reponse got an error
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: body['message'].toString(),
        confirmBtnText: 'OK',

      );
    }
  }

  // switch to student
  void onSwitchedToLogin() {
    NavigationUtil.toSignInScreen(context);
  }

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
      appBar: CustomAppbar(
        onPressed: () {},
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          children: [
            // Title text
            Center(
              child: CustomText(
                text: AppLocalizations.of(context)!.signUpAsCompany,
                size: 20,
                isBold: true,
              ),
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // Form
            Form(
              key: _formKey,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fullname text form
                      CustomTextForm(
                        prefixIcon: Icons.person,
                        controller: fullnameController,
                        listErros: const <InvalidationType>[
                          InvalidationType.isBlank
                        ],
                        hintText: AppLocalizations.of(context)!.fullName,
                        onHelper: (messageError) {
                          setState(() {
                            _isValidFullname =
                                messageError == null ? true : false;
                          });
                        },
                      ),
                      const SizedBox(
                        height: SpacingUtil.smallHeight,
                      ),
                      // Email text form
                      CustomTextForm(
                        prefixIcon: Icons.email,
                        controller: emailController,
                        listErros: const <InvalidationType>[
                          InvalidationType.isBlank,
                          InvalidationType.isInvalidEmail
                        ],
                        hintText: 'Email',
                        onHelper: (messageError) {
                          setState(() {
                            _isValidEmail = messageError == null ? true : false;
                          });
                        },
                      ),
                      const SizedBox(
                        height: SpacingUtil.smallHeight,
                      ),
                      // Password text form
                      CustomTextForm(
                        prefixIcon: Icons.lock,
                        controller: passwordController,
                        listErros: const <InvalidationType>[
                          InvalidationType.isBlank,
                          InvalidationType.isInvalidPassword
                        ],
                        hintText: AppLocalizations.of(context)!.password,
                        obscureText: true,
                        onHelper: (messageError) {
                          setState(() {
                            _isValidPassword =
                                messageError == null ? true : false;
                          });
                        },
                      ),
                      const SizedBox(
                        height: SpacingUtil.smallHeight,
                      ),
                      // Confirm password text form
                      CustomTextForm(
                        prefixIcon:  Icons.lock,
                        controller: confirmPasswordController,
                        listErros: const <InvalidationType>[
                          InvalidationType.isBlank,
                          InvalidationType.isInvalidPassword
                        ],
                        hintText: AppLocalizations.of(context)!.comfirmPassword,
                        obscureText: true,
                        onHelper: (messageError) {
                          setState(() {
                            _isValidConfirmPassword =
                                messageError == null ? true : false;
                          });
                        },
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
                            fillColor: MaterialStateColor.resolveWith(
                                getColorCheckbox),
                            value: _isAcceptedRules,
                            onChanged: tickCheckBox,
                          ),
                          Flexible(child: CustomText(
                            text: AppLocalizations.of(context)!.yesIUnderstandAndAgree,
                            size: 15,
                          ),)
                          
                        ],
                      ),
                      const SizedBox(
                        height: SpacingUtil.smallHeight,
                      ),
                      // submit button
                      CustomButton(
                        onPressed: submit,
                        text: AppLocalizations.of(context)!.createMyAccount,
                        size: CustomButtonSize.large,
                        // enable this button when all fields are filled and rules are accepted
                        isDisabled: !_isAcceptedRules ||
                            !_isValidFullname ||
                            !_isValidEmail ||
                            !_isValidPassword ||
                            !_isValidConfirmPassword,
                      ),
                      const SizedBox(
                        height: SpacingUtil.mediumHeight,
                      ),
                      // Anchor which switches to student
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(text: AppLocalizations.of(context)!.lookingForProject + ' ',),
                          CustomAnchor(
                            text: AppLocalizations.of(context)!.applyAsAStudent,
                            onTap: onSwitchedToLogin,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
