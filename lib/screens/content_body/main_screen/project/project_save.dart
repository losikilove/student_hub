import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_future_builder.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/models/user_model.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:intl/intl.dart';
import 'package:student_hub/models/enums/enum_like_project.dart';

class ProjectBodySavedPart extends StatefulWidget {
  final BuildContext parentContext;

  const ProjectBodySavedPart({
    super.key,
    required this.parentContext,
  });
  @override
  State<ProjectBodySavedPart> createState() => _ProjectBodySavedPart();
}

class _ProjectBodySavedPart extends State<ProjectBodySavedPart> {
  void onPressed() {}

  // switch to switch account screen
  void onSwitchedToSwitchAccountScreen() {
    NavigationUtil.toSwitchAccountScreen(context);
  }

  Future<List<ProjectModel>> initializeFavoriteProject() async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    String? token = userProvider.token;
    UserModel user = userProvider.user!;
    final response = await ProjectService.viewProjectFavorite(
        studentId: user.student!.id, token: token!);
    return ProjectModel.fromFavoriteResponse(response);
  }

  Future<void> unSaveProject(int projectID, EnumLikeProject likeProject) async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    UserModel user = userProvider.user!;
    String? token = userProvider.token;
    final response = await ProjectService.likeProject(
        studentId: user.student!.id,
        projectID: projectID,
        likedProject: likeProject,
        token: token!);
    final body = ApiUtil.getBody(response);
    if (response.statusCode == StatusCode.ok.code) {
      await popupNotification(
        context: context,
        type: NotificationType.success,
        content: 'Unsaved project',
        textSubmit: 'Ok',
        submit: null,
      );
    } else {
      final errorDetails = body['errorDetails'];
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: errorDetails.toString(),
        textSubmit: 'Ok',
        submit: null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Saved projects',
        isBack: true,
        onPressed: onSwitchedToSwitchAccountScreen,
        currentContext: context,
      ),
      body: InitialBody(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFutureBuilder<List<ProjectModel>>(
            future: initializeFavoriteProject(),
            widgetWithData: (snapshot) {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final project = snapshot.data?[index];

                    return saveProjectItem(
                        project!, project.projectScopeFlag.name);
                  },
                ),
              );
            },
            widgetWithError: (snapshot) {
              return CustomText(
                text: snapshot.toString(),
                textColor: Colors.red,
              );
            },
          ),
        ],
      )),
    );
  }

  Row saveProjectItem(ProjectModel project, String month) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => NavigationUtil.toBrowseProjectDetailScreen(
              context,
              project.id,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Title: " + project.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: SpacingUtil.smallHeight,
                ),
                CustomText(
                    text: "Time created: " +
                        DateFormat('dd-MM-yyyy')
                            .format(DateTime.parse(project.timeCreated))),
                const SizedBox(
                  height: SpacingUtil.smallHeight,
                ),
                CustomText(
                    text: "Time: " +
                        month +
                        ", ${project.numberofStudent} students needed"),
                const SizedBox(
                  height: SpacingUtil.mediumHeight,
                ),
                const CustomText(text: "Student are looking for"),
                CustomBulletedList(listItems: project.description.split(',')),
                CustomText(text: "Proposals: " + project.proposal.toString()),
                const SizedBox(
                  height: SpacingUtil.smallHeight,
                ),
                const CustomDivider(),
                const SizedBox(
                  height: SpacingUtil.smallHeight,
                ),
              ],
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                unSaveProject(project.id, EnumLikeProject.dislike);
              });
            },
            icon: const Icon(
              Icons.favorite,
              color: Color.fromARGB(255, 0, 78, 212),
              size: 30,
            )),
      ],
    );
  }
}
