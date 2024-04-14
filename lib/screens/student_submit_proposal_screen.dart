import 'package:flutter/material.dart';
import 'package:student_hub/components/circle_progress.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/popup_confirm.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/models/enums/enum_status_flag.dart';
import 'package:student_hub/services/proposal_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class StudentSubmitProposalScreen extends StatefulWidget {
  final int projectId;

  const StudentSubmitProposalScreen({super.key, required this.projectId});

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
  Future<void> onSubmittedProposal() async {
    // popup confirm that user want to submit this proposal
    final confirmedSubmitProposal = await popupConfirm(
      context: context,
      content: 'Are you sure to submit this',
    );

    // do not want to submit
    if (confirmedSubmitProposal == null || confirmedSubmitProposal == false) {
      return;
    }

    // loading in progress
    showCircleProgress(context: context);

    // handle the submission
    final response = await ProposalService.postProposal(
      context: context,
      projectId: widget.projectId,
      coverLetter: _describeController.text,
      statusFlag: EnumStatusFlag.waitting,
    );

    // stop loading
    Navigator.of(context).pop();

    // handle the response
    // when the reponse is ok
    if (response.statusCode == StatusCode.created.code) {
      // show successful popup
      await popupNotification(
        context: context,
        type: NotificationType.success,
        content: 'Your proposal has submitted',
        textSubmit: 'Ok',
        submit: null,
      );

      // back to the previous screen
      NavigationUtil.turnBack(context);
      return;
    }

    // when expired token
    if (response.statusCode == StatusCode.unauthorized.code) {
      ApiUtil.handleExpiredToken(context: context);
      return;
    }

    // others
    ApiUtil.handleOtherStatusCode(context: context);
  }

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
                  buttonColor: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
