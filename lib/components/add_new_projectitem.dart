import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';

class ProjectItem extends StatefulWidget {
  final ProjectModel project;
  ProjectItem({Key? key, required this.project}) : super(key: key);
  @override
  State<ProjectItem> createState() => _ProjectItem();
}

class _ProjectItem extends State<ProjectItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: widget.project.timeCreating),
              Text(
                widget.project.title,
                style: const TextStyle(
                    color: Color.fromARGB(255, 3, 230, 11), fontSize: 16),
              ),
              CustomText(text: "Time: 6 months, 4 students needed"),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
              const CustomText(text: "Student are looking for"),
              CustomBulletedList(listItems: widget.project.wishes),
              CustomText(
                  text: "Proposals: " +
                      widget.project.numberProposals.toString()),
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                widget.project.setLike = !widget.project.like;
              });
            },
            icon: Icon(
              widget.project.like
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              color: Color.fromARGB(255, 0, 78, 212),
              size: 30,
            )),
      ],
    );
  }
}
