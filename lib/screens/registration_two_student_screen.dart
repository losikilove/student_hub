import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_anchor.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textform.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/spacing_util.dart';

class RegistrationTwoStudentScreen extends StatefulWidget {
  const RegistrationTwoStudentScreen({super.key});

  @override
  State<RegistrationTwoStudentScreen> createState() =>
      _RegistrationTwoStudentScreenState();
}

class _RegistrationTwoStudentScreenState
    extends State<RegistrationTwoStudentScreen> {
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

  void onPressed() {}

  // accept rules of this app
  void tickCheckBox(bool? value) {
    setState(() {
      _isAcceptedRules = value!;
    });
  }

  // create a student account
  void submit() {}

  // switch to student
  void switchToCompany() {}

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
      appBar: CustomAppbar(onPressed: onPressed, currentContext: context),
      body: InitialBody(
        child: Column(
          children: [
            // Title text
            const Center(
              child: CustomText(
                text: 'Sign up as Student',
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
                        controller: fullnameController,
                        listErros: const <InvalidationType>[
                          InvalidationType.isBlank
                        ],
                        hintText: 'Fullname',
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
                        controller: passwordController,
                        listErros: const <InvalidationType>[
                          InvalidationType.isBlank,
                          InvalidationType.isInvalidPassword
                        ],
                        hintText: 'Password',
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
                        controller: confirmPasswordController,
                        listErros: const <InvalidationType>[
                          InvalidationType.isBlank,
                          InvalidationType.isInvalidPassword
                        ],
                        hintText: 'Confirm password',
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
                          const CustomText(
                              text:
                                  'Yes, I understand and agree to StudentHub'),
                        ],
                      ),
                      const SizedBox(
                        height: SpacingUtil.smallHeight,
                      ),
                      // submit button
                      CustomButton(
                        onPressed: submit,
                        text: 'Create my account',
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
                      // Anchor which switches to company
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CustomText(text: 'Initialize a project? '),
                          CustomAnchor(
                            text: 'Apply as a Company',
                            onTap: switchToCompany,
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
