import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_future_builder.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class BrowseProjectDetailScreen extends StatefulWidget {
  // TODO: require a project-model attribute
  final int projectId;
  const BrowseProjectDetailScreen({super.key, required this.projectId});

  @override
  State<BrowseProjectDetailScreen> createState() =>
      _BrowseProjectDetailScreenState();
}

class _BrowseProjectDetailScreenState extends State<BrowseProjectDetailScreen> {
  void onPressed() {}
  void onAppliedNow() {
    NavigationUtil.toSubmitProposal(
      context,
      widget.projectId,
    );
  }

  // save this project
  void onSaved() {}
  Future<ProjectModel> initializeDetailProject() async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    String? token = userProvider.token;
    final response = await ProjectService.viewProjectDetail(
        id: widget.projectId, token: token!);
    return ProjectModel.fromDetailResponse(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: AppLocalizations.of(context)!.detailProject,
        isBack: true,
        onPressed: onPressed,
        currentContext: context,
      ),
      body: InitialBody(
        child: SingleChildScrollView(
          child: CustomFutureBuilder(
            future: initializeDetailProject(),
            widgetWithData: (snapshot) {
              return projectDetail(snapshot.data!);
            },
            widgetWithError: (snapshot) {
              return CustomText(
                text: AppLocalizations.of(context)!.sorySomethingWentWrong,
                textColor: Colors.red,
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        elevation: 0,
        color: Theme.of(context).colorScheme.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              size: CustomButtonSize.small,
              onPressed: onAppliedNow,
              text: AppLocalizations.of(context)!.applyNow,
              buttonColor: Theme.of(context).colorScheme.secondary,
            ),
            CustomButton(
              size: CustomButtonSize.small,
              onPressed: onSaved,
              text: AppLocalizations.of(context)!.save,
            ),
          ],
        ),
      ),
    );
  }

  Column projectDetail(ProjectModel project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "${AppLocalizations.of(context)!.detail}: ${project.title}",
          isBold: true,
          size: 23,
        ),
        const CustomDivider(),
        // desirements of student text
        CustomText(
          size: 18,
          text: AppLocalizations.of(context)!.studentAreLookingFor,
        ),
        CustomBulletedList(
          textSize: 18,
          listItems: project.description.split(','),
        ),
        const CustomDivider(),
        // scope of project
        _projectRequirement(
            Icons.alarm, AppLocalizations.of(context)!.projectScope, project.projectScopeFlag.name),
        const SizedBox(
          height: SpacingUtil.smallHeight,
        ),
        // Required students
        _projectRequirement(Icons.people_outline, AppLocalizations.of(context)!.requiredStudents,
            '${project.numberofStudent} ${AppLocalizations.of(context)!.students}'),
      ],
    );
  }

  Widget _projectRequirement(
      IconData icon, String title, String detailRequirement) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 42,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                size: 20,
              ),
              CustomBulletedList(
                textSize: 18,
                listItems: detailRequirement.split('\n'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
