import 'package:flutter/material.dart';
import 'package:student_hub/components/add_new_experience.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/experience_model.dart';
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AddNewExperience(
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
