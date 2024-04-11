import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/add_new_education.dart';
import 'package:student_hub/components/add_new_language.dart';
import 'package:student_hub/components/circle_progress.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_future_builder.dart';
import 'package:student_hub/components/custom_option.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/mutliselect_chip.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/models/education_model.dart';
import 'package:student_hub/models/language_model.dart';
import 'package:student_hub/models/skill_set_model.dart';
import 'package:student_hub/models/tech_stack_model.dart';
import 'package:student_hub/models/user_model.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/services/education_service.dart';
import 'package:student_hub/services/language_service.dart';
import 'package:student_hub/services/profile_service.dart';
import 'package:student_hub/services/skill_set_service.dart';
import 'package:student_hub/services/tech_stack_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:student_hub/utils/api_util.dart';

class ProfileStudentUtil {
  static const double _percentWidthSize = 0.9;

  // update a techstack
  static Future<void> onUpdatedTechStack(
      {required BuildContext context}) async {
    // get techstack
    UserModel user = Provider.of<UserProvider>(context, listen: false).user!;
    late TechStackModel techStack;

    // initialize the techstack from server
    Future<List<TechStackModel>> initializeTechStack() async {
      final responseTechStack = await TechStackService.getAllTeckStack();

      return TechStackModel.fromResponse(
          ApiUtil.getBody(responseTechStack)['result'] as List<dynamic>);
    }

    // get result from the techstack
    void onGettingValueOfTechstack(TechStackModel? option) {
      techStack = option!;
    }

    // check that info is updated
    final isUpdated = await _showEditedInfo(
      context: context,
      titleAttribute: 'Techstack',
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * _percentWidthSize,
        child: CustomFutureBuilder<List<TechStackModel>>(
          future: initializeTechStack(),
          widgetWithData: (snapshot) => CustomOption<TechStackModel>(
            initialSelection: snapshot.data!.singleWhere(
              (element) => element.id == user.student!.techStack.id,
            ),
            options: snapshot.data!,
            onHelper: onGettingValueOfTechstack,
          ),
          widgetWithError: (snapshot) {
            return const CustomText(
              text: 'Sorry, something went wrong',
              textColor: Colors.red,
            );
          },
        ),
      ),
      handleSubmit: () {
        return ProfileService.updateStudentTechStackOrSkillSets(
          context: context,
          techStack: techStack,
          skillSets: user.student!.skillSets,
        );
      },
    );

    // have no clue
    if (isUpdated == null) {
      return;
    }

    // if isUpdated is false, that means something went wrong
    if (isUpdated == false) {
      ApiUtil.handleOtherStatusCode(context: context);
      return;
    }

