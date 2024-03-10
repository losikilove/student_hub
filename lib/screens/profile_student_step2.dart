
import 'package:flutter/material.dart';
import 'package:student_hub/components/add_new_project.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
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

  late List<ProjectModel> addNewProject = [ ProjectModel('Intelligent Taxi Dispatching System', 
    'It is developer of a super-app for ride-halling, food delivery'
    ' and digital payments services on mobile device that operates in Singapor, Malaysia,...'
    ,'9/2020', '12/2020', '4 months'),
    ProjectModel('Intelligent Taxi Dispatching System', 
    'It is developer of a super-app for ride-halling, food delivery'
    ' and digital payments services on mobile device that operates in Singapor, Malaysia,...'
    ,'9/2020', '12/2020', '4 months'),];

  void onPressed(){

  }

  void onGettingValuesOfProject(List<ProjectModel> project) {
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
                    // add new project
                    AddNewProject(
                      onHelper: onGettingValuesOfProject,
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