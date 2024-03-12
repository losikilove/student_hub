import 'package:flutter/material.dart';
import 'package:student_hub/components/add_new_education.dart';
import 'package:student_hub/components/add_new_language.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_option.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/mutliselect_chip.dart';
import 'package:student_hub/models/education_model.dart';
import 'package:student_hub/models/language_model.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class ProfileStudentStep1Screen extends StatefulWidget {
  const ProfileStudentStep1Screen({super.key});

  @override
  State<ProfileStudentStep1Screen> createState() =>
      _ProfileStudentStep1ScreenState();
}

class _ProfileStudentStep1ScreenState extends State<ProfileStudentStep1Screen> {
  final List<String> techstackOptions = [
    'Backend dev',
    'Frontend dev',
    'Fullstack dev',
    'Backend dev',
    'Frontend dev',
    'Fullstack dev',
    'Backend dev',
    'Frontend dev',
    'Fullstack dev',
    'Backend dev',
    'Frontend dev',
    'Fullstack dev',
    'Backend dev',
    'Frontend dev',
    'Fullstack dev',
    'Backend dev',
    'Frontend dev',
    'Fullstack dev',
    'Backend dev',
    'Frontend dev',
    'Fullstack dev'
  ];
  late String optionValueTechstack;
  final List<String> skillsetOptions = [
    'iOS dev',
    'C/C++',
    'Java',
    'ReactJS',
    'NodeJS',
  ];
  late List<String> selectedSkillsets;
  late List<LanguageModel> addedNewLanguages;
  late List<EducationModel> addedNewEducations;

  void onPressed() {}

  // get result from the techstack
  void onGettingValueOfTechstack(String? option) {
    optionValueTechstack = option!;
  }

  // get results from the skillset
  void onGettingValuesOfSkillset(List<String> selectedItems) {
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
                    CustomOption<String>(
                      options: techstackOptions,
                      onHelper: onGettingValueOfTechstack,
                    ),
                    const SizedBox(
                      height: SpacingUtil.mediumHeight,
                    ),
                    // skillset selections
                    const CustomText(
                      text: 'Skillset',
                      isBold: true,
                    ),
                    MultiSelectChip<String>(
                      listOf: skillsetOptions,
                      onHelper: onGettingValuesOfSkillset,
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
        color: ColorUtil.lightPrimary,
        child: CustomButton(
          size: CustomButtonSize.small,
          onPressed: onPressed,
          text: 'Next',
        ),
      ),
    );
  }
}
