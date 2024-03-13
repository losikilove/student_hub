import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:student_hub/components/custom_divider.dart';

class ProjectItem extends StatelessWidget {
  final String timeCreated;
  final String projectName;
  final String timeAndRequiredNumberStudent;
  final List<String> studentBenefit;
  final String proposal;
  void onPress(){

  }
  const ProjectItem({
    required this.timeCreated,
    required this.projectName,
    required this.timeAndRequiredNumberStudent,
    required this.studentBenefit,
    required this.proposal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: timeCreated),
              Text(
                projectName,
                style: const TextStyle(
                    color: Color.fromARGB(255, 3, 230, 11),
                    fontSize: 16),
              ),
              CustomText(text: timeAndRequiredNumberStudent),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
              const CustomText(text: "Student are looking for"),
              CustomBulletedList(listItems: studentBenefit),
              CustomText(text: "Proposals: $proposal"),
              const CustomDivider(),
            ],
          ),
        ),
        IconButton(
            onPressed: onPress,
            icon: const Icon(
              Icons.favorite_border_outlined,
              color: Color.fromARGB(255, 0, 78, 212),
              size: 30,
            )),
      ],
    );
  }
}
