import 'package:flutter/material.dart';
import 'package:student_hub/components/add_new_projectitem.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/models/user_model.dart';
class ListViewProjectItems extends StatelessWidget {
  final List<ProjectModel> projects;
  const ListViewProjectItems({super.key, required this.projects});
  
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    String? token = userProvider.token; 
    token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTQsImZ1bGxuYW1lIjoiTHV1IE1pbmggTmhhdCIsImVtYWlsIjoibmd1b2lkZXA0MzNAZ21haWwuY29tIiwicm9sZXMiOlswXSwiaWF0IjoxNzEyNDU5NTQwLCJleHAiOjE3MTM2NjkxNDB9.UOxvja9fw5ynKqKk7IRtP0WMkdpSoqA5Wt1ulF8Lua0";
    return Expanded(
      child: ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                GestureDetector(
                  onTap: () {
                    if (token != null) {
                      NavigationUtil.toBrowseProjectDetailScreen(context, project.id, token);
                    }
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
