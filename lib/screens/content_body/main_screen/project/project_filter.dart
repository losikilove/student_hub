import 'package:flutter/material.dart';

import 'package:student_hub/components/custom_appbar.dart';

import 'package:student_hub/components/custom_text.dart';

import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/listview_project_items.dart';

import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/components/custom_future_builder.dart';
class ProjectBodyFilterPart extends StatefulWidget {
  final BuildContext parentContext;
  final String search;
  String? projectScopeFlag;
  String? proposalsLessThan;
  String? numberOfStudents;
  ProjectBodyFilterPart(
      {super.key,
      required this.parentContext,
      required this.search,
      this.projectScopeFlag,
      this.numberOfStudents,
      this.proposalsLessThan
    });

  @override
  State<ProjectBodyFilterPart> createState() => _ProjectBodyFilterPartState();
}

class _ProjectBodyFilterPartState extends State<ProjectBodyFilterPart> {
  late final TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    // initialize the search controller
    _searchController = TextEditingController(text: widget.search);
  }

  Future<List<ProjectModel>> initializeProject() async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    String? token = userProvider.token;
    final response = await ProjectService.filterProject(search: widget.search,projectScopeFlag: widget.projectScopeFlag,
            numberOfStudents: widget.numberOfStudents,proposalsLessThan: widget.proposalsLessThan,token: token!);
    return ProjectModel.fromResponse(response);
  }

  @override
  void dispose() {
    // dispose the search controller
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Filter project',
        isBack: true,
        onPressed: (){},
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // filter list of projects
            CustomFutureBuilder<List<ProjectModel>>(
              future: initializeProject(),
              widgetWithData: (snapshot) =>
                  ListViewProjectItems(projects: snapshot.data!),
              widgetWithError: (snapshot) {
                return CustomText(
                  text: snapshot.toString(),
                  textColor: Colors.red,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
