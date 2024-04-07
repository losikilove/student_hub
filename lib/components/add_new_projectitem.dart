import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:intl/intl.dart';

class ProjectItem extends StatefulWidget {
  final ProjectModel project;
  ProjectItem({Key? key, required this.project}) : super(key: key);
  @override
  State<ProjectItem> createState() => _ProjectItem();
}

class _ProjectItem extends State<ProjectItem> {
  String month = '1 - 3';
  @override
  Widget build(BuildContext context) {
    if (widget.project.projectScopeFlag == 1){
      month = '3-6';
    }
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text("Title: "+ 
                widget.project.title,
                style: const TextStyle(
                  fontSize: 22,fontWeight: FontWeight.w500),
              ),
               const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              CustomText(text:"Time created: " + DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.project.timeCreated)) ),
               const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              CustomText(text: "Time: " + month + " months, ${widget.project.numberofStudent} students needed"),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
              const CustomText(text: "Student are looking for"),
              CustomBulletedList(listItems: widget.project.description.split(';')),
              CustomText(text: "Proposals: " +   widget.project.proposal.toString()),
            ],
          ),
        ),
        // IconButton(
        //     onPressed: () {
        //       setState(() {
        //         widget.project.setLike = !widget.project.like;
        //       });
        //     },
        //     icon: Icon(
        //       widget.project.like
        //           ? Icons.favorite
        //           : Icons.favorite_border_outlined,
        //       color: Color.fromARGB(255, 0, 78, 212),
        //       size: 30,
        //     )),
      ],
    );
  }
}
