import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:student_hub/components/add_new_experience.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_future_builder.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/experience_model.dart';
import 'package:student_hub/models/skill_set_model.dart';
import 'package:student_hub/services/skill_set_service.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class ProfileStudentStep2Screen extends StatefulWidget {
  const ProfileStudentStep2Screen({super.key});

  @override
  State<ProfileStudentStep2Screen> createState() =>
      _ProfileStudentStep2Screen();
}

class _ProfileStudentStep2Screen extends State<ProfileStudentStep2Screen> {
  late List<ExperienceModel> addNewProject = [];

  void onPressed() {}

  void onGettingValuesOfProject(List<ExperienceModel> project) {
    addNewProject = project;
  }

  // initialize skill set
  Future<List<SkillSetModel>> initializeSkillSet() async {
    final responseTechStack = await SkillSetService.getAllSkillSet();

    return SkillSetModel.fromResponse(responseTechStack);
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
            const Center(
              child: CustomText(
                text: 'Experience',
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
            CustomFutureBuilder<List<SkillSetModel>>(
              future: initializeSkillSet(),
              widgetWithData: (snapshot) => Flexible(
                child: AddNewExperience(
                  skills: snapshot.data!,
                  onHelper: onGettingValuesOfProject,
                ),
              ),
              widgetWithError: (snapshot) {
                return const CustomText(
                  text: 'Sorry, something went wrong',
                  textColor: Colors.red,
                );
              },
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
            NavigationUtil.toProfileStudentStep3Screen(context);
          },
          text: 'Next',
        ),
      ),
    );
  }
}
