import 'package:flutter/material.dart';
import 'package:student_hub/components/add_new_education.dart';
import 'package:student_hub/components/add_new_language.dart';
import 'package:student_hub/components/circle_progress.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_future_builder.dart';
import 'package:student_hub/components/custom_option.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/mutliselect_chip.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/models/education_model.dart';
import 'package:student_hub/models/language_model.dart';
import 'package:student_hub/models/skill_set_model.dart';
import 'package:student_hub/models/tech_stack_model.dart';
import 'package:student_hub/services/profile_service.dart';
import 'package:student_hub/services/skill_set_service.dart';
import 'package:student_hub/services/tech_stack_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class ProfileStudentStep1Screen extends StatefulWidget {
  const ProfileStudentStep1Screen({super.key});

  @override
  State<ProfileStudentStep1Screen> createState() =>
      _ProfileStudentStep1ScreenState();
}

class _ProfileStudentStep1ScreenState extends State<ProfileStudentStep1Screen> {
  late TechStackModel optionValueTechstack;
  late List<SkillSetModel> selectedSkillsets;
  late List<LanguageModel> addedNewLanguages;
  late List<EducationModel> addedNewEducations;

  // initialize tech stack
  Future<List<TechStackModel>> initializeTechStack() async {
    final responseTechStack = await TechStackService.getAllTeckStack();

    return TechStackModel.fromResponse(
        ApiUtil.getBody(responseTechStack)['result'] as List<dynamic>);
  }

  // initialize skill set
  Future<List<SkillSetModel>> initializeSkillSet() async {
    final responseSkillSets = await SkillSetService.getAllSkillSet();

    return SkillSetModel.fromResponse(
        ApiUtil.getBody(responseSkillSets)['result'] as List<dynamic>);
  }

  void onPressed() {}

  // get result from the techstack
  void onGettingValueOfTechstack(TechStackModel? option) {
    optionValueTechstack = option!;
  }

  // get results from the skillset
  void onGettingValuesOfSkillset(List<SkillSetModel> selectedItems) {
    selectedSkillsets = selectedItems;
  }

  // get results from the languages
  void onGettingValuesOfLanguage(List<LanguageModel> languages) {
    addedNewLanguages = languages;
  }

  // get results from the educations
  void onGettingValuesOfEducation(List<EducationModel> educations) {
    addedNewEducations = educations;
  }

  // allez-y
  Future<void> onSubmittedThenContinue() async {
    // loading in progress
    showCircleProgress(context: context);

    // reponse of create student profile
    final response = await ProfileService.createStudentProfileStep1(
      techStack: optionValueTechstack,
      skills: selectedSkillsets,
      languages: addedNewLanguages,
      educations: addedNewEducations,
      context: context,
    );

    // handle response
    // when techstack-skillset for student is created
    if (response.statusCode == StatusCode.created.code) {
      // stop the loading
      Navigator.of(context).pop();

      // continue to create experiences of student
      NavigationUtil.toProfileStudentStep2Screen(context);
      return;
    }

    // stop the loading
    Navigator.of(context).pop();

    // when has a problem
    if (response.statusCode == StatusCode.error.code ||
        response.statusCode == StatusCode.unprocessableEntity.code) {
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: ApiUtil.getBody(response)['errorDetails'],
        textSubmit: 'Ok',
        submit: null,
      );

      return;
    }

    // when expired token
    if (response.statusCode == StatusCode.unauthorized.code) {
      // switch to sign in screen
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
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // greeting text
            const Center(
              child: CustomText(
                text: 'Welcome to Student Hub',
                isBold: true,
              ),
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // other text
            const CustomText(
              text:
                  'Tell us about yourself and you will be on your way connect with real-world project',
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // techstack options
                    const CustomText(
                      text: 'Techstack',
                      isBold: true,
                    ),
                    CustomFutureBuilder<List<TechStackModel>>(
                      future: initializeTechStack(),
                      widgetWithData: (snapshot) =>
                          CustomOption<TechStackModel>(
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
                    const SizedBox(
                      height: SpacingUtil.mediumHeight,
                    ),
                    // skillset selections
                    const CustomText(
                      text: 'Skillset',
                      isBold: true,
                    ),
                    CustomFutureBuilder<List<SkillSetModel>>(
                      future: initializeSkillSet(),
                      widgetWithData: (snapshot) =>
                          MultiSelectChip<SkillSetModel>(
                        listOf: snapshot.data!,
                        onHelper: onGettingValuesOfSkillset,
                      ),
                      widgetWithError: (snapshot) {
                        return const CustomText(
                          text: 'Sorry, something went wrong',
                          textColor: Colors.red,
                        );
                      },
                    ),
                    const SizedBox(
                      height: SpacingUtil.mediumHeight,
                    ),
                    // language adding new one
                    AddNewLanguage(
                      onHelper: onGettingValuesOfLanguage,
                    ),
                    const SizedBox(
                      height: SpacingUtil.mediumHeight,
                    ),
                    // education adding new one
                    AddNewEducation(
                      onHelper: onGettingValuesOfEducation,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        elevation: 0,
        color: Theme.of(context).colorScheme.background,
        child: CustomButton(
          size: CustomButtonSize.small,
          onPressed: onSubmittedThenContinue,
          text: 'Next',
        ),
      ),
    );
  }
}
