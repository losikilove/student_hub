import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/listview_project_items.dart';
import 'package:student_hub/models/enums/enum_projectlenght.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/models/user_model.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:intl/intl.dart';
import 'package:student_hub/components/custom_future_builder.dart';
import 'package:student_hub/utils/api_util.dart';

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
  List<ProjectModel> _FavoriteProjects = [];
  Future<List<ProjectModel>> initializeProject() async {
    
      UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    String? token = userProvider.token; 
    final response = await ProjectService.viewProject(token:token!);
    return ProjectModel.fromResponse(response);
  }

  void getSavedProject() async{
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    UserModel user = userProvider.user!;
    String? token = userProvider.token; 
    final response = await ProjectService.viewProjectFavorite(id: user.userId, token: token!);
    final body = ApiUtil.getBody(response);
    if (response.statusCode == 200){
      // //
      setState(() {
        _FavoriteProjects = ProjectModel.fromFavoriteResponse(response);
      });
     
    
    }else if (response.statusCode == StatusCode.notFound.code) {
      // the user is not found
      final errorDetails = body['errorDetails'];

      // show popup error message
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: errorDetails.toString(),
        textSubmit: 'Ok',
        submit: null,
      );
    } else if (response.statusCode == StatusCode.unprocessableEntity.code) {
      // pop the loading progress
      final errorDetails = body['errorDetails'];

      popupNotification(
        context: context,
        type: NotificationType.error,
        content: errorDetails.toString(),
        textSubmit: 'Ok',
        submit: null,
      );
    } else {
      // pop the loading progress
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: 'Something went wrong',
        textSubmit: 'Ok',
        submit: null,
      );
    }
   
  }
  @override
  Widget build(BuildContext context) {
    //getAllProject();
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
                          getSavedProject();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProjectBodySavedPart(projects: _FavoriteProjects)
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

// Search part of this body
class ProjectBodySearchPart extends StatefulWidget {
  final String search;
  final List<ProjectModel> projects;
  const ProjectBodySearchPart(
      {super.key, required this.search, required this.projects});

  @override
  State<ProjectBodySearchPart> createState() => _ProjectBodySearchPartState();
}

class _ProjectBodySearchPartState extends State<ProjectBodySearchPart> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // initialize the search controller
    _searchController = TextEditingController(text: widget.search);
  }

  @override
  void dispose() {
    // dispose the search controller
    _searchController.dispose();

    super.dispose();
  }

  void onPressed() {}

  Future<dynamic> onOpenedFilter(BuildContext context) {
    EnumProjectLenght? enumProjectLenght =
        EnumProjectLenght.less_than_one_month;
    TextEditingController studentNeededController = TextEditingController();
    TextEditingController proposalsLessThanController = TextEditingController();

    return showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void changeProjectLength(EnumProjectLenght? value) {
              setModalState(() {
                enumProjectLenght = value;
              });
            }

            Widget chooseLenght(EnumProjectLenght projectLenght, String text) {
              return Row(
                children: [
                  Radio(
                      activeColor: Theme.of(context).colorScheme.onPrimary,
                      value: projectLenght,
                      groupValue: enumProjectLenght,
                      onChanged: changeProjectLength),
                  CustomText(
                    text: text,
                    size: 15,
                  )
                ],
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const CustomText(
                        text: "Filter by",
                        size: 17,
                        isBold: true,
                      ),
                    ],
                  ),
                  const CustomText(text: 'Project length'),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        chooseLenght(EnumProjectLenght.less_than_one_month,
                            "Less than one month"),
                        chooseLenght(EnumProjectLenght.one_to_three_month,
                            "1 to 3 months"),
                        chooseLenght(EnumProjectLenght.three_to_six_month,
                            "3 to 6 months"),
                        chooseLenght(EnumProjectLenght.more_than_six_month,
                            "more than 6 months"),
                      ]),
                  const CustomText(text: 'Student needed'),
                  SizedBox(
                    width: 200,
                    height: 25,
                    child: TextField(
                      controller: studentNeededController,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimary),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      )),
                      textAlign: TextAlign.center,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  const CustomText(text: 'Proposals less than'),
                  SizedBox(
                    width: 200,
                    height: 25,
                    child: TextField(
                      controller: proposalsLessThanController,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onPrimary),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      )),
                      textAlign: TextAlign.center,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(onPressed: onPressed, text: 'Clear filter'),
                      const SizedBox(
                        width: SpacingUtil.smallHeight,
                      ),
                      CustomButton(onPressed: onPressed, text: 'Apply')
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Project search',
        isBack: true,
        onPressed: onPressed,
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // search bar
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: CustomTextfield(
                    prefixIcon: Icons.search,
                    controller: _searchController,
                    hintText: 'Search for projects',
                  ),
                ),
                // filter list
                IconButton(
                  onPressed: () {
                    onOpenedFilter(context);
                  },
                  icon: const Icon(
                    Icons.filter_list,
                    size: 35,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SpacingUtil.smallHeight),
            // filter list of projects
            ListViewProjectItems(projects: widget.projects),
          ],
        ),
      ),
    );
  }
}

//saved part of this body
class ProjectBodySavedPart extends StatefulWidget {
  List<ProjectModel> projects;
  ProjectBodySavedPart({
    super.key,
    required this.projects,
  });
  @override
  State<ProjectBodySavedPart> createState() => _ProjectBodySavedPart();
}

class _ProjectBodySavedPart extends State<ProjectBodySavedPart> {
  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Saved projects',
        isBack: true,
        onPressed: onPressed,
        currentContext: context,
      ),
      body: InitialBody(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Expanded(
            child: ListView.builder(
              itemCount: widget.projects.length,
              itemBuilder: (context, index) {
                final project = widget.projects[index];
                String month = '1 - 3';
                if (project.projectScopeFlag == 1){
                  month = '3-6';
                }
                return saveProjectItem(project, month);
              }
            )
          ),
        ],
      )),
    );
  }

  Row saveProjectItem(ProjectModel project, String month) {
    return Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title: " + project.title,
                  style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: SpacingUtil.smallHeight,
                ),
                CustomText(text:"Time created: " + DateFormat('dd-MM-yyyy').format(DateTime.parse(project.timeCreated)) ),
                const SizedBox(
                  height: SpacingUtil.smallHeight,
                ),
                CustomText(text: "Time: " + month + " months, ${project.numberofStudent} students needed"),
                const SizedBox(
                  height: SpacingUtil.mediumHeight,
                ),
                const CustomText(text: "Student are looking for"),
                CustomBulletedList(listItems: project.description.split(';')),
                CustomText(text: "Proposals: " +   project.proposal.toString()),
                CustomDivider(),
                const SizedBox(
                  height: SpacingUtil.smallHeight,
                ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon:const Icon(
                Icons.favorite,
                color: Color.fromARGB(255, 0, 78, 212),
                size: 30,
        )),
      ],
    );
  }
 }

