import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_option.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/mutliselect_chip.dart';
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
  late String optionValue;
  final List<String> skillsetOptions = [
    'iOS dev',
    'C/C++',
    'Java',
    'ReactJS',
    'NodeJS',
  ];
  late List<String> selectedSkillsets;

  void onPressed() {}

  void onGettingValueOfTechstack(String? option) {
    optionValue = option!;
  }

  void onGettingValuesOfSkillset(List<String> selectedItems) {
    selectedSkillsets = selectedItems;
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
            // techstack options
            const CustomText(text: 'Techstack'),
            CustomOption<String>(
              options: techstackOptions,
              onHelper: onGettingValueOfTechstack,
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // skillset selections
            const CustomText(text: 'Skillset'),
            MultiSelectChip<String>(
                listOf: skillsetOptions, onHelper: onGettingValuesOfSkillset)
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
