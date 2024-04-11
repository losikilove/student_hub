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
import 'package:student_hub/models/skill_set_model.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/services/experience_service.dart';
import 'package:student_hub/services/skill_set_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import '../models/experience_model.dart';

class StudentUpdateExperienceScreen extends StatefulWidget {
  const StudentUpdateExperienceScreen({super.key});

  @override
  State<StudentUpdateExperienceScreen> createState() =>
      _StudentUpdateExperienceScreenState();
}

class _StudentUpdateExperienceScreenState
    extends State<StudentUpdateExperienceScreen> {
  late List<ExperienceModel> experiences = [];

  void onPressed() {}

  void onGettingValuesOfExperience(List<ExperienceModel> project) {
    experiences = project;
  }

  // initialize skill set
  Future<List<SkillSetModel>> initializeSkillSet() async {
    final responseTechStack = await SkillSetService.getAllSkillSet();

    return SkillSetModel.fromResponse(
      ApiUtil.getBody(responseTechStack)['result'] as List<dynamic>,
    );
  }

  // go to the next screen
  Future<void> onUpdatedExperience() async {
    final isConfirmed = await showConfirmedEdition();

    // do not want to update experiences
    if (isConfirmed == false || isConfirmed == null) {
      return;
    }

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    // get student id
    final token = userProvider.token;
    final studentId = userProvider.user!.student!.id;

    // loading in progress
    showCircleProgress(context: context);

    // call api to create experiences for student
    final response = await ExperienceService.couExperience(
        token: token!, studentId: studentId, experiences: experiences);

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
      await popupNotification(
          context: context,
          type: NotificationType.success,
          content: 'Update experiences successfully',
          textSubmit: 'Ok',
          submit: null);
      NavigationUtil.turnBack(context);
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

  // cancel the update
  void onCanceled() {
    NavigationUtil.turnBack(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Update Experiences',
        isBack: true,
        onPressed: () {},
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFutureBuilder<List<SkillSetModel>>(
              future: initializeSkillSet(),
              widgetWithData: (snapshot) => Flexible(
                child: AddNewExperience(
                  initialExperieces: [
                    ...Provider.of<UserProvider>(context)
                        .user!
                        .student!
                        .experiences
                  ],
                  skills: snapshot.data!,
                  onHelper: onGettingValuesOfExperience,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              size: CustomButtonSize.small,
              onPressed: onUpdatedExperience,
              text: 'Edit',
            ),
            CustomButton(
              size: CustomButtonSize.small,
              onPressed: onCanceled,
              text: 'Cancel',
            ),
          ],
        ),
      ),
    );
  }

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
}
