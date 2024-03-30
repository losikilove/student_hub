import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
class ChangPasswordScreen extends StatefulWidget {
  const ChangPasswordScreen({super.key});

  @override
  State<ChangPasswordScreen> createState() => _ChangPasswordScreenState();
}

class _ChangPasswordScreenState extends State<ChangPasswordScreen> {
  final oldPasswordController = TextEditingController();
  bool _isFilledOldPassword = false;
  final newPasswordController = TextEditingController();
  bool _isFilledNewPassword = false;
  final confirmNewPasswordController = TextEditingController();
  bool _isFilledConfirmPassword = false;
  void onCanceledProposal() {
    // back to the previous screen
    NavigationUtil.turnBack(context);
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: CustomAppbar(onPressed: (){}, 
        currentContext: context,
        isBack: true,
      ),
      body: InitialBody(
        child: Column(
          children: [
            const Center(
              child:CustomText(text:'Change password',
                isBold: true,size:30,
              )
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            CustomTextfield(
              controller: oldPasswordController,
              hintText: 'old password',
              obscureText: true,
              onChanged: (String text) { 
              setState(() {
                 _isFilledOldPassword = text.trim().isNotEmpty;
               });
             },
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            CustomTextfield(
              controller: newPasswordController,
              hintText: 'new password',
              obscureText: true,
              onChanged: (String text) { 
              setState(() {
                 _isFilledNewPassword = text.trim().isNotEmpty;
               });
             },
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            CustomTextfield(
              controller: confirmNewPasswordController,
              hintText: 'confirm password',
              obscureText: true,
              onChanged: (String text) { 
              setState(() {
                 _isFilledConfirmPassword = text.trim().isNotEmpty;
               });
             },
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            CustomButton(
              onPressed:(){},
              isDisabled: !_isFilledOldPassword || !_isFilledConfirmPassword|| !_isFilledNewPassword,
              size:CustomButtonSize.large,
              text: "Update password"
            )
          ],
        )
      ),
    );
  }
}