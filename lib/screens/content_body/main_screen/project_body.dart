import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/listview_project_items.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_future_builder.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/screens/content_body/main_screen/project/project_search.dart';
import 'package:student_hub/screens/content_body/main_screen/project/project_save.dart';
enum ProjectBodyType {
  main(nameRoute: ''),
  search(nameRoute: 'search'),
  saved(nameRoute: 'saved');

  final String nameRoute;

  const ProjectBodyType({required this.nameRoute});
}

class ProjectBody extends StatefulWidget {
  const ProjectBody({super.key});

  @override
  State<ProjectBody> createState() => _ProjectBody();
}

class _ProjectBody extends State<ProjectBody> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // when switch to main screen with chosen project, show the dialog welcome
      showDialogWelcome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        // if search part, switch to it
        if (settings.name == ProjectBodyType.search.nameRoute) {
          final searchArgs = settings.arguments as List<dynamic>;
          return MaterialPageRoute(
            builder: (_) => ProjectBodySearchPart(
              search: searchArgs[0] as String,
              projects: searchArgs[1] as List<ProjectModel>,
            ),
          );
        }
        // have no one, switch to main part
        return MaterialPageRoute(builder: (_) => const ProjectBodyMainPart());
      },
    );
  }

  Future showDialogWelcome() => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Welcome',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          content: const CustomText(
            text:
                'Welcome to StudentHub, a marketplace to connect Student to Real-world projects',
            isCenter: true,
          ),
          actions: [
            CustomButton(
              onPressed: () => NavigationUtil.turnBack(context),
              text: 'Next',
              size: CustomButtonSize.large,
            ),
          ],
        );
      });
}

// Main part of this body
class ProjectBodyMainPart extends StatefulWidget {
  const ProjectBodyMainPart({super.key});

  @override
  State<ProjectBodyMainPart> createState() => _ProjectBodyMainPartState();
}

class _ProjectBodyMainPartState extends State<ProjectBodyMainPart> {
  String searchItem = "Search for project";

  final List<String> suggestion = ["reactjs", "flutter", "education app"];

  void onPressed() {}
  List<ProjectModel> _projects = [];
  // List<ProjectModel> _FavoriteProjects = [];
  Future<List<ProjectModel>> initializeProject() async {
    
      UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    String? token = userProvider.token; 
    final response = await ProjectService.viewProject(token:token!);
    return ProjectModel.fromResponse(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed:(){
          NavigationUtil.toSwitchAccountScreen(context);
        },
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showBottomSheet(context);
                    },
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    label: CustomText(
                      text: searchItem,
                    ),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        alignment: Alignment.centerLeft),
                  ),
                ),
                const SizedBox(
                  width: 32,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(0.2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2DAAD4), // Màu nền của nút
                    ),
                    child: IconButton(
                        onPressed: () {
                          // getSavedProject();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProjectBodySavedPart()
                              )
                            );
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            const CustomDivider(),
            //ListViewProjectItems(projects: _projects),
             CustomFutureBuilder<List<ProjectModel>>(
                    future: initializeProject(),
                    widgetWithData: (snapshot) =>
                        ListViewProjectItems(projects: snapshot.data!),
                    widgetWithError: (snapshot) {
                      return const CustomText(
                        text: 'Sorry, something went wrong',
                        textColor: Colors.red,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // Đặt chiều cao ban đầu tại đây
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 10.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search for project',
                    ),
                    onSubmitted: (s) {
                      // switch to content search
                      Navigator.pushNamed(
                        context,
                        ProjectBodyType.search.nameRoute,
                        arguments: [s, _projects],
                      );
                    },
                  ),
                  ListTile(
                    title: const CustomText(text: 'ReactJS'),
                    onTap: () {
                      setState(() {
                        searchItem = "React JS";
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const CustomText(text: 'Education App'),
                    onTap: () {
                      setState(() {
                        searchItem = "Education App";
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const CustomText(
                      text: "Flutter",
                    ),
                    onTap: () {
                      setState(() {
                        searchItem = "Flutter";
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}