    // popup success
    popupNotification(
      context: context,
      type: NotificationType.success,
      content: 'Update techstack successfully',
      textSubmit: 'Ok',
      submit: null,
    );
  }

  // update skillsets
  static Future<void> onUpdatedSkillSets(
      {required BuildContext context}) async {
    // get skillsets
    UserModel user = Provider.of<UserProvider>(context, listen: false).user!;
    // copy list to avoid accessing the old list
    List<SkillSetModel> skillSets = [...user.student!.skillSets];

    // initialize skill set
    Future<List<SkillSetModel>> initializeSkillSet() async {
      final responseSkillSets = await SkillSetService.getAllSkillSet();

      return SkillSetModel.fromResponse(
          ApiUtil.getBody(responseSkillSets)['result'] as List<dynamic>);
    }

    // get results from the skillset
    void onGettingValuesOfSkillset(List<SkillSetModel> selectedItems) {
      skillSets = selectedItems;
    }

    // check that info is updated
    final isUpdated = await _showEditedInfo(
      context: context,
      titleAttribute: 'Skillsets',
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * _percentWidthSize,
        child: CustomFutureBuilder<List<SkillSetModel>>(
          future: initializeSkillSet(),
          widgetWithData: (snapshot) => MultiSelectChip<SkillSetModel>(
            listOf: snapshot.data!,
            initialList: skillSets
                .map(
                  (parent) => snapshot.data!.singleWhere(
                    (kid) => kid.id == parent.id,
                  ),
                )
                .toList(),
            onHelper: onGettingValuesOfSkillset,
          ),
          widgetWithError: (snapshot) {
            return const CustomText(
              text: 'Sorry, something went wrong',
              textColor: Colors.red,
            );
          },
        ),
      ),
      handleSubmit: () {
        return ProfileService.updateStudentTechStackOrSkillSets(
          context: context,
          techStack: user.student!.techStack,
          skillSets: skillSets,
        );
      },
    );

    // have no clue
    if (isUpdated == null) {
      return;
    }

    // if isUpdated is false, that means something went wrong
    if (isUpdated == false) {
      ApiUtil.handleOtherStatusCode(context: context);
      return;
    }

    // popup success
    popupNotification(
      context: context,
      type: NotificationType.success,
      content: 'Update skillsets successfully',
      textSubmit: 'Ok',
      submit: null,
    );
  }

  // update languages
  static Future<void> onUpdatedLanguages(
      {required BuildContext context}) async {
    // get languages
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserModel user = userProvider.user!;
    // copy list to avoid accessing the old list
    List<LanguageModel> languages = [...user.student!.languages];

    // get results from the languages
    void onGettingValuesOfLanguage(List<LanguageModel> languages) {
      languages = languages;
    }

    // check that info is updated
    final isUpdated = await _showEditedInfo(
      context: context,
      titleAttribute: 'Languages',
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: AddNewLanguage(
          onHelper: onGettingValuesOfLanguage,
          initialLanguages: languages,
        ),
      ),
      handleSubmit: () async {
        // call API
        final response = await LanguageService.couLanguage(
          token: userProvider.token!,
          studentId: user.student!.id,
          languages: languages,
        );

        // save result to user provider
        // to avoid that an id of language is null
        if (response.statusCode == StatusCode.ok.code) {
          userProvider.saveStudentWhenUpdatedProfileStudent(
            languages: LanguageModel.fromResponse(
              jsonDecode(response.body)['result'] as List<dynamic>,
            ),
          );
        }

        return response;
      },
    );

    // have no clue
    if (isUpdated == null) {
      return;
    }

    // if isUpdated is false, that means something went wrong
    if (isUpdated == false) {
      ApiUtil.handleOtherStatusCode(context: context);
      return;
    }

    // and then popup succes
    popupNotification(
      context: context,
      type: NotificationType.success,
      content: 'Update languages successfully',
      textSubmit: 'Ok',
      submit: null,
    );
  }

  // update educations
  static Future<void> onUpdatedEducations(
      {required BuildContext context}) async {
    // get educations
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserModel user = userProvider.user!;
    // copy list to avoid accessing the old list
    List<EducationModel> educations = [...user.student!.educations];

    // get results from the educations
    void onGettingValuesOfEducation(List<EducationModel> newEducations) {
      educations = newEducations;
    }

    // check that info is updated
    final isUpdated = await _showEditedInfo(
      context: context,
      titleAttribute: 'Educations',
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: AddNewEducation(
          onHelper: onGettingValuesOfEducation,
          initialEducations: educations,
        ),
      ),
      handleSubmit: () async {
        // call API
        final response = await EducationService.couEducation(
          token: userProvider.token!,
          studentId: user.student!.id,
          educations: educations,
        );

        // save result to user provider
        // to avoid that an id of language is null
        if (response.statusCode == StatusCode.ok.code) {
          userProvider.saveStudentWhenUpdatedProfileStudent(
            educations: EducationModel.fromResponse(
                jsonDecode(response.body)['result'] as List<dynamic>),
          );
        }

        return response;
      },
    );

    // have no clue
    if (isUpdated == null) {
      return;
    }

    // if isUpdated is false, that means something went wrong
    if (isUpdated == false) {
      ApiUtil.handleOtherStatusCode(context: context);
      return;
    }

    // and then popup succes
    popupNotification(
      context: context,
      type: NotificationType.success,
      content: 'Update languages successfully',
      textSubmit: 'Ok',
      submit: null,
    );
  }

  // update a resume
  static Future<void> onUpdatedResume({required BuildContext context}) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserModel user = userProvider.user!;
    FilePickerResult? _resumeFile;
    // pick a resume of student up
    Future<void> onPickedResume() async {
      // get the resume file
      _resumeFile = await ProfileStudentUtil.pickFile(context);
    }

    // check that info is updated
    final isUpdated = await _showEditedInfo(
      context: context,
      titleAttribute: 'Resume',
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * _percentWidthSize,
        height: MediaQuery.sizeOf(context).width * _percentWidthSize,
        child: DottedBorder(
          radius: const Radius.circular(8),
          color: Theme.of(context).colorScheme.onPrimary,
          child: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
      ),
      handleSubmit: () {
        return ProfileService.couResumeStudent(
          token: userProvider.token!,
          studentId: user.student!.id,
          filePath: _resumeFile!.files.first.path!,
        );
      },
    );

    // have no clue
    if (isUpdated == null) {
      return;
    }

    // if isUpdated is false, that means something went wrong
    if (isUpdated == false) {
      ApiUtil.handleOtherStatusCode(context: context);
      return;
    }

    // popup success
    popupNotification(
      context: context,
      type: NotificationType.success,
      content: 'Update resume successfully',
      textSubmit: 'Ok',
      submit: null,
    );
  }

  // update a transcript
  static Future<void> onUpdatedTranscript(
      {required BuildContext context}) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserModel user = userProvider.user!;
    FilePickerResult? _transcriptFile;
    // pick a transcript of student up
    Future<void> onPickedTransCript() async {
      // get the transcript file
      _transcriptFile = await ProfileStudentUtil.pickFile(context);
    }

    // check that info is updated
    final isUpdated = await _showEditedInfo(
      context: context,
      titleAttribute: 'Transcript',
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * _percentWidthSize,
        height: MediaQuery.sizeOf(context).width * _percentWidthSize,
        child: DottedBorder(
          radius: const Radius.circular(8),
          color: Theme.of(context).colorScheme.onPrimary,
          child: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.upload_file,
                  size: 90,
                ),
                CustomButton(
                  onPressed: onPickedTransCript,
                  text: "choose file to up",
                  buttonColor: Theme.of(context).colorScheme.secondary,
                )
              ],
            ),
          ),
        ),
      ),
      handleSubmit: () {
        return ProfileService.couTranscriptStudent(
          token: userProvider.token!,
          studentId: user.student!.id,
          filePath: _transcriptFile!.files.first.path!,
        );
      },
    );

    // have no clue
    if (isUpdated == null) {
      return;
    }

    // if isUpdated is false, that means something went wrong
    if (isUpdated == false) {
      ApiUtil.handleOtherStatusCode(context: context);
      return;
    }

    // popup success
    popupNotification(
      context: context,
      type: NotificationType.success,
      content: 'Update transcript successfully',
      textSubmit: 'Ok',
      submit: null,
    );
  }

  // custom expansion tile to show info
  static Future<bool?> _showEditedInfo({
    required BuildContext context,
    required String titleAttribute,
    required Widget content,
    required Future<http.Response> Function() handleSubmit,
  }) async =>
      showDialog(
        context: context,
        builder: (context) {
          // confirm edition
          Future<bool?> showConfirmedEdition() async => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // title of popup
                  title: Text(
                    NotificationType.warning.message,
                    style: TextStyle(
                      color: NotificationType.warning.color,
                    ),
                  ),
                  // content of popup
                  content: const CustomText(
                    text: 'Are you sure about that?',
                  ),
                  // buttons
                  actions: <Widget>[
                    // cancel button
                    TextButton(
                      child: const Text('No'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    // submit button
                    CustomButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      text: 'Yes',
                    ),
                  ],
                );
              });

          // return main dialog
          return AlertDialog(
            // title of popup
            title: Text(
              'Update $titleAttribute',
            ),
            // content of popup
            content: content,
            // buttons
            actions: <Widget>[
              // cancel button
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(null),
              ),
              // submit button
              CustomButton(
                onPressed: () async {
                  final isComfirmed = await showConfirmedEdition();
                  // check if the user is not confirmed
                  // that means nothing has edited
                  if (isComfirmed == false || isComfirmed == null) return;

                  // handle submit
                  showCircleProgress(context: context);
                  final response = await handleSubmit();
                  Navigator.pop(context);

                  // if response is not ok
                  if (response.statusCode != StatusCode.ok.code) {
                    Navigator.of(context).pop(false);
                    return;
                  }

                  // back to the main page
                  Navigator.of(context).pop(true);
                },
                text: 'Submit',
              ),
            ],
          );
        },
      );

  static Future<FilePickerResult?> pickFile(BuildContext context) async {
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
}
