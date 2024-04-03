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
import 'package:student_hub/models/skill_set_model.dart';
import 'package:student_hub/models/tech_stack_model.dart';
import 'package:student_hub/services/skill_set_service.dart';
import 'package:student_hub/services/tech_stack_service.dart';
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

    return TechStackModel.fromResponse(responseTechStack);
  }

  // initialize skill set
  Future<List<SkillSetModel>> initializeSkillSet() async {
    final responseTechStack = await SkillSetService.getAllSkillSet();

    return SkillSetModel.fromResponse(responseTechStack);
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
                    FutureBuilder<List<TechStackModel>>(
                      future: initializeTechStack(),
                      builder: (context, snapshot) {
                        Widget child;

                        if (snapshot.hasData) {
                          child = CustomOption<TechStackModel>(
                            options: snapshot.data!,
                            onHelper: onGettingValueOfTechstack,
                          );
                        } else {
                          child = const CircularProgressIndicator();
                        }

                        return child;
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
                    FutureBuilder<List<SkillSetModel>>(
                      future: initializeSkillSet(),
                      builder: (context, snapshot) {
                        Widget child;

                        if (snapshot.hasData) {
                          child = MultiSelectChip<SkillSetModel>(
                            listOf: snapshot.data!,
                            onHelper: onGettingValuesOfSkillset,
                          );
                        } else {
                          child = const CircularProgressIndicator();
                        }

                        return child;
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
          onPressed: () {
            NavigationUtil.toProfileStudentStep2Screen(context);
          },
          text: 'Next',
        ),
      ),
    );
  }
}
