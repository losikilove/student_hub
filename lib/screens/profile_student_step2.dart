
import 'package:flutter/material.dart';
import 'package:student_hub/components/add_new_project.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/mutliselect_chip.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class ProfileStudentStep2Screen extends StatefulWidget{
  const ProfileStudentStep2Screen({super.key});

  @override
  State<ProfileStudentStep2Screen> createState() =>
    _ProfileStudentStep2Screen();
}

class _ProfileStudentStep2Screen extends 
  State<ProfileStudentStep2Screen>{
  
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


  late  List<String> selectedSkillsets;
  late List<ProjectModel> addNewProject;

  void onPressed(){

  }
  void onGettingValuesOfSkillset(List<String> selectedItems) {
    selectedSkillsets = selectedItems;
  }
  void onGettingValuesOfLanguage(List<ProjectModel> project) {
    addNewProject = project;
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CustomText(
                text: 'Experience',
              )
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
                    AddNewProject(
                      onHelper: onGettingValuesOfLanguage,
                    ),
                    const SizedBox(
                      height: SpacingUtil.mediumHeight,
                    ),

          ]),
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