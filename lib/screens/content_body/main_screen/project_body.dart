import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/listview_project_items.dart';
import 'package:student_hub/models/enums/enum_projectlenght.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/color_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_divider.dart';

enum ProjectBodyType {
  main(nameRoute: ''),
  search(nameRoute: 'search'),
  favorite(nameRoute: 'favorite');

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
          title: const Center(
            child: Text(
              'Welcome',
              style: TextStyle(
                color: ColorUtil.darkPrimary,
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
  final List<ProjectModel> _projects = [
    ProjectModel('Senior frontend developer (Fintech)', 'Created 3 days ago',
        ['Clear expectation about your project'], true, false, 0, 8, 2),
    ProjectModel('Senior frontend developer (Fintech)', 'Created 5 days ago',
        ['Clear expectation about your'], false, false, 0, 8, 2),
    ProjectModel('Senior frontend developer (Fintech)', 'Created 5 days ago',
        ['Clear expectation about your'], false, false, 0, 8, 2),
    ProjectModel('Senior frontend developer (Fintech)', 'Created 5 days ago',
        ['Clear expectation about your'], false, false, 0, 8, 2),
    ProjectModel('Senior frontend developer (Fintech)', 'Created 5 days ago',
        ['Clear expectation about your'], false, false, 0, 8, 2),
    ProjectModel('Senior frontend developer (Fintech)', 'Created 5 days ago',
        ['Clear expectation about your'], false, false, 0, 8, 2),
  ];
  final List<String> suggestion = ["reactjs", "flutter", "education app"];

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
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
                    icon: const Icon(Icons.search),
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
                          List<ProjectModel> favorite = _projects.where((projectModel) => projectModel.like).toList();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder:(context) =>ProjectBodyFavoritePart(projects: favorite))
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
            ListViewProjectItems(projects: _projects),
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

  EnumProjectLenght? _enumProjectLenght = EnumProjectLenght.less_than_one_month;
  void changeProjectLength(EnumProjectLenght? value){
    setState(() {
      _enumProjectLenght = value;
    });
  }
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

  void onOpenedFilter(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context){
       return  SingleChildScrollView(
              
              padding: EdgeInsets.all(10),
              child: Column(
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
                    ],
                  ),
                  CustomText(text: "Filter by"),
                  CustomDivider(),
                  CustomText(text: 'Project length'),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    chooseLenght(EnumProjectLenght.less_than_one_month, "Less than one month"),
                    chooseLenght(EnumProjectLenght.one_to_three_month, "1 to 3 months"),
                    chooseLenght(EnumProjectLenght.three_to_six_month, "3 to 6 months"),
                    chooseLenght(EnumProjectLenght.more_than_six_month, "more than 6 months"),
                  ]),
                  CustomText(text: 'Student needed'),
                  const SizedBox(
                    width: 200,
                    height: 25,
                    child: TextField(
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      decoration: InputDecoration(border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      )),
                      textAlign: TextAlign.center,
                    ), 
                  ),
                  CustomText(text: 'Proposal less than'),
                  const SizedBox(
                    width: 200,
                    height: 25,
                    child: TextField(
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      decoration: InputDecoration(border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      )),
                      textAlign: TextAlign.center,
                    ), 
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(onPressed: onPressed, text: 'clear filter'),
                      const SizedBox( width: SpacingUtil.smallHeight,),
                      CustomButton(onPressed: onPressed, text: 'Apply')
                    ],
                  )
                ],
              ),
           
        );
      
      });
  }
  Widget chooseLenght(EnumProjectLenght projectLenght, String text){
    return Row(
      children: [
        Radio(
          activeColor: const Color.fromARGB(236, 3, 70, 147),
          value: projectLenght,
          groupValue: _enumProjectLenght,
          onChanged: changeProjectLength),
        CustomText(text: text, size: 15,)
      ],
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
                  onPressed: (){onOpenedFilter(context);},
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

//Favorite part of this body
class ProjectBodyFavoritePart extends StatefulWidget{
  final List<ProjectModel> projects;
  const ProjectBodyFavoritePart({
    super.key,
    required this.projects,});
  @override
  State<ProjectBodyFavoritePart> createState() => _ProjectBodyFavoritePart();
}

class _ProjectBodyFavoritePart extends State<ProjectBodyFavoritePart>{
  void onPressed() {}
  @override
  Widget build(BuildContext context){
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
            ListViewProjectItems(projects: widget.projects),
          ],
        ) 
      ),
    );
  }
}
  
