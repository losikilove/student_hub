import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/models/enums/enum_like_project.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:intl/intl.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/models/user_model.dart';
import 'package:student_hub/services/project_service.dart';

class ProjectItem extends StatefulWidget {
  final ProjectModel project;
  const ProjectItem({Key? key, required this.project}) : super(key: key);
  @override
  State<ProjectItem> createState() => _ProjectItem();
}

class _ProjectItem extends State<ProjectItem> {
  Future<void> onLikedProject() async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    UserModel user = userProvider.user!;
    String? token = userProvider.token;

    setState(() {
      widget.project.isFavorite = !widget.project.isFavorite;
    });

    if (widget.project.isFavorite == true) {
      final response = await ProjectService.likeProject(
          studentId: user.student!.id,
          projectID: widget.project.id,
          likedProject: EnumLikeProject.like,
          token: token!);
      if (response.statusCode == 200) {
        await popupNotification(
          context: context,
          type: NotificationType.success,
          content: 'Saved successfully',
          textSubmit: 'Ok',
          submit: null,
        );
      }
    } else {
      final response = await ProjectService.likeProject(
          studentId: user.student!.id,
          projectID: widget.project.id,
          likedProject: EnumLikeProject.dislike,
          token: token!);
      if (response.statusCode == 200) {
        await popupNotification(
          context: context,
          type: NotificationType.success,
          content: 'Unsaved successfully',
          textSubmit: 'Ok',
          submit: null,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title: ${widget.project.title}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              CustomText(
                text: "Time created: ${DateFormat('dd-MM-yyyy').format(
                  DateTime.parse(widget.project.timeCreated),
                )}",
              ),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              CustomText(
                text:
                    "Time: ${widget.project.projectScopeFlag.name}, ${widget.project.numberofStudent} students needed",
              ),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
              const CustomText(text: "Student are looking for"),
              CustomBulletedList(
                  listItems: widget.project.description.split(',')),
              CustomText(
                  text: "Proposals: ${widget.project.proposal.toString()}"),
            ],
          ),
        ),
        IconButton(
          onPressed: onLikedProject,
          icon: Icon(
            widget.project.isFavorite
                ? Icons.favorite
                : Icons.favorite_border_outlined,
            color: const Color.fromARGB(255, 0, 78, 212),
            size: 30,
          ),
        ),
      ],
    );
  }
}
