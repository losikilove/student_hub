import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/add_new_experience.dart';
import 'package:student_hub/components/circle_progress.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_future_builder.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/models/experience_model.dart';
import 'package:student_hub/models/skill_set_model.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/services/experience_service.dart';
import 'package:student_hub/services/skill_set_service.dart';
import 'package:student_hub/utils/api_util.dart';
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

    return SkillSetModel.fromResponse(
      ApiUtil.getBody(responseTechStack)['result'] as List<dynamic>,
    );
  }

  // go to the next screen
  Future<void> onGoneToNextScreen() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    // get student id
    final token = userProvider.token;
    final studentId = userProvider.user!.student!.id;

    // loading in progress
    showCircleProgress(context: context);

    // call api to create experiences for student
    final response = await ExperienceService.couExperience(
        token: token!, studentId: studentId, experiences: addNewProject);

    // handle response
    // when created experiences for student
    if (response.statusCode == StatusCode.ok.code) {
      // experiences reponse
      List<ExperienceModel> experiencesReponse = ExperienceModel.fromResponse(
        ApiUtil.getBody(response)['result'] as List<dynamic>,
      );

      // save the new experiences into user provider
      userProvider.saveStudentWhenUpdatedProfileStudent(
        experiences: experiencesReponse,
      );

      // stop loading progress
      Navigator.of(context).pop();

      // go to next screen
      NavigationUtil.toProfileStudentStep3Screen(context);
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
          onPressed: onGoneToNextScreen,
          text: 'Next',
        ),
      ),
    );
  }
}
