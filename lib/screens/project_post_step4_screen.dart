import 'package:flutter/material.dart';
import 'package:student_hub/components/circle_progress.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/models/project_company_model.dart';
import 'package:student_hub/screens/main_screen.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';

class ProjectPostStep4Screen extends StatefulWidget {
  final ProjectCompanyModel projectCompanyModel;
  const ProjectPostStep4Screen({super.key, required this.projectCompanyModel});

  @override
  State<ProjectPostStep4Screen> createState() => _ProjectPostStep4ScreenState();
}

class _ProjectPostStep4ScreenState extends State<ProjectPostStep4Screen> {
  Future<void> createProjectCompany() async {
    // loading in progress
    showCircleProgress(context: context);
    final response = await ProjectService.createProject(
        project: widget.projectCompanyModel, context: context);
    if (response.statusCode == StatusCode.created.code) {
      NavigationUtil.toMainScreen(context, MainScreenIndex.dashboard);
      return;
    }
    if (response.statusCode == StatusCode.error.code) {
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: ApiUtil.getBody(response)['errorDetails'],
        textSubmit: 'Ok',
        submit: null,
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: () {},
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "4/4-Project details",
              isBold: true,
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            CustomText(text: widget.projectCompanyModel.title),
            const CustomDivider(
              isFullWidth: true,
            ),
            const CustomText(text: "Student are looking for"),
            CustomBulletedList(
              listItems: [widget.projectCompanyModel.description],
            ),
            const CustomDivider(
              isFullWidth: true,
            ),
            _projectRequirement(Icons.alarm, 'Project scope',
                widget.projectCompanyModel.projectScopeFlag.name),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            _projectRequirement(
                Icons.people_outline,
                'Required students',
                widget.projectCompanyModel.numberofStudent.toString() +
                    ' students'),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        elevation: 0,
        color: Theme.of(context).colorScheme.background,
        child: Container(
          alignment: Alignment.topRight,
          child: CustomButton(
            size: CustomButtonSize.small,
            onPressed: createProjectCompany,
            text: 'Save',
          ),
        ),
      ),
    );
  }

  Widget _projectRequirement(
      IconData icon, String title, String detailRequirement) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 35,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: title),
              CustomBulletedList(
                listItems: [detailRequirement],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
