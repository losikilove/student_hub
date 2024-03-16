import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class StudentSubmitProposalScreen extends StatefulWidget {
  const StudentSubmitProposalScreen({super.key});

  @override
  State<StudentSubmitProposalScreen> createState() =>
      _StudentSubmitProposalScreenState();
}

class _StudentSubmitProposalScreenState
    extends State<StudentSubmitProposalScreen> {
  final _describeController = TextEditingController();
  bool _isDisabledSubmission = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _describeController.dispose();
    super.dispose();
  }

  void onPressed() {}

  // handle the submit button with mutations of textfield
  void onChangedDescribe(String text) {
    setState(() {
      _isDisabledSubmission = text.isEmpty ? true : false;
    });
  }

  // cancel this proposal
  void onCanceledProposal() {
    // back to the previous screen
    NavigationUtil.turnBack(context);
  }

  // submit this proposal
  void onSubmittedProposal() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,
        isBack: true,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title of this screen
            const CustomText(
              text: 'Cover letter',
              isBold: true,
            ),
            const SizedBox(height: SpacingUtil.smallHeight),
            // describe info text
            const CustomText(
              text: 'Describe why do you fit to this project?',
            ),
            const SizedBox(height: SpacingUtil.smallHeight),
            // describe textfield
            CustomTextfield(
              controller: _describeController,
              hintText: '',
              isBox: true,
              maxLines: 7,
              isFocus: true,
              keyboardType: TextInputType.text,
              // when have no describe in textfield, disable the submit button
              onChanged: onChangedDescribe,
            ),
            const SizedBox(height: SpacingUtil.smallHeight),
            // button area
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // cancel button
                CustomButton(
                  onPressed: onCanceledProposal,
                  text: 'Cancel',
                ),
                // submit button
                CustomButton(
                  onPressed: onSubmittedProposal,
                  text: 'Submit proposal',
                  // when have no describe, disable the submit button
                  isDisabled: _isDisabledSubmission,
                  buttonColor: ColorUtil.darkPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
