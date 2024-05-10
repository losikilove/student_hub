import 'package:flutter/material.dart';
import 'package:student_hub/components/add_new_projectitem.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';

class ListViewProjectItems extends StatelessWidget {
  final List<ProjectModel> projects;
  const ListViewProjectItems({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return projects.isEmpty ? const Center(child: CustomText(text: "Not any found project",isBold: true,) ): Expanded(
      child: ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    NavigationUtil.toBrowseProjectDetailScreen(
                        context, project.id);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProjectItem(
                        project: project,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: SpacingUtil.smallHeight,
                ),
                const CustomDivider(
                  isFullWidth: true,
                ),
                const SizedBox(
                  height: SpacingUtil.mediumHeight,
                ),
              ],
            );
          }),
    );
  }
}
