import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:student_hub/components/circle_progress.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/screens/main_screen.dart';
import 'package:student_hub/services/profile_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:file_picker/file_picker.dart';

class ProfileStudentStep3Screen extends StatefulWidget {
  const ProfileStudentStep3Screen({Key? key}) : super(key: key);

  @override
  State<ProfileStudentStep3Screen> createState() =>
      _ProfileStudentStep3ScreenState();
}

class _ProfileStudentStep3ScreenState extends State<ProfileStudentStep3Screen> {
  FilePickerResult? _resumeFile;
  FilePickerResult? _transcriptFile;

  Future<FilePickerResult?> pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      return result;
    } catch (e) {
      // when have error, show the popup
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: 'Sorry, cannot get the file',
        textSubmit: 'Ok',
        submit: null,
      );
      return null;
    }
  }

  // pick a resume of student up
  Future<void> onPickedResume() async {
    // get the resume file
    _resumeFile = await pickFile(context);
  }

  // pick a transcript of student up
  Future<void> onPickedTranscript() async {
    // get the transcript file
    _transcriptFile = await pickFile(context);
  }

  // go to the next screen
  Future<void> onGoneToTheNextScreen() async {
    // loading in progress
    showCircleProgress(context: context);

    // get response from the 2 APIs: resume and transcript
    final response = await ProfileService.createStudentProfileStep3(
      context: context,
      resumeFilePath: _resumeFile!.files.first.path!,
      transcriptFilePath: _transcriptFile!.files.first.path!,
    );

    // handle response
    // go to next screen
    if (response.statusCode == StatusCode.ok.code) {
      // stop loading progress
      Navigator.of(context).pop();

      // go the main screen
      NavigationUtil.toMainScreen(context, MainScreenIndex.project);

      return;
    }

    // stop loading progress
    Navigator.of(context).pop();

    // when has a problem
    if (response.statusCode == StatusCode.error.code) {
      final result = ApiUtil.getResult(response);

      popupNotification(
        context: context,
        type: NotificationType.error,
        content: result['errorDetails'] as String,
        textSubmit: 'Ok',
        submit: null,
      );
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
        onPressed: () {},
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CustomText(
                text: "CV & Transcript",
                isBold: true,
              ),
            ),
            const CustomText(
              text:
                  "Tell us about yourself and you will be on your way to connect with real projects.",
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            const CustomText(text: "Resume/CV (*)"),
            DottedBorder(
              radius: const Radius.circular(8),
              color: Theme.of(context).colorScheme.onPrimary,
              child: Container(
                alignment: Alignment.center,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.upload_file,
                      size: 90,
                    ),
                    CustomButton(
                      onPressed: onPickedResume,
                      text: "choose file to up",
                      buttonColor: Theme.of(context).colorScheme.secondary,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            const CustomText(text: "Transcript (*)"),
            DottedBorder(
              radius: const Radius.circular(8),
              color: Theme.of(context).colorScheme.onPrimary,
              child: Container(
                alignment: Alignment.center,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.upload_file,
                      size: 90,
                    ),
                    // CustomText(text: "Drag on",isBold: true,),
                    CustomButton(
                      onPressed: onPickedTranscript,
                      text: "choose file to up",
                      buttonColor: Theme.of(context).colorScheme.secondary,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: SpacingUtil.largeHeight,
            ),
            Container(
              alignment: Alignment.topRight,
              child: CustomButton(
                onPressed: onGoneToTheNextScreen,
                text: "Continue",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
